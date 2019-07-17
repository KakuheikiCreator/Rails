# -*- coding: utf-8 -*-
###############################################################################
# ファンクショナルテスト
# テスト対象：規制クッキー一覧コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/07/23 Nakanohito
# 更新日:
###############################################################################
require 'drb/drb'
require 'test_helper'
require 'functional/functional_test_util'
require 'functional/filter/filter_test_module'

class RegulationCookieList::RegulationCookieListControllerTest < ActionController::TestCase
  include FunctionalTestUtil
  include Filter::FilterTestModule
  
  # 初期化処理
  def setup
#    @controller = Login::LoginController.new
#    @request    = ActionController::TestRequest.new
#    @response   = ActionController::TestResponse.new
#    Thread.list.each do |th|
#      print_log('pid:' + th.respond_to?(:pid).to_s)
#      print_log('drb_service:' + th[:drb_service].to_s)
#      if th.respond_to?(:pid) && th[:drb_service] == @service_name then
#        
#      end
#    end
#    DRb.stop_service
  end
  
  # 後始末処理
  def teardown
#    DRb.stop_service
  end
  
  # 2-01
  # action:list
  # テスト項目概要：一覧表示
  test '2-01 list action' do
    # ログインセッション生成
    session_init?(@controller, 'test_user')
    ###########################################################################
    # 正常（初回）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NEW, 1)
      post(:list, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      assert(params[:regulation_cookie].nil?, 'CASE:2-01-01-01')
      assert(params[:sort_item].nil?, 'CASE:2-01-01-04')
      assert(params[:sort_order].nil?, 'CASE:2-01-01-05')
      assert(params[:disp_counts].nil?, 'CASE:2-01-01-06')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-01-01-07')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-01-01-08')
      valid_state('regulation_cookie_list/regulation_cookie_list', 2, 1, false, 'CASE:2-01-01-09')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-01-01-10')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-01-01-11')
      # システムIDコンボ
      valid_system_id('CASE:2-01-01-12')
      # 備考テキストボックス
      assert_select('#regulation_cookie_remarks', true, 'CASE:2-01-01-13')
      # クッキーテキストボックス
      assert_select('#regulation_cookie_cookie', true, 'CASE:2-01-01-14')
      # ソート項目コンボ
      valid_sort_item('CASE:2-01-01-15', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-01-01-16', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-01-01-17', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_cookie_list/regulation_cookie_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-01-18')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-01-01-19')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-01-01-20')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-01-01-21')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_cookie_list/regulation_cookie_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-01-22')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 4, 'CASE:2-01-01-23')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_cookie_list = assigns[:reg_cookie_list]
      assert(reg_cookie_list.size == 4, 'CASE:2-01-01-24')
      # 明細チェック
      idx = 1
      reg_cookie_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-01-01-25')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-01-01")
    end
    ###########################################################################
    # 正常（検索条件有り）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      params[:regulation_cookie] = {:system_id=>'1', :cookie=>'^[123]$', :remarks=>'MyString'}
      params[:sort_item] = 'remarks'
      params[:sort_order] = 'DESC'
      params[:disp_counts] = '10'
      # 処理実行
      post(:list, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      reg_cookie = req_params[:regulation_cookie]
      assert(reg_cookie[:system_id] == '1', 'CASE:2-01-02-01')
      assert(reg_cookie[:cookie] == '^[123]$', 'CASE:2-01-02-02')
      assert(reg_cookie[:remarks] == 'MyString', 'CASE:2-01-02-03')
      assert(req_params[:sort_item] == 'remarks', 'CASE:2-01-02-04')
      assert(req_params[:sort_order] == 'DESC', 'CASE:2-01-02-05')
      assert(req_params[:disp_counts] == '10', 'CASE:2-01-02-06')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-01-02-07')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-01-02-08')
      valid_state('regulation_cookie_list/regulation_cookie_list', 2, 1, false, 'CASE:2-01-02-09')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-01-02-10')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-01-02-11')
      # システムIDコンボ
      valid_system_id('CASE:2-01-02-12', '1')
      # 備考テキストボックス
      assert_select('#regulation_cookie_remarks[value="MyString"]', true, 'CASE:2-01-02-13')
      # クッキーテキストボックス
      assert_select('#regulation_cookie_cookie[value]', true, 'CASE:2-01-02-14')
      # ソート項目コンボ
      valid_sort_item('CASE:2-01-02-15', 'remarks')
      # ソート順序
      valid_sort_order('CASE:2-01-02-16', 'DESC')
      # 表示件数
      valid_disp_counts('CASE:2-01-02-17', '10')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_cookie_list/regulation_cookie_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-02-18')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-01-02-19')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-01-02-20')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-01-02-21')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_cookie_list/regulation_cookie_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-02-22')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 1, 'CASE:2-01-02-23')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_cookie_list = assigns[:reg_cookie_list]
      assert(reg_cookie_list.size == 1, 'CASE:2-01-02-24')
      # 明細チェック
      idx = 1
      reg_cookie_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-01-02-25')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-01-02")
    end
    ###########################################################################
    # 異常（検索条件有り）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      params[:regulation_cookie] = {:system_id=>'a', :cookie=>'^[123]$', :remarks=>'MyString'}
      params[:sort_item] = 'remarks'
      params[:sort_order] = 'DESC'
      params[:disp_counts] = '10'
      # 処理実行
      post(:list, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      reg_cookie = req_params[:regulation_cookie]
      assert(reg_cookie[:system_id] == 'a', 'CASE:2-01-03-01')
      assert(reg_cookie[:cookie] == '^[123]$', 'CASE:2-01-03-02')
      assert(reg_cookie[:remarks] == 'MyString', 'CASE:2-01-03-03')
      assert(req_params[:sort_item] == 'remarks', 'CASE:2-01-03-04')
      assert(req_params[:sort_order] == 'DESC', 'CASE:2-01-03-05')
      assert(req_params[:disp_counts] == '10', 'CASE:2-01-03-06')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-01-03-07')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-01-03-08')
      valid_state('regulation_cookie_list/regulation_cookie_list', 2, 1, false, 'CASE:2-01-03-09')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 1, 'CASE:2-01-03-10')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-01-03-11')
      # システムIDコンボ
      valid_system_id('CASE:2-01-03-12')
      assert_select('#sverr_system_id[value="システム名 は不正な値です。"]', true, 'CASE:2-01-03-13')
      # 備考テキストボックス
      assert_select('#regulation_cookie_remarks[value="MyString"]', true, 'CASE:2-01-03-14')
      # クッキーテキストボックス
      assert_select('#regulation_cookie_cookie[value]', true, 'CASE:2-01-03-15')
      # ソート項目コンボ
      valid_sort_item('CASE:2-01-03-16', 'remarks')
      # ソート順序
      valid_sort_order('CASE:2-01-03-17', 'DESC')
      # 表示件数
      valid_disp_counts('CASE:2-01-03-18', '10')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_cookie_list/regulation_cookie_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-03-19')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-01-03-20')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-01-03-21')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-01-03-22')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_cookie_list/regulation_cookie_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-03-23')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 4, 'CASE:2-01-03-24')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_cookie_list = assigns[:reg_cookie_list]
      assert(reg_cookie_list.size == 4, 'CASE:2-01-03-25')
      # 明細チェック
      idx = 1
      reg_cookie_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-01-03-26')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-01-03")
    end
  end
  
  # 2-02
  # action:create
  # テスト項目概要：登録
  test '2-02 create action' do
    # ログインセッション生成
    session_init?(@controller, 'test_user')
    ###########################################################################
    # 正常（全項目入力）
    ###########################################################################
    begin
      # 送信パラメータ生成
