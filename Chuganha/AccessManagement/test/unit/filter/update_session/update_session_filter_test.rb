# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：セッション情報更新フィルタークラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/10/03 Nakanohito
# 更新日:
###############################################################################
require 'common/session_util_module'
require 'filter/update_session/update_session_filter'
require 'function_state/function_state'
require 'function_state/function_state_hash'
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/unit_test_util'

class UpdateSessionFilterTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Common::SessionUtilModule
  include Filter::UpdateSession
  include FunctionState
  include Mock

  # 前処理
  def setup
    # 設定情報ロード
    @business_config = BizCommon::BusinessConfig.instance
#    SystemCache.instance.data_load
  end
  # 後処理
  def teardown
  end
  # パラメータクラステスト
  test "2-01:Parameter Test:instance" do
    # 正常ケース：画面遷移パターン
    begin
      token = '12345abcde12345abcde12345abcde12345abcde'
      # 新規起動
      params = create_params(TRANS_PTN_NEW, '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-1-1")
#error_log("CASE:2-1-1-2:" + parameter.error_message.to_s)
      assert(parameter.error_message.nil?, "CASE:2-1-1-2")
      assert(parameter.screen_transition_pattern == TRANS_PTN_NEW, "CASE:2-1-1-3")
      assert(parameter.function_transition_no == 1, "CASE:2-1-1-4")
      assert(parameter.restored_transition_no.nil?, "CASE:2-1-1-5")
      assert(parameter.synchronous_token == token, "CASE:2-1-1-6")
      # 別画面起動
      params = create_params(TRANS_PTN_OTH, '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-2")
      assert(parameter.error_message.nil?, "CASE:2-1-2")
      assert(parameter.screen_transition_pattern == TRANS_PTN_OTH, "CASE:2-1-2")
      assert(parameter.function_transition_no == 1, "CASE:2-1-2")
      assert(parameter.restored_transition_no.nil?, "CASE:2-1-2")
      assert(parameter.synchronous_token == token, "CASE:2-1-2")
      # 現在機能内遷移
      params = create_params(TRANS_PTN_NOW, '2', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
#error_log("CASE:2-1-2:" + parameter.error_message.to_s)
      assert(!parameter.nil?, "CASE:2-1-3")
      assert(parameter.error_message.nil?, "CASE:2-1-3")
      assert(parameter.screen_transition_pattern == TRANS_PTN_NOW, "CASE:2-1-3-2")
      assert(parameter.function_transition_no == 2, "CASE:2-1-3-3")
      assert(parameter.restored_transition_no == nil, "CASE:2-1-3-4")
      assert(parameter.synchronous_token == token, "CASE:2-1-3-5")
      # 直前遷移
      params = create_params(TRANS_PTN_BACK, '2', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-4")
#error_log("Error Log:" + parameter.error_message.to_s)
      assert(parameter.error_message.nil?, "CASE:2-1-4-1")
      assert(parameter.screen_transition_pattern == TRANS_PTN_BACK, "CASE:2-1-4-2")
      assert(parameter.function_transition_no == 2, "CASE:2-1-4-3")
      assert(parameter.restored_transition_no == nil, "CASE:2-1-4-4")
      assert(parameter.synchronous_token == token, "CASE:2-1-4-5")
      # 復元遷移
      params = create_params(TRANS_PTN_REST, '2', '1', token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-5")
#error_log("Error Log:" + parameter.error_message.to_s)
      assert(parameter.error_message.nil?, "CASE:2-1-5-1")
      assert(parameter.screen_transition_pattern == TRANS_PTN_REST, "CASE:2-1-5-2")
      assert(parameter.function_transition_no == 2, "CASE:2-1-5-3")
      assert(parameter.restored_transition_no == 1, "CASE:2-1-5-4")
      assert(parameter.synchronous_token == token, "CASE:2-1-5-5")
      # 置換遷移
      params = create_params(TRANS_PTN_REP, '2', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-6")
      assert(parameter.error_message.nil?, "CASE:2-1-6-1")
      assert(parameter.screen_transition_pattern == TRANS_PTN_REP, "CASE:2-1-6-2")
      assert(parameter.function_transition_no == 2, "CASE:2-1-6-3")
      assert(parameter.restored_transition_no == nil, "CASE:2-1-6-4")
      assert(parameter.synchronous_token == token, "CASE:2-1-6-5")
      # 履歴クリア後新規起動
      params = create_params(TRANS_PTN_CLH, '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-7")
      assert(parameter.error_message.nil?, "CASE:2-1-7-1")
      assert(parameter.screen_transition_pattern == TRANS_PTN_CLH, "CASE:2-1-7-2")
      assert(parameter.function_transition_no == 1, "CASE:2-1-7-3")
      assert(parameter.restored_transition_no == nil, "CASE:2-1-7-4")
      assert(parameter.synchronous_token == token, "CASE:2-1-7-5")
      # 全状態クリア後新規起動
      params = create_params(TRANS_PTN_CLR, '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-8")
      assert(parameter.error_message.nil?, "CASE:2-1-8-1")
      assert(parameter.screen_transition_pattern == TRANS_PTN_CLR, "CASE:2-1-8-2")
#    error_log("CASE:2-1-6-3:" + parameter.function_transition_no.to_s)
      assert(parameter.function_transition_no == 1, "CASE:2-1-8-3")
      assert(parameter.restored_transition_no == nil, "CASE:2-1-8-4")
      assert(parameter.synchronous_token == token, "CASE:2-1-8-5")
      # 履歴クリア
      params = create_params(TRANS_PTN_HCL, '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-9")
      assert(parameter.error_message.nil?, "CASE:2-1-9-1")
      assert(parameter.screen_transition_pattern == TRANS_PTN_HCL, "CASE:2-1-9-2")
#    error_log("CASE:2-1-6-3:" + parameter.function_transition_no.to_s)
      assert(parameter.function_transition_no == 1, "CASE:2-1-9-3")
      assert(parameter.restored_transition_no == nil, "CASE:2-1-9-4")
      assert(parameter.synchronous_token == token, "CASE:2-1-9-5")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    # 異常ケース：画面遷移パターン
    begin
      token = '12345abcde12345abcde12345abcde12345abcde'
      params = create_params(1, '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-9")
#    error_log("Error Message:" + parameter.error_message.to_s)
      assert(parameter.error_message == '画面遷移パターン は不正な値です。', "CASE:2-1-9")
      params = create_params('0', '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-10")
      assert(parameter.error_message == '画面遷移パターン は不正な値です。', "CASE:2-1-10")
      params = create_params('10', '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-11")
      assert(parameter.error_message == '画面遷移パターン は不正な値です。', "CASE:2-1-11")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    # 異常ケース：遷移元機能遷移番号
    begin
      token = '12345abcde12345abcde12345abcde12345abcde'
      params = create_params(TRANS_PTN_NEW, 1, nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-12")
      assert(parameter.error_message == '機能遷移番号 は不正な値です。', "CASE:2-1-12")
      params = create_params(TRANS_PTN_NEW, 'a', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-12")
      assert(parameter.error_message == '機能遷移番号 は不正な値です。', "CASE:2-1-12")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    # 異常ケース：遷移先機能遷移番号
    begin
      token = '12345abcde12345abcde12345abcde12345abcde'
      params = create_params(TRANS_PTN_NEW, '2', '1', token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-13-1")
#   print_log("Error Message:" + parameter.error_message)
      assert(parameter.error_message == '復元先の機能遷移番号 は不正な値です。', "CASE:2-1-13-2")
      params = create_params(TRANS_PTN_REST, '2', 1, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-13-3")
#   print_log("Error Message:" + parameter.error_message)
      assert(parameter.error_message == '復元先の機能遷移番号 は不正な値です。', "CASE:2-1-13-4")
      params = create_params(TRANS_PTN_REST, '2', 'a', token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-13-5")
#   print_log("Error Message:" + parameter.error_message)
      assert(parameter.error_message == '復元先の機能遷移番号 は不正な値です。', "CASE:2-1-13-6")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    # 異常ケース：同期トークン
    begin
      params = create_params(TRANS_PTN_NEW, '1', nil, nil)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-14")
      assert(parameter.error_message == '同期トークン は不正な値です。', "CASE:2-1-14")
      token = '12345abcde12345abcde12345abcde12345abcd'
      params = create_params(TRANS_PTN_NEW, '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-14")
      assert(parameter.error_message == '同期トークン は不正な値です。', "CASE:2-1-14")
      token = '12345abcde12345abcde12345abcde12345abcdef'
      params = create_params(TRANS_PTN_NEW, '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-14")
      assert(parameter.error_message == '同期トークン は不正な値です。', "CASE:2-1-14")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：コンストラクタ
  test "2-02:UpdateSessionFilter Test:initialize" do
    # コンストラクタ
    begin
      filter = UpdateSessionFilter.new
      assert(!filter.nil?, "CASE:2-2-1")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：フィルタ処理　flashパラメータ渡し
  test "2-03:UpdateSessionFilter Test:filter flash" do
    client_host = 'nfmv001123166.uqw.ppp.infoweb.ne.jp'
    client_ip = '222.158.186.166'
    proxy_host = 'proxy001066096.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '192.168.254.10'
    msg_head = "Update Session Error!!!::"
    host_msg = "(HOST:" + client_host + ", PROXY:" + proxy_host + ")"
    # 正常：ログイン状態
    begin
      # コントローラー生成
      params = {:controller_path => 'update_session_filter_test/sub',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # PROXY情報
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      # クライアント情報：ホスト情報逆引き、NULL
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      top_state = state_hash.new_state(mock_controller, nil)
      mock_controller.controller_path = "mock/mock"
      target_state = state_hash.new_state(mock_controller, top_state.func_tran_no)
      target_token = target_state.sync_tkn
      state = state_hash.new_state(mock_controller, target_state.func_tran_no)
      state = state_hash.new_state(mock_controller, state.func_tran_no)
      state = state_hash.new_state(mock_controller, state.func_tran_no)
      # パラメータ生成
      prev_token = state.sync_tkn
      mock_controller.flash[:params] = create_params(TRANS_PTN_REST, '5', '2', prev_token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-3-1-1")
        params = mock_controller.flash[:params]
        assert(params.size == 4, "CASE:2-3-2")
        assert(params[:screen_transition_pattern] == TRANS_PTN_REST, "CASE:2-3-2")
        assert(params[:function_transition_no] == '5', "CASE:2-3-2")
        assert(params[:restored_transition_no] == '2', "CASE:2-3-2")
        assert(params[:synchronous_token] == prev_token, "CASE:2-3-2")
        assert(mock_controller.session.size == 2, "CASE:2-3-3-1")
        message = mock_controller.logger.warn_msg_list[0]
        assert(message.nil?, "CASE:2-3-3-2")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-3-4")
        assert(top_state == state_hash[1], "CASE:2-3-4")
        assert(target_state == state_hash[2], "CASE:2-3-4")
        assert(state_hash[3].nil?, "CASE:2-3-4")
        assert(state_hash[4].nil?, "CASE:2-3-4")
        assert(state_hash[5].nil?, "CASE:2-3-4")
        now_state = mock_controller.session[:function_state]
#    print_log("CASE:2-3-5:" +
#              target_state.func_tran_no.to_s + ':' +
#              now_state.func_tran_no.to_s)
        assert(FunctionState === now_state, "CASE:2-3-5-1")
        assert(target_state === now_state, "CASE:2-3-5-2")
        assert(now_state.cntr_path == "mock/mock", "CASE:2-3-5-3")
        assert(now_state.func_tran_no == 2, "CASE:2-3-5-4")
        assert(now_state.prev_tran_no == 1, "CASE:2-3-5-5")
        assert(now_state.next_tran_no.nil?, "CASE:2-3-5-6")
        assert(!now_state.sept_flg, "CASE:2-3-5-7")
        assert(now_state.sync_tkn == target_token, "CASE:2-3-5-8")
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("Error Message:" + message.to_s)
      assert(execute_flg, "CASE:2-3-1-2")
      assert(message.nil?, "CASE:2-3-3-3")
      assert(mock_controller.request.size == 0, "CASE:2-3-1-3")
      assert(mock_controller.flash[:params].size == 4, "CASE:2-3-2")
#      print_log("Session Size:" + mock_controller.session.size.to_s)
      assert(mock_controller.session.size == 1, "CASE:2-3-3-4")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    # 異常：履歴削除エラー
    begin
      # コントローラー生成
      params = {:controller_path => "mock/mock",
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # PROXY情報
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      # クライアント情報：ホスト情報逆引き、NULL
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      target_state = state_hash.new_state(mock_controller, nil)
      target_token = target_state.sync_tkn
      state = state_hash.new_state(mock_controller, target_state.func_tran_no)
      token = state.sync_tkn
      # パラメータ生成
      mock_controller.flash[:params] = create_params(TRANS_PTN_REST, '2', '0', token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-3-1-4")
        params = mock_controller.flash[:params]
        assert(params.size == 4, "CASE:2-3-2")
        assert(params[:screen_transition_pattern] == TRANS_PTN_REST, "CASE:2-3-2")
        assert(params[:function_transition_no] == '2', "CASE:2-3-2")
        assert(params[:restored_transition_no] == '0', "CASE:2-3-2")
        assert(params[:synchronous_token] == token, "CASE:2-3-2")
        assert(mock_controller.session.size == 2, "CASE:2-3-3-5")
        message = mock_controller.logger.warn_msg_list[0]
        assert(message == '復元先の機能遷移番号 は不正な値です。', "CASE:2-3-6")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-3-3-6")
        assert(target_state == state_hash[1], "CASE:2-3-3-7")
        assert(state == state_hash[2], "CASE:2-3-3-8")
        now_state = mock_controller.session[:function_state]
        assert(now_state.nil?, "CASE:2-3-3-9")
      end
      message = mock_controller.logger.warn_msg_list[0]
      assert(execute_flg == false, "CASE:2-3-1-5")
#    print_log("CASE:2-3-3-10 Message:" + message)
      assert(message == (msg_head + "復元先の機能遷移番号 は不正な値です。" + host_msg).to_s, "CASE:2-3-3-10")
      assert(mock_controller.request.size == 0, "CASE:2-3-1-6")
      assert(mock_controller.flash[:params].size == 4, "CASE:2-3-2")
      assert(mock_controller.session.size == 1, "CASE:2-3-3-11")
      assert(mock_controller.redirect_hash[:url] == '/403.html', "CASE:2-3-4")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：フィルタ処理（新規起動）
  test "2-04:UpdateSessionFilter Test:filter TRANS_PTN_NEW" do
    client_host = 'nfmv001012086.uqw.ppp.infoweb.ne.jp'
    client_ip = '175.179.198.86'
    proxy_host = 'proxy001066096.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '192.168.254.10'
    msg_head = "Update Session Error!!!::"
    host_msg = "(HOST:" + client_host + ", PROXY:" + proxy_host + ")"
    # 正常：能状態生成メソッド無し
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # PROXY情報
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      # クライアント情報：ホスト情報逆引き、NULL
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(mock_controller, nil)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params(TRANS_PTN_NEW, state.func_tran_no.to_s, nil, state.sync_tkn)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-3")
        assert(mock_controller.params.size == 3, "CASE:2-4-4")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_NEW, "CASE:2-4-4")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-4-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-4-4")
        assert(mock_controller.session.size == 2, "CASE:2-4-5-1")
        message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-5-3 Error Message:" + message.to_s)
        assert(message.nil?, "CASE:2-4-5-3")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-4-5-4")
        assert(state == state_hash[1], "CASE:2-4-5-5")
        new_state = mock_controller.session[:function_state]
        assert(new_state == state_hash[2], "CASE:2-4-6-1")
        assert(FunctionState === new_state, "CASE:2-4-6-2")
        assert(new_state.cntr_path == 'mock/mock', "CASE:2-4-6-3")
        assert(new_state.func_tran_no == 2, "CASE:2-4-6-4")
        assert(new_state.prev_tran_no == 1, "CASE:2-4-6-5")
        assert(new_state.next_tran_no.nil?, "CASE:2-4-6-6")
        assert(!new_state.sept_flg, "CASE:2-4-6-7")
        assert(new_state.sync_tkn.length == 40, "CASE:2-4-6-8")
        assert(new_state.sync_tkn != token, "CASE:2-4-6-9")
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-5-6 Error Message:" + message.to_s)
      assert(execute_flg, "CASE:2-4-2-1")
      assert(message.nil?, "CASE:2-4-5-6")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 1, "CASE:2-4-5-7")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    # 正常：機能状態生成メソッド有り
    begin
      # コントローラー生成
      params = {:controller_path => 'update_session_filter_test/sub',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
#      mock_controller = MockController.new(params)
      mock_controller = SubController.new(params)
      # PROXY情報
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      # クライアント情報：ホスト情報逆引き、NULL
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(mock_controller, nil)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params(TRANS_PTN_NEW, state.func_tran_no.to_s, nil, state.sync_tkn)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-3")
        assert(mock_controller.params.size == 3, "CASE:2-4-4")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_NEW, "CASE:2-4-4")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-4-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-4-4")
#      print_log("Session:" + mock_controller.session.to_s)
#      print_log("Session Size:" + mock_controller.session.size.to_s)
#      print_log("Controller Path:" + mock_controller.controller_path)
        assert(mock_controller.session.size == 2, "CASE:2-4-5-8")
#        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-4-5-9")
        message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-5-10 Error Message:" + message.to_s)
        assert(message.nil?, "CASE:2-4-5-10")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-4-5-11")
        assert(state == state_hash[1], "CASE:2-4-5-12")
        new_state = mock_controller.session[:function_state]
#      print_log("CASE:2-4-7-1:" + new_state.class.name)
        assert(SubFunctionState === new_state, "CASE:2-4-7-1")
#      print_log("Function Info:" + new_state.cntr_path.to_s)
        assert(new_state.cntr_path == 'update_session_filter_test/sub', "CASE:2-4-7-2")
        assert(new_state.func_tran_no == 2, "CASE:2-4-7-3")
        assert(new_state.prev_tran_no == 1, "CASE:2-4-7-4")
        assert(new_state.next_tran_no.nil?, "CASE:2-4-7-5")
        assert(!new_state.sept_flg, "CASE:2-4-7-6")
        assert(new_state.sync_tkn.length == 40, "CASE:2-4-7-7")
        assert(new_state.sync_tkn != token, "CASE:2-4-7-8")
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-5-13 Error Message:" + message.to_s)
      assert(execute_flg, "CASE:2-4-2-2")
      assert(message.nil?, "CASE:2-4-5-13")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 1, "CASE:2-4-5-14")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    ###########################################################################
    # 異常：画面遷移パターンエラー
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # PROXY情報
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      # クライアント情報：ホスト情報逆引き、NULL
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(mock_controller, nil)
      # パラメータ生成（エラー）
      mock_controller.params = create_params('10', '1', nil, state.sync_tkn)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-5-25 Error Message:" + message.to_s)
      assert(execute_flg == false, "CASE:2-4-2-3")
      assert(message == (msg_head + "画面遷移パターン は不正な値です。" + host_msg).to_s, "CASE:2-4-5-25")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 1, "CASE:2-4-5-26")
      assert(mock_controller.redirect_hash[:url] == '/403.html', "CASE:2-4-5-27")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # PROXY情報
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      # クライアント情報：ホスト情報逆引き、NULL
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(mock_controller, nil)
      # パラメータ生成（エラー）
      mock_controller.params = create_params('0', '1', nil, state.sync_tkn)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-5-25 Error Message:" + message.to_s)
      assert(execute_flg == false, "CASE:2-4-2-3")
      assert(message == (msg_head + "画面遷移パターン は不正な値です。" + host_msg).to_s, "CASE:2-4-5-25")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 1, "CASE:2-4-5-26")
      assert(mock_controller.redirect_hash[:url] == '/403.html', "CASE:2-4-5-27")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    
    ###########################################################################
    # 異常：送信元機能遷移番号エラー
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # PROXY情報
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      # クライアント情報：ホスト情報逆引き、NULL
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(mock_controller, nil)
      # パラメータ生成（エラー）
      token = state.sync_tkn
      mock_controller.params = create_params(TRANS_PTN_NEW, '10', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-3")
        assert(mock_controller.params.size == 3, "CASE:2-4-4")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_NEW, "CASE:2-4-4")
        assert(mock_controller.params[:function_transition_no] == '10', "CASE:2-4-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-4-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-4-4")
        assert(mock_controller.session.size == 2, "CASE:2-4-5-27")
        message = mock_controller.logger.warn_msg_list[0]
#      print_log("Error Message:" + message.to_s)
        assert(message == '機能遷移番号 は不正な値です。', "CASE:2-4-10")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-4-5-29")
        assert(state == state_hash[1], "CASE:2-4-5-30")
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-5-31 Error Message:" + message.to_s)
      assert(execute_flg == false, "CASE:2-4-2-4")
      assert(message == (msg_head + "機能遷移番号 は不正な値です。" + host_msg).to_s, "CASE:2-4-5-31")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 1, "CASE:2-4-5-32")
      assert(mock_controller.redirect_hash[:url] == '/403.html', "CASE:2-4-5-33")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end

    ###########################################################################
    # 異常：同期トークンエラー
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # PROXY情報
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      # クライアント情報：ホスト情報逆引き、NULL
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(mock_controller, nil)
      # パラメータ生成（エラー）
      token = '1234567890123456789012345678901234567890'
      mock_controller.params = create_params(TRANS_PTN_NEW, '1', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-3")
        assert(mock_controller.params.size == 3, "CASE:2-4-4")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_NEW, "CASE:2-4-4")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-4-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-4-4")
        assert(mock_controller.session.size == 2, "CASE:2-4-5-33")
        message = mock_controller.logger.warn_msg_list[0]
        assert(message == '同期トークン は不正な値です。', "CASE:2-4-11")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-4-5-35")
        assert(state == state_hash[1], "CASE:2-4-5-36")
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-5-37 Error Message:" + message.to_s)
      assert(execute_flg == false, "CASE:2-4-2-5")
      assert(message == (msg_head + "同期トークン は不正な値です。" + host_msg).to_s, "CASE:2-4-5-37")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 1, "CASE:2-4-5-38")
      assert(mock_controller.redirect_hash[:url] == '/403.html', "CASE:2-4-5-39")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    
    ###########################################################################
    # 異常：機能状態ハッシュオーバーフロー
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # PROXY情報
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      # クライアント情報：ホスト情報逆引き、NULL
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成（ハッシュ数フル）
      state = state_hash.new_state(mock_controller, nil)
      while(!state_hash.max_size?) do
        state = state_hash.new_state(mock_controller, state.func_tran_no)
      end
      # パラメータ生成
      token = state.sync_tkn
      trans_no = state.func_tran_no.to_s
      mock_controller.params = create_params(TRANS_PTN_NEW, trans_no, nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-3")
        assert(mock_controller.params.size == 3, "CASE:2-4-4")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_NEW, "CASE:2-4-4")
        assert(mock_controller.params[:function_transition_no] == trans_no, "CASE:2-4-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-4-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-4-4")
        assert(mock_controller.session.size == 2, "CASE:2-4-5-39")
        message = mock_controller.logger.warn_msg_list[0]
        assert(message == '機能状態ハッシュ が一杯です。', "CASE:2-4-12")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-4-5-41")
        assert(state == state_hash[trans_no.to_i], "CASE:2-4-5-42")
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-5-43 Error Message:" + message.to_s)
      assert(execute_flg == false, "CASE:2-4-2-6")
      assert(message == (msg_head + "機能状態ハッシュ が一杯です。" + host_msg).to_s, "CASE:2-4-5-43")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 1, "CASE:2-4-5-44")
      assert(mock_controller.redirect_hash[:url] == '/403.html', "CASE:2-4-5-45")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    
    ###########################################################################
    # 異常：セッション情報エラー
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態生成（ハッシュ数フル）
      state_hash = FunctionStateHash.new
      state = state_hash.new_state(mock_controller, nil)
      # パラメータ生成
      token = state.sync_tkn
      trans_no = state.func_tran_no.to_s
      mock_controller.params = create_params(TRANS_PTN_NEW, trans_no, nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-6 Error Message:" + message.to_s)
      assert(execute_flg == false, "CASE:2-4-6-10")
      assert(message == (msg_head + "セッション情報 は不正な値です。" + host_msg).to_s, "CASE:2-4-6-11")
      assert(mock_controller.request.size == 0, "CASE:2-4-6-12")
      assert(mock_controller.params.size == 3, "CASE:2-4-6-13")
      assert(mock_controller.session.size == 0, "CASE:2-4-6-14")
      assert(mock_controller.redirect_hash[:url] == '/403.html', "CASE:2-4-6-15")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
    
  # UpdateSessionFilterクラス：フィルタ処理（別画面起動）
  test "2-05:UpdateSessionFilter Test:filter TRANS_PTN_OTH" do
    client_host = 'nfmv001012086.uqw.ppp.infoweb.ne.jp'
    client_ip = '175.179.198.86'
    proxy_host = 'proxy001066096.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '192.168.254.10'
    msg_head = "Update Session Error!!!::"
    host_msg = "(HOST:" + client_host + ", PROXY:" + proxy_host + ")"
    ###########################################################################
    # 正常：機能状態生成メソッド無し
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      top_state = state_hash.new_state(mock_controller, nil)
      # パラメータ生成
      mock_controller.params = create_params(TRANS_PTN_OTH, top_state.func_tran_no.to_s, nil, top_state.sync_tkn)
      # テスト実行
      execute_flg = false
      token = top_state.sync_tkn
      filter_obj = UpdateSessionFilter.new
      filter_obj.filter(mock_controller) do
        execute_flg = true
        state_hash = mock_controller.session[:function_state_hash]
        new_state = mock_controller.session[:function_state]
        assert(new_state == state_hash[2], "CASE:2-5-1")
        assert(FunctionState === new_state, "CASE:2-5-1")
        assert(new_state.cntr_path == 'mock/mock', "CASE:2-5-1")
        assert(new_state.func_tran_no == 2, "CASE:2-5-1")
        assert(new_state.prev_tran_no == 1, "CASE:2-5-1")
        assert(new_state.next_tran_no.nil?, "CASE:2-5-1")
        assert(new_state.sept_flg, "CASE:2-5-1")
        assert(new_state.sync_tkn.length == 40, "CASE:2-5-1")
        assert(new_state.sync_tkn != token, "CASE:2-5-1")
        assert(FunctionStateHash === state_hash, "CASE:2-5-2")
        assert(top_state == state_hash[1], "CASE:2-5-2")
        assert(mock_controller.request.size == 0, "CASE:2-5-3")
        assert(mock_controller.params.size == 3, "CASE:2-5-4")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_OTH, "CASE:2-5-4")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-5-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-5-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-5-4")
        assert(mock_controller.session.size == 2, "CASE:2-5-5-1")
        message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-5-3 Error Message:" + message.to_s)
        assert(message.nil?, "CASE:2-5-5-3")
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-5-6 Error Message:" + message.to_s)
      assert(execute_flg, "CASE:2-5-1")
      assert(message.nil?, "CASE:2-5-1")
      assert(mock_controller.request.size == 0, "CASE:2-5-3")
      assert(mock_controller.params.size == 3, "CASE:2-5-4")
      assert(mock_controller.session.size == 1, "CASE:2-5-5-7")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    ###########################################################################
    # 異常：機能状態ハッシュ最大サイズオーバー
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(mock_controller, nil)
      (2..30).each do
        state = state_hash.new_state(mock_controller, state.func_tran_no)
      end
      # パラメータ生成
      mock_controller.params = create_params(TRANS_PTN_OTH, state.func_tran_no.to_s, nil, state.sync_tkn)
      # テスト実行
      execute_flg = false
      token = state.sync_tkn
      filter_obj = UpdateSessionFilter.new
      filter_obj.filter(mock_controller) do
        execute_flg = true
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-4-5-6 Error Message:" + message.to_s)
      assert(!execute_flg, "CASE:2-5-2-1")
      assert(message == (msg_head + "機能状態ハッシュ が一杯です。" + host_msg).to_s, "CASE:2-5-5-6")
      assert(mock_controller.request.size == 0, "CASE:2-5-3")
      assert(mock_controller.params.size == 3, "CASE:2-5-4")
      assert(mock_controller.session.size == 1, "CASE:2-5-5-7")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：フィルタ処理（現在機能内遷移）
  test "2-06:UpdateSessionFilter Test:filter TRANS_PTN_NOW" do
    client_host = 'nfmv001012086.uqw.ppp.infoweb.ne.jp'
    client_ip = '175.179.198.86'
    proxy_host = 'proxy001066096.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '192.168.254.10'
    msg_head = "Update Session Error!!!::"
    host_msg = "(HOST:" + client_host + ", PROXY:" + proxy_host + ")"
    ###########################################################################
    # 正常：ログイン状態
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(mock_controller, nil)
      mock_controller.session[:function_state] = state
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params(TRANS_PTN_NOW, '1', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-6-1")
        assert(mock_controller.params.size == 3, "CASE:2-6-2")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_NOW, "CASE:2-6-2")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-6-2")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-6-2")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-6-2")
        assert(mock_controller.session.size == 2, "CASE:2-6-3")
        message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-6-3 Error Message:" + message.to_s)
        assert(message.nil?, "CASE:2-6-3")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-6-3")
        assert(state == state_hash[1], "CASE:2-6-3")
        now_state = mock_controller.session[:function_state]
#        print_log("2-6-4 now state:" + now_state.class.name)
        assert(state_hash[2].nil?, "CASE:2-6-4-1")
        assert(FunctionState === now_state, "CASE:2-6-4-2")
        assert(now_state.cntr_path == 'mock/mock', "CASE:2-6-4-3")
        assert(now_state.func_tran_no == 1, "CASE:2-6-4-4")
        assert(now_state.prev_tran_no.nil?, "CASE:2-6-4-5")
        assert(now_state.next_tran_no.nil?, "CASE:2-6-4-6")
        assert(now_state.sept_flg, "CASE:2-6-4-7")
        assert(now_state.sync_tkn == token, "CASE:2-6-4-8")
      end
      assert(execute_flg, "CASE:2-6-1")
      message = mock_controller.logger.warn_msg_list[0]
      assert(message.nil?, "CASE:2-6-3")
      assert(mock_controller.request.size == 0, "CASE:2-6-1")
      assert(mock_controller.params.size == 3, "CASE:2-6-2")
      assert(mock_controller.session.size == 1, "CASE:2-6-3")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    ###########################################################################
    # 異常：コントローラーパス異常
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(mock_controller, nil)
      # コントローラー切り替え
      params = {:controller_path => 'mock/error',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ設定
      mock_controller.session[:function_state_hash] = state_hash
      # パラメータ生成
      mock_controller.params = create_params(TRANS_PTN_NOW, state.func_tran_no.to_s, nil, state.sync_tkn)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
      end
      assert(!execute_flg, "CASE:2-6-5-1")
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-6-5 Error Message:" + message.to_s)
      assert(message == (msg_head + "コントローラーパス は不正な値です。" + host_msg).to_s, "CASE:2-6-5-2")
      assert(mock_controller.request.size == 0, "CASE:2-6-5-3")
      assert(mock_controller.params.size == 3, "CASE:2-6-5-4")
      assert(mock_controller.session.size == 1, "CASE:2-6-5-5")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：フィルタ処理（直前遷移）
  test "2-07:UpdateSessionFilter Test:filter TRANS_PTN_BACK" do
    client_host = 'nfmv001012086.uqw.ppp.infoweb.ne.jp'
    client_ip = '175.179.198.86'
    proxy_host = 'proxy001066096.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '192.168.254.10'
    msg_head = "Update Session Error!!!::"
    host_msg = "(HOST:" + client_host + ", PROXY:" + proxy_host + ")"
    ###########################################################################
    # 正常：
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      top_state = state_hash.new_state(mock_controller, nil)
      state = state_hash.new_state(mock_controller, top_state.func_tran_no)
      state = state_hash.new_state(mock_controller, state.func_tran_no)
      target_state = state_hash.new_state(mock_controller, state.func_tran_no)
      target_token = target_state.sync_tkn
      state = state_hash.new_state(mock_controller, target_state.func_tran_no)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params(TRANS_PTN_BACK, '5', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-7-1-1")
        assert(mock_controller.params.size == 3, "CASE:2-7-2")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_BACK, "CASE:2-7-2")
        assert(mock_controller.params[:function_transition_no] == '5', "CASE:2-7-2")
        assert(mock_controller.params[:restored_transition_no] == nil, "CASE:2-7-2")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-7-2")
        assert(mock_controller.session.size == 2, "CASE:2-7-3-1")
        message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-7-3-3 Error Message:" + message.to_s)
        assert(message.nil?, "CASE:2-7-3-3")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-7-4")
        assert(top_state == state_hash[1], "CASE:2-7-4")
        assert(target_state == state_hash[4], "CASE:2-7-4")
        assert(state_hash[5].nil?, "CASE:2-7-4")
        now_state = mock_controller.session[:function_state]
        assert(FunctionState === now_state, "CASE:2-7-5")
        assert(target_state === now_state, "CASE:2-7-5")
        assert(now_state.cntr_path == 'mock/mock', "CASE:2-7-5")
        assert(now_state.func_tran_no == 4, "CASE:2-7-5")
        assert(now_state.prev_tran_no == 3, "CASE:2-7-5")
        assert(now_state.next_tran_no.nil?, "CASE:2-7-5")
        assert(!now_state.sept_flg, "CASE:2-7-5")
        assert(now_state.sync_tkn == target_token, "CASE:2-7-5")
      end
      message = mock_controller.logger.warn_msg_list[0]
      assert(execute_flg, "CASE:2-7-1-2")
#      print_log("2-7-3-4 Error Message:" + message.to_s)
      assert(message.nil?, "CASE:2-7-3-4")
      assert(mock_controller.request.size == 0, "CASE:2-7-1-3")
      assert(mock_controller.params.size == 3, "CASE:2-7-2")
      assert(mock_controller.session.size == 1, "CASE:2-7-3-5")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    ###########################################################################
    # 異常：遷移元の機能状態無し
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      target_state = state_hash.new_state(mock_controller, nil)
      # パラメータ生成
      mock_controller.params = create_params(TRANS_PTN_BACK,
                                             target_state.func_tran_no.to_s,
                                             nil,
                                             target_state.sync_tkn)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
      end
      assert(execute_flg == false, "CASE:2-7-1-5")
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-7-3 Error Message:" + message.to_s)
      assert(message == (msg_head + "遷移元の機能状態 が見つかりません。" + host_msg).to_s, "CASE:2-7-3-1")
      assert(mock_controller.request.size == 0, "CASE:2-7-1-6")
      assert(mock_controller.params.size == 3, "CASE:2-7-2")
      assert(mock_controller.session.size == 1, "CASE:2-7-3-2")
      assert(mock_controller.redirect_hash[:url] == '/403.html', "CASE:2-7-4")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    ###########################################################################
    # 異常：分離ポイントからの遷移
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      prev_state = state_hash.new_state(mock_controller, nil)
      target_state = state_hash.new_state(mock_controller, prev_state.func_tran_no, true)
      # パラメータ生成
      mock_controller.params = create_params(TRANS_PTN_BACK,
                                             target_state.func_tran_no.to_s,
                                             nil,
                                             target_state.sync_tkn)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
      end
      assert(execute_flg == false, "CASE:2-7-1-5")
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-7-3 Error Message:" + message.to_s)
      assert(message == (msg_head + "遷移元の機能状態 が見つかりません。" + host_msg).to_s, "CASE:2-7-3-1")
      assert(mock_controller.request.size == 0, "CASE:2-7-1-6")
      assert(mock_controller.params.size == 3, "CASE:2-7-2")
      assert(mock_controller.session.size == 1, "CASE:2-7-3-2")
      assert(mock_controller.redirect_hash[:url] == '/403.html', "CASE:2-7-4")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：フィルタ処理（復元遷移）
  test "2-08:UpdateSessionFilter Test:filter TRANS_PTN_REST" do
    client_host = 'nfmv001012086.uqw.ppp.infoweb.ne.jp'
    client_ip = '175.179.198.86'
    proxy_host = 'proxy001066096.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '192.168.254.10'
    msg_head = "Update Session Error!!!::"
    host_msg = "(HOST:" + client_host + ", PROXY:" + proxy_host + ")"
    ###########################################################################
    # 正常：復元遷移
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      top_state = state_hash.new_state(mock_controller, nil)
      target_state = state_hash.new_state(mock_controller, nil)
      target_token = target_state.sync_tkn
      state = state_hash.new_state(mock_controller, target_state.func_tran_no)
      state = state_hash.new_state(mock_controller, target_state.func_tran_no)
      state = state_hash.new_state(mock_controller, target_state.func_tran_no)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params(TRANS_PTN_REST, '5', '2', token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-8-1")
        assert(mock_controller.params.size == 4, "CASE:2-8-2")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_REST, "CASE:2-8-2")
        assert(mock_controller.params[:function_transition_no] == '5', "CASE:2-8-2")
        assert(mock_controller.params[:restored_transition_no] == '2', "CASE:2-8-2")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-8-2")
        assert(mock_controller.session.size == 2, "CASE:2-8-3-1")
        message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-8-3-3 Error Message:" + message.to_s)
        assert(message.nil?, "CASE:2-8-3-3")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-8-4")
        assert(top_state == state_hash[1], "CASE:2-8-4")
        assert(target_state == state_hash[2], "CASE:2-8-4")
        assert(state_hash[3].nil?, "CASE:2-8-4")
        assert(state_hash[4].nil?, "CASE:2-8-4")
        assert(state_hash[5].nil?, "CASE:2-8-4")
        now_state = mock_controller.session[:function_state]
        assert(FunctionState === now_state, "CASE:2-8-5")
        assert(target_state === now_state, "CASE:2-8-5")
        assert(now_state.cntr_path == 'mock/mock', "CASE:2-8-5")
        assert(now_state.func_tran_no == 2, "CASE:2-8-5")
        assert(now_state.prev_tran_no.nil?, "CASE:2-8-5")
        assert(now_state.next_tran_no.nil?, "CASE:2-8-5")
        assert(now_state.sept_flg, "CASE:2-8-5")
        assert(now_state.sync_tkn == target_token, "CASE:2-8-5")
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-8-3 Error Message:" + message.to_s)
      assert(execute_flg, "CASE:2-8-1")
      assert(message.nil?, "CASE:2-8-3")
      assert(mock_controller.request.size == 0, "CASE:2-8-1")
      assert(mock_controller.params.size == 4, "CASE:2-8-2")
      assert(mock_controller.session.size == 1, "CASE:2-8-3")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    ###########################################################################
    # 異常：履歴削除エラー
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      target_state = state_hash.new_state(mock_controller, nil)
      target_token = target_state.sync_tkn
      state = state_hash.new_state(mock_controller, target_state.func_tran_no)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params(TRANS_PTN_REST, '2', '0', token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
      end
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-8-3 Error Message:" + message.to_s)
      assert(execute_flg == false, "CASE:2-8-1")
      assert(message == (msg_head + "復元先の機能遷移番号 は不正な値です。" + host_msg).to_s, "CASE:2-8-3")
      assert(mock_controller.request.size == 0, "CASE:2-8-1")
      assert(mock_controller.params.size == 4, "CASE:2-8-2")
      assert(mock_controller.session.size == 1, "CASE:2-8-3")
      assert(mock_controller.redirect_hash[:url] == '/403.html', "CASE:2-8-4")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：フィルタ処理（置換遷移）
  test "2-09:UpdateSessionFilter Test:filter TRANS_PTN_REP" do
    client_host = 'nfmv001012086.uqw.ppp.infoweb.ne.jp'
    client_ip = '175.179.198.86'
    proxy_host = 'proxy001066096.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '192.168.254.10'
    msg_head = "Update Session Error!!!::"
    host_msg = "(HOST:" + client_host + ", PROXY:" + proxy_host + ")"
    ###########################################################################
    # 正常：置換遷移
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(mock_controller, nil)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params(TRANS_PTN_REP, '1', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-9-1")
        assert(mock_controller.params.size == 3, "CASE:2-9-2")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_REP, "CASE:2-9-2")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-9-2")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-9-2")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-9-2")
        assert(mock_controller.session.size == 2, "CASE:2-9-3")
        message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-9-3 Error Message:" + message.to_s)
        assert(message.nil?, "CASE:2-9-3")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-9-4")
        assert(state_hash[1].nil?, "CASE:2-9-4")
        now_state = mock_controller.session[:function_state]
        assert(FunctionState === now_state, "CASE:2-9-5")
        assert(now_state == state_hash[2], "CASE:2-9-5")
        assert(now_state.cntr_path == 'mock/mock', "CASE:2-9-5")
        assert(now_state.func_tran_no == 2, "CASE:2-9-5")
        assert(now_state.prev_tran_no.nil?, "CASE:2-9-5")
        assert(now_state.next_tran_no.nil?, "CASE:2-9-5")
        assert(now_state.sept_flg, "CASE:2-9-5")
        assert(now_state.sync_tkn == state_hash[2].sync_tkn, "CASE:2-9-5")
      end
      assert(execute_flg, "CASE:2-9-1")
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-9-3 Error Message:" + message.to_s)
      assert(message.nil?, "CASE:2-9-3")
      assert(mock_controller.request.size == 0, "CASE:2-9-1")
      assert(mock_controller.params.size == 3, "CASE:2-9-2")
      assert(mock_controller.session.size == 1, "CASE:2-9-3")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：フィルタ処理（履歴クリア後新規起動）
  test "2-10:UpdateSessionFilter Test:filter TRANS_PTN_CLH" do
    client_host = 'nfmv001012086.uqw.ppp.infoweb.ne.jp'
    client_ip = '175.179.198.86'
    proxy_host = 'proxy001066096.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '192.168.254.10'
    msg_head = "Update Session Error!!!::"
    host_msg = "(HOST:" + client_host + ", PROXY:" + proxy_host + ")"
    ###########################################################################
    # 正常：履歴クリア後新規起動
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      top_state = state_hash.new_state(mock_controller, nil)
      state = state_hash.new_state(mock_controller, top_state.func_tran_no, true)
      (3..30).each do
        state = state_hash.new_state(mock_controller, state.func_tran_no)
      end
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params(TRANS_PTN_CLH, state.func_tran_no.to_s, nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-10-1")
        assert(mock_controller.params.size == 3, "CASE:2-10-2-1")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_CLH, "CASE:2-10-2-2")
        assert(mock_controller.params[:function_transition_no] == '30', "CASE:2-10-2-3")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-10-2-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-10-2-5")
        assert(mock_controller.session.size == 2, "CASE:2-10-3")
        message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-10-3 Error Message:" + message.to_s)
        assert(message.nil?, "CASE:2-10-3")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-10-4")
        assert(state_hash[1] == top_state, "CASE:2-10-4")
        (2..30).each do |idx|
          assert(state_hash[idx].nil?, "CASE:2-10-4")
        end
        now_state = mock_controller.session[:function_state]
        assert(FunctionState === now_state, "CASE:2-10-5-1")
        assert(now_state == state_hash[31], "CASE:2-10-5-2")
        assert(now_state.cntr_path == 'mock/mock', "CASE:2-10-5-3")
        assert(now_state.func_tran_no == 31, "CASE:2-10-5-4")
        assert(now_state.prev_tran_no.nil?, "CASE:2-10-5-5")
        assert(now_state.next_tran_no.nil?, "CASE:2-10-5-6")
        assert(now_state.sept_flg, "CASE:2-10-5-7")
        assert(now_state.sync_tkn == state_hash[31].sync_tkn, "CASE:2-10-5-8")
      end
      assert(execute_flg, "CASE:2-10-1")
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-10-3 Error Message:" + message.to_s)
      assert(message.nil?, "CASE:2-10-3")
      assert(mock_controller.request.size == 0, "CASE:2-10-1")
      assert(mock_controller.params.size == 3, "CASE:2-10-2")
      assert(mock_controller.session.size == 1, "CASE:2-10-3")
      # 機能状態のチェック
      state_hash = mock_controller.session[:function_state_hash]
      assert(FunctionStateHash === state_hash, "CASE:2-10-4")
      assert(state_hash[1] == top_state, "CASE:2-10-4")
      (2..30).each do |idx|
        assert(state_hash[idx].nil?, "CASE:2-10-4")
      end
      now_state = state_hash[31]
      assert(FunctionState === now_state, "CASE:2-10-5-1")
      assert(now_state.cntr_path == 'mock/mock', "CASE:2-10-5-3")
      assert(now_state.func_tran_no == 31, "CASE:2-10-5-4")
      assert(now_state.prev_tran_no.nil?, "CASE:2-10-5-5")
      assert(now_state.next_tran_no.nil?, "CASE:2-10-5-6")
      assert(now_state.sept_flg, "CASE:2-10-5-7")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：フィルタ処理（全状態クリア後新規遷移）
  test "2-11:UpdateSessionFilter Test:filter TRANS_PTN_CLR" do
    client_host = 'nfmv001012086.uqw.ppp.infoweb.ne.jp'
    client_ip = '175.179.198.86'
    proxy_host = 'proxy001066096.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '192.168.254.10'
    msg_head = "Update Session Error!!!::"
    host_msg = "(HOST:" + client_host + ", PROXY:" + proxy_host + ")"
    ###########################################################################
    # 正常：全状態クリア後新規遷移
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
#      print_log("Controller_Path:" + mock_controller.controller_path)
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(mock_controller, nil)
      state = state_hash.new_state(mock_controller, state.func_tran_no)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params(TRANS_PTN_CLR, '2', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-11-1")
        assert(mock_controller.params.size == 3, "CASE:2-11-2")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_CLR, "CASE:2-11-2")
        assert(mock_controller.params[:function_transition_no] == '2', "CASE:2-11-2")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-11-2")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-11-2")
        assert(mock_controller.session.size == 2, "CASE:2-11-3")
        message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-11-3 Error Message:" + message.to_s)
        assert(message.nil?, "CASE:2-11-3")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-11-4")
        assert(state_hash[1].nil?, "CASE:2-11-4")
        assert(state_hash[2].nil?, "CASE:2-11-4")
        now_state = mock_controller.session[:function_state]
        assert(FunctionState === now_state, "CASE:2-11-5")
        assert(now_state == state_hash[3], "CASE:2-11-5")
        assert(now_state.cntr_path == 'mock/mock', "CASE:2-11-5")
        assert(now_state.func_tran_no == 3, "CASE:2-11-5")
        assert(now_state.prev_tran_no.nil?, "CASE:2-11-5")
        assert(now_state.next_tran_no.nil?, "CASE:2-11-5")
        assert(now_state.sept_flg, "CASE:2-11-5")
        assert(now_state.sync_tkn == state_hash[3].sync_tkn, "CASE:2-11-5")
      end
      assert(execute_flg, "CASE:2-11-1")
      message = mock_controller.logger.warn_msg_list[0]
      assert(message.nil?, "CASE:2-11-3")
      assert(mock_controller.request.size == 0, "CASE:2-11-1")
      assert(mock_controller.params.size == 3, "CASE:2-11-2")
      assert(mock_controller.session.size == 1, "CASE:2-11-3")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：フィルタ処理（履歴クリア）
  test "2-12:UpdateSessionFilter Test:filter TRANS_PTN_HCL" do
    client_host = 'nfmv001012086.uqw.ppp.infoweb.ne.jp'
    client_ip = '175.179.198.86'
    proxy_host = 'proxy001066096.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '192.168.254.10'
    msg_head = "Update Session Error!!!::"
    host_msg = "(HOST:" + client_host + ", PROXY:" + proxy_host + ")"
    ###########################################################################
    # 正常：履歴クリア後新規起動
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      top_state = state_hash.new_state(mock_controller, nil)
      state = state_hash.new_state(mock_controller, top_state.func_tran_no, true)
      (3..30).each do
        state = state_hash.new_state(mock_controller, state.func_tran_no)
      end
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params(TRANS_PTN_HCL, state.func_tran_no.to_s, nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-12-1")
        assert(mock_controller.params.size == 3, "CASE:2-12-2-1")
        assert(mock_controller.params[:screen_transition_pattern] == TRANS_PTN_HCL, "CASE:2-12-2-2")
        assert(mock_controller.params[:function_transition_no] == '30', "CASE:2-12-2-3")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-12-2-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-12-2-5")
        assert(mock_controller.session.size == 2, "CASE:2-12-3")
        message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-12-3 Error Message:" + message.to_s)
        assert(message.nil?, "CASE:2-12-3")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-12-4")
        assert(state_hash[1] == top_state, "CASE:2-12-4")
        (2..30).each do |idx|
          assert(state_hash[idx].nil?, "CASE:2-12-4")
        end
        now_state = mock_controller.session[:function_state]
        assert(now_state.nil?, "CASE:2-12-5-1")
      end
      assert(execute_flg, "CASE:2-12-1")
      message = mock_controller.logger.warn_msg_list[0]
#      print_log("2-10-3 Error Message:" + message.to_s)
      assert(message.nil?, "CASE:2-12-3")
      assert(mock_controller.request.size == 0, "CASE:2-12-1")
      assert(mock_controller.params.size == 3, "CASE:2-12-2")
      assert(mock_controller.session.size == 1, "CASE:2-12-3")
      # 機能状態のチェック
      state_hash = mock_controller.session[:function_state_hash]
      assert(FunctionStateHash === state_hash, "CASE:2-12-4")
      assert(state_hash[1] == top_state, "CASE:2-12-4")
      (2..30).each do |idx|
        assert(state_hash[idx].nil?, "CASE:2-12-4")
      end
      now_state = state_hash[31]
      assert(now_state.nil?, "CASE:2-12-5-1")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：フィルタ処理（パフォーマンステスト：置換遷移）
  test "3-01:UpdateSessionFilter Test:Performance" do
    client_host = 'nfmv001012086.uqw.ppp.infoweb.ne.jp'
    client_ip = '175.179.198.86'
    proxy_host = 'proxy001066096.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '192.168.254.10'
    msg_head = "Update Session Error!!!::"
    host_msg = "(HOST:" + client_host + ", PROXY:" + proxy_host + ")"
    ###########################################################################
    # 正常：パフォーマンステスト
    ###########################################################################
    begin
      # コントローラー生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:post,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエストヘッダー編集
      mock_controller.request.headers['REMOTE_HOST'] = proxy_host
      mock_controller.request.headers['REMOTE_ADDR'] = proxy_ip
      mock_controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
      mock_controller.request.headers['HTTP_SP_HOST'] = client_host
      mock_controller.request.headers['HTTP_CLIENT_IP'] = client_ip
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(mock_controller, nil)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params(TRANS_PTN_REP, state.func_tran_no.to_s, nil, token)
#      mock_controller.params = create_params(TRANS_PTN_NOW, '1', nil, token)
      # テスト実行
      print_log("Processing Start")
      loop_count = 0
      exe_count = 0
      begin_time = Time.now
      10000.times do
        loop_count += 1
        UpdateSessionFilter.new.filter(mock_controller) do
          exe_count += 1
          state = mock_controller.session[:function_state]
          mock_controller.params = create_params(TRANS_PTN_REP,
                                                 state.func_tran_no.to_s,
                                                 nil, state.sync_tkn)
        end
      end
      execute_time = (Time.now.usec - begin_time.usec) / 1000
#      message = mock_controller.logger.warn_msg_list[0]
#      print("Error Message:" + message.to_s + "\n")
#      print_log("Error Message:" + message.to_s)
      print("Loop count:" + loop_count.to_s + "\n")
      print_log("Loop count:" + loop_count.to_s)
      print("Execute count:" + exe_count.to_s + "\n")
      print_log("Execute count:" + exe_count.to_s)
      print("Processing time:" + execute_time.to_s + "ms\n")
      print_log("Processing time:" + execute_time.to_s + "ms")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # パラメータオブジェクト生成処理
  def create_params(ptn, trans_no, rest_no, token)
    params = Hash.new
    params[:screen_transition_pattern] = ptn
    params[:function_transition_no] = trans_no
    params[:restored_transition_no] = rest_no unless rest_no.nil?
    params[:synchronous_token] = token
    return params
  end
  # 機能状態
  class SubFunctionState < FunctionState
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期化メソッド
    def initialize(cntr_path, func_tran_no, prev_tran_no, sept_flg=false)
      super(cntr_path, func_tran_no, prev_tran_no, sept_flg=false)
    end
  end
  # コントローラー
  class SubController < MockController
    ##########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize(params)
      super(params)
    end
    # 機能状態生成処理
    def create_function_state(cntr_path, func_tran_no, prev_tran_no, sept_flg=false)
      return SubFunctionState.new(cntr_path, func_tran_no, prev_tran_no, sept_flg)
    end
  end
  # コントローラー（エラー）
  class ErrorController < MockController
    ##########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize(params)
      super(params)
    end
    # 機能状態生成処理
    def create_function_state(cntr_path, func_tran_no, prev_tran_no, sept_flg=false)
      return SubFunctionState.new(cntr_path, func_tran_no, prev_tran_no, sept_flg)
    end
  end
end
