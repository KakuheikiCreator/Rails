# -*- coding: utf-8 -*-
###############################################################################
# ファンクショナルテスト
# テスト対象：規制ホスト一覧コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/09/11 Nakanohito
# 更新日:
###############################################################################
require 'drb/drb'
require 'test_helper'
require 'functional/functional_test_util'
require 'functional/filter/filter_test_module'

class RegulationHostList::RegulationHostListControllerTest < ActionController::TestCase
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
      assert(params[:regulation_host].nil?, 'CASE:2-01-01-01')
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
      valid_state('regulation_host_list/regulation_host_list', 2, 1, false, 'CASE:2-01-01-09')
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
      assert_select('#regulation_host_remarks', true, 'CASE:2-01-01-13')
      # プロキシホストテキストボックス
      assert_select('#regulation_host_proxy_host', true, 'CASE:2-01-01-14')
      # プロキシIPテキストボックス
      assert_select('#regulation_host_proxy_ip_address', true, 'CASE:2-01-01-15')
      # クライアントホストテキストボックス
      assert_select('#regulation_host_remote_host', true, 'CASE:2-01-01-16')
      # クライアントIPテキストボックス
      assert_select('#regulation_host_ip_address', true, 'CASE:2-01-01-17')
      # ソート項目コンボ
      valid_sort_item('CASE:2-01-01-18', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-01-01-19', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-01-01-20', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_host_list/regulation_host_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-01-21')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-01-01-22')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-01-01-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-01-01-24')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_host_list/regulation_host_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-01-25')
      # HIDDEN項目のチェック
      assert_select('#delete_form input[value=""]', 1, 'CASE:2-01-01-26')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 11, 'CASE:2-01-01-27')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_host_list = assigns[:reg_host_list]
      assert(reg_host_list.size == 11, 'CASE:2-01-01-28')
      # 明細チェック
      idx = 1
      reg_host_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-01-01-29')
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
      params[:regulation_host] = {:system_id=>'1',
                                  :proxy_host=>'^proxy2\.ne\.jp$', :proxy_ip_address=>'192.168.254.2',
                                  :remote_host=>'^client2\.ne\.jp$', :ip_address=>'192.168.255.2',
                                  :remarks=>'MyString'}
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
      reg_host = req_params[:regulation_host]
      assert(reg_host[:system_id] == '1', 'CASE:2-01-02-01')
      assert(reg_host[:proxy_host] == '^proxy2\.ne\.jp$', 'CASE:2-01-02-02')
      assert(reg_host[:proxy_ip_address] == '192.168.254.2', 'CASE:2-01-02-03')
      assert(reg_host[:remote_host] == '^client2\.ne\.jp$', 'CASE:2-01-02-04')
      assert(reg_host[:ip_address] == '192.168.255.2', 'CASE:2-01-02-05')
      assert(reg_host[:remarks] == 'MyString', 'CASE:2-01-02-06')
      assert(req_params[:sort_item] == 'remarks', 'CASE:2-01-02-07')
      assert(req_params[:sort_order] == 'DESC', 'CASE:2-01-02-08')
      assert(req_params[:disp_counts] == '10', 'CASE:2-01-02-09')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-01-02-10')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-01-02-11')
      valid_state('regulation_host_list/regulation_host_list', 2, 1, false, 'CASE:2-01-02-12')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-01-02-13')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-01-02-14')
      # システムIDコンボ
      valid_system_id('CASE:2-01-02-15', '1')
      # 備考テキストボックス
      assert_select('#regulation_host_remarks[value="MyString"]', true, 'CASE:2-01-02-16')
      # プロキシホストテキストボックス
      assert_select('#regulation_host_proxy_host[value="^proxy2\.ne\.jp$"]', true, 'CASE:2-01-02-17')
      # プロキシIPテキストボックス
      assert_select('#regulation_host_proxy_ip_address[value="192.168.254.2"]', true, 'CASE:2-01-02-18')
      # クライアントホストテキストボックス
      assert_select('#regulation_host_remote_host[value="^client2\.ne\.jp$"]', true, 'CASE:2-01-02-19')
      # クライアントIPテキストボックス
      assert_select('#regulation_host_ip_address[value="192.168.255.2"]', true, 'CASE:2-01-02-20')
      # ソート項目コンボ
      valid_sort_item('CASE:2-01-02-21', 'remarks')
      # ソート順序
      valid_sort_order('CASE:2-01-02-22', 'DESC')
      # 表示件数
      valid_disp_counts('CASE:2-01-02-23', '10')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_host_list/regulation_host_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-02-24')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-01-02-25')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-01-02-26')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-01-02-27')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_host_list/regulation_host_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-02-28')
      # HIDDEN項目のチェック
      assert_select('#delete_form input[value=""]', 1, 'CASE:2-01-02-29')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 1, 'CASE:2-01-02-30')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_host_list = assigns[:reg_host_list]
      assert(reg_host_list.size == 1, 'CASE:2-01-02-31')
      # 明細チェック
      idx = 1
      reg_host_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-01-02-32')
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
      params[:regulation_host] = {:system_id=>'a',
                                  :proxy_host=>'^proxy2\.ne\.jp$', :proxy_ip_address=>'192.168.254.2',
                                  :remote_host=>'^client2\.ne\.jp$', :ip_address=>'192.168.255.2',
                                  :remarks=>'MyString'}
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
      reg_host = req_params[:regulation_host]
      assert(reg_host[:system_id] == 'a', 'CASE:2-01-03-01')
      assert(reg_host[:proxy_host] == '^proxy2\.ne\.jp$', 'CASE:2-01-03-02')
      assert(reg_host[:proxy_ip_address] == '192.168.254.2', 'CASE:2-01-03-03')
      assert(reg_host[:remote_host] == '^client2\.ne\.jp$', 'CASE:2-01-03-04')
      assert(reg_host[:ip_address] == '192.168.255.2', 'CASE:2-01-03-05')
      assert(reg_host[:remarks] == 'MyString', 'CASE:2-01-03-06')
      assert(req_params[:sort_item] == 'remarks', 'CASE:2-01-03-07')
      assert(req_params[:sort_order] == 'DESC', 'CASE:2-01-03-08')
      assert(req_params[:disp_counts] == '10', 'CASE:2-01-03-09')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-01-03-10')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-01-03-11')
      valid_state('regulation_host_list/regulation_host_list', 2, 1, false, 'CASE:2-01-03-12')
      # エラーメッセージ判定
      print_log('err_hash:' + assigns(:err_hash).to_s)
      assert(assigns(:err_hash).size == 1, 'CASE:2-01-03-13')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-01-03-14')
      # システムIDコンボ
      valid_system_id('CASE:2-01-03-15')
      assert_select('#sverr_system_id[value="システム名 は不正な値です。"]', true, 'CASE:2-01-03-16')
      # 備考テキストボックス
      assert_select('#regulation_host_remarks[value="MyString"]', true, 'CASE:2-01-03-17')
      # プロキシホストテキストボックス
      assert_select('#regulation_host_proxy_host[value="^proxy2\.ne\.jp$"]', true, 'CASE:2-01-03-18')
      # プロキシIPテキストボックス
      assert_select('#regulation_host_proxy_ip_address[value="192.168.254.2"]', true, 'CASE:2-01-03-19')
      # クライアントホストテキストボックス
      assert_select('#regulation_host_remote_host[value="^client2\.ne\.jp$"]', true, 'CASE:2-01-03-20')
      # クライアントIPテキストボックス
      assert_select('#regulation_host_ip_address[value="192.168.255.2"]', true, 'CASE:2-01-03-21')
      # ソート項目コンボ
      valid_sort_item('CASE:2-01-03-22', 'remarks')
      # ソート順序
      valid_sort_order('CASE:2-01-03-23', 'DESC')
      # 表示件数
      valid_disp_counts('CASE:2-01-03-24', '10')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_host_list/regulation_host_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-03-25')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-01-03-26')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-01-03-27')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-01-03-28')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_host_list/regulation_host_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-01-03-29')
      # HIDDEN項目のチェック
      assert_select('#delete_form input[value=""]', 1, 'CASE:2-01-03-30')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 11, 'CASE:2-01-03-31')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_host_list = assigns[:reg_host_list]
      assert(reg_host_list.size == 11, 'CASE:2-01-03-32')
      # 明細チェック
      idx = 1
      reg_host_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-01-03-33')
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
      params[:regulation_host] = {:system_id=>'1',
                                  :proxy_host=>'^proxy12\.ne\.jp$', :proxy_ip_address=>'192.168.254.12',
                                  :remote_host=>'^client12\.ne\.jp$', :ip_address=>'192.168.255.12',
                                  :remarks=>'MyString12'}
      params[:sort_item] = 'system_id'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      post(:create, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      reg_host = req_params[:regulation_host]
      assert(reg_host[:system_id] == '1', 'CASE:2-02-01-01')
      assert(reg_host[:proxy_host] == '^proxy12\.ne\.jp$', 'CASE:2-02-01-02')
      assert(reg_host[:proxy_ip_address] == '192.168.254.12', 'CASE:2-02-01-03')
      assert(reg_host[:remote_host] == '^client12\.ne\.jp$', 'CASE:2-02-01-04')
      assert(reg_host[:ip_address] == '192.168.255.12', 'CASE:2-02-01-05')
      assert(reg_host[:remarks] == 'MyString12', 'CASE:2-02-01-06')
      assert(req_params[:sort_item] == 'system_id', 'CASE:2-02-01-07')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-02-01-08')
      assert(req_params[:disp_counts] == '500', 'CASE:2-02-01-09')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-02-01-10')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-02-01-11')
      valid_state('regulation_host_list/regulation_host_list', 1, nil, true, 'CASE:2-02-01-12')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-02-01-13')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-02-01-14')
      # システムIDコンボ
      valid_system_id('CASE:2-02-01-15')
      # 備考テキストボックス
      assert_select('#regulation_host_remarks[value="MyString12"]', true, 'CASE:2-02-01-16')
      # プロキシホストテキストボックス
      assert_select('#regulation_host_proxy_host[value="^proxy12\.ne\.jp$"]', true, 'CASE:2-02-01-17')
      # プロキシIPテキストボックス
      assert_select('#regulation_host_proxy_ip_address[value="192.168.254.12"]', true, 'CASE:2-02-01-18')
      # クライアントホストテキストボックス
      assert_select('#regulation_host_remote_host[value="^client12\.ne\.jp$"]', true, 'CASE:2-02-01-19')
      # クライアントIPテキストボックス
      assert_select('#regulation_host_ip_address[value="192.168.255.12"]', true, 'CASE:2-02-01-20')
      # ソート項目コンボ
      valid_sort_item('CASE:2-02-01-21', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-02-01-22', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-02-01-23', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_host_list/regulation_host_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-01-24')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-02-01-25')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-02-01-26')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-02-01-27')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_host_list/regulation_host_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-01-28')
      # HIDDEN項目のチェック
      assert_select('#delete_form input[value=""]', 1, 'CASE:2-02-01-29')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 12, 'CASE:2-02-01-30')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_host_list = assigns[:reg_host_list]
      assert(reg_host_list.size == 12, 'CASE:2-02-01-31')
      # 明細チェック
      idx = 1
      reg_host_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-02-01-32')
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
      params[:regulation_host] = {:system_id=>'1',
                                  :proxy_host=>'^[a', :proxy_ip_address=>'192.168.254.12',
                                  :remote_host=>'^client12\.ne\.jp$', :ip_address=>'192.168.255.12',
                                  :remarks=>'MyString12'}
      params[:sort_item] = 'system_id'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      post(:create, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      reg_host = req_params[:regulation_host]
      assert(reg_host[:system_id] == '1', 'CASE:2-02-02-01')
      assert(reg_host[:proxy_host] == '^[a', 'CASE:2-02-02-02')
      assert(reg_host[:proxy_ip_address] == '192.168.254.12', 'CASE:2-02-02-03')
      assert(reg_host[:remote_host] == '^client12\.ne\.jp$', 'CASE:2-02-02-04')
      assert(reg_host[:ip_address] == '192.168.255.12', 'CASE:2-02-02-05')
      assert(reg_host[:remarks] == 'MyString12', 'CASE:2-02-02-06')
      assert(req_params[:sort_item] == 'system_id', 'CASE:2-02-02-07')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-02-02-08')
      assert(req_params[:disp_counts] == '500', 'CASE:2-02-02-09')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-02-02-10')
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-02-02-11')
      valid_state('regulation_host_list/regulation_host_list', 1, nil, true, 'CASE:2-02-02-12')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 1, 'CASE:2-02-02-13')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-02-02-14')
      # システムIDコンボ
      valid_system_id('CASE:2-02-02-15')
      # 備考テキストボックス
      assert_select('#regulation_host_remarks[value="MyString12"]', true, 'CASE:2-02-02-16')
      # プロキシホストテキストボックス
      assert_select('#regulation_host_proxy_host[value="^[a"]', true, 'CASE:2-02-02-17')
      assert_select('#sverr_proxy_host[value="プロキシホスト は不正な値です。"]', true, 'CASE:2-02-02-18')
      # プロキシIPテキストボックス
      assert_select('#regulation_host_proxy_ip_address[value="192.168.254.12"]', true, 'CASE:2-01-02-19')
      # クライアントホストテキストボックス
      assert_select('#regulation_host_remote_host[value="^client12\.ne\.jp$"]', true, 'CASE:2-01-02-20')
      # クライアントIPテキストボックス
      assert_select('#regulation_host_ip_address[value="192.168.255.12"]', true, 'CASE:2-01-02-21')
      # ソート項目コンボ
      valid_sort_item('CASE:2-02-02-22', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-02-02-23', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-02-02-24', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_host_list/regulation_host_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-02-25')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-02-02-26')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-02-02-27')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-02-02-28')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_host_list/regulation_host_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-02-02-29')
      # HIDDEN項目のチェック
      assert_select('#delete_form input[value=""]', 1, 'CASE:2-02-02-30')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 12, 'CASE:2-02-02-31')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_host_list = assigns[:reg_host_list]
      assert(reg_host_list.size == 12, 'CASE:2-02-02-32')
      # 明細チェック
      idx = 1
      reg_host_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-02-02-33')
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
      valid_state('regulation_host_list/regulation_host_list', 1, nil, true, 'CASE:2-03-01-09')
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
      assert_select('#regulation_host_remarks', true, 'CASE:2-03-01-13')
      # プロキシホストテキストボックス
      assert_select('#regulation_host_proxy_host', true, 'CASE:2-03-01-14')
      # プロキシIPテキストボックス
      assert_select('#regulation_host_proxy_ip_address', true, 'CASE:2-03-01-15')
      # クライアントホストテキストボックス
      assert_select('#regulation_host_remote_host', true, 'CASE:2-03-01-16')
      # クライアントIPテキストボックス
      assert_select('#regulation_host_ip_address', true, 'CASE:2-03-01-17')
      # ソート項目コンボ
      valid_sort_item('CASE:2-03-01-18', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-03-01-19', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-03-01-20', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_host_list/regulation_host_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-01-21')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-03-01-22')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-03-01-23')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-03-01-24')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_host_list/regulation_host_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-01-25')
      # HIDDEN項目のチェック
      assert_select('#delete_form input[value=""]', 1, 'CASE:2-03-01-26')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 10, 'CASE:2-03-01-27')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_host_list = assigns[:reg_host_list]
      assert(reg_host_list.size == 10, 'CASE:2-03-01-28')
      # 明細チェック
      idx = 1
      reg_host_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-03-01-29')
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
      valid_state('regulation_host_list/regulation_host_list', 1, nil, true, 'CASE:2-03-02-04')
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
      assert_select('#regulation_host_remarks', true, 'CASE:2-03-02-09')
      # プロキシホストテキストボックス
      assert_select('#regulation_host_proxy_host', true, 'CASE:2-03-02-10')
      # プロキシIPテキストボックス
      assert_select('#regulation_host_proxy_ip_address', true, 'CASE:2-03-02-11')
      # クライアントホストテキストボックス
      assert_select('#regulation_host_remote_host', true, 'CASE:2-03-02-12')
      # クライアントIPテキストボックス
      assert_select('#regulation_host_ip_address', true, 'CASE:2-03-02-13')
      # ソート項目コンボ
      valid_sort_item('CASE:2-03-02-14', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-03-02-15', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-02-01-16', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_host_list/regulation_host_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-02-17')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-03-02-18')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-03-02-19')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-03-02-20')
      # エラーメッセージ
      assert_select('.error_msg', '対象データ が見つかりません。', 'CASE:2-03-02-21')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_host_list/regulation_host_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-03-02-22')
      # HIDDEN項目のチェック
      assert_select('#delete_form input[value=""]', 1, 'CASE:2-03-02-23')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 10, 'CASE:2-03-02-24')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_host_list = assigns[:reg_host_list]
      assert(reg_host_list.size == 10, 'CASE:2-03-02-25')
      # 明細チェック
      idx = 1
      reg_host_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-03-02-26')
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
      params[:regulation_host] = {:system_id=>'1',
                                  :proxy_host=>'^proxy12\.ne\.jp$', :proxy_ip_address=>'192.168.254.12',
                                  :remote_host=>'^client12\.ne\.jp$', :ip_address=>'192.168.255.12',
                                  :remarks=>'MyString12'}
      params[:sort_item] = 'system_id'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      post(:notify, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      reg_host = req_params[:regulation_host]
      assert(reg_host[:system_id] == '1', 'CASE:2-04-01-01')
      assert(reg_host[:proxy_host] == '^proxy12\.ne\.jp$', 'CASE:2-04-01-02')
      assert(reg_host[:proxy_ip_address] == '192.168.254.12', 'CASE:2-04-01-03')
      assert(reg_host[:remote_host] == '^client12\.ne\.jp$', 'CASE:2-04-01-04')
      assert(reg_host[:ip_address] == '192.168.255.12', 'CASE:2-04-01-05')
      assert(reg_host[:remarks] == 'MyString12', 'CASE:2-04-01-06')
      assert(req_params[:sort_item] == 'system_id', 'CASE:2-04-01-07')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-04-01-08')
      assert(req_params[:disp_counts] == '500', 'CASE:2-04-01-09')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-04-01-10')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-04-01-11')
      valid_state('regulation_host_list/regulation_host_list', 1, nil, true, 'CASE:2-04-01-12')
      # エラーメッセージ判定
      assert(assigns(:err_hash).size == 0, 'CASE:2-04-01-13')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-04-01-14')
      # システムIDコンボ
      valid_system_id('CASE:2-04-01-15')
      # 備考テキストボックス
      assert_select('#regulation_host_remarks[value="MyString12"]', true, 'CASE:2-04-01-16')
      # プロキシホストテキストボックス
      assert_select('#regulation_host_proxy_host[value="^proxy12\.ne\.jp$"]', true, 'CASE:2-04-01-17')
      # プロキシIPテキストボックス
      assert_select('#regulation_host_proxy_ip_address[value="192.168.254.12"]', true, 'CASE:2-04-01-18')
      # クライアントホストテキストボックス
      assert_select('#regulation_host_remote_host[value="^client12\.ne\.jp$"]', true, 'CASE:2-04-01-19')
      # クライアントIPテキストボックス
      assert_select('#regulation_host_ip_address[value="192.168.255.12"]', true, 'CASE:2-04-01-20')
      # ソート項目コンボ
      valid_sort_item('CASE:2-04-01-21', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-04-01-22', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-04-01-23', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_host_list/regulation_host_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-01-24')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-04-01-25')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-04-01-26')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-04-01-27')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_host_list/regulation_host_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-01-28')
      # HIDDEN項目のチェック
      assert_select('#delete_form input[value=""]', 1, 'CASE:2-04-01-29')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 11, 'CASE:2-04-01-30')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_host_list = assigns[:reg_host_list]
      assert(reg_host_list.size == 11, 'CASE:2-04-01-31')
      # 明細チェック
      idx = 1
      reg_host_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-04-01-32')
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
      params[:regulation_host] = {:system_id=>'a',
                                  :proxy_host=>'^proxy12\.ne\.jp$', :proxy_ip_address=>'192.168.254.12',
                                  :remote_host=>'^client12\.ne\.jp$', :ip_address=>'192.168.255.12',
                                  :remarks=>'MyString12'}
      params[:sort_item] = 'system_id'
      params[:sort_order] = 'ASC'
      params[:disp_counts] = '500'
      post(:notify, params)
      #########################################################################
      # リクエスト確認
      #########################################################################
      req_params = @request.request_parameters
