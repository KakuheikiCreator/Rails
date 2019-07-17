# -*- coding: utf-8 -*-
###############################################################################
# ファンクショナルテスト
# テスト対象：スケジュール一覧コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/08/25 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'functional/functional_test_util'
require 'functional/filter/filter_test_module'

class ScheduleList::ScheduleListControllerTest < ActionController::TestCase
  include FunctionalTestUtil
  include Filter::FilterTestModule
  
  # 初期化処理
  def setup
#    @controller = Login::LoginController.new
#    @request    = ActionController::TestRequest.new
#    @response   = ActionController::TestResponse.new
  end
  # 2-01
  # action:list
  # テスト項目概要：一覧表示
  test '2-01 list action' do
    # ログインセッション生成
    session_init?(@controller, 'test_user')
    ###########################################################################
    # テストデータ登録
    ###########################################################################
    rec = RequestAnalysisSchedule.new
    rec.gets_start_date = DateTime.new(2020,1,1)
    rec.system_id = 1
    rec.save
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
      assert(params[:system_id].nil?, 'CASE:2-01-01-01')
      assert(params[:from_datetime].nil?, 'CASE:2-01-01-02')
      assert(params[:to_datetime].nil?, 'CASE:2-01-01-03')
      assert(params[:delete_id].nil?, 'CASE:2-01-01-04')
      assert(params[:sort_item].nil?, 'CASE:2-01-01-05')
      assert(params[:sort_order].nil?, 'CASE:2-01-01-06')
      assert(params[:disp_counts].nil?, 'CASE:2-01-01-07')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-01-01-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-01-01-09')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-01-01-10')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-01-01-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-01-01-12')
      # システムIDコンボ
      valid_system_id('CASE:2-01-01-13')
      # 取得開始日時（From）
      assert_select('#from_datetime_year', true, 'CASE:2-01-01-14-01')
      assert_select('#from_datetime_month', true, 'CASE:2-01-01-14-02')
      assert_select('#from_datetime_day', true, 'CASE:2-01-01-14-03')
      assert_select('#from_datetime_hour', true, 'CASE:2-01-01-14-04')
      assert_select('#from_datetime_minute', true, 'CASE:2-01-01-14-05')
      assert_select('#from_datetime_second', true, 'CASE:2-01-01-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year', true, 'CASE:2-01-01-15-01')
      assert_select('#to_datetime_month', true, 'CASE:2-01-01-15-02')
      assert_select('#to_datetime_day', true, 'CASE:2-01-01-15-03')
      assert_select('#to_datetime_hour', true, 'CASE:2-01-01-15-04')
      assert_select('#to_datetime_minute', true, 'CASE:2-01-01-15-05')
      assert_select('#to_datetime_second', true, 'CASE:2-01-01-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-01-01-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-01-01-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-01-01-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-01-01-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-01-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-01-01-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-01-01-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-01-01-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-01-01-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-01-25')
      valid_update_form('CASE:2-01-01-26')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
#      print_log('list size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 8, 'CASE:2-01-01-27')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-01-01-28')
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
      params[:system_id] = '1'
      params[:from_datetime] = {:year=>'2011', :month=>'9', :day=>'8', :hour=>'2', :minute=>'0', :second=>'0'}
      params[:to_datetime] = {:year=>'2011', :month=>'9', :day=>'8', :hour=>'2', :minute=>'0', :second=>'2'}
      params[:sort_item] = 'gets_start_date'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      # 処理実行
      post(:list, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      assert(req_params[:system_id] == '1', 'CASE:2-01-02-01')
      from_hash = req_params[:from_datetime]
      assert(from_hash[:year] == '2011', 'CASE:2-01-02-02-01')
      assert(from_hash[:month] == '9', 'CASE:2-01-02-02-02')
      assert(from_hash[:day] == '8', 'CASE:2-01-02-02-03')
      assert(from_hash[:hour] == '2', 'CASE:2-01-02-02-04')
      assert(from_hash[:minute] == '0', 'CASE:2-01-02-02-05')
      assert(from_hash[:second] == '0', 'CASE:2-01-02-02-06')
      to_hash = req_params[:to_datetime]
      assert(to_hash[:year] == '2011', 'CASE:2-01-02-03-01')
      assert(to_hash[:month] == '9', 'CASE:2-01-02-03-02')
      assert(to_hash[:day] == '8', 'CASE:2-01-02-03-03')
      assert(to_hash[:hour] == '2', 'CASE:2-01-02-03-04')
      assert(to_hash[:minute] == '0', 'CASE:2-01-02-03-05')
      assert(to_hash[:second] == '2', 'CASE:2-01-02-03-06')
      assert(req_params[:delete_id].nil?, 'CASE:2-01-02-04')
      assert(req_params[:sort_item] == 'gets_start_date', 'CASE:2-01-02-05')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-01-02-06')
      assert(req_params[:disp_counts] == '500', 'CASE:2-01-02-07')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-01-02-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-01-02-09')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-01-02-10')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-01-02-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-01-02-12')
      # システムIDコンボ
      valid_system_id('CASE:2-01-02-13', '1')
      # 取得開始日時（From）
      assert_select('#from_datetime_year>option[selected="selected"][value="2011"]', true, 'CASE:2-01-02-14-01')
      assert_select('#from_datetime_month>option[selected="selected"][value="9"]', true, 'CASE:2-01-02-14-02')
      assert_select('#from_datetime_day>option[selected="selected"][value="8"]', true, 'CASE:2-01-02-14-03')
      assert_select('#from_datetime_hour>option[selected="selected"][value="02"]', true, 'CASE:2-01-02-14-04')
      assert_select('#from_datetime_minute>option[selected="selected"][value="00"]', true, 'CASE:2-01-02-14-05')
      assert_select('#from_datetime_second>option[selected="selected"][value="00"]', true, 'CASE:2-01-02-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year>option[selected="selected"][value="2011"]', true, 'CASE:2-01-02-15-01')
      assert_select('#to_datetime_month>option[selected="selected"][value="9"]', true, 'CASE:2-01-02-15-02')
      assert_select('#to_datetime_day>option[selected="selected"][value="8"]', true, 'CASE:2-01-02-15-03')
      assert_select('#to_datetime_hour>option[selected="selected"][value="02"]', true, 'CASE:2-01-02-15-04')
      assert_select('#to_datetime_minute>option[selected="selected"][value="00"]', true, 'CASE:2-01-02-15-05')
      assert_select('#to_datetime_second>option[selected="selected"][value="02"]', true, 'CASE:2-01-02-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-01-02-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-01-02-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-01-02-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-01-02-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-02-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-01-02-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-01-02-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-01-02-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-01-02-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-02-25')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