#      params = create_params(:TRANS_PTN_NEW, 1)
      params = create_params(:TRANS_PTN_NOW, 1)
      params[:regulation_cookie] = {:system_id=>'1', :cookie=>'test data 1', :remarks=>'remarks 1'}
      params[:sort_item] = 'system_id'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      post(:create, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      reg_cookie = req_params[:regulation_cookie]
      assert(reg_cookie[:system_id] == '1', 'CASE:2-02-01-01')
      assert(reg_cookie[:cookie] == 'test data 1', 'CASE:2-02-01-02')
      assert(reg_cookie[:remarks] == 'remarks 1', 'CASE:2-02-01-03')
      assert(req_params[:sort_item] == 'system_id', 'CASE:2-02-01-04')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-02-01-05')
      assert(req_params[:disp_counts] == '500', 'CASE:2-02-01-06')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-02-01-07')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-02-01-08')
      valid_state('regulation_cookie_list/regulation_cookie_list', 1, nil, true, 'CASE:2-02-01-09')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-02-01-10')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-02-01-11')
      # システムIDコンボ
      valid_system_id('CASE:2-02-01-12')
      # 備考テキストボックス
      assert_select('#regulation_cookie_remarks', true, 'CASE:2-02-01-13')
      # クッキーテキストボックス
      assert_select('#regulation_cookie_cookie', true, 'CASE:2-02-01-14')
      # ソート項目コンボ
      valid_sort_item('CASE:2-02-01-15', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-02-01-16', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-02-01-17', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_cookie_list/regulation_cookie_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-01-18')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-02-01-19')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-02-01-20')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-02-01-21')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_cookie_list/regulation_cookie_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-01-22')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 5, 'CASE:2-02-01-23')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_cookie_list = assigns[:reg_cookie_list]
      assert(reg_cookie_list.size == 5, 'CASE:2-02-01-24')
      # 明細チェック
      idx = 1
      reg_cookie_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-02-01-25')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-02-01")
    end
    ###########################################################################
    # 異常（全項目入力）
    ###########################################################################
    begin
      # 送信パラメータ生成
