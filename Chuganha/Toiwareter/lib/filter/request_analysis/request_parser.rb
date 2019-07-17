# -*- coding: utf-8 -*-
###############################################################################
# リクエスト解析パーサーオブジェクト
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/07 Nakanohito
# 更新日:
###############################################################################
require 'common/common_logger'
require 'data_cache/request_analysis_result_cache'
require 'filter/request_analysis/analysis_parameters'
require 'filter/request_analysis/accept_lang_setter'
require 'filter/request_analysis/browser_setter'
require 'filter/request_analysis/client_id_setter'
require 'filter/request_analysis/default_setter'
require 'filter/request_analysis/domain_setter'
require 'filter/request_analysis/host_info_setter'
require 'filter/request_analysis/null_setter'
require 'filter/request_analysis/received_time_setter'
require 'filter/request_analysis/referrer_setter'
require 'filter/request_analysis/session_info_setter'
require 'filter/request_analysis/termination_setter'
require 'singleton'
require 'thread'

module Filter
  module RequestAnalysis
    # リクエスト解析オブジェクト
    class RequestParser
      include Singleton
      include DataCache
      include Filter::RequestAnalysis
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize
        # 排他制御オブジェクト生成
        @mutex = Mutex.new
        # Logger
        @logger = Common::CommonLogger.instance
        # リクエスト解析結果キャッシュ
        @analysis_info_cache = RequestAnalysisResultCache.instance
        # 現在の前処理の解析設定(初期値はダミー)
        @prepare_setting_info = RequestAnalysisSchedule.new
        # 現在の解析設定(初期値はダミー)
        @current_setting_info = RequestAnalysisSchedule.new
        # 前処理セッター
        @prepare_setter = nil
        # 現在のセッターのトップ
        @current_setter = nil
        # 解析スレッド生成
        @parser_queue  = Queue.new
        @parser_thread = create_parser_thread
      end
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # リクエスト解析
      def parse(controller)
        raise ArgumentError, 'invalid argument' unless ApplicationController === controller
        params = AnalysisParameters.new(controller)
        return if params.setting_info.nil?
        # クリティカルセクションの実行
        @mutex.synchronize do
          # スレッドの状態判定
          @parser_thread = create_parser_thread unless @parser_thread.alive?
          # 前処理の切り替わり判定
          unless setting_compare?(params.setting_info, @prepare_setting_info) then
            @prepare_setting_info = params.setting_info
            @prepare_setter = create_prepare_setter_chain(@prepare_setting_info)
          end
          # 前処理実行
          @prepare_setter.execute(params)
          # 解析キューに投入
          @parser_queue.push(params)
        end
      end 
      #########################################################################
      # protectesdメソッド定義
      #########################################################################
      protected
      # 永続化スレッド生成
      def create_parser_thread
        return Thread.start do
          params = @parser_queue.pop
          until params.nil? do
            parse_params(params)
            params = @parser_queue.pop
          end
        end
      end
      
      # 設定スケジュール比較
      def setting_compare?(setting_info_a, setting_info_b)
        return false if setting_info_a.id != setting_info_b.id
        return setting_info_a.updated_at == setting_info_b.updated_at
      end
      
      # リクエスト解析処理
      def parse_params(params)
        begin
          # 現在のリクエスト解析スケジュールを取得
          unless setting_compare?(params.setting_info, @current_setting_info) then
            @current_setting_info = params.setting_info
            @current_setter = create_setter_chain(@current_setting_info)
          end
          # リクエスト解析結果編集
          @current_setter.execute(params)
          # リクエスト解析結果キャッシュを使用してカウントアップ
          @analysis_info_cache.request_count_up(@current_setting_info, params.request_analysis_result)
        rescue => ex
          @logger.error('Exception:' + ex.class.name)
          @logger.error('Message  :' + ex.message)
          @logger.error('Backtrace:' + ex.backtrace)
        end
      end
      
      # セッター生成処理
      def create_setter_chain(setting_info)
        # 終端セッター
        before_setter = TerminationSetter.new(setting_info, nil)
        # NULLセッター
        before_setter = NullSetter.new(setting_info, before_setter)
        # ドメインセッター
        if setting_info.gs_domain_id then
          before_setter = DomainSetter.new(setting_info, before_setter)
        end
        # ホスト情報セッター
        if setting_info.gs_proxy_host || setting_info.gs_proxy_ip_address ||
           setting_info.gs_remote_host || setting_info.gs_ip_address ||
           setting_info.gs_domain_id then
          before_setter = HostInfoSetter.new(setting_info, before_setter)
        end
        # リファラーセッター
        if setting_info.gs_referrer then
          before_setter = ReferrerSetter.new(setting_info, before_setter)
        end
        # 言語セッター
        if setting_info.gs_accept_language then
          before_setter = AcceptLangSetter.new(setting_info, before_setter)
        end
        # ブラウザセッター
        if setting_info.gs_browser_id || setting_info.gs_browser_version_id then
          before_setter = BrowserSetter.new(setting_info, before_setter)
        end
        # セッション情報セッター
        if setting_info.gs_session_id || setting_info.gs_client_id then
          before_setter = SessionInfoSetter.new(setting_info, before_setter)
        end
        # 受信日時セッター
        if setting_info.gs_received_year || setting_info.gs_received_month || setting_info.gs_received_day ||
           setting_info.gs_received_hour || setting_info.gs_received_minute || setting_info.gs_received_second then
          before_setter = ReceivedTimeSetter.new(setting_info, before_setter)
        end
        # デフォルトセッター
        return DefaultSetter.new(setting_info, before_setter)
      end
      
      # 前処理セッター生成処理
      def create_prepare_setter_chain(setting_info)
        # 終端セッター
        before_setter = TerminationSetter.new(setting_info, nil)
        unless setting_info.nil? then
          # クライアントIDセッター
          before_setter = ClientIDSetter.new(setting_info, before_setter) if setting_info.gs_client_id
        end
        return before_setter
      end
    end
  end
end