#      print_log('schedule_list.size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 3, 'CASE:2-01-02-26')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-01-02-27')
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
      params[:system_id] = 'a'
      params[:from_datetime] = {:year=>'2011', :month=>'9', :day=>'8', :hour=>'2', :minute=>'0', :second=>'0'}
      params[:to_datetime] = {:year=>'2011', :month=>'9', :day=>'8', :hour=>'2', :minute=>'0', :second=>'2'}
      params[:sort_item] = 'system_id'
      params[:sort_order] = 'DESC'
      params[:disp_counts] = '10'
      # 処理実行
      post(:list, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
      assert(req_params[:system_id] == 'a', 'CASE:2-01-03-01')
      from_hash = req_params[:from_datetime]
      assert(from_hash[:year] == '2011', 'CASE:2-01-03-02-01')
      assert(from_hash[:month] == '9', 'CASE:2-01-03-02-02')
      assert(from_hash[:day] == '8', 'CASE:2-01-03-02-03')
      assert(from_hash[:hour] == '2', 'CASE:2-01-03-02-04')
      assert(from_hash[:minute] == '0', 'CASE:2-01-03-02-05')
      assert(from_hash[:second] == '0', 'CASE:2-01-03-02-06')
      to_hash = req_params[:to_datetime]
      assert(to_hash[:year] == '2011', 'CASE:2-01-03-03-01')
      assert(to_hash[:month] == '9', 'CASE:2-01-03-03-02')
      assert(to_hash[:day] == '8', 'CASE:2-01-03-03-03')
      assert(to_hash[:hour] == '2', 'CASE:2-01-03-03-04')
      assert(to_hash[:minute] == '0', 'CASE:2-01-03-03-05')
      assert(to_hash[:second] == '2', 'CASE:2-01-03-03-06')
      assert(req_params[:delete_id].nil?, 'CASE:2-01-03-04')
      assert(req_params[:sort_item] == 'system_id', 'CASE:2-01-03-05')
      assert(req_params[:sort_order] == 'DESC', 'CASE:2-01-03-06')
      assert(req_params[:disp_counts] == '10', 'CASE:2-01-03-07')
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
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-01-03-09')
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
      # 取得開始日時（From）
      assert_select('#from_datetime_year>option[selected="selected"][value="2011"]', true, 'CASE:2-01-03-14-01')
      assert_select('#from_datetime_month>option[selected="selected"][value="9"]', true, 'CASE:2-01-03-14-02')
      assert_select('#from_datetime_day>option[selected="selected"][value="8"]', true, 'CASE:2-01-03-14-03')
      assert_select('#from_datetime_hour>option[selected="selected"][value="02"]', true, 'CASE:2-01-03-14-04')
      assert_select('#from_datetime_minute>option[selected="selected"][value="00"]', true, 'CASE:2-01-03-14-05')
      assert_select('#from_datetime_second>option[selected="selected"][value="00"]', true, 'CASE:2-01-03-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year>option[selected="selected"][value="2011"]', true, 'CASE:2-01-03-15-01')
      assert_select('#to_datetime_month>option[selected="selected"][value="9"]', true, 'CASE:2-01-03-15-02')
      assert_select('#to_datetime_day>option[selected="selected"][value="8"]', true, 'CASE:2-01-03-15-03')
      assert_select('#to_datetime_hour>option[selected="selected"][value="02"]', true, 'CASE:2-01-03-15-04')
      assert_select('#to_datetime_minute>option[selected="selected"][value="00"]', true, 'CASE:2-01-03-15-05')
      assert_select('#to_datetime_second>option[selected="selected"][value="02"]', true, 'CASE:2-01-03-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-01-03-16')
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
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-03-19')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-01-03-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-01-03-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-01-03-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-01-03-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-02-25')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
      assert(schedule_list.size == 8, 'CASE:2-01-03-25')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
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
  # テスト項目概要：登録処理
  test '2-02 create action' do
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
      assert(params[:system_id].nil?, 'CASE:2-02-01-01')
      assert(params[:from_datetime].nil?, 'CASE:2-02-01-02')
      assert(params[:to_datetime].nil?, 'CASE:2-02-01-03')
      assert(params[:delete_id].nil?, 'CASE:2-02-01-04')
      assert(params[:sort_item].nil?, 'CASE:2-02-01-05')
      assert(params[:sort_order].nil?, 'CASE:2-02-01-06')
      assert(params[:disp_counts].nil?, 'CASE:2-02-01-07')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-02-01-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-02-01-09')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-02-01-10')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-02-01-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-02-01-12')
      # システムIDコンボ
      valid_system_id('CASE:2-02-01-13')
      # 取得開始日時（From）
      assert_select('#from_datetime_year', true, 'CASE:2-02-01-14-01')
      assert_select('#from_datetime_month', true, 'CASE:2-02-01-14-02')
      assert_select('#from_datetime_day', true, 'CASE:2-02-01-14-03')
      assert_select('#from_datetime_hour', true, 'CASE:2-02-01-14-04')
      assert_select('#from_datetime_minute', true, 'CASE:2-02-01-14-05')
      assert_select('#from_datetime_second', true, 'CASE:2-02-01-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year', true, 'CASE:2-02-01-15-01')
      assert_select('#to_datetime_month', true, 'CASE:2-02-01-15-02')
      assert_select('#to_datetime_day', true, 'CASE:2-02-01-15-03')
      assert_select('#to_datetime_hour', true, 'CASE:2-02-01-15-04')
      assert_select('#to_datetime_minute', true, 'CASE:2-02-01-15-05')
      assert_select('#to_datetime_second', true, 'CASE:2-02-01-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-02-01-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-02-01-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-02-01-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-02-01-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-01-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-02-01-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-02-01-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-02-01-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-02-01-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-01-25')
      valid_update_form('CASE:2-02-01-26')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
#      print_log('list size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 7, 'CASE:2-02-01-27')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-02-01-28')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-02-01")
    end
    ###########################################################################
    # 正常（Fromのみ指定）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      params[:system_id] = '1'
      params[:from_datetime] = {:year=>'2021', :month=>'9', :day=>'1', :hour=>'2', :minute=>'0', :second=>'0'}
      params[:to_datetime] = nil
      params[:sort_item] = 'gets_start_date'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      # 処理実行
      post(:create, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      assert(req_params[:system_id] == '1', 'CASE:2-02-02-01')
      from_hash = req_params[:from_datetime]
      assert(from_hash[:year] == '2021', 'CASE:2-02-02-02-01')
      assert(from_hash[:month] == '9', 'CASE:2-02-02-02-02')
      assert(from_hash[:day] == '1', 'CASE:2-02-02-02-03')
      assert(from_hash[:hour] == '2', 'CASE:2-02-02-02-04')
      assert(from_hash[:minute] == '0', 'CASE:2-02-02-02-05')
      assert(from_hash[:second] == '0', 'CASE:2-02-02-02-06')
      assert(req_params[:to_datetime].nil?, 'CASE:2-02-02-03')
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-02-02-08')
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-02-02-09')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-02-02-10')
      # エラーメッセージ判定
#      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-02-02-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-02-02-12')
      # システムIDコンボ
      valid_system_id('CASE:2-02-02-13', '1')
      # 取得開始日時（From）
      assert_select('#from_datetime_year>option[selected="selected"][value="2021"]', true, 'CASE:2-02-02-14-01')
      assert_select('#from_datetime_month>option[selected="selected"][value="9"]', true, 'CASE:2-02-02-14-02')
      assert_select('#from_datetime_day>option[selected="selected"][value="1"]', true, 'CASE:2-02-02-14-03')
      assert_select('#from_datetime_hour>option[selected="selected"][value="02"]', true, 'CASE:2-02-02-14-04')
      assert_select('#from_datetime_minute>option[selected="selected"][value="00"]', true, 'CASE:2-02-02-14-05')
      assert_select('#from_datetime_second>option[selected="selected"][value="00"]', true, 'CASE:2-02-02-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year>option', true, 'CASE:2-02-02-15-01')
      assert_select('#to_datetime_month>option', true, 'CASE:2-02-02-15-02')
      assert_select('#to_datetime_day>option', true, 'CASE:2-02-02-15-03')
      assert_select('#to_datetime_hour>option', true, 'CASE:2-02-02-15-04')
      assert_select('#to_datetime_minute>option', true, 'CASE:2-02-02-15-05')
      assert_select('#to_datetime_second>option', true, 'CASE:2-02-02-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-02-02-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-02-02-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-02-02-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-02-02-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-02-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-02-02-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-02-02-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-02-02-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-02-02-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-02-25')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