#      params = create_params(:TRANS_PTN_NEW, 1)
      params = create_params(:TRANS_PTN_NOW, 1)
      params[:regulation_cookie] = {:system_id=>'1', :cookie=>'^[', :remarks=>'remarks 2'}
      params[:sort_item] = 'system_id'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      post(:create, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      reg_cookie = req_params[:regulation_cookie]
      assert(reg_cookie[:system_id] == '1', 'CASE:2-02-02-01')
      assert(reg_cookie[:cookie] == '^[', 'CASE:2-02-02-02')
      assert(reg_cookie[:remarks] == 'remarks 2', 'CASE:2-02-02-03')
      assert(req_params[:sort_item] == 'system_id', 'CASE:2-02-02-04')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-02-02-05')
      assert(req_params[:disp_counts] == '500', 'CASE:2-02-02-06')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-02-02-07')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-02-02-08')
      valid_state('regulation_cookie_list/regulation_cookie_list', 1, nil, true, 'CASE:2-02-02-09')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 1, 'CASE:2-02-02-10')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-02-02-11')
      # システムIDコンボ
      valid_system_id('CASE:2-02-02-12')
      # 備考テキストボックス
      assert_select('#regulation_cookie_remarks', true, 'CASE:2-02-02-13')
      # クッキーテキストボックス
      assert_select('#regulation_cookie_cookie', true, 'CASE:2-02-02-14')
      assert_select('#sverr_cookie[value="クッキー は不正な値です。"]', true, 'CASE:2-02-02-15')
      # ソート項目コンボ
      valid_sort_item('CASE:2-02-02-16', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-02-02-17', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-02-02-18', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_cookie_list/regulation_cookie_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-02-19')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-02-02-20')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-02-02-21')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-02-02-22')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_cookie_list/regulation_cookie_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-02-23')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 5, 'CASE:2-02-02-24')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_cookie_list = assigns[:reg_cookie_list]
      assert(reg_cookie_list.size == 5, 'CASE:2-02-02-25')
      # 明細チェック
      idx = 1
      reg_cookie_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-02-02-26')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-02-02")
    end
  end
  
  # 2-03
  # action:delete
  # テスト項目概要：削除
  test '2-03 delete action' do
    # ログインセッション生成
    session_init?(@controller, 'test_user')
    ###########################################################################
    # 正常（削除）
    ###########################################################################
    begin
      # 送信パラメータ生成
#      params = create_params(:TRANS_PTN_NEW, 1)
      params = create_params(:TRANS_PTN_NOW, 1)
      params[:delete_id] = '1'
      post(:delete, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      assert(req_params[:delete_id] == '1', 'CASE:2-03-01-01')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-03-01-07')
      # セッション取得
      state_hash = session[:function_state_hash]
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-03-01-08')
      valid_state('regulation_cookie_list/regulation_cookie_list', 1, nil, true, 'CASE:2-03-01-09')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-03-01-10')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-03-01-11')
      # システムIDコンボ
      valid_system_id('CASE:2-03-01-12')
      # 備考テキストボックス
      assert_select('#regulation_cookie_remarks', true, 'CASE:2-03-01-13')
      # クッキーテキストボックス
      assert_select('#regulation_cookie_cookie', true, 'CASE:2-03-01-14')
      # ソート項目コンボ
      valid_sort_item('CASE:2-03-01-15', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-03-01-16', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-02-01-17', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_cookie_list/regulation_cookie_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-01-18')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-03-01-19')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-03-01-20')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-03-01-21')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_cookie_list/regulation_cookie_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-01-22')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 3, 'CASE:2-03-01-23')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_cookie_list = assigns[:reg_cookie_list]
      assert(reg_cookie_list.size == 3, 'CASE:2-03-01-24')
      # 明細チェック
      idx = 1
      reg_cookie_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-03-01-25')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-03-01")
    end
    ###########################################################################
    # 異常（ID異常）
    ###########################################################################
    begin
      # 送信パラメータ生成