#      print_log('@request:' + @request.request_parameters.to_s)
      reg_host = req_params[:regulation_host]
      assert(reg_host[:system_id] == 'a', 'CASE:2-04-02-01')
      assert(reg_host[:proxy_host] == '^proxy12\.ne\.jp$', 'CASE:2-04-02-02')
      assert(reg_host[:proxy_ip_address] == '192.168.254.12', 'CASE:2-04-02-03')
      assert(reg_host[:remote_host] == '^client12\.ne\.jp$', 'CASE:2-04-02-04')
      assert(reg_host[:ip_address] == '192.168.255.12', 'CASE:2-04-02-05')
      assert(reg_host[:remarks] == 'MyString12', 'CASE:2-04-02-06')
      assert(req_params[:sort_item] == 'system_id', 'CASE:2-04-02-07')
      assert(req_params[:sort_order] == 'ASC', 'CASE:2-04-02-08')
      assert(req_params[:disp_counts] == '500', 'CASE:2-04-02-09')
#      print_log('@controller:' + @controller.class.name.to_s)
#      print_log('@request:' + @request.class.name.to_s)
#      print_log('@request:' + @request.request_parameters.to_s)
#      print_log('@response:' + @response.class.name.to_s)
#      print_log('@response:' + @response.body.to_s)
      #########################################################################
      # レスポンスステータス確認
      #########################################################################
      assert_response(:success, 'CASE:2-04-02-10')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[2]