#      print_log('schedule_list.size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 8, 'CASE:2-02-02-26')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-02-02-27')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-02-02")
    end
    ###########################################################################
    # 正常（From、To指定）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      params[:system_id] = '1'
      params[:from_datetime] = {:year=>'2021', :month=>'9', :day=>'8', :hour=>'2', :minute=>'0', :second=>'0'}
      params[:to_datetime] = {:year=>'2021', :month=>'9', :day=>'8', :hour=>'2', :minute=>'0', :second=>'2'}
      params[:sort_item] = 'gets_start_date'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      # 処理実行
      post(:create, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      assert(req_params[:system_id] == '1', 'CASE:2-02-03-01')
      from_hash = req_params[:from_datetime]
      assert(from_hash[:year] == '2021', 'CASE:2-02-03-02-01')
      assert(from_hash[:month] == '9', 'CASE:2-02-03-02-02')
      assert(from_hash[:day] == '8', 'CASE:2-02-03-02-03')
      assert(from_hash[:hour] == '2', 'CASE:2-02-03-02-04')
      assert(from_hash[:minute] == '0', 'CASE:2-02-03-02-05')
      assert(from_hash[:second] == '0', 'CASE:2-02-03-02-06')
      to_hash = req_params[:to_datetime]
      assert(to_hash[:year] == '2021', 'CASE:2-02-03-03-01')
      assert(to_hash[:month] == '9', 'CASE:2-02-03-03-02')
      assert(to_hash[:day] == '8', 'CASE:2-02-03-03-03')
      assert(to_hash[:hour] == '2', 'CASE:2-02-03-03-04')
      assert(to_hash[:minute] == '0', 'CASE:2-02-03-03-05')
      assert(to_hash[:second] == '2', 'CASE:2-02-03-03-06')
      assert(req_params[:delete_id].nil?, 'CASE:2-02-03-04')
      assert(req_params[:sort_item] == 'gets_start_date', 'CASE:2-02-03-05')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-02-03-06')
      assert(req_params[:disp_counts] == '500', 'CASE:2-02-03-07')
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-02-03-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-02-03-09')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-02-03-10')
      # エラーメッセージ判定
#      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-02-03-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-02-03-12')
      # システムIDコンボ
      valid_system_id('CASE:2-02-03-13', '1')
      # 取得開始日時（From）
      assert_select('#from_datetime_year>option[selected="selected"][value="2021"]', true, 'CASE:2-02-03-14-01')
      assert_select('#from_datetime_month>option[selected="selected"][value="9"]', true, 'CASE:2-02-03-14-02')
      assert_select('#from_datetime_day>option[selected="selected"][value="8"]', true, 'CASE:2-02-03-14-03')
      assert_select('#from_datetime_hour>option[selected="selected"][value="02"]', true, 'CASE:2-02-03-14-04')
      assert_select('#from_datetime_minute>option[selected="selected"][value="00"]', true, 'CASE:2-02-03-14-05')
      assert_select('#from_datetime_second>option[selected="selected"][value="00"]', true, 'CASE:2-02-03-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year>option[selected="selected"][value="2021"]', true, 'CASE:2-02-03-15-01')
      assert_select('#to_datetime_month>option[selected="selected"][value="9"]', true, 'CASE:2-02-03-15-02')
      assert_select('#to_datetime_day>option[selected="selected"][value="8"]', true, 'CASE:2-02-03-15-03')
      assert_select('#to_datetime_hour>option[selected="selected"][value="02"]', true, 'CASE:2-02-03-15-04')
      assert_select('#to_datetime_minute>option[selected="selected"][value="00"]', true, 'CASE:2-02-03-15-05')
      assert_select('#to_datetime_second>option[selected="selected"][value="02"]', true, 'CASE:2-02-03-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-02-03-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-02-03-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-02-03-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-02-03-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-03-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-02-03-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-02-03-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-02-03-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-02-03-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-03-25')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
#      print_log('schedule_list.size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 10, 'CASE:2-02-03-26')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-02-03-27')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-02-03")
    end
    ###########################################################################
    # 異常（検索条件有り）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      params[:system_id] = '1'
#      params[:from_datetime] = {:year=>'2011', :month=>'9', :day=>'8', :hour=>'2', :minute=>'0', :second=>'0'}
#      params[:to_datetime] = {:year=>'2011', :month=>'9', :day=>'8', :hour=>'2', :minute=>'0', :second=>'2'}
      params[:sort_item] = 'system_id'
      params[:sort_order] = 'DESC'
      params[:disp_counts] = '10'
      # 処理実行
      post(:create, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
      assert(req_params[:system_id] == '1', 'CASE:2-02-04-01')
      from_hash = req_params[:from_datetime]
      assert(from_hash.nil?, 'CASE:2-02-04-02')
#      assert(from_hash[:year] == '2011', 'CASE:2-02-04-02-01')
#      assert(from_hash[:month] == '9', 'CASE:2-02-04-02-02')
#      assert(from_hash[:day] == '8', 'CASE:2-02-04-02-03')
#      assert(from_hash[:hour] == '2', 'CASE:2-02-04-02-04')
#      assert(from_hash[:minute] == '0', 'CASE:2-02-04-02-05')
#      assert(from_hash[:second] == '0', 'CASE:2-02-04-02-06')
      to_hash = req_params[:to_datetime]
      assert(to_hash.nil?, 'CASE:2-02-04-03')
#      assert(to_hash[:year] == '2011', 'CASE:2-02-04-03-01')
#      assert(to_hash[:month] == '9', 'CASE:2-02-04-03-02')
#      assert(to_hash[:day] == '8', 'CASE:2-02-04-03-03')
#      assert(to_hash[:hour] == '2', 'CASE:2-02-04-03-04')
#      assert(to_hash[:minute] == '0', 'CASE:2-02-04-03-05')
#      assert(to_hash[:second] == '2', 'CASE:2-02-04-03-06')
      assert(req_params[:delete_id].nil?, 'CASE:2-02-04-04')
      assert(req_params[:sort_item] == 'system_id', 'CASE:2-02-04-05')
      assert(req_params[:sort_order] == 'DESC', 'CASE:2-02-04-06')
      assert(req_params[:disp_counts] == '10', 'CASE:2-02-04-07')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-02-04-07')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-02-04-08')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-02-04-09')
      # エラーメッセージ判定
      err_hash = assigns(:err_hash)
#      print_log('err_hash:' + err_hash.to_s)
      assert(err_hash.size == 1, 'CASE:2-02-04-10')
      assert(err_hash[:gets_start_date] == '取得開始日時 を入力してください。', 'CASE:2-02-04-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-02-04-12')
      # システムIDコンボ
      valid_system_id('CASE:2-02-04-13', '1')
      # 取得開始日時（From）
      assert_select('#from_datetime_year>option', true, 'CASE:2-02-04-14-01')
      assert_select('#from_datetime_month>option', true, 'CASE:2-02-04-14-02')
      assert_select('#from_datetime_day>option', true, 'CASE:2-02-04-14-03')
      assert_select('#from_datetime_hour>option', true, 'CASE:2-02-04-14-04')
      assert_select('#from_datetime_minute>option', true, 'CASE:2-02-04-14-05')
      assert_select('#from_datetime_second>option', true, 'CASE:2-02-04-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year>option', true, 'CASE:2-02-04-15-01')
      assert_select('#to_datetime_month>option', true, 'CASE:2-02-04-15-02')
      assert_select('#to_datetime_day>option', true, 'CASE:2-02-04-15-03')
      assert_select('#to_datetime_hour>option', true, 'CASE:2-02-04-15-04')
      assert_select('#to_datetime_minute>option', true, 'CASE:2-02-04-15-05')
      assert_select('#to_datetime_second>option', true, 'CASE:2-02-04-15-06')
      assert_select('#sverr_gets_start_date[value="取得開始日時 を入力してください。"]', true, 'CASE:2-02-04-16')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-02-04-17')
      # ソート項目コンボ
      valid_sort_item('CASE:2-02-04-18', 'remarks')
      # ソート順序
      valid_sort_order('CASE:2-02-04-19', 'DESC')
      # 表示件数
      valid_disp_counts('CASE:2-02-04-20', '10')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-04-21')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-02-04-22')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-02-04-23')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-02-04-24')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-02-04-25')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-04-26')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
      assert(schedule_list.size == 10, 'CASE:2-02-04-27')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-02-04-28')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-02-04")
    end
  end
  
  # 2-03
  # action:update
  # テスト項目概要：登録処理
  test '2-03 update action' do
    # ログインセッション生成
    session_init?(@controller, 'test_user')
    ###########################################################################
    # テストデータ登録
    ###########################################################################
    target_date = DateTime.new(2025,1,1,9,0,0,'GMT+09')
    rec = RequestAnalysisSchedule.new
    rec.gets_start_date = target_date
    rec.system_id = 1
    rec.gs_received_year = false
    rec.gs_received_month = false
    rec.gs_received_day = false
    rec.gs_received_hour = false
    rec.gs_received_minute = false
    rec.gs_received_second = false
    rec.gs_function_id = false
    rec.gs_function_transition_no = false
    rec.gs_login_id = false
    rec.gs_client_id = false
    rec.gs_browser_id = false
    rec.gs_browser_version_id = false
    rec.gs_accept_language = false
    rec.gs_referrer = false
    rec.gs_domain_id = false
    rec.gs_proxy_host = false
    rec.gs_proxy_ip_address = false
    rec.gs_remote_host = false
    rec.gs_ip_address = false
    rec.save!
