# -*- coding: utf-8 -*-
###############################################################################
# ファンクショナルテスト
# テスト対象：ログインコントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/06/17 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'functional/functional_test_util'
require 'functional/filter/filter_test_module'

# ログイン機能ファンクショナルテスト
class Login::LoginControllerTest < ActionController::TestCase
  include FunctionalTestUtil
  include Filter::FilterTestModule
  
  # 初期化処理
  def setup
#    @controller = Login::LoginController.new
#    @request    = ActionController::TestRequest.new
#    @response   = ActionController::TestResponse.new
  end
  
  # 2-01
  # action:form
  # テスト項目概要：ログインフォーム表示
  test '2-01 form action' do
    # 正常（初回）
    begin
      get :form
      assert_response(:success, 'CASE2-01-01-01')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE2-01-01-02')
      valid_state('login/login', 1, nil, true, 'CASE2-01-01-03')
      # アクション実行結果変数確認
      assert(assigns(:err_msg).nil?, 'CASE2-01-01-04')
      # ログインフォーム確認
      assert_template('form', 'CASE2-01-01-05')
      assert_select('#login_id', '', 'CASE2-01-01-06')
      assert_select('#password', '', 'CASE2-01-01-07')
      # セッション取得
#      state_hash = session[:function_state_hash]
#      state = state_hash[1]
      state = session[:function_state]
      # 画面遷移パラメータチェック
      selector = '#login_form[action="/login/login/login"]'
      assert_select(selector, true, 'CASE2-01-01-08')
      selector = '#login_form input[name=screen_transition_pattern][value=3]'
      assert_select(selector, true, 'CASE2-01-01-09')
      selector = '#login_form input[name=function_transition_no][value=' + state.func_tran_no.to_s + ']'
      assert_select(selector, true, 'CASE2-01-01-10')
      selector = '#login_form input[name=synchronous_token][value=' + state.sync_tkn + ']'
      assert_select(selector, true, 'CASE2-01-01-11')
      selector = '#login_form input[name=restored_transition_no]'
      assert_select(selector, false, 'CASE2-01-01-12')
      selector = '#login_form_submit'
      assert_select(selector, true, 'CASE2-01-01-13')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-01-01")
    end
    sleep(0.2)
    # 正常（2回目）
    begin
      params = create_params(:TRANS_PTN_NEW, 1)
      get(:form, params)
#      get :form
      assert_response(:success, 'CASE2-01-02-01')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE2-01-02-02')
      valid_state('login/login', 1, nil, true, 'CASE2-01-02-03')
      # アクション実行結果変数確認
      assert(assigns(:err_msg).nil?, 'CASE2-01-02-04')
      # ログインフォーム確認
      assert_template('form', 'CASE2-01-02-05')
      assert_select('#login_id', '', 'CASE2-01-02-06')
      assert_select('#password', '', 'CASE2-01-02-07')
      # セッション取得
#      state_hash = session[:function_state_hash]
#      state = state_hash[1]
      state = session[:function_state]
      # 画面遷移パラメータチェック
      selector = '#login_form[action="/login/login/login"]'
      assert_select(selector, true, 'CASE2-01-02-08')
      selector = '#login_form input[name=screen_transition_pattern][value=3]'
      assert_select(selector, true, 'CASE2-01-02-09')
      selector = '#login_form input[name=function_transition_no][value=' + state.func_tran_no.to_s + ']'
      assert_select(selector, true, 'CASE2-01-02-10')
      selector = '#login_form input[name=synchronous_token][value=' + state.sync_tkn + ']'
      assert_select(selector, true, 'CASE2-01-02-11')
      selector = '#login_form input[name=restored_transition_no]'
      assert_select(selector, false, 'CASE2-01-02-12')
      selector = '#login_form_submit'
      assert_select(selector, true, 'CASE2-01-02-13')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-01-02")
    end
    sleep(0.2)
    # 正常（3回目 POST）
    begin
      post :form
      assert_response(:success, 'CASE2-01-03-01')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE2-01-03-02')
      valid_state('login/login', 1, nil, true, 'CASE2-01-03-03')
      # アクション実行結果変数確認
      assert(assigns(:err_msg).nil?, 'CASE2-01-03-04')
      # ログインフォーム確認
      assert_template('form', 'CASE2-01-03-05')
      assert_select('#login_id', '', 'CASE2-01-03-06')
      assert_select('#password', '', 'CASE2-01-03-07')
      # セッション取得