#      params = create_params(:TRANS_PTN_NEW, 1)
      params = create_params(:TRANS_PTN_NOW, 1)
      params[:delete_id] = 'a'
      post(:delete, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      assert(req_params[:delete_id] == 'a', 'CASE:2-03-02-01')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
#      print_log('@err_hash:' + assigns(:err_hash).to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-03-02-02')
      # セッション取得
      state_hash = session[:function_state_hash]
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-03-02-03')
      valid_state('regulation_cookie_list/regulation_cookie_list', 1, nil, true, 'CASE:2-03-02-04')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 1, 'CASE:2-03-02-05')
      assert(assigns(:err_hash)[:error_msg] == '対象データ が見つかりません。', 'CASE:2-03-02-06')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-03-02-07')
      # システムIDコンボ
      valid_system_id('CASE:2-03-02-08')
      # 備考テキストボックス
      assert_select('#regulation_cookie_remarks', true, 'CASE:2-03-02-09')
      # クッキーテキストボックス
      assert_select('#regulation_cookie_cookie', true, 'CASE:2-03-02-10')
      # ソート項目コンボ
      valid_sort_item('CASE:2-03-02-11', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-03-02-12', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-02-01-13', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_cookie_list/regulation_cookie_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-02-14')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-03-02-15')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-03-02-16')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-03-02-17')
      # エラーメッセージ
      assert_select('.error_msg', '対象データ が見つかりません。', 'CASE:2-03-02-18')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_cookie_list/regulation_cookie_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-02-19')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 3, 'CASE:2-03-02-20')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_cookie_list = assigns[:reg_cookie_list]
      assert(reg_cookie_list.size == 3, 'CASE:2-03-02-21')
      # 明細チェック
      idx = 1
      reg_cookie_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-03-02-22')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-03-02")
    end
  end
  
  # 2-04
  # action:notify
  # テスト項目概要：通知
  test '2-04 notify action' do
    # ログインセッション生成
    session_init?(@controller, 'test_user')
    ###########################################################################
    # 正常（全項目入力）
    ###########################################################################
    begin
      # 送信パラメータ生成
#      params = create_params(:TRANS_PTN_NEW, 1)
      params = create_params(:TRANS_PTN_NOW, 1)
      params[:regulation_cookie] = {:system_id=>'1', :cookie=>'test data 1', :remarks=>'remarks 1'}
      params[:sort_item] = 'system_id'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      post(:notify, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      reg_cookie = req_params[:regulation_cookie]
      assert(reg_cookie[:system_id] == '1', 'CASE:2-04-01-01')
      assert(reg_cookie[:cookie] == 'test data 1', 'CASE:2-04-01-02')
      assert(reg_cookie[:remarks] == 'remarks 1', 'CASE:2-04-01-03')
      assert(req_params[:sort_item] == 'system_id', 'CASE:2-04-01-04')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-04-01-05')
      assert(req_params[:disp_counts] == '500', 'CASE:2-04-01-06')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-04-01-07')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-04-01-08')
      valid_state('regulation_cookie_list/regulation_cookie_list', 1, nil, true, 'CASE:2-04-01-09')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-04-01-10')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-04-01-11')
      # システムIDコンボ
      valid_system_id('CASE:2-04-01-12')
      # 備考テキストボックス
      assert_select('#regulation_cookie_remarks', true, 'CASE:2-04-01-13')
      # クッキーテキストボックス
      assert_select('#regulation_cookie_cookie', true, 'CASE:2-04-01-14')
      # ソート項目コンボ
      valid_sort_item('CASE:2-04-01-15', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-04-01-16', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-04-01-17', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_cookie_list/regulation_cookie_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-01-18')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-04-01-19')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-04-01-20')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-04-01-21')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_cookie_list/regulation_cookie_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-01-22')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 4, 'CASE:2-04-01-23')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_cookie_list = assigns[:reg_cookie_list]
      assert(reg_cookie_list.size == 4, 'CASE:2-04-01-24')
      # 明細チェック
      idx = 1
      reg_cookie_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-04-01-25')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-04-01")
    end
    ###########################################################################
    # 異常（全項目入力）
    ###########################################################################
    begin
      # 送信パラメータ生成