#    Rails.logger.debug('DEBUG!!!   gets_start_date:' + rec.reload.gets_start_date.to_s)
    target_id = RequestAnalysisSchedule.where(:system_id=>1, :gets_start_date=>target_date)[0].id
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
      assert(params[:system_id].nil?, 'CASE:2-03-01-01')
      assert(params[:from_datetime].nil?, 'CASE:2-03-01-02')
      assert(params[:to_datetime].nil?, 'CASE:2-03-01-03')
      assert(params[:delete_id].nil?, 'CASE:2-03-01-04')
      assert(params[:sort_item].nil?, 'CASE:2-03-01-05')
      assert(params[:sort_order].nil?, 'CASE:2-03-01-06')
      assert(params[:disp_counts].nil?, 'CASE:2-03-01-07')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-03-01-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-03-01-09')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-03-01-10')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-03-01-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-03-01-12')
      # システムIDコンボ
      valid_system_id('CASE:2-03-01-13')
      # 取得開始日時（From）
      assert_select('#from_datetime_year', true, 'CASE:2-03-01-14-01')
      assert_select('#from_datetime_month', true, 'CASE:2-03-01-14-02')
      assert_select('#from_datetime_day', true, 'CASE:2-03-01-14-03')
      assert_select('#from_datetime_hour', true, 'CASE:2-03-01-14-04')
      assert_select('#from_datetime_minute', true, 'CASE:2-03-01-14-05')
      assert_select('#from_datetime_second', true, 'CASE:2-03-01-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year', true, 'CASE:2-03-01-15-01')
      assert_select('#to_datetime_month', true, 'CASE:2-03-01-15-02')
      assert_select('#to_datetime_day', true, 'CASE:2-03-01-15-03')
      assert_select('#to_datetime_hour', true, 'CASE:2-03-01-15-04')
      assert_select('#to_datetime_minute', true, 'CASE:2-03-01-15-05')
      assert_select('#to_datetime_second', true, 'CASE:2-03-01-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-03-01-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-03-01-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-03-01-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-03-01-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-01-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-03-01-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-03-01-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-03-01-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-03-01-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-01-25')
      valid_update_form('CASE:2-03-01-26')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
#      print_log('list size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 8, 'CASE:2-03-01-27')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-03-01-28')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-03-01")
    end
    ###########################################################################
    # 正常（更新項目のみ指定指定）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      params[:target_id] = target_id
      analysis_schedule_hash = Hash.new
#      analysis_schedule_hash[:gs_received_year] = true
#      analysis_schedule_hash[:gs_received_month] = true
#      analysis_schedule_hash[:gs_received_day] = true
#      analysis_schedule_hash[:gs_received_hour] = true
#      analysis_schedule_hash[:gs_received_minute] = true
#      analysis_schedule_hash[:gs_received_second] = true
      analysis_schedule_hash[:gs_function_id] = true
      analysis_schedule_hash[:gs_function_transition_no] = true
#      analysis_schedule_hash[:gs_login_id] = true
#      analysis_schedule_hash[:gs_client_id] = true
      analysis_schedule_hash[:gs_browser_id] = true
#      analysis_schedule_hash[:gs_browser_version_id] = true
      analysis_schedule_hash[:gs_accept_language] = true
#      analysis_schedule_hash[:gs_referrer] = true
#      analysis_schedule_hash[:gs_domain_id] = true
#      analysis_schedule_hash[:gs_proxy_host] = true
#      analysis_schedule_hash[:gs_proxy_ip_address] = true
      analysis_schedule_hash[:gs_remote_host] = true
      analysis_schedule_hash[:gs_ip_address] = true
      params[:analysis_schedule] = analysis_schedule_hash
      # 処理実行
      post(:update, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      assert(req_params[:system_id].nil?, 'CASE:2-03-02-01')
      assert(req_params[:from_datetime].nil?, 'CASE:2-03-02-02')
      assert(req_params[:to_datetime].nil?, 'CASE:2-03-02-03')
      assert(req_params[:sort_item].nil?, 'CASE:2-03-02-05')
      assert(req_params[:sort_order].nil?, 'CASE:2-03-02-06')
      assert(req_params[:disp_counts].nil?, 'CASE:2-03-02-07')
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-03-02-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-03-02-09')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-03-02-10')
      # エラーメッセージ判定
#      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-03-02-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-03-02-12')
      # システムIDコンボ
      valid_system_id('CASE:2-03-02-13', nil)
      # 取得開始日時（From）
      assert_select('#from_datetime_year>option', true, 'CASE:2-03-02-14-01')
      assert_select('#from_datetime_month>option', true, 'CASE:2-03-02-14-02')
      assert_select('#from_datetime_day>option', true, 'CASE:2-03-02-14-03')
      assert_select('#from_datetime_hour>option', true, 'CASE:2-03-02-14-04')
      assert_select('#from_datetime_minute>option', true, 'CASE:2-03-02-14-05')
      assert_select('#from_datetime_second>option', true, 'CASE:2-03-02-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year>option', true, 'CASE:2-03-02-15-01')
      assert_select('#to_datetime_month>option', true, 'CASE:2-03-02-15-02')
      assert_select('#to_datetime_day>option', true, 'CASE:2-03-02-15-03')
      assert_select('#to_datetime_hour>option', true, 'CASE:2-03-02-15-04')
      assert_select('#to_datetime_minute>option', true, 'CASE:2-03-02-15-05')
      assert_select('#to_datetime_second>option', true, 'CASE:2-03-02-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-03-02-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-03-02-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-03-02-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-03-02-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-02-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-03-02-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-03-02-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-03-02-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-03-02-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-02-25')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
#      print_log('schedule_list.size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 8, 'CASE:2-03-02-26')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-03-02-27')
        idx += 1
      end
      # 更新明細確認
      target_ent = schedule_list[6]
#      print_log('target_ent.gs_function_id:' + target_ent.gs_function_id.to_s)
      assert(target_ent.id == target_id, 'CASE:2-03-02-28-01')
      assert(target_ent.gs_received_year == false, 'CASE:2-03-02-28-02')
      assert(target_ent.gs_received_month == false, 'CASE:2-03-02-28-03')
      assert(target_ent.gs_received_day == false, 'CASE:2-03-02-28-04')
      assert(target_ent.gs_received_hour == false, 'CASE:2-03-02-28-05')
      assert(target_ent.gs_received_minute == false, 'CASE:2-03-02-28-06')
      assert(target_ent.gs_received_second == false, 'CASE:2-03-02-28-07')
      assert(target_ent.gs_function_id == true, 'CASE:2-03-02-28-08')
      assert(target_ent.gs_function_transition_no == true, 'CASE:2-03-02-28-09')
      assert(target_ent.gs_login_id == false, 'CASE:2-03-02-28-10')
      assert(target_ent.gs_client_id == false, 'CASE:2-03-02-28-11')
      assert(target_ent.gs_browser_id == true, 'CASE:2-03-02-28-12')
      assert(target_ent.gs_browser_version_id == false, 'CASE:2-03-02-28-13')
      assert(target_ent.gs_accept_language == true, 'CASE:2-03-02-28-14')
      assert(target_ent.gs_referrer == false, 'CASE:2-03-02-28-15')
      assert(target_ent.gs_domain_id == false, 'CASE:2-03-02-28-16')
      assert(target_ent.gs_proxy_host == false, 'CASE:2-03-02-28-17')
      assert(target_ent.gs_proxy_ip_address == false, 'CASE:2-03-02-28-18')
      assert(target_ent.gs_remote_host == true, 'CASE:2-03-02-28-19')
      assert(target_ent.gs_ip_address == true, 'CASE:2-03-02-28-20')
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-03-02")
    end
    ###########################################################################
    # 異常（検索条件有り）
    ###########################################################################
    begin
      bef_datetime = DateTime.now
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      params[:target_id] = 1000
      analysis_schedule_hash = Hash.new
