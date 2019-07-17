# -*- coding: utf-8 -*-
###############################################################################
# セッション更新フィルタ
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/09/26 Nakanohito
# 更新日:
###############################################################################
require 'common/message_util_module'
require 'common/net_util_module'
require 'common/session_util_module'
require 'common/validation_chk_module'
require 'function_state/function_state_hash'

module Filter
  module UpdateSession
    class UpdateSessionFilter
      include Common::MessageUtilModule
      include Common::NetUtilModule
      include Common::SessionUtilModule
      include FunctionState
      # 定数（メッセージ関係）
      MESSAGE_HEAD = 'Update Session Error!!!::'
      MESSAGE_PATH = 'filter.update_session.attributes.'
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize
        @business_config = BizCommon::BusinessConfig.instance
        @system_name = @business_config.system_name
        @subsystem_name = @business_config.subsystem_name
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # フィルタ処理
      def filter(controller, &action)
        before_time = Time.now
        controller.logger.debug('UpdateSessionFilter Execute!!!')
        # セッション情報の更新処理
        unless update_session?(controller) then
          controller.redirect_to('/403.html')
          return
        end
        # 処理時間
        proc_time = (Time.now.to_f - before_time.to_f) * 1000.0
        controller.logger.debug('UpdateSessionFilter proc time:' + proc_time.to_s + " msec")
        # 本体処理
        yield
        # アクション実行後のフィルタ処理
        controller.session.delete(:function_state)
        # 処理時間
        proc_time = (Time.now.to_f - before_time.to_f) * 1000.0
        controller.logger.debug('UpdateSessionFilter proc time:' + proc_time.to_s + " msec")
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # セッションの更新処理
      def update_session?(controller)
        # セッションチェック
        state_hash = controller.session[:function_state_hash]
        unless FunctionStateHash === state_hash then
          error_msg = error_msg(MESSAGE_PATH + 'session_information', 'invalid')
          warn_log(controller, error_msg)
          return false
        end
        # リクエストの画面遷移パラメータのチェック
        scr_trans_params = controller.flash[:params]
        scr_trans_params ||= controller.params
        param = Parameter.new(scr_trans_params)
        unless param.error_message.nil? then
          warn_log(controller, param.error_message)
          return false
        end
        # 送信元機能遷移番号チェック
        source_state = state_hash[param.function_transition_no]
        if source_state.nil? then
          error_msg = error_msg(MESSAGE_PATH + 'function_transition_no', 'invalid')
          warn_log(controller, error_msg)
          return false
        end
        # 同期トークン判定
        if source_state.sync_tkn != param.synchronous_token then
          error_msg = error_msg(MESSAGE_PATH + 'synchronous_token', 'invalid')
          warn_log(controller, error_msg)
          return false
        end
        # 機能状態更新
        next_state = nil
        case param.screen_transition_pattern
        when TRANS_PTN_NEW then # 新規起動
          # 機能状態生成
          next_state = state_hash.new_state(controller, param.function_transition_no)
          # ハッシュサイズチェック
          if next_state.nil? then
            error_msg = error_msg(MESSAGE_PATH + 'function_state_hash', 'full')
            warn_log(controller, error_msg)
            return false
          end
        when TRANS_PTN_OTH then # 別画面起動
          # 機能状態生成
          next_state = state_hash.new_state(controller, param.function_transition_no, true)
          # ハッシュサイズチェック
          if next_state.nil? then
            error_msg = error_msg(MESSAGE_PATH + 'function_state_hash', 'full')
            warn_log(controller, error_msg)
            return false
          end
        when TRANS_PTN_NOW then # 現在機能内遷移
          if controller.controller_path != source_state.cntr_path then
            error_msg = error_msg(MESSAGE_PATH + 'controller_path', 'invalid')
            warn_log(controller, error_msg)
            return false
          end
          next_state = source_state
        when TRANS_PTN_BACK then # 直前遷移
          next_state = state_hash.previous_state(source_state.func_tran_no)
          if next_state.nil? then
            error_msg = error_msg(MESSAGE_PATH + 'previous_state', 'not_found')
            warn_log(controller, error_msg)
            return false
          end
          state_hash.delete?(source_state.func_tran_no)
        when TRANS_PTN_REST then # 復元遷移
          rest_trans_no = param.restored_transition_no # 遷移先機能遷移番号
          unless state_hash.delete_history?(param.function_transition_no, rest_trans_no) then
            error_msg = error_msg(MESSAGE_PATH + 'restored_transition_no', 'invalid')
            warn_log(controller, error_msg)
            return false
          end
          next_state = state_hash[rest_trans_no]
        when TRANS_PTN_REP then # 置換遷移
          next_state = state_hash.replace_state(controller, param.function_transition_no)
        when TRANS_PTN_CLH then # 履歴クリア後新規起動
          state_hash.delete_history?(param.function_transition_no)
          next_state = state_hash.new_state(controller, nil, true)
        when TRANS_PTN_CLR then # 全状態クリア後新規遷移
          state_hash.delete_all
          next_state = state_hash.new_state(controller, nil, true)
        when TRANS_PTN_HCL then # 履歴クリア
          state_hash.delete_history?(param.function_transition_no)
        end
        controller.session[:function_state] = next_state
        return true
      end
      
      # 機能状態抽出
      def extraction_state(controller, transition_no)
        session = controller.session
        state_hash = session[:function_state_hash]
        return nil unless FunctionStateHash === state_hash
        return state_hash[transition_no]
      end
      
      # ログメッセージ出力
      def warn_log(controller, error_msg)
        host_info = extract_host(controller.request)
        host_msg = ('(HOST:' + host_info[0].to_s + ')') if host_info.size == 2
        host_msg ||= ('(HOST:' + host_info[0].to_s + ', PROXY:' + host_info[2].to_s + ')')
        controller.logger.warn(MESSAGE_HEAD + error_msg.to_s + host_msg)
      end
      #########################################################################
      # パラメータクラス
      #########################################################################
      class Parameter
        include Common::MessageUtilModule
        include Common::ValidationChkModule
        # 定数
        PTN_RANGE = (UpdateSessionFilter::TRANS_PTN_NEW.to_i..UpdateSessionFilter::TRANS_PTN_HCL.to_i)
        #######################################################################
        # メソッド定義
        #######################################################################
        # アクセスメソッド定義
        attr_reader :error_message,
                    :function_transition_no,
                    :restored_transition_no,
                    :screen_transition_pattern,
                    :synchronous_token
        # 初期化メソッド
        def initialize(params)
          # 値検証処理
          @error_message = validate(params)
          return unless @error_message.nil?
          @screen_transition_pattern = params[:screen_transition_pattern]   # 画面遷移パターン
          @function_transition_no    = params[:function_transition_no].to_i # 遷移元機能遷移番号
          restored_no                = params[:restored_transition_no]      # 遷移先機能遷移番号
          @restored_transition_no    = nil
          @restored_transition_no    = restored_no.to_i unless restored_no.nil?
          @synchronous_token         = params[:synchronous_token]           # 同期トークン
        end
        #######################################################################
        # protectesdメソッド定義
        #######################################################################
        protected
        # 値検証処理
        def validate(params)
          # 画面遷移パターン
          screen_transition_pattern = params[:screen_transition_pattern]
          if !valid_number?(screen_transition_pattern) ||
             !PTN_RANGE.include?(screen_transition_pattern.to_i) then
            return error_msg(MESSAGE_PATH + 'screen_transition_pattern', 'invalid')
          end
          # 遷移元機能遷移番号
          function_transition_no = params[:function_transition_no]
          if !valid_number?(function_transition_no) then
            return error_msg(MESSAGE_PATH + 'function_transition_no', 'invalid')
          end
          # 遷移先機能遷移番号
          restored_transition_no = params[:restored_transition_no]
          if (screen_transition_pattern == UpdateSessionFilter::TRANS_PTN_REST &&
              !valid_number?(restored_transition_no)) ||
             (screen_transition_pattern != UpdateSessionFilter::TRANS_PTN_REST &&
              !blank?(restored_transition_no)) then
            return error_msg(MESSAGE_PATH + 'restored_transition_no', 'invalid')
          end
          # 同期トークン
          synchronous_token = params[:synchronous_token]
          if blank?(synchronous_token) ||
             synchronous_token.split(//s).length != UpdateSessionFilter::TOKEN_SIZE then
            return error_msg(MESSAGE_PATH + 'synchronous_token', 'invalid')
          end
          # 正常
          return nil
        end
        
        # 遷移番号チェック
        def valid_number?(trans_no)
          return !blank?(trans_no) && numeric?(trans_no)
        end
      end
    end
  end
end