#      params = create_params(:TRANS_PTN_NEW, 1)
      params = create_params(:TRANS_PTN_NOW, 1)
      params[:regulation_cookie] = {:system_id=>'a', :cookie=>'^[', :remarks=>'remarks 2'}
      params[:sort_item] = 'system_id'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      post(:notify, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      reg_cookie = req_params[:regulation_cookie]
      assert(reg_cookie[:system_id] == 'a', 'CASE:2-04-02-01')
      assert(reg_cookie[:cookie] == '^[', 'CASE:2-04-02-04')
      assert(reg_cookie[:remarks] == 'remarks 2', 'CASE:2-04-02-03')
      assert(req_params[:sort_item] == 'system_id', 'CASE:2-04-02-04')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-04-02-05')
      assert(req_params[:disp_counts] == '500', 'CASE:2-04-02-06')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-04-02-07')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-04-02-08')
      valid_state('regulation_cookie_list/regulation_cookie_list', 1, nil, true, 'CASE:2-04-02-09')
      # エラーメッセージ判定
      err_hash = assigns(:err_hash)
#      print_log('err_hash:' + err_hash.to_s)
      assert(err_hash.size == 1, 'CASE:2-04-02-10')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-04-02-11')
      # システムIDコンボ
      valid_system_id('CASE:2-04-02-12')
      assert_select('#sverr_system_id[value="システム名 は不正な値です。"]', true, 'CASE:2-04-02-13')
      # 備考テキストボックス
      assert_select('#regulation_cookie_remarks', true, 'CASE:2-04-02-14')
      # クッキーテキストボックス
      assert_select('#regulation_cookie_cookie', true, 'CASE:2-04-02-15')
      # ソート項目コンボ
      valid_sort_item('CASE:2-04-02-16', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-04-02-17', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-04-02-18', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_cookie_list/regulation_cookie_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-02-19')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-04-02-20')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-04-02-21')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-04-02-22')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_cookie_list/regulation_cookie_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-02-23')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 4, 'CASE:2-04-02-24')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_cookie_list = assigns[:reg_cookie_list]
      assert(reg_cookie_list.size == 4, 'CASE:2-04-02-25')
      # 明細チェック
      idx = 1
      reg_cookie_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-04-02-26')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-04-02")
    end
  end
  
  # システムIDコンボチェック
  def valid_system_id(err_msg, selected_val=nil)
    # システムIDコンボ
    combo_hash = Hash.new
#    combo_hash['選択してください。'] = ''
    sub_hash_1 = Hash.new
    sub_hash_1['Access Management'] = '1'
    sub_hash_1['Member Management'] = '2'
    sub_hash_1['Toitter'] = '3'
    combo_hash['仲観派'] = sub_hash_1
    sub_hash_2 = Hash.new
    sub_hash_2['Member Management'] = '4'
    combo_hash['防犯秘密結社'] = sub_hash_2
    valid_combo('#regulation_cookie_system_id', combo_hash, err_msg, selected_val)
  end
  
  # ソート項目コンボチェック
  def valid_sort_item(err_msg, selected_val=nil)
    combo_hash = Hash.new
    combo_hash['システム名'] = 'system_id'
    combo_hash['クッキー'] = 'cookie'
    combo_hash['備考'] = 'remarks'
    valid_combo('#sort_item', combo_hash, err_msg, selected_val)
  end
  
  # ソート順序コンボチェック
  def valid_sort_order(err_msg, selected_val=nil)
    combo_hash = Hash.new
    combo_hash['昇順'] = 'ASC'
    combo_hash['降順'] = 'DESC'
    valid_combo('#sort_order', combo_hash, err_msg, selected_val)
  end
  
  # 表示件数コンボチェック
  def valid_disp_counts(err_msg, selected_val=nil)
    # 表示件数
    combo_hash = Hash.new
    combo_hash['全て'] = 'ALL'
    combo_hash['10'] = '10'
    combo_hash['50'] = '50'
    combo_hash['100'] = '100'
    combo_hash['300'] = '300'
    combo_hash['500'] = '500'
    valid_combo('#disp_counts', combo_hash, err_msg, selected_val)
  end
  
  # 明細チェック
  def valid_details(idx, ent, err_msg)
    head = '#search_result_list>tbody>tr:nth-of-type(' + idx.to_s + ')'
    assert_select(head + ' td:nth-of-type(1) font', ent.system.system_name, err_msg)
    assert_select(head + '>td:nth-of-type(2) font', ent.system.subsystem_name, err_msg)
    assert_select(head + '>td:nth-of-type(3) font', ent.cookie, err_msg)
    assert_select(head + '>td:nth-of-type(4) font', ent.remarks, err_msg)
  end
end