#      analysis_schedule_hash[:gs_received_year] = true
#      analysis_schedule_hash[:gs_received_month] = true
#      analysis_schedule_hash[:gs_received_day] = true
#      analysis_schedule_hash[:gs_received_hour] = true
#      analysis_schedule_hash[:gs_received_minute] = true
#      analysis_schedule_hash[:gs_received_second] = true
      analysis_schedule_hash[:gs_function_id] = true
      analysis_schedule_hash[:gs_function_transition_no] = true
#      analysis_schedule_hash[:gs_login_id] = true
#      analysis_schedule_hash[:gs_client_id] = true
      analysis_schedule_hash[:gs_browser_id] = true
#      analysis_schedule_hash[:gs_browser_version_id] = true
      analysis_schedule_hash[:gs_accept_language] = true
#      analysis_schedule_hash[:gs_referrer] = true
#      analysis_schedule_hash[:gs_domain_id] = true
#      analysis_schedule_hash[:gs_proxy_host] = true
#      analysis_schedule_hash[:gs_proxy_ip_address] = true
      analysis_schedule_hash[:gs_remote_host] = true
      analysis_schedule_hash[:gs_ip_address] = true
      params[:analysis_schedule] = analysis_schedule_hash
      # 処理実行
      post(:update, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
      assert(req_params[:system_id].nil?, 'CASE:2-03-02-01')
      assert(req_params[:from_datetime].nil?, 'CASE:2-03-02-02')
      assert(req_params[:to_datetime].nil?, 'CASE:2-03-02-03')
      assert(req_params[:sort_item].nil?, 'CASE:2-03-02-05')
      assert(req_params[:sort_order].nil?, 'CASE:2-03-02-06')
      assert(req_params[:disp_counts].nil?, 'CASE:2-03-02-07')
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-03-03-07')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-03-03-08')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-03-03-09')
      # エラーメッセージ判定
      err_hash = assigns(:err_hash)
#      print_log('err_hash:' + err_hash.to_s)
      assert(err_hash.size == 1, 'CASE:2-03-03-10')
      assert(err_hash[:error_msg] == '対象データ が見つかりません。', 'CASE:2-03-03-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-03-03-12')
      # システムIDコンボ
      valid_system_id('CASE:2-03-03-13')
      # 取得開始日時（From）
      assert_select('#from_datetime_year>option', true, 'CASE:2-03-03-14-01')
      assert_select('#from_datetime_month>option', true, 'CASE:2-03-03-14-02')
      assert_select('#from_datetime_day>option', true, 'CASE:2-03-03-14-03')
      assert_select('#from_datetime_hour>option', true, 'CASE:2-03-03-14-04')
      assert_select('#from_datetime_minute>option', true, 'CASE:2-03-03-14-05')
      assert_select('#from_datetime_second>option', true, 'CASE:2-03-03-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year>option', true, 'CASE:2-03-03-15-01')
      assert_select('#to_datetime_month>option', true, 'CASE:2-03-03-15-02')
      assert_select('#to_datetime_day>option', true, 'CASE:2-03-03-15-03')
      assert_select('#to_datetime_hour>option', true, 'CASE:2-03-03-15-04')
      assert_select('#to_datetime_minute>option', true, 'CASE:2-03-03-15-05')
      assert_select('#to_datetime_second>option', true, 'CASE:2-03-03-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-03-03-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-03-03-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-03-03-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-03-03-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-03-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-03-03-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-03-03-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-03-03-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-03-03-24')
      # エラーメッセージ
      assert_select('.error_msg', '対象データ が見つかりません。', 'CASE:2-03-03-25')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-03-26')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
      assert(schedule_list.size == 8, 'CASE:2-03-03-27')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-03-03-28')
        assert(ent.updated_at < bef_datetime, 'CASE:2-03-03-29')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-03-03")
    end
  end
  
  # 2-04
  # action:delete
  # テスト項目概要：削除処理
  test '2-04 delete action' do
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
      assert(params[:system_id].nil?, 'CASE:2-04-01-01')
      assert(params[:from_datetime].nil?, 'CASE:2-04-01-02')
      assert(params[:to_datetime].nil?, 'CASE:2-04-01-03')
      assert(params[:delete_id].nil?, 'CASE:2-04-01-04')
      assert(params[:sort_item].nil?, 'CASE:2-04-01-05')
      assert(params[:sort_order].nil?, 'CASE:2-04-01-06')
      assert(params[:disp_counts].nil?, 'CASE:2-04-01-07')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-04-01-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-04-01-09')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-04-01-10')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-04-01-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-04-01-12')
      # システムIDコンボ
      valid_system_id('CASE:2-04-01-13')
      # 取得開始日時（From）
      assert_select('#from_datetime_year', true, 'CASE:2-04-01-14-01')
      assert_select('#from_datetime_month', true, 'CASE:2-04-01-14-02')
      assert_select('#from_datetime_day', true, 'CASE:2-04-01-14-03')
      assert_select('#from_datetime_hour', true, 'CASE:2-04-01-14-04')
      assert_select('#from_datetime_minute', true, 'CASE:2-04-01-14-05')
      assert_select('#from_datetime_second', true, 'CASE:2-04-01-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year', true, 'CASE:2-04-01-15-01')
      assert_select('#to_datetime_month', true, 'CASE:2-04-01-15-02')
      assert_select('#to_datetime_day', true, 'CASE:2-04-01-15-03')
      assert_select('#to_datetime_hour', true, 'CASE:2-04-01-15-04')
      assert_select('#to_datetime_minute', true, 'CASE:2-04-01-15-05')
      assert_select('#to_datetime_second', true, 'CASE:2-04-01-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-04-01-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-04-01-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-04-01-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-04-01-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-01-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-04-01-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-04-01-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-04-01-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-04-01-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-01-25')
      valid_update_form('CASE:2-04-01-26')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
#      print_log('list size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 7, 'CASE:2-04-01-27')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-04-01-28')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-04-01")
    end
    ###########################################################################
    # 正常（From、To指定）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      params[:system_id] = '1'
      params[:from_datetime] = {:year=>'2011', :month=>'9', :day=>'8', :hour=>'2', :minute=>'0', :second=>'3'}
      params[:to_datetime] = {:year=>'2011', :month=>'9', :day=>'17', :hour=>'9', :minute=>'0', :second=>'0'}
      params[:sort_item] = 'gets_start_date'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      # 処理実行
      post(:delete, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      assert(req_params[:system_id] == '1', 'CASE:2-04-02-01')
      from_hash = req_params[:from_datetime]
      assert(from_hash[:year] == '2011', 'CASE:2-04-02-02-01')
      assert(from_hash[:month] == '9', 'CASE:2-04-02-02-02')
      assert(from_hash[:day] == '8', 'CASE:2-04-02-02-03')
      assert(from_hash[:hour] == '2', 'CASE:2-04-02-02-04')
      assert(from_hash[:minute] == '0', 'CASE:2-04-02-02-05')
      assert(from_hash[:second] == '3', 'CASE:2-04-02-02-06')
      to_hash = req_params[:to_datetime]
      assert(to_hash[:year] == '2011', 'CASE:2-04-02-03-01')
      assert(to_hash[:month] == '9', 'CASE:2-04-02-03-02')
      assert(to_hash[:day] == '17', 'CASE:2-04-02-03-03')
      assert(to_hash[:hour] == '9', 'CASE:2-04-02-03-04')
      assert(to_hash[:minute] == '0', 'CASE:2-04-02-03-05')
      assert(to_hash[:second] == '0', 'CASE:2-04-02-03-06')
      assert(req_params[:delete_id].nil?, 'CASE:2-04-02-04')
      assert(req_params[:sort_item] == 'gets_start_date', 'CASE:2-04-02-05')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-04-02-06')
      assert(req_params[:disp_counts] == '500', 'CASE:2-04-02-07')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-04-02-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-04-02-09')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-04-02-10')
      # エラーメッセージ判定
