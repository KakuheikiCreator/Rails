# -*- coding: utf-8 -*-
###############################################################################
# リクエスト解析結果キャッシュクラス
# 機能：データベース上のリクエスト解析結果をローカルメモリ上に展開したキャッシュ情報
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/09/09 Nakanohito
# 更新日:
###############################################################################
require 'rubygems'
require 'singleton'
require 'thread'
require 'data_cache/request_analysis_schedule_cache'

module DataCache
  # リクエスト解析結果キャッシュクラス
  class RequestAnalysisResultCache
    include Singleton
    # アクセサー
    attr_reader :max_data_count, :persistent_data_count
    ###########################################################################
     # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # Logger
      @logger = Rails.logger
      # キャッシュサイズ情報
      @max_data_count = 10000
      @persistent_data_count = 3000
      # 永続化スレッド生成
      @persistence_queue = Queue.new
      @persistence_thread = create_persistent_thread
      # 現在のリクエスト解析スケジュール
      setting = RequestAnalysisScheduleCache.instance.get_setting
      @current_unit_info = SettingUnitInfo.new(setting)
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # キャッシュサイズ設定
    def set_cache_size(max_size, persistent_size)
      raise ArgumentError, 'invalid argument' if max_size.nil? || persistent_size.nil?
      # クリティカルセクションの実行
      @mutex.synchronize do
        # スレッド状態判定
        @persistence_thread = create_persistent_thread unless @persistence_thread.alive?
        if @current_unit_info.data_count >= max_size then
          count = @current_unit_info.data_count - (max_size - persistent_size)
          @current_unit_info.eject_node(@persistence_queue, count)
        end
        @max_data_count = max_size
        @persistent_data_count = persistent_size
      end
    end
    # リクエスト回数カウントアップ
    def request_count_up(setting, analysis_result)
      raise ArgumentError, 'invalid argument' if analysis_result.nil?
      setting ||= analysis_result.request_analysis_schedule
      raise ArgumentError, 'invalid argument' if setting.nil?
      # クリティカルセクションの実行
      @mutex.synchronize do
        # スレッド状態判定
        @persistence_thread = create_persistent_thread unless @persistence_thread.alive?
        unit_info = get_unit_info(setting)
        # キャッシュに投入
        unit_info.request_count_up(analysis_result)
        # キャッシュオーバーフロー判定
        return if unit_info.data_count <= @max_data_count
        unit_info.eject_node(@persistence_queue, @persistent_data_count)
      end
    end
    # データ排出処理
    def eject_all
      # クリティカルセクションの実行
      @mutex.synchronize do
        # スレッド状態判定
        @persistence_thread = create_persistent_thread unless @persistence_thread.alive?
        # キャッシュしている情報を永続化
        @current_unit_info.eject_node(@persistence_queue)
      end
    end
    
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # 永続化スレッド生成
    def create_persistent_thread
      return Thread.start do
        list_node = @persistence_queue.pop
        until list_node.nil? do
          data_persistence(list_node)
          list_node = @persistence_queue.pop
        end
      end
    end
    # データ登録
    def data_persistence(list_node)
      ActiveRecord::Base.transaction do
        begin
          analysis_result = list_node.analysis_result
          # 重複データ検索
          infos = RequestAnalysisResult.duplicate(analysis_result).lock
          if infos.empty? then
            analysis_result[:request_count] = list_node.request_count
          else
            analysis_result = infos[0]
            analysis_result[:request_count] += list_node.request_count
          end
          analysis_result.save!
        rescue => ex
          @logger.error('RequestAnalysisResult Persistence Error')
          @logger.error('Exception:' + ex.class.name)
          @logger.error('Message  :' + ex.message)
          @logger.error('Backtrace:' + ex.backtrace)
          raise ActiveRecord::Rollback
        end
      end
    end
    # 設定単位情報取得
    def get_unit_info(setting)
      if @current_unit_info.setting.id != setting.id then
        @current_unit_info.eject_node(@persistence_queue) # 現在の設定単位情報を永続化
        @current_unit_info = SettingUnitInfo.new(setting) # 設定単位情報生成
      end
      return @current_unit_info
    end
    ###########################################################################
    # 設定単位情報クラス定義
    ###########################################################################
    class SettingUnitInfo
      # アクセサー
      attr_reader :setting, :data_count
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(setting)
        @setting = setting
        @setting = RequestAnalysisSchedule.new if @setting.nil?
        @item_list = generate_item_list(@setting)
        @data_count = 0
        # リクエスト解析結果ツリー
        analysis_result = RequestAnalysisResult.new
        analysis_result.request_analysis_schedule_id = @setting.id
        param = Parameter.new(analysis_result, [:request_analysis_schedule_id])
        @tree_top_node = TreeNode.new(param)
        # リクエスト解析結果リスト
        @list_top_node = nil
        @list_end_node = nil
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # リクエスト解析結果追加
      def request_count_up(analysis_result)
        param = Parameter.new(analysis_result, @item_list)
        # リクエスト解析結果を挿入
        target_node = @tree_top_node.add_node(param)
        # 新規ノード判定
        if target_node.list_node.nil? then
          target_node.list_node = LinkListNode.new(param, target_node)
          @data_count += 1
          add_list_node(target_node.list_node)
        else
          target_node.list_node.request_count += 1
        end
        update_list_info(target_node.list_node)
      end
      # ノード排出
      def eject_node(eject_queue, count=@data_count)
        return if @list_top_node.nil?
        target_node = @list_top_node
        count.times do
          # ツリーからノードを除去
          target_node.tree_node.delete_node
          eject_queue.push(target_node)
          target_node = target_node.next_node
        end
        # リンクリストの情報更新
        @list_top_node = target_node
        @list_end_node = nil if @list_top_node.nil?
        # データ件数更新
        @data_count -= count
      end
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # 項目リスト生成
      def generate_item_list(setting)
        item_list = [:request_analysis_schedule_id]
        item_list.push(:received_year) if setting.gs_received_year
        item_list.push(:received_month) if setting.gs_received_month
        item_list.push(:received_day) if setting.gs_received_day
        item_list.push(:received_hour) if setting.gs_received_hour
        item_list.push(:received_minute) if setting.gs_received_minute
        item_list.push(:received_second) if setting.gs_received_second
        item_list.push(:function_id) if setting.gs_function_id
        item_list.push(:function_transition_no) if setting.gs_function_transition_no
        item_list.push(:session_id) if setting.gs_session_id
        item_list.push(:client_id) if setting.gs_client_id
        item_list.push(:browser_id) if setting.gs_browser_id
        item_list.push(:browser_version_id) if setting.gs_browser_version_id
        item_list.push(:accept_language) if setting.gs_accept_language
        item_list.push(:referrer) if setting.gs_referrer
        item_list.push(:domain_id) if setting.gs_domain_id
        item_list.push(:proxy_host) if setting.gs_proxy_host
        item_list.push(:proxy_ip_address) if setting.gs_proxy_ip_address
        item_list.push(:remote_host) if setting.gs_remote_host
        item_list.push(:ip_address) if setting.gs_ip_address
        return item_list
      end
      # リンクリストにノード追加
      def add_list_node(list_node)
        # リンクリスト情報更新
        if @list_top_node.nil? then
          @list_top_node = list_node
          @list_end_node = list_node
          return
        end
        @list_end_node.set_next_node(list_node)
        @list_end_node = list_node
      end
      # リンクリスト情報更新
      def update_list_info(list_node)
        # リンクリスト情報更新
        return if @list_end_node == list_node
        @list_top_node = list_node.next_node if @list_top_node == list_node
        list_node.removal_node
        @list_end_node.set_next_node(list_node)
        @list_end_node = list_node
      end
    end
    
    ###########################################################################
    # パラメータクラス定義
    ###########################################################################
    class Parameter
      # アクセサー
      attr_reader :analysis_result
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(analysis_result, item_list)
        @item_list = item_list
        @analysis_result = analysis_result
        # チェック対象項目の値のみを配列に加える
        @values = generate_values(analysis_result, item_list)
        @last_idx = @values.size - 1
        @current_pos = 0
        @current_value = @values[@current_pos]
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # 前へ移動
      def move_before?
        return false if @current_pos <= 0
        @current_pos -= 1
        @current_value = @values[@current_pos]
        return true
      end
      # 次へ移動
      def move_next?
        return false if @current_pos >= @last_idx
        @current_pos += 1
        @current_value = @values[@current_pos]
        return true
      end
      # 現在ポジションの値取得
      def current_value
        return @current_value
      end
      
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # 取得対象値リスト
      def generate_values(analysis_result, item_list)
        values = Array.new
        item_list.each do |item|
          values.push(analysis_result[item])
        end
        return values
      end
    end
    
    ###########################################################################
    # ツリーノードクラス
    ###########################################################################
    class TreeNode
      # アクセサー
      attr_reader :value, :child_node_hash
      attr_accessor :list_node
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(param, parent=nil)
        @value = param.current_value
        @parent = parent
        @list_node = nil
        @child_node_hash = Hash.new
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # ノード追加
      def add_node(param)
        # パラメータの状態を次の階層に更新
        unless param.move_next? then
          @child_node_hash = nil
          return self
        end
        # 次のノードを追加
        value = param.current_value
        next_node = @child_node_hash[value]
        if next_node.nil? then
          next_node = TreeNode.new(param, self)
          @child_node_hash[value] = next_node
        end
        target_node = next_node.add_node(param)
        param.move_before?
        return target_node
      end
      # ノード削除
      def delete_node
        @parent.delete_child_node(@value) unless @parent.nil?
      end
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # 子ノード削除（子ノードが全て無くなったら自ノードも削除）
      def delete_child_node(key)
        @child_node_hash.delete(key)
        return if @parent.nil?
        @parent.delete_child_node(@value) if @child_node_hash.empty?
      end
    end
    
    ###########################################################################
    # リンクリストノードクラス
    ###########################################################################
    class LinkListNode
      # アクセサー
      attr_reader :analysis_result, :tree_node
      attr_accessor :request_count, :previous_node, :next_node
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(param, tree_node)
        @analysis_result = param.analysis_result
        @request_count = 1
        @previous_node = nil
        @next_node = nil
        @tree_node = tree_node
      end
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # 次ノード設定処理
      def set_next_node(next_node)
        @next_node = next_node
        return if next_node.nil?
        next_node.previous_node = self
      end
      # ノードの除去処理
      def removal_node
        @previous_node.next_node = @next_node unless @previous_node.nil?
        @next_node.previous_node = @previous_node unless @next_node.nil?
        @previous_node = nil
        @next_node = nil
      end
    end
  end
end