#      state_hash = session[:function_state_hash]
#      state = state_hash[1]
      state = session[:function_state]
      # 画面遷移パラメータチェック
      selector = '#login_form[action="/login/login/login"]'
      assert_select(selector, true, 'CASE2-01-03-08')
      selector = '#login_form input[name=screen_transition_pattern][value=3]'
      assert_select(selector, true, 'CASE2-01-03-09')
      selector = '#login_form input[name=function_transition_no][value=' + state.func_tran_no.to_s + ']'
      assert_select(selector, true, 'CASE2-01-03-10')
      selector = '#login_form input[name=synchronous_token][value=' + state.sync_tkn + ']'
      assert_select(selector, true, 'CASE2-01-03-11')
      selector = '#login_form input[name=restored_transition_no]'
      assert_select(selector, false, 'CASE2-01-03-12')
      selector = '#login_form_submit'
      assert_select(selector, true, 'CASE2-01-03-13')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-01-03")
    end
    # 正常（3回目 POST）
#    begin
#      100.times do
#        post :form
#      end
#    rescue StandardError => ex
#      print_log("Exception:" + ex.class.name)
#      print_log("Message  :" + ex.message)
#      print_log("Backtrace:" + ex.backtrace.join("\n"))
#      flunk("2-01-04")
#    end
  end
  
  # 2-02
  # action:form
  # テスト項目概要：ログイン状態判定してリダイレクト
  test '2-02 form action' do
    # 正常（初回セッション生成）
    begin
      get(:form)
      assert_response(:success, 'CASE2-02-01-01')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE2-02-01-02')
      valid_state('login/login', 1, nil, true, 'CASE2-02-01-03')
      # アクション実行結果変数確認
      assert(assigns(:err_msg).nil?, 'CASE2-02-01-04')
      # ログインフォーム確認
      assert_template('form', 'CASE2-02-01-05')
      assert_select('#login_id', '', 'CASE2-02-01-06')
      assert_select('#password', '', 'CASE2-02-01-07')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-02-01")
    end
    sleep(0.2)
    # 正常（ログイン状態）
    begin
      # セッション生成（ログイン状態にする）
      session[:login_id] = 'dummy_id'
      state = session[:function_state]
      new_state = new_state('menu/menu', state.func_tran_no)
      session[:function_state] = new_state
      # ログイン状態のチェック
      valid_state('login/login', 1, nil, true, 'CASE2-02-02-01')
      valid_state('menu/menu', 2, 1, false, 'CASE2-02-02-02')
      # テスト実行
      get(:form)
      # 結果検証
      assert_response(:redirect, 'CASE2-02-02-03')
      # リダイレクト先確認
      assert_redirected_to({:controller=>"menu/menu", :action=>"menu"}, 'CASE2-02-02-04')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE2-02-02-05')
      valid_state('login/login', 1, nil, true, 'CASE2-02-02-06')
      # アクション実行結果変数確認
      assert(assigns(:err_msg).nil?, 'CASE2-02-02-07')
      # フラッシュ設定
      valid_flash(:TRANS_PTN_CLH, 2, nil, 'CASE2-02-02-08')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-02-02")
    end
  end
  
  # 2-03
  # action:login
  # テスト項目概要：正常ログイン
  test '2-03 login action' do
    # 正常（ログインフォーム表示）
    begin
      get(:form)
      assert_response(:success, 'CASE2-03-01-01')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE2-03-01-02')
      valid_state('login/login', 1, nil, true, 'CASE2-03-01-03')
      # アクション実行結果変数確認
      assert(assigns(:err_msg).nil?, 'CASE2-03-01-04')
      # ログインフォーム確認
      assert_template('form', 'CASE2-03-01-05')
      assert_select('#login_id', '', 'CASE2-03-01-06')
      assert_select('#password', '', 'CASE2-03-01-07')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-03-01")
    end
    sleep(0.2)
    # 正常（ログイン）
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 1)
      params['login_id'] = 'a'
      params['password'] = 'b'
      post(:login, params)
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@response:' + @response.class.name.to_s)
      assert_response(:redirect, 'CASE2-03-02-01')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE2-03-02-02')
      valid_state('login/login', 1, nil, true, 'CASE2-03-02-03')
      # アクション実行結果変数確認
      assert(assigns(:err_msg).nil?, 'CASE2-03-02-04')
      # リダイレクト先確認
      assert_redirected_to({:controller=>"menu/menu", :action=>"menu"}, 'CASE2-03-02-05')
      # フラッシュ設定確認
      valid_flash(:TRANS_PTN_CLH, 1, nil, 'CASE2-03-02-06')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-03-02")
    end
  end
  
  # 2-04
  # action:login
  # テスト項目概要：ログインエラー
  test '2-04 login action' do
    # 正常（ログインフォーム表示）
    begin
      get(:form)
      assert_response(:success, 'CASE2-04-01-01')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE2-04-01-02')
      valid_state('login/login', 1, nil, true, 'CASE2-04-01-03')
      # アクション実行結果変数確認
      assert(assigns(:err_msg).nil?, 'CASE2-04-01-04')
      # ログインフォーム確認
      assert_template('form', 'CASE2-04-01-05')
      assert_select('#login_id', '', 'CASE2-04-01-06')
      assert_select('#password', '', 'CASE2-04-01-07')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-04-01")
    end
    sleep(0.2)
    # 異常（ユーザーIDエラー）
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 1)
      params['login_id'] = 'error_id'
      params['password'] = 'b'
      post(:login, params)
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@response:' + @response.class.name.to_s)
      # レスポンスステータス確認
      assert_response(:success, 'CASE2-04-02-01')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE2-04-02-02')
      valid_state('login/login', 1, nil, true, 'CASE2-04-02-03')
      # エラーメッセージ判定
      assert(assigns(:err_msg) == '有効なアカウントを入力してください。', 'CASE2-04-02-04')
      # ログインフォーム確認
      assert_template('form', 'CASE2-04-05-05')
      assert_select('#login_id', '', 'CASE2-04-02-06')
      assert_select('#password', '', 'CASE2-04-02-07')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 画面遷移パラメータチェック
      selector = '#login_form[action="/login/login/login"]'
      assert_select(selector, true, 'CASE2-04-02-08')
      selector = '#login_form input[name=screen_transition_pattern][value=3]'
      assert_select(selector, true, 'CASE2-04-02-09')
      selector = '#login_form input[name=function_transition_no][value=' + state.func_tran_no.to_s + ']'
      assert_select(selector, true, 'CASE2-04-02-10')
      selector = '#login_form input[name=synchronous_token][value=' + state.sync_tkn + ']'
      assert_select(selector, true, 'CASE2-04-02-11')
      selector = '#login_form input[name=restored_transition_no]'
      assert_select(selector, false, 'CASE2-04-02-12')
      selector = '#login_form_submit'
      assert_select(selector, true, 'CASE2-04-02-13')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-04-02")
    end
    sleep(0.2)
    # 異常（パスワードエラー）
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 1)
      params['login_id'] = 'a'
      params['password'] = 'error_pw'
      post(:login, params)
      # レスポンスステータス
      assert_response(:success, 'CASE2-04-02-01')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE2-04-02-02')
      valid_state('login/login', 1, nil, true, 'CASE2-02-02-03')
      # エラーメッセージ判定
      assert(assigns(:err_msg) == '有効なアカウントを入力してください。', 'CASE2-04-02-04')
      # ログインフォーム確認
      assert_template('form', 'CASE2-04-05-05')
      assert_select('#login_id', '', 'CASE2-04-02-06')
      assert_select('#password', '', 'CASE2-04-02-07')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 画面遷移パラメータチェック
      selector = '#login_form[action="/login/login/login"]'
      assert_select(selector, true, 'CASE2-04-02-08')
      selector = '#login_form input[name=screen_transition_pattern][value=3]'
      assert_select(selector, true, 'CASE2-04-02-09')
      selector = '#login_form input[name=function_transition_no][value=' + state.func_tran_no.to_s + ']'
      assert_select(selector, true, 'CASE2-04-02-10')
      selector = '#login_form input[name=synchronous_token][value=' + state.sync_tkn + ']'
      assert_select(selector, true, 'CASE2-04-02-11')
      selector = '#login_form input[name=restored_transition_no]'
      assert_select(selector, false, 'CASE2-04-02-12')
      selector = '#login_form_submit'
      assert_select(selector, true, 'CASE2-04-02-13')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-04-03")
    end
  end
  
  # 2-05
  # action:logout
  # テスト項目概要：ログアウト
  test '2-05 logout action' do
    # 正常（ログインフォーム表示）
    begin
      get(:form)
      assert_response(:success, 'CASE2-05-01-01')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE2-05-01-02')
      valid_state('login/login', 1, nil, true, 'CASE2-05-01-03')
      # アクション実行結果変数確認
      assert(assigns(:err_msg).nil?, 'CASE2-05-01-04')
      # ログインフォーム確認
      assert_template('form', 'CASE2-05-01-05')
      assert_select('#login_id', '', 'CASE2-05-01-06')
      assert_select('#password', '', 'CASE2-05-01-07')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-05-01")
    end
    sleep(0.2)
    # 正常（ログアウト）
    begin
      # セッション生成（ログイン状態にする）
      session[:login_id] = 'dummy_id'
      state = session[:function_state]
      new_state = new_state('menu/menu', state.func_tran_no)
      session[:function_state] = new_state
      # ログイン状態のチェック
      valid_state('login/login', 1, nil, true, 'CASE2-05-02-01')
      valid_state('menu/menu', 2, 1, false, 'CASE2-02-05-02-02')
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NEW, 2)
      # テスト実行
      post(:logout, params)
      # 結果検証
      assert_response(:success, 'CASE2-05-02-03')
      # セッション確認
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      valid_state('login/login', 1, nil, true, 'CASE2-05-02-04')
      # フラッシュ確認
      assert(flash.empty?, 'CASE2-05-02-05')
      # エラーメッセージ判定
      assert(assigns(:err_msg).nil?, 'CASE2-05-02-06')
      # ログインフォーム確認
      assert_template('form', 'CASE2-04-05-07')
      assert_select('#login_id', '', 'CASE2-04-02-08')
      assert_select('#password', '', 'CASE2-04-02-09')
      # 画面遷移パラメータチェック
      selector = '#login_form[action="/login/login/login"]'
      assert_select(selector, true, 'CASE2-05-02-10')
      selector = '#login_form input[name=screen_transition_pattern][value=3]'
      assert_select(selector, true, 'CASE2-05-02-11')
      selector = '#login_form input[name=function_transition_no][value=' + state.func_tran_no.to_s + ']'
      assert_select(selector, true, 'CASE2-05-02-12')
      selector = '#login_form input[name=synchronous_token][value=' + state.sync_tkn + ']'
      assert_select(selector, true, 'CASE2-05-02-13')
      selector = '#login_form input[name=restored_transition_no]'
      assert_select(selector, false, 'CASE2-05-02-14')
      selector = '#login_form_submit'
      assert_select(selector, true, 'CASE2-05-02-15')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-05-02")
    end
  end
  
  # 2-07
  # テスト項目概要：フィルターテスト
  test '2-07 Filter Test' do
    # 異常（アクセス規制フィルター）
    begin
      # login
      regulation_filter_chk(:login, :get, 'CASE2-07-01-01')
      # logout
      regulation_filter_chk(:logout, :get, 'CASE2-07-01-02')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-07-01")
    end
    sleep(0.2)
    # 異常（メソッド規制フィルター）
    begin
      # login
      regulation_filter_chk(:login, :get, 'CASE2-07-02-01')
      # logout
      regulation_filter_chk(:logout, :get, 'CASE2-07-02-02')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-07-02")
    end
  end
end