#      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-04-02-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-04-02-12')
      # システムIDコンボ
      valid_system_id('CASE:2-04-02-13', '1')
      # 取得開始日時（From）
      assert_select('#from_datetime_year>option[selected="selected"][value="2011"]', true, 'CASE:2-04-02-14-01')
      assert_select('#from_datetime_month>option[selected="selected"][value="9"]', true, 'CASE:2-04-02-14-02')
      assert_select('#from_datetime_day>option[selected="selected"][value="8"]', true, 'CASE:2-04-02-14-03')
      assert_select('#from_datetime_hour>option[selected="selected"][value="02"]', true, 'CASE:2-04-02-14-04')
      assert_select('#from_datetime_minute>option[selected="selected"][value="00"]', true, 'CASE:2-04-02-14-05')
      assert_select('#from_datetime_second>option[selected="selected"][value="03"]', true, 'CASE:2-04-02-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year>option[selected="selected"][value="2011"]', true, 'CASE:2-04-02-15-01')
      assert_select('#to_datetime_month>option[selected="selected"][value="9"]', true, 'CASE:2-04-02-15-02')
      assert_select('#to_datetime_day>option[selected="selected"][value="17"]', true, 'CASE:2-04-02-15-03')
      assert_select('#to_datetime_hour>option[selected="selected"][value="09"]', true, 'CASE:2-04-02-15-04')
      assert_select('#to_datetime_minute>option[selected="selected"][value="00"]', true, 'CASE:2-04-02-15-05')
      assert_select('#to_datetime_second>option[selected="selected"][value="00"]', true, 'CASE:2-04-02-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-04-02-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-04-02-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-04-02-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-04-02-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-02-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-04-02-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-04-02-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-04-02-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-04-02-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-02-25')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
#      print_log('schedule_list.size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 5, 'CASE:2-04-02-26')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-04-02-27')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-04-02")
    end
    ###########################################################################
    # 正常（ID指定）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      params[:system_id] = '1'
      params[:from_datetime] = nil
      params[:to_datetime] = nil
      params[:delete_id] = '7'
      params[:sort_item] = 'gets_start_date'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      # 処理実行
      post(:delete, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      assert(req_params[:system_id] == '1', 'CASE:2-04-03-01')
      assert(req_params[:from_datetime].nil?, 'CASE:2-04-03-02')
      assert(req_params[:to_datetime].nil?, 'CASE:2-04-03-03')
      assert(req_params[:delete_id] == '7', 'CASE:2-04-03-04')
      assert(req_params[:sort_item] == 'gets_start_date', 'CASE:2-04-03-05')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-04-03-06')
      assert(req_params[:disp_counts] == '500', 'CASE:2-04-03-07')
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-04-03-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-04-03-09')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-04-03-10')
      # エラーメッセージ判定
      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-04-03-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-04-03-12')
      # システムIDコンボ
      valid_system_id('CASE:2-04-03-13', '1')
      # 取得開始日時（From）
      assert_select('#from_datetime_year>option', true, 'CASE:2-04-03-14-01')
      assert_select('#from_datetime_month>option', true, 'CASE:2-04-03-14-02')
      assert_select('#from_datetime_day>option', true, 'CASE:2-04-03-14-03')
      assert_select('#from_datetime_hour>option', true, 'CASE:2-04-03-14-04')
      assert_select('#from_datetime_minute>option', true, 'CASE:2-04-03-14-05')
      assert_select('#from_datetime_second>option', true, 'CASE:2-04-03-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year>option', true, 'CASE:2-04-03-15-01')
      assert_select('#to_datetime_month>option', true, 'CASE:2-04-03-15-02')
      assert_select('#to_datetime_day>option', true, 'CASE:2-04-03-15-03')
      assert_select('#to_datetime_hour>option', true, 'CASE:2-04-03-15-04')
      assert_select('#to_datetime_minute>option', true, 'CASE:2-04-03-15-05')
      assert_select('#to_datetime_second>option', true, 'CASE:2-04-03-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-04-03-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-04-03-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-04-03-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-04-03-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-03-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-04-03-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-04-03-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-04-03-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-04-03-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-03-25')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
#      print_log('schedule_list.size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 4, 'CASE:2-04-03-26')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-04-03-27')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-04-03")
    end
    ###########################################################################
    # 異常（検索条件有り）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      params[:system_id] = '1'
      params[:from_datetime] = nil
      params[:to_datetime] = nil
      params[:delete_id] = '1000'
      params[:sort_item] = 'system_id'
      params[:sort_order] = 'DESC'
      params[:disp_counts] = '10'
      # 処理実行
      post(:delete, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
      assert(req_params[:system_id] == '1', 'CASE:2-04-04-01')
      from_hash = req_params[:from_datetime]
      assert(from_hash.nil?, 'CASE:2-04-04-02')
      to_hash = req_params[:to_datetime]
      assert(to_hash.nil?, 'CASE:2-04-04-03')
      assert(req_params[:delete_id] == '1000', 'CASE:2-04-04-04')
      assert(req_params[:sort_item] == 'system_id', 'CASE:2-04-04-05')
      assert(req_params[:sort_order] == 'DESC', 'CASE:2-04-04-06')
      assert(req_params[:disp_counts] == '10', 'CASE:2-04-04-07')
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-04-04-07')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-04-04-08')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-04-04-09')
      # エラーメッセージ判定
      err_hash = assigns(:err_hash)
