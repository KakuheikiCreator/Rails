# -*- coding: utf-8 -*-
###############################################################################
# 会員キャッシュクラス
# 機能：データベース上の会員情報をローカルメモリ上に展開したキャッシュ
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/07 Nakanohito
# 更新日:
###############################################################################
require 'rubygems'
require 'singleton'
require 'thread'
require 'common/code_conv/encryption_setting'
require 'biz_common/business_config'
require 'biz_search/business_sql'
require 'biz_search/member_search'

module DataCache
  # 会員キャッシュクラス
  class MemberCache
    include Singleton
    include BizCommon
    # アクセサー
    attr_reader :max_data_count, :persistent_data_count
    ###########################################################################
     # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # キャッシュサイズ情報
      @max_cache_size = BusinessConfig.instance[:max_member_cache_size].to_i
      # 会員データハッシュ（キー：会員ID）
      @member_id_hash = nil
      # 会員データハッシュ（キー：OpenID）
      @open_id_hash = nil
      # リクエスト解析結果リスト
      @list_top_node = nil
      @list_end_node = nil
      # 初期データロード
      data_load?
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # データロード処理
    def data_load?
      # クリティカルセクションの実行
      @mutex.synchronize do
        # 会員情報を不変オブジェクトの内部データとしてハッシュ化
        new_list_top_node = nil
        new_list_end_node = nil
        new_member_id_hash = Hash.new
        new_open_id_hash = Hash.new
        ents = Member.order('last_login_date DESC').limit(@max_cache_size)
        ents.each do |ent|
          node = LinkListNode.new(ent)
          if new_list_top_node.nil? then
            new_list_top_node = node
            new_list_end_node = node
          else
            new_list_end_node.add_next_node(node)
            new_list_end_node = node
          end
          new_member_id_hash[ent.member_id] = node
          new_open_id_hash[ent.open_id] = node
        end
        @list_top_node = new_list_top_node
        @list_end_node = new_list_end_node
        @member_id_hash = new_member_id_hash
        @open_id_hash = new_open_id_hash
      end
    end
    
    # キャッシュサイズ設定
    def set_cache_size(max_size)
      raise ArgumentError, 'invalid argument' unless Integer === max_size
      # クリティカルセクションの実行
      @mutex.synchronize do
        @max_data_count = max_size
      end
    end
    
    # 会員データアクセス
    def [](member_id)
      @mutex.synchronize do
        node = @member_id_hash[member_id]
        unless node.nil? then
          refresh_list(node)
          return node.member_ent
        end
        # キャッシュミス（検索）
        member_ent = find_by_member_id(member_id)
        node = add_node(member_ent)
        return nil if node.nil?
        return node.member_ent
      end
    end
    
    # 会員データ検索（キー：OpenID）
    def open_id_rec(open_id)
      @mutex.synchronize do
        node = @open_id_hash[open_id]
        unless node.nil? then
          refresh_list(node)
          return node.member_ent
        end
        # キャッシュミス（検索）
        member_ent = find_by_open_id(open_id)
        add_node(member_ent)
        return member_ent
      end
    end
    
    # キャッシュデータ更新
    def refresh_data(member_ent)
      @mutex.synchronize do
        node = @member_id_hash[member_ent.member_id]
        return if node.nil?
        node.member_ent = member_ent
        refresh_list(node)
      end
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # 会員データ検索（キー：会員ID）
    def find_by_member_id(member_id)
      # Solrで検索
      member_search = BizSearch::MemberSearch.instance
      search = member_search.find_by_member_id('"' + member_id.to_s + '"')
      return search.results[0] if search.results.length > 0
      # DBを直に検索
      return Member.where(:member_id=>member_id)[0]
    end
    
    # 会員データ検索（キー：OpenID）
    def find_by_open_id(open_id)
      # Solrで検索
      member_search = BizSearch::MemberSearch.instance
      search = member_search.find_by_open_id('"' + open_id + '"')
      return search.results[0] if search.results.length > 0
      # DBを直に検索
      ActiveRecord::Base.transaction do
        sql_member = SQLMember.new(open_id)
        sql_member.set_db_variable
        result_list = Member.find_by_sql(sql_member.sql_params)
        sql_member.clear_db_variable
        return result_list[0]
      end
    end
    
    # データ追加
    def add_node(member_ent)
      return nil if member_ent.nil?
      new_node = LinkListNode.new(member_ent)
      @member_id_hash[member_ent.member_id] = new_node
      @open_id_hash[member_ent.open_id] = new_node
      new_node.add_next_node(@list_top_node)
      @list_top_node = new_node
      # 終端データ除去判定
      if @member_id_hash.size > @max_cache_size then
        @member_id_hash.delete(@list_end_node.member_ent.member_id)
        @open_id_hash.delete(@list_end_node.member_ent.open_id)
        previous_node = @list_end_node.previous_node
        @list_end_node.removal_node
        @list_end_node = previous_node
      end
      return new_node
    end
    
    # リスト順序更新
    def refresh_list(node)
      return unless LinkListNode === node
      if node.terminal? then
        @list_end_node = node.previous_node
      end
      if @list_top_node != node then
        node.removal_node
        node.add_next_node(@list_top_node)
        @list_top_node = node
      end
    end
    
    # リンクリストノードクラス
    class LinkListNode
      # アクセサー
      attr_accessor :member_ent, :previous_node, :next_node
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(ent)
        @member_ent = ent
        @previous_node = nil
        @next_node = nil
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # 次ノード追加処理
      def add_next_node(next_node)
        @next_node = next_node
        return if next_node.nil?
        next_node.previous_node = self
      end
      
      # 終端判定
      def terminal?
        return !@previous_node.nil? && @next_node.nil?
      end
      
      # ノードの除去処理
      def removal_node
        @previous_node.next_node = @next_node unless @previous_node.nil?
        @next_node.previous_node = @previous_node unless @next_node.nil?
        @previous_node = nil
        @next_node = nil
      end
    end
    
    # 検索SQL生成
    class SQLMember < BizSearch::BusinessSQL
      include Common::CodeConv
      # 初期化メソッド
      def initialize(open_id)
        super()
        # バインド変数
        @bind_params = [open_id]
        # SQL文
        @statement = generate_select
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # SELECT文生成
      def generate_select
        return 'SELECT * FROM members WHERE ' + dec_item_statement(:enc_open_id) + ' = ?'
      end
    end
  end
end