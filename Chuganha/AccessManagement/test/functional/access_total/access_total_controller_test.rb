# -*- coding: utf-8 -*-
###############################################################################
# ファンクショナルテスト
# テスト対象：アクセス集計コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/21 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'functional/functional_test_util'
require 'functional/filter/filter_test_module'
require 'functional/access_total/totalization_data'

class AccessTotal::AccessTotalControllerTest < ActionController::TestCase
  include FunctionalTestUtil
  include Filter::FilterTestModule
  
  # 初期化処理
  def setup
#    @controller = Login::LoginController.new
#    @request    = ActionController::TestRequest.new
#    @response   = ActionController::TestResponse.new
    # データ生成オブジェクト
    @generator = TotalizationData.new
  end
  
  # 2-01
  # action:form
  # テスト項目概要：集計フォーム表示
  test '2-01 form action' do
    # ログインセッション生成
    session_init?(@controller, 'test_user')
    ###########################################################################
    # テストデータ登録
    ###########################################################################
    create_data
    ###########################################################################
    # 正常（初回）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NEW, 1)
      post(:form, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      # 線分類
      assert(params[:item_1].nil?, 'CASE:2-01-01-01')
      assert(params[:item_2].nil?, 'CASE:2-01-01-02')
      assert(params[:item_3].nil?, 'CASE:2-01-01-03')
      assert(params[:item_4].nil?, 'CASE:2-01-01-04')
      assert(params[:item_5].nil?, 'CASE:2-01-01-05')
      assert(params[:disp_number].nil?, 'CASE:2-01-01-06')
      assert(params[:disp_order].nil?, 'CASE:2-01-01-07')
      # 横軸
      assert(params[:received_date_from].nil?, 'CASE:2-01-01-07')
      assert(params[:time_unit_num].nil?, 'CASE:2-01-01-07')
      assert(params[:time_unit].nil?, 'CASE:2-01-01-07')
      assert(params[:aggregation_period].nil?, 'CASE:2-01-01-07')
      # 抽出条件
      assert(params[:system_id].nil?, 'CASE:2-01-01-07')
      assert(params[:function_id].nil?, 'CASE:2-01-01-07')
      assert(params[:function_trans_no].nil?, 'CASE:2-01-01-07')
      assert(params[:function_trans_no_comp].nil?, 'CASE:2-01-01-07')
      assert(params[:login_id].nil?, 'CASE:2-01-01-07')
      assert(params[:client_id].nil?, 'CASE:2-01-01-07')
      assert(params[:browser_id].nil?, 'CASE:2-01-01-07')
      assert(params[:browser_version_id].nil?, 'CASE:2-01-01-07')
      assert(params[:browser_version_id_comp].nil?, 'CASE:2-01-01-07')
      assert(params[:accept_language].nil?, 'CASE:2-01-01-07')
      assert(params[:referrer].nil?, 'CASE:2-01-01-07')
      assert(params[:referrer_match].nil?, 'CASE:2-01-01-07')
      assert(params[:domain_name].nil?, 'CASE:2-01-01-07')
      assert(params[:domain_name_match].nil?, 'CASE:2-01-01-07')
      assert(params[:proxy_host].nil?, 'CASE:2-01-01-07')
      assert(params[:proxy_host_match].nil?, 'CASE:2-01-01-07')
      assert(params[:proxy_ip_address].nil?, 'CASE:2-01-01-07')
      assert(params[:remote_host].nil?, 'CASE:2-01-01-07')
      assert(params[:remote_host_match].nil?, 'CASE:2-01-01-07')
      assert(params[:ip_address].nil?, 'CASE:2-01-01-07')
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-01-01-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-01-01-09')
      valid_state('access_total/access_total', 2, 1, false, 'CASE:2-01-01-10')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-01-01-11')
      #########################################################################
      # 集計フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('totalization', 'CASE:2-01-01-12')
      #########################################################################
      # 線分類
      #########################################################################
      # 項目
      valid_item('CASE:2-01-01-14-01', '#item_1')
      valid_item('CASE:2-01-01-14-01', '#item_2')
      valid_item('CASE:2-01-01-14-01', '#item_3')
      valid_item('CASE:2-01-01-14-01', '#item_4')
      valid_item('CASE:2-01-01-14-01', '#item_5')
      valid_disp_number('CASE:2-01-01-14-01')
      valid_sort_order('CASE:2-01-01-17', '#disp_order')
      # 取得開始日時（From）
      assert_select('#received_date_from_year', true, 'CASE:2-01-01-14-01')
      assert_select('#received_date_from_month', true, 'CASE:2-01-01-14-02')
      assert_select('#received_date_from_day', true, 'CASE:2-01-01-14-03')
      assert_select('#received_date_from_hour', true, 'CASE:2-01-01-14-04')
      assert_select('#received_date_from_minute', true, 'CASE:2-01-01-14-05')
      assert_select('#received_date_from_second', true, 'CASE:2-01-01-14-06')
      #########################################################################
      # 横軸
      #########################################################################
      assert_select('#time_unit_num', true, 'CASE:2-01-01-14-01')
      assert_select('#time_unit', true, 'CASE:2-01-01-14-01')
      assert_select('#aggregation_period', true, 'CASE:2-01-01-14-01')
      #########################################################################
      # 抽出条件
      #########################################################################
      # システムIDコンボ
      valid_system_id('CASE:2-01-01-13')
      assert_select('#function_id', true, 'CASE:2-01-01-14-01')
      assert_select('#function_trans_no', true, 'CASE:2-01-01-14-01')
      valid_comp('CASE:2-01-01-14-01', '#function_trans_no_comp')
      assert_select('#login_id', true, 'CASE:2-01-01-14-01')
      assert_select('#client_id', true, 'CASE:2-01-01-14-01')
      # ブラウザID
      valid_browser_id('CASE:2-01-01-13')
      assert_select('#browser_version_id', true, 'CASE:2-01-01-14-01')
      valid_comp('CASE:2-01-01-14-01', '#browser_version_id_comp')
      assert_select('#accept_language', true, 'CASE:2-01-01-14-01')
      assert_select('#referrer', true, 'CASE:2-01-01-14-01')
      valid_match('CASE:2-01-01-14-01', '#referrer_match')
      assert_select('#domain_name', true, 'CASE:2-01-01-14-01')
      valid_match('CASE:2-01-01-14-01', '#domain_name_match')
      assert_select('#proxy_host', true, 'CASE:2-01-01-14-01')
      valid_match('CASE:2-01-01-14-01', '#proxy_host_match')
      assert_select('#proxy_ip_address', true, 'CASE:2-01-01-14-01')
      assert_select('#remote_host', true, 'CASE:2-01-01-14-01')
      valid_match('CASE:2-01-01-14-01', '#remote_host_match')
      assert_select('#ip_address', true, 'CASE:2-01-01-14-01')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/access_total/access_total/totalization"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-01-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="集計"]', true, 'CASE:2-01-01-21')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-01-01")
    end
  end

  # 2-02
  # action:totalization
  # テスト項目概要：集計フォーム表示
  test '2-02 totalization action' do
    # ログインセッション生成
    session_init?(@controller, 'test_user')
    ###########################################################################
    # テストデータ登録
    ###########################################################################
    create_data
    ###########################################################################
    # 正常（初回）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NEW, 1)
      post(:form, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      # 線分類
      assert(params[:item_1].nil?, 'CASE:2-02-01-01')
      assert(params[:item_2].nil?, 'CASE:2-02-01-02')
      assert(params[:item_3].nil?, 'CASE:2-02-01-03')
      assert(params[:item_4].nil?, 'CASE:2-02-01-04')
      assert(params[:item_5].nil?, 'CASE:2-02-01-05')
      assert(params[:disp_number].nil?, 'CASE:2-02-01-06')
      assert(params[:disp_order].nil?, 'CASE:2-02-01-07')
      # 横軸
      assert(params[:received_date_from].nil?, 'CASE:2-02-01-07')
      assert(params[:time_unit_num].nil?, 'CASE:2-02-01-07')
      assert(params[:time_unit].nil?, 'CASE:2-02-01-07')
      assert(params[:aggregation_period].nil?, 'CASE:2-02-01-07')
      # 抽出条件
      assert(params[:system_id].nil?, 'CASE:2-02-01-07')
      assert(params[:function_id].nil?, 'CASE:2-02-01-07')
      assert(params[:function_trans_no].nil?, 'CASE:2-02-01-07')
      assert(params[:function_trans_no_comp].nil?, 'CASE:2-02-01-07')
      assert(params[:login_id].nil?, 'CASE:2-02-01-07')
      assert(params[:client_id].nil?, 'CASE:2-02-01-07')
      assert(params[:browser_id].nil?, 'CASE:2-02-01-07')
      assert(params[:browser_version_id].nil?, 'CASE:2-02-01-07')
      assert(params[:browser_version_id_comp].nil?, 'CASE:2-02-01-07')
      assert(params[:accept_language].nil?, 'CASE:2-02-01-07')
      assert(params[:referrer].nil?, 'CASE:2-02-01-07')
      assert(params[:referrer_match].nil?, 'CASE:2-02-01-07')
      assert(params[:domain_name].nil?, 'CASE:2-02-01-07')
      assert(params[:domain_name_match].nil?, 'CASE:2-02-01-07')
      assert(params[:proxy_host].nil?, 'CASE:2-02-01-07')
      assert(params[:proxy_host_match].nil?, 'CASE:2-02-01-07')
      assert(params[:proxy_ip_address].nil?, 'CASE:2-02-01-07')
      assert(params[:remote_host].nil?, 'CASE:2-02-01-07')
      assert(params[:remote_host_match].nil?, 'CASE:2-02-01-07')
      assert(params[:ip_address].nil?, 'CASE:2-02-01-07')
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-02-01-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-02-01-09')
      valid_state('access_total/access_total', 2, 1, false, 'CASE:2-02-01-10')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-02-01-11')
      #########################################################################
      # 集計フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('totalization', 'CASE:2-02-01-12')
      #########################################################################
      # 線分類
      #########################################################################
      # 項目
      valid_item('CASE:2-02-01-14-01', '#item_1')
      valid_item('CASE:2-02-01-14-01', '#item_2')
      valid_item('CASE:2-02-01-14-01', '#item_3')
      valid_item('CASE:2-02-01-14-01', '#item_4')
      valid_item('CASE:2-02-01-14-01', '#item_5')
      valid_disp_number('CASE:2-02-01-14-01')
      valid_sort_order('CASE:2-02-01-17', '#disp_order')
      # 取得開始日時（From）
      assert_select('#received_date_from_year', true, 'CASE:2-02-01-14-01')
      assert_select('#received_date_from_month', true, 'CASE:2-02-01-14-02')
      assert_select('#received_date_from_day', true, 'CASE:2-02-01-14-03')
      assert_select('#received_date_from_hour', true, 'CASE:2-02-01-14-04')
      assert_select('#received_date_from_minute', true, 'CASE:2-02-01-14-05')
      assert_select('#received_date_from_second', true, 'CASE:2-02-01-14-06')
      #########################################################################
      # 横軸
      #########################################################################
      assert_select('#time_unit_num', true, 'CASE:2-02-01-14-01')
      assert_select('#time_unit', true, 'CASE:2-02-01-14-01')
      assert_select('#aggregation_period', true, 'CASE:2-02-01-14-01')
      #########################################################################
      # 抽出条件
      #########################################################################
      # システムIDコンボ
      valid_system_id('CASE:2-02-01-13')
      assert_select('#function_id', true, 'CASE:2-02-01-14-01')
      assert_select('#function_trans_no', true, 'CASE:2-02-01-14-01')
      valid_comp('CASE:2-02-01-14-01', '#function_trans_no_comp')
      assert_select('#login_id', true, 'CASE:2-02-01-14-01')
      assert_select('#client_id', true, 'CASE:2-02-01-14-01')
      # ブラウザID
      valid_browser_id('CASE:2-02-01-13')
      assert_select('#browser_version_id', true, 'CASE:2-02-01-14-01')
      valid_comp('CASE:2-02-01-14-01', '#browser_version_id_comp')
      assert_select('#accept_language', true, 'CASE:2-02-01-14-01')
      assert_select('#referrer', true, 'CASE:2-02-01-14-01')
      valid_match('CASE:2-02-01-14-01', '#referrer_match')
      assert_select('#domain_name', true, 'CASE:2-02-01-14-01')
      valid_match('CASE:2-02-01-14-01', '#domain_name_match')
      assert_select('#proxy_host', true, 'CASE:2-02-01-14-01')
      valid_match('CASE:2-02-01-14-01', '#proxy_host_match')
      assert_select('#proxy_ip_address', true, 'CASE:2-02-01-14-01')
      assert_select('#remote_host', true, 'CASE:2-02-01-14-01')
      valid_match('CASE:2-02-01-14-01', '#remote_host_match')
      assert_select('#ip_address', true, 'CASE:2-02-01-14-01')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/access_total/access_total/totalization"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-01-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="集計"]', true, 'CASE:2-02-01-21')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-02-01")
    end
    ###########################################################################
    # 正常（集計処理）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      # 線分類
      params[:item_1] = 'system_id'
      params[:item_2] = 'function_id'
      params[:item_3] = 'login_id'
      params[:item_4] = 'client_id'
      params[:item_5] = 'referrer'
      params[:disp_number] = '8'
      params[:disp_order] = 'DESC'
      # 横軸
      params[:received_date_from] = {:year=>'2007', :month=>'10', :day=>'20',
                                     :hour=>'10', :minute=>'20', :second=>'30'}
      params[:time_unit_num] = '10'
      params[:time_unit] = 'second'
      params[:aggregation_period] = '20'
      # 抽出条件
      params[:system_id] = '1'
      params[:function_id] = '1'
      params[:function_trans_no] = '1'
      params[:function_trans_no_comp] = 'EQ'
      params[:login_id] = 'Login_ID_1'
      params[:client_id] = 'Client_ID_1'
      params[:browser_id] = '1'
      params[:browser_version_id] = '1'
      params[:browser_version_id_comp] = 'EQ'
      params[:accept_language] = 'ja_1'
      params[:referrer] = 'http://www.yahoo.co.jp/'
      params[:referrer_match] = 'F'
      params[:domain_name] = 'ne.jp'
      params[:domain_name_match] = 'F'
      params[:proxy_host] = 'proxy1.com'
      params[:proxy_host_match] = 'F'
      params[:proxy_ip_address] = '192.168.100.1'
      params[:remote_host] = 'client1.com'
      params[:remote_host_match] = 'F'
      params[:ip_address] = '192.168.200.1'
      # 処理実行
      post(:totalization, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      # 線分類
      assert(params[:item_1] == 'system_id', 'CASE:2-02-02-01')
      assert(params[:item_2] == 'function_id', 'CASE:2-02-02-02')
      assert(params[:item_3] == 'login_id', 'CASE:2-02-02-03')
      assert(params[:item_4] == 'client_id', 'CASE:2-02-02-04')
      assert(params[:item_5] == 'referrer', 'CASE:2-02-02-05')
      assert(params[:disp_number] == '8', 'CASE:2-02-02-06')
      assert(params[:disp_order] == 'DESC', 'CASE:2-02-02-07')
      # 横軸
#      print_log('DateTime:' + params[:received_date_from].to_s)
      assert(params[:received_date_from][:year] == '2007', 'CASE:2-02-02-07')
      assert(params[:received_date_from][:month] == '10', 'CASE:2-02-02-07')
      assert(params[:received_date_from][:day] == '20', 'CASE:2-02-02-07')
      assert(params[:received_date_from][:hour] == '10', 'CASE:2-02-02-07')
      assert(params[:received_date_from][:minute] == '20', 'CASE:2-02-02-07')
      assert(params[:received_date_from][:second] == '30', 'CASE:2-02-02-07')
      assert(params[:time_unit_num] == '10', 'CASE:2-02-02-07')
      assert(params[:time_unit] == 'second', 'CASE:2-02-02-07')
      assert(params[:aggregation_period] == '20', 'CASE:2-02-02-07')
      # 抽出条件
      assert(params[:system_id] == '1', 'CASE:2-02-02-07')
      assert(params[:function_id] == '1', 'CASE:2-02-02-07')
      assert(params[:function_trans_no] == '1', 'CASE:2-02-02-07')
      assert(params[:function_trans_no_comp] == 'EQ', 'CASE:2-02-02-07')
      assert(params[:login_id] == 'Login_ID_1', 'CASE:2-02-02-07')
      assert(params[:client_id] == 'Client_ID_1', 'CASE:2-02-02-07')
      assert(params[:browser_id] == '1', 'CASE:2-02-02-07')
      assert(params[:browser_version_id] == '1', 'CASE:2-02-02-07')
      assert(params[:browser_version_id_comp] == 'EQ', 'CASE:2-02-02-07')
      assert(params[:accept_language] == 'ja_1', 'CASE:2-02-02-07')
      assert(params[:referrer] == 'http://www.yahoo.co.jp/', 'CASE:2-02-02-07')
      assert(params[:referrer_match] == 'F', 'CASE:2-02-02-07')
      assert(params[:domain_name] == 'ne.jp', 'CASE:2-02-02-07')
      assert(params[:domain_name_match] == 'F', 'CASE:2-02-02-07')
      assert(params[:proxy_host] == 'proxy1.com', 'CASE:2-02-02-07')
      assert(params[:proxy_host_match] == 'F', 'CASE:2-02-02-07')
      assert(params[:proxy_ip_address] == '192.168.100.1', 'CASE:2-02-02-07')
      assert(params[:remote_host] == 'client1.com', 'CASE:2-02-02-07')
      assert(params[:remote_host_match] == 'F', 'CASE:2-02-02-07')
      assert(params[:ip_address] == '192.168.200.1', 'CASE:2-02-02-07')
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-02-02-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      #########################################################################
      # 受信パラメータ確認
      #########################################################################
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-02-02-09')
      valid_state('access_total/access_total', 2, 1, false, 'CASE:2-02-02-10')
      action_obj = assigns(:biz_obj)
      # 線分類
      assert(action_obj.item_1 == 'system_id', 'CASE:2-02-02-01')
      assert(action_obj.item_2 == 'function_id', 'CASE:2-02-02-02')
      assert(action_obj.item_3 == 'login_id', 'CASE:2-02-02-03')
      assert(action_obj.item_4 == 'client_id', 'CASE:2-02-02-04')
      assert(action_obj.item_5 == 'referrer', 'CASE:2-02-02-05')
      assert(action_obj.disp_number == '8', 'CASE:2-02-02-06')
      assert(action_obj.disp_order == 'DESC', 'CASE:2-02-02-07')
      # 横軸
      date_from = DateTime.parse('2007-10-20T10:20:30+09:00')
      assert(action_obj.received_date_from == date_from, 'CASE:2-02-02-07')
      assert(action_obj.time_unit_num == '10', 'CASE:2-02-02-07')
      assert(action_obj.time_unit == 'second', 'CASE:2-02-02-07')
      assert(action_obj.aggregation_period == '20', 'CASE:2-02-02-07')
      # 抽出条件
      assert(action_obj.system_id == '1', 'CASE:2-02-02-07')
      assert(action_obj.function_id == '1', 'CASE:2-02-02-07')
      assert(action_obj.function_trans_no == '1', 'CASE:2-02-02-07')
      assert(action_obj.function_trans_no_comp == 'EQ', 'CASE:2-02-02-07')
      assert(action_obj.login_id == 'Login_ID_1', 'CASE:2-02-02-07')
      assert(action_obj.client_id == 'Client_ID_1', 'CASE:2-02-02-07')
      assert(action_obj.browser_id == '1', 'CASE:2-02-02-07')
      assert(action_obj.browser_version_id == '1', 'CASE:2-02-02-07')
      assert(action_obj.browser_version_id_comp == 'EQ', 'CASE:2-02-02-07')
      assert(action_obj.accept_language == 'ja_1', 'CASE:2-02-02-07')
      assert(action_obj.referrer == 'http://www.yahoo.co.jp/', 'CASE:2-02-02-07')
      assert(action_obj.referrer_match == 'F', 'CASE:2-02-02-07')
      assert(action_obj.domain_name == 'ne.jp', 'CASE:2-02-02-07')
      assert(action_obj.domain_name_match == 'F', 'CASE:2-02-02-07')
      assert(action_obj.proxy_host == 'proxy1.com', 'CASE:2-02-02-07')
      assert(action_obj.proxy_host_match == 'F', 'CASE:2-02-02-07')
      assert(action_obj.proxy_ip_address == '192.168.100.1', 'CASE:2-02-02-07')
      assert(action_obj.remote_host == 'client1.com', 'CASE:2-02-02-07')
      assert(action_obj.remote_host_match == 'F', 'CASE:2-02-02-07')
      assert(action_obj.ip_address == '192.168.200.1', 'CASE:2-02-02-07')
      # エラーメッセージ判定
#      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-02-02-11')
      #########################################################################
      # 集計フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('totalization', 'CASE:2-02-02-12')
      #########################################################################
      # 線分類
      #########################################################################
      # 項目
      valid_item('CASE:2-02-02-14-01', '#item_1')
      valid_item('CASE:2-02-02-14-01', '#item_2')
      valid_item('CASE:2-02-02-14-01', '#item_3')
      valid_item('CASE:2-02-02-14-01', '#item_4')
      valid_item('CASE:2-02-02-14-01', '#item_5')
      valid_disp_number('CASE:2-02-02-14-01')
      valid_sort_order('CASE:2-02-02-17', '#disp_order')
      # 取得開始日時（From）
      assert_select('#received_date_from_year', true, 'CASE:2-02-02-14-01')
      assert_select('#received_date_from_month', true, 'CASE:2-02-02-14-02')
      assert_select('#received_date_from_day', true, 'CASE:2-02-02-14-03')
      assert_select('#received_date_from_hour', true, 'CASE:2-02-02-14-04')
      assert_select('#received_date_from_minute', true, 'CASE:2-02-02-14-05')
      assert_select('#received_date_from_second', true, 'CASE:2-02-02-14-06')
      #########################################################################
      # 横軸
      #########################################################################
      assert_select('#time_unit_num', true, 'CASE:2-02-02-14-01')
      assert_select('#time_unit', true, 'CASE:2-02-02-14-01')
      assert_select('#aggregation_period', true, 'CASE:2-02-02-14-01')
      #########################################################################
      # 抽出条件
      #########################################################################
      # システムIDコンボ
      valid_system_id('CASE:2-02-02-13')
      assert_select('#function_id', true, 'CASE:2-02-02-14-01')
      assert_select('#function_trans_no', true, 'CASE:2-02-02-14-01')
      valid_comp('CASE:2-02-02-14-01', '#function_trans_no_comp')
      assert_select('#login_id', true, 'CASE:2-02-02-14-01')
      assert_select('#client_id', true, 'CASE:2-02-02-14-01')
      # ブラウザID
      valid_browser_id('CASE:2-02-02-13')
      assert_select('#browser_version_id', true, 'CASE:2-02-02-14-01')
      valid_comp('CASE:2-02-02-14-01', '#browser_version_id_comp')
      assert_select('#accept_language', true, 'CASE:2-02-02-14-01')
      assert_select('#referrer', true, 'CASE:2-02-02-14-01')
      valid_match('CASE:2-02-02-14-01', '#referrer_match')
      assert_select('#domain_name', true, 'CASE:2-02-02-14-01')
      valid_match('CASE:2-02-02-14-01', '#domain_name_match')
      assert_select('#proxy_host', true, 'CASE:2-02-02-14-01')
      valid_match('CASE:2-02-02-14-01', '#proxy_host_match')
      assert_select('#proxy_ip_address', true, 'CASE:2-02-02-14-01')
      assert_select('#remote_host', true, 'CASE:2-02-02-14-01')
      valid_match('CASE:2-02-02-14-01', '#remote_host_match')
      assert_select('#ip_address', true, 'CASE:2-02-02-14-01')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/access_total/access_total/totalization"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-02-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="集計"]', true, 'CASE:2-02-02-21')
      #########################################################################
      # グラフデータ
      #########################################################################
      assert_select('#graphs_col_names[value="集計単位,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20"]', true, 'CASE:2-02-02-21')
#      assert_select('#graphs_data_A[value="A,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150"]', true, 'CASE:2-02-02-21')
      assert_select('#graphs_data_A[value="A,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2"]', true, 'CASE:2-02-02-21')
#      assert_select('#graphs_data_A', true, 'CASE:2-02-02-21')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-02-02")
    end
    ###########################################################################
    # 異常（集計処理）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      # 線分類
      params[:item_1] = 'system_id?'
      params[:item_2] = 'function_id?'
      params[:item_3] = 'login_id?'
      params[:item_4] = 'client_id?'
      params[:item_5] = 'referrer?'
      params[:disp_number] = '8?'
      params[:disp_order] = 'DESC?'
      # 横軸
      params[:received_date_from] = {:year=>'にせんなな', :month=>'じゅう', :day=>'きゅう',
                                     :hour=>'じゅう', :minute=>'にじゅう', :second=>'さんじゅう'}
      params[:time_unit_num] = '10?'
      params[:time_unit] = 'second?'
      params[:aggregation_period] = '20?'
      # 抽出条件
      params[:system_id] = '1?'
      params[:function_id] = '1?'
      params[:function_trans_no] = '1?'
      params[:function_trans_no_comp] = 'EQ?'
      login_id = generate_str(CHAR_SET_ZENKAKU, 256)
      client_id = generate_str(CHAR_SET_ZENKAKU, 256)
      params[:login_id] = login_id
      params[:client_id] = client_id
      params[:browser_id] = '1?'
      params[:browser_version_id] = '1?'
      params[:browser_version_id_comp] = 'EQ?'
      params[:accept_language] = '日本語でたのみま～す'
      params[:referrer] = 'http://www.yahoo.co.jp/から来ました。'
      params[:referrer_match] = 'F?'
      params[:domain_name] = 'ne.jp?どめいんでごわす'
      params[:domain_name_match] = 'F?'
      params[:proxy_host] = 'proxy1.com?ぷろきしでごわす'
      params[:proxy_host_match] = 'F?'
      params[:proxy_ip_address] = '192.168.100.1?'
      params[:remote_host] = 'client1.com?依頼人ざます'
      params[:remote_host_match] = 'F?'
      params[:ip_address] = '192.168.200.1?'
      # 処理実行
      post(:totalization, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      # 線分類
      assert(params[:item_1] == 'system_id?', 'CASE:2-02-03-01')
      assert(params[:item_2] == 'function_id?', 'CASE:2-02-03-02')
      assert(params[:item_3] == 'login_id?', 'CASE:2-02-03-03')
      assert(params[:item_4] == 'client_id?', 'CASE:2-02-03-04')
      assert(params[:item_5] == 'referrer?', 'CASE:2-02-03-05')
      assert(params[:disp_number] == '8?', 'CASE:2-02-03-06')
      assert(params[:disp_order] == 'DESC?', 'CASE:2-02-03-07')
      # 横軸
#      print_log('DateTime:' + params[:received_date_from].to_s)
      assert(params[:received_date_from][:year] == 'にせんなな', 'CASE:2-02-03-07')
      assert(params[:received_date_from][:month] == 'じゅう', 'CASE:2-02-03-07')
      assert(params[:received_date_from][:day] == 'きゅう', 'CASE:2-02-03-07')
      assert(params[:received_date_from][:hour] == 'じゅう', 'CASE:2-02-03-07')
      assert(params[:received_date_from][:minute] == 'にじゅう', 'CASE:2-02-03-07')
      assert(params[:received_date_from][:second] == 'さんじゅう', 'CASE:2-02-03-07')
      assert(params[:time_unit_num] == '10?', 'CASE:2-02-03-07')
      assert(params[:time_unit] == 'second?', 'CASE:2-02-03-07')
      assert(params[:aggregation_period] == '20?', 'CASE:2-02-03-07')
      # 抽出条件
      assert(params[:system_id] == '1?', 'CASE:2-02-03-07')
      assert(params[:function_id] == '1?', 'CASE:2-02-03-07')
      assert(params[:function_trans_no] == '1?', 'CASE:2-02-03-07')
      assert(params[:function_trans_no_comp] == 'EQ?', 'CASE:2-02-03-07')
      assert(params[:login_id] == login_id, 'CASE:2-02-03-07')
      assert(params[:client_id] == client_id, 'CASE:2-02-03-07')
      assert(params[:browser_id] == '1?', 'CASE:2-02-03-07')
      assert(params[:browser_version_id] == '1?', 'CASE:2-02-03-07')
      assert(params[:browser_version_id_comp] == 'EQ?', 'CASE:2-02-03-07')
      assert(params[:accept_language] == '日本語でたのみま～す', 'CASE:2-02-03-07')
#      print_log('referrer:' + params[:referrer].to_s)
      assert(params[:referrer] == 'http://www.yahoo.co.jp/から来ました。', 'CASE:2-02-03-07')
      assert(params[:referrer_match] == 'F?', 'CASE:2-02-03-07')
      assert(params[:domain_name] == 'ne.jp?どめいんでごわす', 'CASE:2-02-03-07')
      assert(params[:domain_name_match] == 'F?', 'CASE:2-02-03-07')
      assert(params[:proxy_host] == 'proxy1.com?ぷろきしでごわす', 'CASE:2-02-03-07')
      assert(params[:proxy_host_match] == 'F?', 'CASE:2-02-03-07')
      assert(params[:proxy_ip_address] == '192.168.100.1?', 'CASE:2-02-03-07')
      assert(params[:remote_host] == 'client1.com?依頼人ざます', 'CASE:2-02-03-07')
      assert(params[:remote_host_match] == 'F?', 'CASE:2-02-03-07')
      assert(params[:ip_address] == '192.168.200.1?', 'CASE:2-02-03-07')
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-02-03-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      #########################################################################
      # 受信パラメータ確認
      #########################################################################
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-02-03-09')
      valid_state('access_total/access_total', 2, 1, false, 'CASE:2-02-03-10')
      action_obj = assigns(:biz_obj)
      # 線分類
      assert(action_obj.item_1 == 'system_id?', 'CASE:2-02-03-01')
      assert(action_obj.item_2 == 'function_id?', 'CASE:2-02-03-02')
      assert(action_obj.item_3 == 'login_id?', 'CASE:2-02-03-03')
      assert(action_obj.item_4 == 'client_id?', 'CASE:2-02-03-04')
      assert(action_obj.item_5 == 'referrer?', 'CASE:2-02-03-05')
      assert(action_obj.disp_number == '8?', 'CASE:2-02-03-06')
      assert(action_obj.disp_order == 'DESC?', 'CASE:2-02-03-07')
      # 横軸
      date_from = DateTime.parse('2007-10-09T10:20:30+09:00')
#      print_log('Date:' + action_obj.received_date_from.to_s)
      assert(action_obj.received_date_from.nil?, 'CASE:2-02-03-07')
      assert(action_obj.time_unit_num == '10?', 'CASE:2-02-03-07')
      assert(action_obj.time_unit == 'second?', 'CASE:2-02-03-07')
      assert(action_obj.aggregation_period == '20?', 'CASE:2-02-03-07')
      # 抽出条件
      assert(action_obj.system_id == '1?', 'CASE:2-02-03-07')
      assert(action_obj.function_id == '1?', 'CASE:2-02-03-07')
      assert(action_obj.function_trans_no == '1?', 'CASE:2-02-03-07')
      assert(action_obj.function_trans_no_comp == 'EQ?', 'CASE:2-02-03-07')
      assert(action_obj.login_id == login_id, 'CASE:2-02-03-07')
      assert(action_obj.client_id == client_id, 'CASE:2-02-03-07')
      assert(action_obj.browser_id == '1?', 'CASE:2-02-03-07')
      assert(action_obj.browser_version_id == '1?', 'CASE:2-02-03-07')
      assert(action_obj.browser_version_id_comp == 'EQ?', 'CASE:2-02-03-07')
      assert(action_obj.accept_language == '日本語でたのみま～す', 'CASE:2-02-03-07')
      assert(action_obj.referrer == 'http://www.yahoo.co.jp/から来ました。', 'CASE:2-02-03-07')
      assert(action_obj.referrer_match == 'F?', 'CASE:2-02-03-07')
      assert(action_obj.domain_name == 'ne.jp?どめいんでごわす', 'CASE:2-02-03-07')
      assert(action_obj.domain_name_match == 'F?', 'CASE:2-02-03-07')
      assert(action_obj.proxy_host == 'proxy1.com?ぷろきしでごわす', 'CASE:2-02-03-07')
      assert(action_obj.proxy_host_match == 'F?', 'CASE:2-02-03-07')
      assert(action_obj.proxy_ip_address == '192.168.100.1?', 'CASE:2-02-03-07')
      assert(action_obj.remote_host == 'client1.com?依頼人ざます', 'CASE:2-02-03-07')
      assert(action_obj.remote_host_match == 'F?', 'CASE:2-02-03-07')
      assert(action_obj.ip_address == '192.168.200.1?', 'CASE:2-02-03-07')
      # エラーメッセージ判定
      err_hash = assigns(:err_hash)
#      print_log('err_hash:' + err_hash.to_s)
      assert(err_hash.size == 23, 'CASE:2-02-03-11')
      #########################################################################
      # 集計フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('totalization', 'CASE:2-02-03-12')
      #########################################################################
      # 線分類
      #########################################################################
      # 項目
      valid_item('CASE:2-02-03-14-01', '#item_1')
      valid_item('CASE:2-02-03-14-01', '#item_2')
      valid_item('CASE:2-02-03-14-01', '#item_3')
      valid_item('CASE:2-02-03-14-01', '#item_4')
      valid_item('CASE:2-02-03-14-01', '#item_5')
      assert_select('#sverr_item_1[value="第１項目 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#sverr_item_2[value="第２項目 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#sverr_item_3[value="第３項目 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#sverr_item_4[value="第４項目 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#sverr_item_5[value="第５項目 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      valid_disp_number('CASE:2-02-03-14-01')
      valid_sort_order('CASE:2-02-03-17', '#disp_order')
      assert_select('#sverr_disp_cond[value="表示対象 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      # 取得開始日時（From）
      assert_select('#received_date_from_year', true, 'CASE:2-02-03-14-01')
      assert_select('#received_date_from_month', true, 'CASE:2-02-03-14-02')
      assert_select('#received_date_from_day', true, 'CASE:2-02-03-14-03')
      assert_select('#received_date_from_hour', true, 'CASE:2-02-03-14-04')
      assert_select('#received_date_from_minute', true, 'CASE:2-02-03-14-05')
      assert_select('#received_date_from_second', true, 'CASE:2-02-03-14-06')
      assert_select('#sverr_received_date_from[value="受信日時 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      #########################################################################
      # 横軸
      #########################################################################
      assert_select('#time_unit_num', true, 'CASE:2-02-03-14-01')
      assert_select('#time_unit', true, 'CASE:2-02-03-14-01')
      assert_select('#sverr_time_unit_cond[value="集計単位 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#aggregation_period', true, 'CASE:2-02-03-14-01')
      assert_select('#sverr_aggregation_period[value="集計期間 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      #########################################################################
      # 抽出条件
      #########################################################################
      # システムIDコンボ
      valid_system_id('CASE:2-02-03-13')
      assert_select('#sverr_system_id[value="システム名 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#function_id', true, 'CASE:2-02-03-14-01')
      assert_select('#sverr_function_id[value="機能名 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#function_trans_no', true, 'CASE:2-02-03-14-01')
      valid_comp('CASE:2-02-03-14-01', '#function_trans_no_comp')
      assert_select('#sverr_function_trans_no_cond[value="機能遷移番号 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#login_id', true, 'CASE:2-02-03-14-01')
      assert_select('#sverr_login_id[value="ログインID は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#client_id', true, 'CASE:2-02-03-14-01')
      assert_select('#sverr_client_id[value="クライアントID は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      # ブラウザID
      valid_browser_id('CASE:2-02-03-13')
      assert_select('#sverr_browser_id[value="ブラウザ名 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#browser_version_id', true, 'CASE:2-02-03-14-01')
      valid_comp('CASE:2-02-03-14-01', '#browser_version_id_comp')
      assert_select('#sverr_browser_version_cond[value="ブラウザバージョン は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#accept_language', true, 'CASE:2-02-03-14-01')
      assert_select('#sverr_accept_language[value="言語 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#referrer', true, 'CASE:2-02-03-14-01')
      valid_match('CASE:2-02-03-14-01', '#referrer_match')
      assert_select('#sverr_referrer_cond[value="リファラー は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#domain_name', true, 'CASE:2-02-03-14-01')
      valid_match('CASE:2-02-03-14-01', '#domain_name_match')
      assert_select('#sverr_domain_name_cond[value="ドメイン名 は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#proxy_host', true, 'CASE:2-02-03-14-01')
      valid_match('CASE:2-02-03-14-01', '#proxy_host_match')
      assert_select('#sverr_proxy_host_cond[value="プロキシホスト は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#proxy_ip_address', true, 'CASE:2-02-03-14-01')
      assert_select('#sverr_proxy_ip_address[value="プロキシIP は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#remote_host', true, 'CASE:2-02-03-14-01')
      valid_match('CASE:2-02-03-14-01', '#remote_host_match')
      assert_select('#sverr_remote_host_cond[value="クライアントホスト は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      assert_select('#ip_address', true, 'CASE:2-02-03-14-01')
      assert_select('#sverr_ip_address[value="クライアントIP は不正な値です。"]', true, 'CASE:2-02-03-14-01')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/access_total/access_total/totalization"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-03-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="集計"]', true, 'CASE:2-02-03-21')
      #########################################################################
      # グラフデータ
      #########################################################################
      assert_select('#graphs_col_names[value="集計単位,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20"]', false, 'CASE:2-02-02-21')
#      assert_select('#graphs_data_A[value="A,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150"]', true, 'CASE:2-02-02-21')
      assert_select('#graphs_data_A[value="A,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2"]', false, 'CASE:2-02-02-21')
#      assert_select('#graphs_data_A', true, 'CASE:2-02-02-21')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-02-03")
    end
  end
  
  # 2-03
  # action:function
  # テスト項目概要：機能
  test '2-03 function action' do
    ###########################################################################
    # テストデータ生成
    ###########################################################################
    [1, 1, 2, 2, 2].each_with_index do |sys_id, type|
      data = Function.new
      data.system_id = sys_id
      data.function_path = 'Function Path ' + (type + 1).to_s
      data.function_name = 'Function Name ' + (type + 1).to_s
      data.save!
    end
    # ログインセッション生成
    session_init?(@controller, 'test_user')
    ###########################################################################
    # 正常（初回）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NEW, 1)
      post(:form, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-03-01-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-03-01-09')
      valid_state('access_total/access_total', 2, 1, false, 'CASE:2-03-01-10')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-03-01-11')
      #########################################################################
      # 集計フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('totalization', 'CASE:2-03-01-12')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/access_total/access_total/totalization"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-01-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="集計"]', true, 'CASE:2-03-01-21')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-03-01")
    end
    ###########################################################################
    # 正常（パラメータあり）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      # 抽出条件
      params[:system_id] = '1'
      # 処理実行
      post(:function, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-03-02-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      #########################################################################
      # 受信パラメータ確認
      #########################################################################
      # エラーメッセージ判定
#      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-03-02-11')
      #########################################################################
      # レスポンスデータ確認
      #########################################################################
      res_body = @response.body.to_s
      print_log('body:' + res_body)
      stmt = '<option value="">全て</option>'
      stmt += '<option value="1">アクセス解析</option>'
      stmt += '<option value="2">リクエスト解析スケジュール一覧</option>'
      stmt += '<option value="3">モック機能</option>'
      stmt += '<option value="4">テスト用リクエストデータ</option>'
      stmt += '<option value="5">セッション更新フィルターテストデータ</option>'
      stmt += '<option value="6">Function Name 1</option>'
      stmt += '<option value="7">Function Name 2</option>'
      assert(res_body == stmt, 'CASE:2-03-02-11')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-03-02")
    end
    ###########################################################################
    # 正常（パラメータなし）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      # 処理実行
      post(:function, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-03-03-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      #########################################################################
      # 受信パラメータ確認
      #########################################################################
      # エラーメッセージ判定
#      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-03-03-11')
      #########################################################################
      # レスポンスデータ確認
      #########################################################################
      res_body = @response.body.to_s
      print_log('body:' + res_body)
      stmt = '<option value="">全て</option>'
      assert(res_body == stmt, 'CASE:2-03-03-11')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-03-03")
    end
    ###########################################################################
    # 正常（対象データ無し）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      # 抽出条件
      params[:system_id] = '1000'
      # 処理実行
      post(:function, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-03-04-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      #########################################################################
      # 受信パラメータ確認
      #########################################################################
      # エラーメッセージ判定
#      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-03-04-11')
      #########################################################################
      # レスポンスデータ確認
      #########################################################################
      res_body = @response.body.to_s
      print_log('body:' + res_body)
      stmt = '<option value="">全て</option>'
      assert(res_body == stmt, 'CASE:2-03-04-11')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-03-04")
    end
  end
  
  # 2-04
  # action:browser_version
  # テスト項目概要：ブラウザバージョン
  test '2-04 browser_version action' do
    # ログインセッション生成
    session_init?(@controller, 'test_user')
    ###########################################################################
    # 正常（初回）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NEW, 1)
      post(:form, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-04-01-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-04-01-09')
      valid_state('access_total/access_total', 2, 1, false, 'CASE:2-04-01-10')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-04-01-11')
      #########################################################################
      # 集計フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('totalization', 'CASE:2-04-01-12')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/access_total/access_total/totalization"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-01-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="集計"]', true, 'CASE:2-04-01-21')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-04-01")
    end
    ###########################################################################
    # 正常（パラメータあり）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      # 抽出条件
      params[:browser_id] = '1'
      # 処理実行
      post(:browser_version, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-04-02-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      #########################################################################
      # 受信パラメータ確認
      #########################################################################
      # エラーメッセージ判定
#      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-04-02-11')
      #########################################################################
      # レスポンスデータ確認
      #########################################################################
      res_body = @response.body.to_s
      print_log('body:' + res_body)
      stmt = '<option value="">全て</option>'
      stmt += '<option value="1">4</option>'
      stmt += '<option value="2">5</option>'
      stmt += '<option value="3">6</option>'
      stmt += '<option value="4">7</option>'
      stmt += '<option value="5">8</option>'
      stmt += '<option value="6">other</option>'
      assert(res_body == stmt, 'CASE:2-04-02-11')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-04-02")
    end
    ###########################################################################
    # 正常（パラメータなし）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      # 処理実行
      post(:browser_version, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-04-03-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      #########################################################################
      # 受信パラメータ確認
      #########################################################################
      # エラーメッセージ判定
#      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-04-03-11')
      #########################################################################
      # レスポンスデータ確認
      #########################################################################
      res_body = @response.body.to_s
      print_log('body:' + res_body)
      stmt = '<option value="">全て</option>'
      assert(res_body == stmt, 'CASE:2-04-03-11')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-04-03")
    end
    ###########################################################################
    # 正常（対象データなし）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      # 処理実行
      post(:browser_version, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      params = @request.request_parameters
      # 抽出条件
      params[:browser_id] = '1000'
#      print_log('@request:' + @request.request_parameters.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-04-04-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      #########################################################################
      # 受信パラメータ確認
      #########################################################################
      # エラーメッセージ判定
#      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-04-04-11')
      #########################################################################
      # レスポンスデータ確認
      #########################################################################
      res_body = @response.body.to_s
      print_log('body:' + res_body)
      stmt = '<option value="">全て</option>'
      assert(res_body == stmt, 'CASE:2-04-04-11')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-04-04")
    end
  end

  # データ生成処理
  def create_data
    ###########################################################################
    # テストデータ生成処理
    ###########################################################################
    # 基準日時
    datetime = Time.new(2007, 10, 20, 10, 20, 0)
    # マスタデータ生成
#    @generator.delete_master
#    @generator.create_master
    # スケジュールデータ生成
    @generator.create_schedule(datetime)
    # 解析結果データ再生成
    RequestAnalysisResult.delete_all
    ActiveRecord::Base.transaction do
#      save_count = 0
      120.times do |i|
        rcvd_dt = datetime + (i * 5).seconds
#        print_log('rcvd_dt:' + rcvd_dt.to_s)
#        print_log('Counter i:' + i.to_s)
        15.times do |j|
          @generator.result_data(j + 1, rcvd_dt).save
#          save_count += 1
        end
      end
#      print_log('Save Count:' + save_count.to_s)
#      print_log('All Count:' + RequestAnalysisResult.all.count.to_s)
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
    valid_combo('#system_id', combo_hash, err_msg, selected_val)
  end
  
  # ブラウザIDコンボチェック
  def valid_browser_id(err_msg, selected_val=nil)
    # システムIDコンボ
    combo_hash = Hash.new
    combo_hash['Internet Explorer'] = '1'
    combo_hash['Firefox'] = '2'
    combo_hash['Google Chrome'] = '3'
    combo_hash['Opera'] = '4'
    combo_hash['Safari'] = '5'
    combo_hash['Netscape'] = '6'
    valid_combo('#browser_id', combo_hash, err_msg, selected_val)
  end
  
  # 線項目コンボチェック
  def valid_item(err_msg, selector, selected_val=nil)
    combo_hash = Hash.new
    combo_hash['システム名'] = 'system_id'
    combo_hash['機能'] = 'function_id'
    combo_hash['機能遷移番号'] = 'function_transition_no'
    combo_hash['ログインID'] = 'login_id'
    combo_hash['クライアントID'] = 'client_id'
    combo_hash['ブラウザ名'] = 'browser_id'
    combo_hash['ブラウザバージョン'] = 'browser_version_id'
    combo_hash['言語'] = 'accept_language'
    combo_hash['リファラー'] = 'referrer'
    combo_hash['ドメイン名'] = 'domain_name'
    combo_hash['プロキシホスト'] = 'proxy_host'
    combo_hash['プロキシIP'] = 'proxy_ip_address'
    combo_hash['クライアントホスト'] = 'remote_host'
    combo_hash['クライアントIP'] = 'ip_address'
    valid_combo(selector, combo_hash, err_msg, selected_val)
  end
  
  # ソート順序コンボチェック
  def valid_sort_order(err_msg, selector, selected_val=nil)
    combo_hash = Hash.new
    combo_hash['昇順'] = 'ASC'
    combo_hash['降順'] = 'DESC'
    valid_combo(selector, combo_hash, err_msg, selected_val)
  end
  
  # 表示件数チェック
  def valid_disp_number(err_msg, selected_val=nil)
    combo_hash = Hash.new
    combo_hash['５件'] = '5'
    combo_hash['８件'] = '8'
    valid_combo('#disp_number', combo_hash, err_msg, selected_val)
  end
  
  # 一致条件チェック
  def valid_comp(err_msg, selector, selected_val=nil)
    combo_hash = Hash.new
    combo_hash['と一致'] = 'EQ'
    combo_hash['と不一致'] = 'NE'
    combo_hash['より小さい'] = 'LT'
    combo_hash['より大きい'] = 'GT'
    combo_hash['以下'] = 'LE'
    combo_hash['以上'] = 'GE'
    valid_combo(selector, combo_hash, err_msg, selected_val)
  end
  
  # マッチング条件チェック
  def valid_match(err_msg, selector, selected_val=nil)
    combo_hash = Hash.new
    combo_hash['と一致'] = 'E'
    combo_hash['で始まる'] = 'F'
    combo_hash['を含む'] = 'P'
    combo_hash['で終わる'] = 'B'
    valid_combo(selector, combo_hash, err_msg, selected_val)
  end
end