#      print_log('err_hash:' + err_hash.to_s)
      assert(err_hash.size == 1, 'CASE:2-04-04-10')
      assert(err_hash[:error_msg] == '対象データ が見つかりません。', 'CASE:2-04-04-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-04-04-12')
      # システムIDコンボ
      valid_system_id('CASE:2-04-04-13', '1')
      # 取得開始日時（From）
      assert_select('#from_datetime_year>option', true, 'CASE:2-04-04-14-01')
      assert_select('#from_datetime_month>option', true, 'CASE:2-04-04-14-02')
      assert_select('#from_datetime_day>option', true, 'CASE:2-04-04-14-03')
      assert_select('#from_datetime_hour>option', true, 'CASE:2-04-04-14-04')
      assert_select('#from_datetime_minute>option', true, 'CASE:2-04-04-14-05')
      assert_select('#from_datetime_second>option', true, 'CASE:2-04-04-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year>option', true, 'CASE:2-04-04-15-01')
      assert_select('#to_datetime_month>option', true, 'CASE:2-04-04-15-02')
      assert_select('#to_datetime_day>option', true, 'CASE:2-04-04-15-03')
      assert_select('#to_datetime_hour>option', true, 'CASE:2-04-04-15-04')
      assert_select('#to_datetime_minute>option', true, 'CASE:2-04-04-15-05')
      assert_select('#to_datetime_second>option', true, 'CASE:2-04-04-15-06')
      assert_select('.error_msg', '対象データ が見つかりません。', 'CASE:2-04-04-16')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-04-04-17')
      # ソート項目コンボ
      valid_sort_item('CASE:2-04-04-18', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-04-04-19', 'DESC')
      # 表示件数
      valid_disp_counts('CASE:2-04-04-20', '10')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-04-21')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-04-04-22')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-04-04-23')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-04-04-24')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-04-04-25')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-04-26')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
      assert(schedule_list.size == 4, 'CASE:2-04-04-27')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-04-04-28')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-04-04")
    end
  end
  
  # 2-05
  # action:notify
  # テスト項目概要：削除処理
  test '2-05 notify action' do
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
      assert(params[:system_id].nil?, 'CASE:2-05-01-01')
      assert(params[:from_datetime].nil?, 'CASE:2-05-01-02')
      assert(params[:to_datetime].nil?, 'CASE:2-05-01-03')
      assert(params[:delete_id].nil?, 'CASE:2-05-01-04')
      assert(params[:sort_item].nil?, 'CASE:2-05-01-05')
      assert(params[:sort_order].nil?, 'CASE:2-05-01-06')
      assert(params[:disp_counts].nil?, 'CASE:2-05-01-07')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-05-01-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-05-01-09')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-05-01-10')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-05-01-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-05-01-12')
      # システムIDコンボ
      valid_system_id('CASE:2-05-01-13')
      # 取得開始日時（From）
      assert_select('#from_datetime_year', true, 'CASE:2-05-01-14-01')
      assert_select('#from_datetime_month', true, 'CASE:2-05-01-14-02')
      assert_select('#from_datetime_day', true, 'CASE:2-05-01-14-03')
      assert_select('#from_datetime_hour', true, 'CASE:2-05-01-14-04')
      assert_select('#from_datetime_minute', true, 'CASE:2-05-01-14-05')
      assert_select('#from_datetime_second', true, 'CASE:2-05-01-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year', true, 'CASE:2-05-01-15-01')
      assert_select('#to_datetime_month', true, 'CASE:2-05-01-15-02')
      assert_select('#to_datetime_day', true, 'CASE:2-05-01-15-03')
      assert_select('#to_datetime_hour', true, 'CASE:2-05-01-15-04')
      assert_select('#to_datetime_minute', true, 'CASE:2-05-01-15-05')
      assert_select('#to_datetime_second', true, 'CASE:2-05-01-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-05-01-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-05-01-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-05-01-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-05-01-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-05-01-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-05-01-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-05-01-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-05-01-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-05-01-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-05-01-25')
      valid_update_form('CASE:2-05-01-26')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
#      print_log('list size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 7, 'CASE:2-05-01-27')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-05-01-28')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-05-01")
    end
    ###########################################################################
    # 正常（From、To指定）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      params[:system_id] = '1'
      params[:from_datetime] = {:year=>'2011', :month=>'9', :day=>'8', :hour=>'2', :minute=>'0', :second=>'3'}
      params[:to_datetime] = {:year=>'2011', :month=>'9', :day=>'17', :hour=>'9', :minute=>'0', :second=>'0'}
      params[:sort_item] = 'gets_start_date'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      # 処理実行
      post(:notify, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      assert(req_params[:system_id] == '1', 'CASE:2-05-02-01')
      from_hash = req_params[:from_datetime]
      assert(from_hash[:year] == '2011', 'CASE:2-05-02-02-01')
      assert(from_hash[:month] == '9', 'CASE:2-05-02-02-02')
      assert(from_hash[:day] == '8', 'CASE:2-05-02-02-03')
      assert(from_hash[:hour] == '2', 'CASE:2-05-02-02-04')
      assert(from_hash[:minute] == '0', 'CASE:2-05-02-02-05')
      assert(from_hash[:second] == '3', 'CASE:2-05-02-02-06')
      to_hash = req_params[:to_datetime]
      assert(to_hash[:year] == '2011', 'CASE:2-05-02-03-01')
      assert(to_hash[:month] == '9', 'CASE:2-05-02-03-02')
      assert(to_hash[:day] == '17', 'CASE:2-05-02-03-03')
      assert(to_hash[:hour] == '9', 'CASE:2-05-02-03-04')
      assert(to_hash[:minute] == '0', 'CASE:2-05-02-03-05')
      assert(to_hash[:second] == '0', 'CASE:2-05-02-03-06')
      assert(req_params[:delete_id].nil?, 'CASE:2-05-02-04')
      assert(req_params[:sort_item] == 'gets_start_date', 'CASE:2-05-02-05')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-05-02-06')
      assert(req_params[:disp_counts] == '500', 'CASE:2-05-02-07')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-05-02-08')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-05-02-09')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-05-02-10')
      # エラーメッセージ判定
#      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 0, 'CASE:2-05-02-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-05-02-12')
      # システムIDコンボ
      valid_system_id('CASE:2-05-02-13', '1')
      # 取得開始日時（From）
      assert_select('#from_datetime_year>option[selected="selected"][value="2011"]', true, 'CASE:2-05-02-14-01')
      assert_select('#from_datetime_month>option[selected="selected"][value="9"]', true, 'CASE:2-05-02-14-02')
      assert_select('#from_datetime_day>option[selected="selected"][value="8"]', true, 'CASE:2-05-02-14-03')
      assert_select('#from_datetime_hour>option[selected="selected"][value="02"]', true, 'CASE:2-05-02-14-04')
      assert_select('#from_datetime_minute>option[selected="selected"][value="00"]', true, 'CASE:2-05-02-14-05')
      assert_select('#from_datetime_second>option[selected="selected"][value="03"]', true, 'CASE:2-05-02-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year>option[selected="selected"][value="2011"]', true, 'CASE:2-05-02-15-01')
      assert_select('#to_datetime_month>option[selected="selected"][value="9"]', true, 'CASE:2-05-02-15-02')
      assert_select('#to_datetime_day>option[selected="selected"][value="17"]', true, 'CASE:2-05-02-15-03')
      assert_select('#to_datetime_hour>option[selected="selected"][value="09"]', true, 'CASE:2-05-02-15-04')
      assert_select('#to_datetime_minute>option[selected="selected"][value="00"]', true, 'CASE:2-05-02-15-05')
      assert_select('#to_datetime_second>option[selected="selected"][value="00"]', true, 'CASE:2-05-02-15-06')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-05-02-16')
      # ソート項目コンボ
      valid_sort_item('CASE:2-05-02-17', 'gets_start_date')
      # ソート順序
      valid_sort_order('CASE:2-05-02-18', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-05-02-19', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-05-02-20')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-05-02-21')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-05-02-22')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-05-02-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-05-02-24')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-05-02-25')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
#      print_log('schedule_list.size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 7, 'CASE:2-05-02-26')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-05-02-27')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-05-02")
    end
    ###########################################################################
    # 異常（検索条件有り）
    ###########################################################################
    begin
      # 送信パラメータ生成
      params = create_params(:TRANS_PTN_NOW, 2)
      params[:system_id] = '1000'
      params[:from_datetime] = nil
      params[:to_datetime] = nil
      params[:delete_id] = nil
      params[:sort_item] = 'system_id'
      params[:sort_order] = 'DESC'
      params[:disp_counts] = '10'
      # 処理実行
      post(:notify, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
      assert(req_params[:system_id] == '1000', 'CASE:2-05-03-01')
      from_hash = req_params[:from_datetime]
      assert(from_hash.nil?, 'CASE:2-05-03-02')
      to_hash = req_params[:to_datetime]
      assert(to_hash.nil?, 'CASE:2-05-03-03')
      assert(req_params[:delete_id].nil?, 'CASE:2-05-03-04')
      assert(req_params[:sort_item] == 'system_id', 'CASE:2-05-03-05')
      assert(req_params[:sort_order] == 'DESC', 'CASE:2-05-03-06')
      assert(req_params[:disp_counts] == '10', 'CASE:2-05-03-07')
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-05-03-07')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-05-03-08')
      valid_state('schedule_list/schedule_list', 2, 1, false, 'CASE:2-05-03-09')
      # エラーメッセージ判定
      err_hash = assigns(:err_hash)
