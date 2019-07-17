# -*- coding: utf-8 -*-
###############################################################################
# ドメインキャッシュクラス
# 機能：データベース上のドメインをローカルメモリ上に展開したキャッシュ情報
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2011/08/12 Nakanohito
# 更新日:
###############################################################################
require 'rubygems'
require 'singleton'
require 'date'
require 'thread'
require 'monitor'
require 'common/net_util_module'

module DataCache
  # ドメインキャッシュクラス
  class DomainCache
    include Singleton
    # アクセサー
    attr_reader :loaded_at
    # 定数宣言
    UNIT_MONTH   = 1 # 月単位
    UNIT_DAY     = 0 # 日単位
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @monitor = Monitor.new
      # Logger
      @logger = Rails.logger
      # ドメインツリー生成
      @domain_tree = Hash.new
      # 有効期間
      @validity_period_unit = nil
      @validity_period = nil
      # キャッシュデータロード日時
      @loaded_at = nil
      # 有効期間
      set_validity_period('7d')
      # データをメモリに展開
      data_load
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # 有効期間の設定
    def set_validity_period(validity_period)
      unless String === validity_period then
        raise ArgumentError, 'invalid argument'
      end
      @monitor.synchronize do
        @validity_period_unit = unit(validity_period)
        @validity_period = validity_period[/^\d+/].to_i
      end
    end
    
    # ドメインID取得
    def get_domain_id(param)
      return nil unless String === param || Domain === param
      # パラメータ生成
      search_param = DomainParameter.new(param, standard_time)
      # ノードの追加
      node = add_node(search_param)
      return node.domain_id unless node.nil?
      return nil
    end
    
    # データロード処理
    def data_load
      # クリティカルセクションの実行
      @monitor.synchronize do
        # キャッシュクリア
        @domain_tree = Hash.new
        @loaded_at = Time.now
        # トランザクションの開始
        time = standard_time
        Domain.all.each do |domain|
          # パラメータ生成
          param = DomainParameter.new(domain, time)
          add_node(param)
        end
      end
    end
    
    ###########################################################################
    # protectesdメソッド定義
    ###########################################################################
    protected
    # ドメインノード追加
    def add_node(param)
      tld_phrase = param.current_phrase
      tld_node = @domain_tree[tld_phrase]
      if tld_node.nil? then
        # ドメインを生成して挿入
        tld_node = DomainTreeNode.new(param)
        @domain_tree[tld_phrase] = tld_node
      end
      # ドメインを挿入
      return tld_node.add_node(param)
    end
    
    # 有効期間単位
    def unit(validity_period)
      if /^\d+[Mm]/ =~ validity_period then
        return UNIT_MONTH
      elsif /^\d+[Dd]/ =~ validity_period then
        return UNIT_DAY
      end
      raise ArgumentError, 'invalid argument'
    end
    
    # 基準日時取得
    def standard_time
      @monitor.synchronize do
        case @validity_period_unit
        when UNIT_MONTH then
          return Time.now << @validity_period
        when UNIT_DAY then
          return Time.now - @validity_period
        end
      end
    end
    
    ###########################################################################
    # パラメータクラス定義
    ###########################################################################
    class DomainParameter
      # アクセサー
      attr_reader :date_confirmed, :standard_time
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(param, standard_time=Time.now)
        @current_pos = 0  # 現在ポジション
        @domain_id = nil  # ドメインID
        @key_array = nil  # キー配列
        @date_confirmed = nil # 確認日時
        @fixed_flg = nil  # 固定ドメインフラグ
        if Domain === param then
          @domain_id = param.id
          @key_array = param.domain_name.split(/\./).reverse
          @date_confirmed = param.date_confirmed
          @fixed_flg = param.fixed?
        else
          @key_array = param.split(/\./).reverse
          @date_confirmed = standard_time - 1 # 基準日時の前日（有効期限切れ）
          @fixed_flg = false
        end
        @last_idx = @key_array.size - 1 # 最終ポジション
        @standard_time = standard_time  # 基準日時
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # 前へ移動
      def move_before?
        return false if @current_pos <= 0
        @current_pos -= 1
        return true
      end
      
      # 次へ移動
      def move_next?
        return false if @current_pos >= @last_idx
        @current_pos += 1
        return true
      end
      
      # 現在フレーズの取得
      def current_phrase
        return @key_array[@current_pos]
      end
      
      # 現在ノードのドメインIDの取得
      def domain_id
        return @domain_id if @current_pos == @last_idx
        return nil
      end
      
      # 固定ノード判定
      def fixed?
        return true if @fixed_flg
        return @current_pos < 1
      end
    end
    
    ###########################################################################
    # ドメインツリーノードクラス
    ###########################################################################
    class DomainTreeNode
      include Common::NetUtilModule
      # 定数宣言
      CLASS_FIXED     = 0 # 固定ドメインノード(TLD等)
      CLASS_DOMAIN    = 1 # ドメインノード
      CLASS_NOT_EXIST = 2 # 存在しないドメインノード
      
      #########################################################################
      # メソッド定義
      #########################################################################
      # アクセサー
      attr_reader :parents, :phrase, :domain_id, :node_class, :date_confirmed
      # コンストラクタ
      def initialize(param, parents=nil)
        @mutex = Mutex.new     # 排他制御オブジェクト生成
        @parents = parents     # 親ノード
        @phrase  = param.current_phrase # 現在ノードフレーズ
        @domain_id  = param.domain_id # 現在ノードのドメインID
        @child_node_hash = Hash.new
        # 固定ドメインノード判定
        if param.fixed? then
          @node_class = CLASS_FIXED
          @date_confirmed = nil
        else
          @node_class = CLASS_DOMAIN
          @date_confirmed = param.date_confirmed
          # プロパティ更新
          property_update(param)
        end
      end
      
      #########################################################################
      # Publicメソッド定義
      #########################################################################
      public
      # ノード追加
      def add_node(param)
        @mutex.synchronize do
          # 自ノードの状態更新
          property_update(param)
          # 存在しないドメインのノードなのか判定
          return @parents if @node_class == CLASS_NOT_EXIST
          # パラメータの状態を次の階層に更新
          return self unless param.move_next?
          # 次のノードを追加
          phrase = param.current_phrase
          next_node = @child_node_hash[phrase]
          if next_node.nil? then
            next_node = DomainTreeNode.new(param, self)
            @child_node_hash[phrase] = next_node
          end
          domain_node = next_node.add_node(param)
          param.move_before?
          return domain_node
        end
      end
      
      # ドメインノード検索
      def node_search(param)
        @mutex.synchronize do
          # 自ノードが対象ノードか判定
          return @parents if @node_class == CLASS_NOT_EXIST
          return self unless param.move_next?
          # 子ノードに検索を依頼
          domain_node = self
          child_node = @child_node_hash[param.current_phrase]
          unless child_node.nil? then
            domain_node = child_node.node_search(param)
          end
          param.move_before?
          return domain_node
        end
      end
      
      # ドメイン名生成
      def generate_domain_name
        phrase_array = [phrase]
        parents = @parents
        until parents.nil? do
          phrase_array.push('.')
          phrase_array.push(parents.phrase)
          parents = parents.parents
        end
        return phrase_array.join
      end
      
      #########################################################################
      # Protectedメソッド定義
      #########################################################################
      protected
      # 自ノードのプロパティ情報更新
      def property_update(param)
        # 固定ドメイン判定
        if fixed?(param) then
          @node_class = CLASS_FIXED
          @date_confirmed = nil
          @child_node_hash = Hash.new if @child_node_hash.nil?
          return
        end
        # ドメインの存在確認の必要性を判定
        return unless @date_confirmed < param.standard_time
        # ドメイン存在チェック
        domain_name = generate_domain_name
        unless domain_exists?(domain_name) then
          # ドメインが存在しない場合
          @node_class = CLASS_NOT_EXIST
          @date_confirmed = Time.now
          @child_node_hash = nil
          domain_destroy(domain_name)
          return
        end
        # ドメインが存在する場合
        @node_class = CLASS_DOMAIN
        @date_confirmed = Time.now
        @child_node_hash = Hash.new if @child_node_hash.nil?
        domain_save(domain_name)
      end
      
      # 固定ドメイン判定
      def fixed?(param)
        return true if @node_class == CLASS_FIXED
        # 固定ドメインフラグ
        return param.fixed?
      end
      # ドメイン検索
      def find_domain(domain_name)
        domain = nil
        domain = Domain.find(@domain_id, :lock => true) unless @domain_id.nil?
        domain = Domain.where(:domain_name => domain_name).lock[0] if domain.nil?
        return domain
      end
      # ドメイン削除
      def domain_destroy(domain_name)
        ActiveRecord::Base.transaction do
          begin
            # 自ノード配下のデータを論理削除
            Domain.where('domain_name like ?', '%.' + domain_name).
                   lock.update_all({:date_confirmed => @date_confirmed,
                                    :delete_flg => true,
                                    :updated_at => Time.now})
            # 自ノードに対応するデータを論理削除する
            domain = find_domain(domain_name)
            return if domain.nil?
            domain.date_confirmed = @date_confirmed
            domain.delete_flg = true
            domain.save!
          rescue ActiveRecord::ActiveRecordError => ex
            @logger.error('Domain Logical delete Error')
            @logger.error('Exception:' + ex.class.name)
            @logger.error('Message  :' + ex.message)
            @logger.error('Backtrace:' + ex.backtrace.join("\n"))
            raise ActiveRecord::Rollback
          end
        end
      end
      # ドメイン保存
      def domain_save(domain_name)
        # トランザクション開始
        ActiveRecord::Base.transaction do
          begin
            # ドメインオブジェクトの取得
            domain = find_domain(domain_name)
            if domain.nil? then
              domain = Domain.new
              domain.domain_name = domain_name
              domain.domain_class = Domain::DOMAIN_CLASS_OTHER
              domain.date_confirmed = @date_confirmed
              domain.save!
              @domain_id = domain.id
              return
            end
            @domain_id = domain.id
            # 確認日時の比較
            if @date_confirmed > domain.date_confirmed then
              domain.date_confirmed = @date_confirmed
              domain.delete_flg = false
              domain.save!
            else
              # データベース上のデータの確認日時の方が新しい場合
              @date_confirmed = domain.date_confirmed
            end
          rescue ActiveRecord::ActiveRecordError => ex
            @logger.error('Domain Persistence Error')
            @logger.error('Exception:' + ex.class.name)
            @logger.error('Message  :' + ex.message)
            @logger.error('Backtrace:' + ex.backtrace.join("\n"))
            raise ActiveRecord::Rollback
          end
        end
      end
    end
  end
end