#      print_log('cntr_path:' + state.cntr_path.to_s)
      # 画面遷移パラメータチェック
      assert(!@request.session.nil?, 'CASE:2-04-02-11')
      valid_state('regulation_host_list/regulation_host_list', 1, nil, true, 'CASE:2-04-02-12')
      # エラーメッセージ判定
      err_hash = assigns(:err_hash)
#      print_log('err_hash:' + err_hash.to_s)
      assert(err_hash.size == 1, 'CASE:2-04-02-13')
      #########################################################################
      # 入力フォーム確認
      #########################################################################
      # テンプレート確認
      assert_template('list', 'CASE:2-04-02-14')
      # システムIDコンボ
      valid_system_id('CASE:2-04-02-12')
      assert_select('#sverr_system_id[value="システム名 は不正な値です。"]', true, 'CASE:2-04-02-15')
      # 備考テキストボックス
      assert_select('#regulation_host_remarks[value="MyString12"]', true, 'CASE:2-04-02-16')
      # プロキシホストテキストボックス
      assert_select('#regulation_host_proxy_host[value="^proxy12\.ne\.jp$"]', true, 'CASE:2-04-02-17')
      # プロキシIPテキストボックス
      assert_select('#regulation_host_proxy_ip_address[value="192.168.254.12"]', true, 'CASE:2-04-02-18')
      # クライアントホストテキストボックス
      assert_select('#regulation_host_remote_host[value="^client12\.ne\.jp$"]', true, 'CASE:2-04-02-19')
      # クライアントIPテキストボックス
      assert_select('#regulation_host_ip_address[value="192.168.255.12"]', true, 'CASE:2-04-02-20')
      # ソート項目コンボ
      valid_sort_item('CASE:2-04-02-21', 'system_id')
      # ソート順序
      valid_sort_order('CASE:2-04-02-22', 'ASC')
      # 表示件数
      valid_disp_counts('CASE:2-04-02-23', '500')
      # セッション取得
      state_hash = session[:function_state_hash]
      state = state_hash[1]
      # 入力フォームの画面遷移パラメータチェック
      selector = '#input_form[action="/regulation_host_list/regulation_host_list/list"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-02-24')
      # ボタンの有無チェック
      assert_select('#input_form input[value="検索"]', true, 'CASE:2-04-02-25')
      assert_select('#input_form input[value="登録"]', true, 'CASE:2-04-02-26')
      assert_select('#input_form input[value="通知"]', true, 'CASE:2-04-02-27')
      #########################################################################
      # 削除フォーム確認
      #########################################################################
      # 画面遷移パラメータチェック
      selector = '#delete_form[action="/regulation_host_list/regulation_host_list/delete"]'
      valid_scr_param(selector, state, 3, nil, 'CASE:2-04-02-28')
      # HIDDEN項目のチェック
      assert_select('#delete_form input[value=""]', 1, 'CASE:2-04-02-29')
      # ボタンの有無チェック
      assert_select('#delete_form input[value="削"]', 11, 'CASE:2-04-02-30')
      #########################################################################
      # 一覧確認
      #########################################################################
      # 明細件数
      reg_host_list = assigns[:reg_host_list]
      assert(reg_host_list.size == 11, 'CASE:2-04-02-31')
      # 明細チェック
      idx = 1
      reg_host_list.each do |ent|
        valid_details(idx, ent, 'CASE:2-04-02-32')
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
    valid_combo('#regulation_host_system_id', combo_hash, err_msg, selected_val)
  end
  
  # ソート項目コンボチェック
  def valid_sort_item(err_msg, selected_val=nil)
    combo_hash = Hash.new
    combo_hash['システム名'] = 'system_id'
    combo_hash['プロキシホスト'] = 'proxy_host'
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
    assert_select(head + '>td:nth-of-type(3) font', ent.proxy_host, err_msg)
    assert_select(head + '>td:nth-of-type(4) font', ent.proxy_ip_address, err_msg)
    assert_select(head + '>td:nth-of-type(5) font', ent.remote_host, err_msg)
    assert_select(head + '>td:nth-of-type(6) font', ent.ip_address, err_msg)
    assert_select(head + '>td:nth-of-type(7) font', ent.remarks, err_msg)
  end
end