#      print_log('err_hash:' + err_hash.to_s)
      assert(err_hash.size == 1, 'CASE:2-05-03-10')
      assert(err_hash[:system_id] == 'システム名 は不正な値です。', 'CASE:2-05-03-11')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-05-03-12')
      # システムIDコンボ
      valid_system_id('CASE:2-05-03-13', '1000')
      # 取得開始日時（From）
      assert_select('#from_datetime_year>option', true, 'CASE:2-05-03-14-01')
      assert_select('#from_datetime_month>option', true, 'CASE:2-05-03-14-02')
      assert_select('#from_datetime_day>option', true, 'CASE:2-05-03-14-03')
      assert_select('#from_datetime_hour>option', true, 'CASE:2-05-03-14-04')
      assert_select('#from_datetime_minute>option', true, 'CASE:2-05-03-14-05')
      assert_select('#from_datetime_second>option', true, 'CASE:2-05-03-14-06')
      # 取得開始日時（To）
      assert_select('#to_datetime_year>option', true, 'CASE:2-05-03-15-01')
      assert_select('#to_datetime_month>option', true, 'CASE:2-05-03-15-02')
      assert_select('#to_datetime_day>option', true, 'CASE:2-05-03-15-03')
      assert_select('#to_datetime_hour>option', true, 'CASE:2-05-03-15-04')
      assert_select('#to_datetime_minute>option', true, 'CASE:2-05-03-15-05')
      assert_select('#to_datetime_second>option', true, 'CASE:2-05-03-15-06')
      assert_select('#sverr_system_id[value="システム名 は不正な値です。"]', true, 'CASE:2-05-03-16')
      # 削除ID
      assert_select('#delete_id', true, 'CASE:2-05-03-17')
      # ソート項目コンボ
      valid_sort_item('CASE:2-05-03-18', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-05-03-19', 'DESC')
      # 表示件数
      valid_disp_counts('CASE:2-05-03-20', '10')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/schedule_list/schedule_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-05-03-21')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-05-03-22')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-05-03-23')
      assert_select('#input_form input[value="削除"]', true, 'CASE:2-05-03-24')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-05-03-25')
      #########################################################################
      # 更新フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#update_form[action="/schedule_list/schedule_list/update"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-05-03-26')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      schedule_list = assigns[:schedule_list]
      assert(schedule_list.size == 7, 'CASE:2-05-03-27')
      # 明細チェック
      idx = 1
      schedule_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-05-03-28')
        idx += 1
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-05-03")
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
  
  # 明細チェック
  def valid_update_form(err_msg)
    head = '#update_form input'
    assert_select(head + '[id="target_id"]',true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_received_year"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_received_month"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_received_day"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_received_hour"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_received_minute"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_received_second"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_function_id"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_function_transition_no"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_login_id"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_client_id"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_browser_id"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_browser_version_id"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_accept_language"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_referrer"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_domain_id"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_proxy_host"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_proxy_ip_address"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_remote_host"]', true, err_msg)
    assert_select(head + '[id="analysis_schedule_gs_ip_address"]', true, err_msg)
  end
  
  # ソート項目コンボチェック
  def valid_sort_item(err_msg, selected_val=nil)
    combo_hash = Hash.new
    combo_hash['システム名'] = 'system_id'
    combo_hash['取得開始日時'] = 'gets_start_date'
    combo_hash['取得設定（受信年）'] = 'gs_received_year'
    combo_hash['取得設定（受信月）'] = 'gs_received_month'
    combo_hash['取得設定（受信日）'] = 'gs_received_day'
    combo_hash['取得設定（受信時）'] = 'gs_received_hour'
    combo_hash['取得設定（受信分）'] = 'gs_received_minute'
    combo_hash['取得設定（受信秒）'] = 'gs_received_second'
    combo_hash['取得設定（機能ID）'] = 'gs_function_id'
    combo_hash['取得設定（機能遷移番号）'] = 'gs_function_transition_no'
    combo_hash['取得設定（ログインID）'] = 'gs_login_id'
    combo_hash['取得設定（クライアントID）'] = 'gs_client_id'
    combo_hash['取得設定（ブラウザID）'] = 'gs_browser_id'
    combo_hash['取得設定（ブラウザバージョンID）'] = 'gs_browser_version_id'
    combo_hash['取得設定（言語）'] = 'gs_accept_language'
    combo_hash['取得設定（リファラー）'] = 'gs_referrer'
    combo_hash['取得設定（ドメインID）'] = 'gs_domain_id'
    combo_hash['取得設定（プロキシホスト）'] = 'gs_proxy_host'
    combo_hash['取得設定（プロキシIP）'] = 'gs_proxy_ip_address'
    combo_hash['取得設定（クライアントホスト）'] = 'gs_remote_host'
    combo_hash['取得設定（クライアントIP）'] = 'gs_ip_address'
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
    assert_select(head + '>td:nth-of-type(1) font', ent.system.system_name, err_msg)
    assert_select(head + '>td:nth-of-type(2) font', ent.system.subsystem_name, err_msg)
    assert_select(head + '>td:nth-of-type(3) font', default_time(ent.gets_start_date), err_msg)
    assert_select(head + '>td:nth-of-type(4) ' + chk_box_select('gs_received_year', ent.gs_received_year), true, err_msg)
    assert_select(head + '>td:nth-of-type(5) ' + chk_box_select('gs_received_month', ent.gs_received_month), true, err_msg)
    assert_select(head + '>td:nth-of-type(6) ' + chk_box_select('gs_received_day', ent.gs_received_day), true, err_msg)
    assert_select(head + '>td:nth-of-type(7) ' + chk_box_select('gs_received_hour', ent.gs_received_hour), true, err_msg)
    assert_select(head + '>td:nth-of-type(8) ' + chk_box_select('gs_received_minute', ent.gs_received_minute), true, err_msg)
    assert_select(head + '>td:nth-of-type(9) ' + chk_box_select('gs_received_second', ent.gs_received_second), true, err_msg)
    assert_select(head + '>td:nth-of-type(10) ' + chk_box_select('gs_function_id', ent.gs_function_id), true, err_msg)
    assert_select(head + '>td:nth-of-type(11) ' + chk_box_select('gs_function_transition_no', ent.gs_function_transition_no), true, err_msg)
    assert_select(head + '>td:nth-of-type(12) ' + chk_box_select('gs_login_id', ent.gs_login_id), true, err_msg)
    assert_select(head + '>td:nth-of-type(13) ' + chk_box_select('gs_client_id', ent.gs_client_id), true, err_msg)
    assert_select(head + '>td:nth-of-type(14) ' + chk_box_select('gs_browser_id', ent.gs_browser_id), true, err_msg)
    assert_select(head + '>td:nth-of-type(15) ' + chk_box_select('gs_browser_version_id', ent.gs_browser_version_id), true, err_msg)
    assert_select(head + '>td:nth-of-type(16) ' + chk_box_select('gs_accept_language', ent.gs_accept_language), true, err_msg)
    assert_select(head + '>td:nth-of-type(17) ' + chk_box_select('gs_referrer', ent.gs_referrer), true, err_msg)
    assert_select(head + '>td:nth-of-type(18) ' + chk_box_select('gs_domain_id', ent.gs_domain_id), true, err_msg)
    assert_select(head + '>td:nth-of-type(19) ' + chk_box_select('gs_proxy_host', ent.gs_proxy_host), true, err_msg)
    assert_select(head + '>td:nth-of-type(20) ' + chk_box_select('gs_proxy_ip_address', ent.gs_proxy_ip_address), true, err_msg)
    assert_select(head + '>td:nth-of-type(21) ' + chk_box_select('gs_remote_host', ent.gs_remote_host), true, err_msg)
    assert_select(head + '>td:nth-of-type(22) ' + chk_box_select('gs_ip_address', ent.gs_ip_address), true, err_msg)
    if ent.gets_start_date > DateTime.now then
      assert_select(head + '>td:nth-of-type(23) input[type="button"][value="更"]', true, err_msg)
    end
    assert_select(head + '>td:nth-of-type(23) input[type="button"][value="削"]', true, err_msg)
  end
  
  # チェックボックスセレクタ生成
  def chk_box_select(item_name, chk_flg=false)
    checked = ''
    checked = '[checked=checked]' if chk_flg
    return 'input[id="analysis_schedule_' + item_name + '"]' + checked
  end
end
