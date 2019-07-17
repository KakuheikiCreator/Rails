require 'test_helper'
require 'common/session_util_module'
require 'functional/functional_test_util'
require 'functional/filter/filter_test_module'

class Menu::MenuControllerTest < ActionController::TestCase
  include Common
  include FunctionalTestUtil
  include Filter::FilterTestModule
  
  # 2-01
  # action:menu
  # テスト項目概要：メニュー表示
  test '2-01 menu action' do
    # 正常（ポストメソッド）
    begin
      # セッション情報生成
      session_init?
      session[:login_id] = 'test_id'
      params = create_params(:TRANS_PTN_NEW, session[:function_state].func_tran_no)
      # メニュー表示
      post(:menu, params)
      assert_response(:success, 'CASE2-01-01-01')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE2-01-01-02')
      valid_state('menu/menu', 2, 1, false, 'CASE2-01-01-03')
      # アクション実行結果変数確認
      assert(assigns(:err_msg).nil?, 'CASE2-01-01-04')
      # メニュー画面確認
      assert_template('menu', 'CASE2-01-01-05')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # ログアウトリンク確認
      selector = '#03[action="/login/login/logout"]'
      assert_select(selector, true, 'CASE2-01-01-06')
      selector = '#03 input[name=screen_transition_pattern][value=8]'
      assert_select(selector, true, 'CASE2-01-01-07')
      selector = '#03 input[name=function_transition_no][value=' + state.func_tran_no.to_s + ']'
      assert_select(selector, true, 'CASE2-01-01-08')
      selector = '#03 input[name=synchronous_token][value=' + state.sync_tkn + ']'
      assert_select(selector, true, 'CASE2-01-01-09')
      selector = '#03 input[name=restored_transition_no]'
      assert_select(selector, false, 'CASE2-01-01-10')
      selector = '#link_03[href]'
      assert_select(selector, true, 'CASE2-01-01-11')
      # 規制クッキー一覧
      selector = '#05[action=/regulation_cookie_list/regulation_cookie_list/list]'
      assert_select(selector, true, 'CASE2-01-01-12')
      selector = '#05 input[name=screen_transition_pattern][value=1]'
      assert_select(selector, true, 'CASE2-01-01-13')
      selector = '#05 input[name=function_transition_no][value=' + state.func_tran_no.to_s + ']'
      assert_select(selector, true, 'CASE2-01-01-14')
      selector = '#05 input[name=synchronous_token][value=' + state.sync_tkn + ']'
      assert_select(selector, true, 'CASE2-01-01-15')
      selector = '#05 input[name=restored_transition_no]'
      assert_select(selector, false, 'CASE2-01-01-16')
      selector = '#link_05[href]'
      assert_select(selector, true, 'CASE2-01-01-17')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-01-01")
    end
  end

  # 2-07
  # テスト項目概要：フィルターテスト
  test '2-07 Filter Test' do
    sleep(0.2)
    # 異常（メソッド規制フィルター）
    begin
      # menu
      regulation_filter_chk(:menu, :get, 'CASE2-07-01-01')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-07-01")
    end
  end
end
