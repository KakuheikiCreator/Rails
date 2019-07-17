# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：リクエストパーサー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/04 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/mock/mock_request'
require 'function_state/function_state'
require 'data_cache/request_analysis_result_cache'
require 'data_cache/system_cache'
require 'filter/request_analysis/analysis_parameters'
require 'filter/request_analysis/session_info_setter'
require 'filter/request_analysis/request_parser'
require 'unit/unit_test_util'

class RequestParserTest < ActiveSupport::TestCase
  include Mock
  include DataCache
  include FunctionState
  include Filter::RequestAnalysis
  include UnitTestUtil
  
  # 前処理
  def setup
    SystemCache.instance.data_load
  end

  # テスト対象メソッド：execute
  test "CASE:2-1 execute" do
    ###########################################################################
    # 正常ケース
    # 初期処理：初回切り替え有り
    # セッター：初回切り替え有り、全セッター
    # 解析情報キャッシュ：新規追加
    ###########################################################################
    session_id  = 'dummy_session_id1'
    client_id = 'dummy_client_id1'
    client_host = 'nfmv001068144.uqw.ppp.infoweb.ne.jp'
    client_ip = '124.24.245.144'
    function_state = FunctionState.new(1, 2, nil)
    session = {:function_state=>function_state,
               :session_id=>session_id,
               :client_id=>client_id}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['HTTP_USER_AGENT'] = 'Mozilla/4.0 (compatible; MSIE 4.01; Windows NT)'
    controller.request.headers['Accept-Language'] = 'ja'
    controller.request.headers['REMOTE_HOST'] = client_host
    controller.request.headers['REMOTE_ADDR'] = client_ip
    received_time = Time.now
    RequestParser.instance.parse(controller)
    sleep(3)
    RequestAnalysisResultCache.instance.eject_all
    sleep(5)
    setting = RequestAnalysisSchedule.find(6)
#    setting = RequestAnalysisSchedule.where(:gets_start_date=>'2012-01-04 00:00:00', :system_id=>1)
#    RequestAnalysisResult.all.each do |ent|
#      print_log("id:" + ent.id.to_s)
#      print_log("schedule_id:" + ent.request_analysis_schedule_id.to_s)
#    end
#    print_log("size:" + setting.request_analysis_result.size.to_s)
    analysis_info = setting.request_analysis_result[0]
    assert(analysis_info.system_id == 1, "CASE:2-2-17-1")
    assert(analysis_info.request_analysis_schedule_id == 6, "CASE:2-2-17-2")
    assert(analysis_info.received_year == received_time.year, "CASE:2-2-15")
    assert(analysis_info.received_month == received_time.month, "CASE:2-2-15")
    assert(analysis_info.received_day == received_time.day, "CASE:2-2-15")
    assert(analysis_info.received_hour == received_time.hour, "CASE:2-2-15")
    assert(analysis_info.received_minute == received_time.min, "CASE:2-2-15")
#    assert(analysis_info.received_second == received_time.sec, "CASE:2-2-15")
    assert(analysis_info.function_id == 3, "CASE:2-2-17-3")
    assert(analysis_info.function_transition_no == 2, "CASE:2-2-13")
    assert(analysis_info.session_id == session_id, "CASE:2-2-13")
    assert(analysis_info.client_id == client_id, "CASE:2-1-1,2-2-13")
    assert(analysis_info.browser_id == 1, "CASE:2-2-11")
    assert(analysis_info.browser_version_id == 1, "CASE:2-2-11")
    assert(analysis_info.accept_language == 'ja', "CASE:2-2-9")
    assert(analysis_info.domain_id == 6, "CASE:2-2-3")
    assert(analysis_info.remote_host == client_host, "CASE:2-2-5")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-5")
    assert(analysis_info.proxy_host.nil?, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address.nil?, "CASE:2-2-5")
    assert(analysis_info.request_count == 1, "CASE:2-2-17-4")
    ###########################################################################
    # 正常ケース
    # 初期処理：切り替え無し
    # セッター：切り替え無し、全セッター
    # 解析情報キャッシュ：新規追加
    ###########################################################################
    session_id  = 'dummy_session_id2'
    client_id = 'dummy_client_id2'
    client_host = 'nfmv001068144.uqw.ppp.infoweb.ne.jp'
    client_ip = '124.24.245.144'
    function_state = FunctionState.new(1, 2, nil)
    session = {:function_state=>function_state,
               :session_id=>session_id,
               :client_id=>client_id}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['HTTP_USER_AGENT'] = 'Mozilla/4.0 (compatible; MSIE 4.01; Windows NT)'
    controller.request.headers['Accept-Language'] = 'ja'
    controller.request.headers['REMOTE_HOST'] = client_host
    controller.request.headers['REMOTE_ADDR'] = client_ip
    received_time = Time.now
    RequestParser.instance.parse(controller)
    sleep(3)
    RequestAnalysisResultCache.instance.eject_all
    sleep(1)
    setting = RequestAnalysisSchedule.find(6)
#    print_log("size:" + setting.request_analysis_result.size.to_s)
    analysis_info = setting.request_analysis_result[1]
    assert(analysis_info.system_id == 1, "CASE:2-2-17-5")
    assert(analysis_info.request_analysis_schedule_id == 6, "CASE:2-2-17-6")
    assert(analysis_info.received_year == received_time.year, "CASE:2-2-15")
    assert(analysis_info.received_month == received_time.month, "CASE:2-2-15")
    assert(analysis_info.received_day == received_time.day, "CASE:2-2-15")
    assert(analysis_info.received_hour == received_time.hour, "CASE:2-2-15")
    assert(analysis_info.received_minute == received_time.min, "CASE:2-2-15")
#    assert(analysis_info.received_second == received_time.sec, "CASE:2-2-15")
    assert(analysis_info.function_id == 3, "CASE:2-2-17-7")
    assert(analysis_info.function_transition_no == 2, "CASE:2-2-13")
    assert(analysis_info.session_id == session_id, "CASE:2-2-13")
    assert(analysis_info.client_id == client_id, "CASE:2-1-1,2-2-13")
    assert(analysis_info.browser_id == 1, "CASE:2-2-11")
    assert(analysis_info.browser_version_id == 1, "CASE:2-2-11")
    assert(analysis_info.accept_language == 'ja', "CASE:2-2-9")
    assert(analysis_info.domain_id == 6, "CASE:2-2-3")
    assert(analysis_info.remote_host == client_host, "CASE:2-2-5")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-5")
    assert(analysis_info.proxy_host.nil?, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address.nil?, "CASE:2-2-5")
    assert(analysis_info.request_count == 1, "CASE:2-2-17-8")
    ###########################################################################
    # 正常ケース
    # 初期処理：切り替え有り
    # セッター：切り替え有り、全セッター使用しない
    # 解析情報キャッシュ：新規追加
    ###########################################################################
    # リクエスト解析スケジュール登録
    setting = RequestAnalysisSchedule.new
    setting.gets_start_date = Time.now
    setting.system_id  = 1
    setting.save
    RequestAnalysisScheduleCache.instance.data_load
    sleep(1)
    # テストデータリクエスト作成
    session_id  = 'dummy_session_id3'
    client_id = 'dummy_client_id3'
    client_host = 'nfmv001068144.uqw.ppp.infoweb.ne.jp'
    client_ip = '124.24.245.144'
    function_state = FunctionState.new(1, 2, nil)
    session = {:function_state=>function_state,
               :session_id=>session_id,
               :client_id=>client_id}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['HTTP_USER_AGENT'] = 'Mozilla/4.0 (compatible; MSIE 4.01; Windows NT)'
    controller.request.headers['Accept-Language'] = 'ja'
    controller.request.headers['REMOTE_HOST'] = client_host
    controller.request.headers['REMOTE_ADDR'] = client_ip
    # テスト実行
    received_time = Time.now
    RequestParser.instance.parse(controller)
    sleep(3)
    RequestAnalysisResultCache.instance.eject_all
    sleep(1)
#    print_log("size:" + setting.request_analysis_result.size.to_s)
#    print_log("ID:" + setting.id.to_s)
    analysis_info = setting.request_analysis_result[0]
    assert(analysis_info.system_id == 1, "CASE:2-2-17-9")
    assert(analysis_info.request_analysis_schedule_id == setting.id, "CASE:2-2-17-10")
    assert(analysis_info.received_year.nil?, "CASE:2-2-16")
    assert(analysis_info.received_month.nil?, "CASE:2-2-16")
    assert(analysis_info.received_day.nil?, "CASE:2-2-16")
    assert(analysis_info.received_hour.nil?, "CASE:2-2-16")
    assert(analysis_info.received_minute.nil?, "CASE:2-2-16")
#    assert(analysis_info.received_second == received_time.sec, "CASE:2-2-16")
    assert(analysis_info.function_id.nil?, "CASE:2-2-17-11")
    assert(analysis_info.function_transition_no.nil?, "CASE:2-2-14")
    assert(analysis_info.session_id.nil?, "CASE:2-3-11")
    assert(analysis_info.client_id.nil?, "CASE:2-1-2,2-2-13")
    assert(analysis_info.browser_id.nil?, "CASE:2-2-12")
    assert(analysis_info.browser_version_id.nil?, "CASE:2-2-12")
    assert(analysis_info.accept_language.nil?, "CASE:2-2-10")
    assert(analysis_info.domain_id.nil?, "CASE:2-2-4")
    assert(analysis_info.remote_host.nil?, "CASE:2-2-6")
    assert(analysis_info.ip_address.nil?, "CASE:2-2-6")
    assert(analysis_info.proxy_host.nil?, "CASE:2-2-6")
    assert(analysis_info.proxy_ip_address.nil?, "CASE:2-2-6")
    assert(analysis_info.request_count == 1, "CASE:2-2-17-12")
    ###########################################################################
    # 正常ケース：４
    # 初期処理：切り替え有り
    # セッター：切り替え有り、選択して使用
    # 解析情報キャッシュ：新規追加
    ###########################################################################
    # リクエスト解析スケジュール編集
    setting = RequestAnalysisSchedule.new
    setting.gets_start_date = Time.now
    setting.system_id  = 1
    # ホスト情報セッター
    setting.gs_proxy_host = true
    setting.gs_proxy_ip_address = false
    setting.gs_remote_host = false
    setting.gs_ip_address = false
    setting.gs_domain_id = false
    # ブラウザセッター
    setting.gs_browser_id = true
    setting.gs_browser_version_id = false
    # セッション情報セッター
    setting.gs_function_id = true
    setting.gs_function_transition_no = false
    setting.gs_session_id = false
    setting.gs_client_id = false
    # リクエスト解析スケジュール登録
    setting.save
    RequestAnalysisScheduleCache.instance.data_load
    sleep(1)
    # テストデータリクエスト作成
    session_id  = 'dummy_session_id3'
    client_id = 'dummy_client_id3'
    client_host = 'nfmv001068144.uqw.ppp.infoweb.ne.jp'
    client_ip = '124.24.245.144'
    proxy_host = 'proxy.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '124.24.245.145'
    function_state = FunctionState.new(1, 2, nil)
    session = {:function_state=>function_state,
               :session_id=>session_id,
               :client_id=>client_id}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['HTTP_USER_AGENT'] = 'Mozilla/4.0 (compatible; MSIE 4.01; Windows NT)'
    controller.request.headers['Accept-Language'] = 'ja'
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = client_host
    controller.request.headers['HTTP_CLIENT_IP'] = client_ip
    # テスト実行
    received_time = Time.now
    RequestParser.instance.parse(controller)
    sleep(3)
    RequestAnalysisResultCache.instance.eject_all
    sleep(1)
#    print_log("size:" + setting.request_analysis_result.size.to_s)
#    print_log("ID:" + setting.id.to_s)
    analysis_info = setting.request_analysis_result[0]
    assert(analysis_info.system_id == 1, "CASE:2-2-17")
    assert(analysis_info.request_analysis_schedule_id == setting.id, "CASE:2-2-17")
    assert(analysis_info.received_year.nil?, "CASE:2-2-16")
    assert(analysis_info.received_month.nil?, "CASE:2-2-16")
    assert(analysis_info.received_day.nil?, "CASE:2-2-16")
    assert(analysis_info.received_hour.nil?, "CASE:2-2-16")
    assert(analysis_info.received_minute.nil?, "CASE:2-2-16")
#    assert(analysis_info.received_second == received_time.sec, "CASE:2-2-16")
    assert(analysis_info.function_id == 3, "CASE:2-2-17")
    assert(analysis_info.function_transition_no.nil?, "CASE:2-2-14")
    assert(analysis_info.session_id.nil?, "CASE:2-4-11")
    assert(analysis_info.client_id.nil?, "CASE:2-1-2,2-2-13")
    assert(analysis_info.browser_id == 1, "CASE:2-2-11")
    assert(analysis_info.browser_version_id.nil?, "CASE:2-2-12")
    assert(analysis_info.accept_language.nil?, "CASE:2-2-10")
    assert(analysis_info.domain_id.nil?, "CASE:2-2-4")
    assert(analysis_info.remote_host.nil?, "CASE:2-2-6")
    assert(analysis_info.ip_address.nil?, "CASE:2-2-6")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-6")
    assert(analysis_info.proxy_ip_address.nil?, "CASE:2-2-6")
    assert(analysis_info.request_count == 1, "CASE:2-2-17")
     ###########################################################################
    # 正常ケース：５
    # 初期処理：切り替え有り
    # セッター：切り替え有り、選択して使用
    # 解析情報キャッシュ：新規追加
    ###########################################################################
    # リクエスト解析スケジュール編集
    setting = RequestAnalysisSchedule.new
    setting.gets_start_date = Time.now
    setting.system_id  = 1
    # ホスト情報セッター
    setting.gs_proxy_host = false
    setting.gs_proxy_ip_address = true
    setting.gs_remote_host = false
    setting.gs_ip_address = false
    setting.gs_domain_id = false
    # ブラウザセッター
    setting.gs_browser_id = false
    setting.gs_browser_version_id = true
    # セッション情報セッター
    setting.gs_function_id = false
    setting.gs_function_transition_no = true
    setting.gs_session_id = false
    setting.gs_client_id = false
    # リクエスト解析スケジュール登録
    setting.save
    RequestAnalysisScheduleCache.instance.data_load
    sleep(1)
    # テストデータリクエスト作成
    session_id  = 'dummy_session_id3'
    client_id = 'dummy_client_id3'
    client_host = 'nfmv001068144.uqw.ppp.infoweb.ne.jp'
    client_ip = '124.24.245.144'
    proxy_host = 'proxy.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '124.24.245.145'
    function_state = FunctionState.new(1, 2, nil)
    session = {:function_state=>function_state,
               :session_id=>session_id,
               :client_id=>client_id}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['HTTP_USER_AGENT'] = 'Mozilla/4.0 (compatible; MSIE 4.01; Windows NT)'
    controller.request.headers['Accept-Language'] = 'ja'
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = client_host
    controller.request.headers['HTTP_CLIENT_IP'] = client_ip
    # テスト実行
    received_time = Time.now
    RequestParser.instance.parse(controller)
    sleep(3)
    RequestAnalysisResultCache.instance.eject_all
    sleep(1)
#    print_log("size:" + setting.request_analysis_result.size.to_s)
#    print_log("ID:" + setting.id.to_s)
    analysis_info = setting.request_analysis_result[0]
    assert(analysis_info.system_id == 1, "CASE:2-2-17")
    assert(analysis_info.request_analysis_schedule_id == setting.id, "CASE:2-2-17")
    assert(analysis_info.received_year.nil?, "CASE:2-2-16")
    assert(analysis_info.received_month.nil?, "CASE:2-2-16")
    assert(analysis_info.received_day.nil?, "CASE:2-2-16")
    assert(analysis_info.received_hour.nil?, "CASE:2-2-16")
    assert(analysis_info.received_minute.nil?, "CASE:2-2-16")
#    assert(analysis_info.received_second == received_time.sec, "CASE:2-2-16")
    assert(analysis_info.function_id.nil?, "CASE:2-2-17")
    assert(analysis_info.function_transition_no == 2, "CASE:2-2-14")
    assert(analysis_info.session_id.nil?, "CASE:2-2-14")
    assert(analysis_info.client_id.nil?, "CASE:2-1-2,2-2-14")
    assert(analysis_info.browser_id.nil?, "CASE:2-2-12")
    assert(analysis_info.browser_version_id == 1, "CASE:2-2-12")
    assert(analysis_info.accept_language.nil?, "CASE:2-2-10")
    assert(analysis_info.domain_id.nil?, "CASE:2-2-4")
    assert(analysis_info.remote_host.nil?, "CASE:2-2-6")
    assert(analysis_info.ip_address.nil?, "CASE:2-2-6")
    assert(analysis_info.proxy_host.nil?, "CASE:2-2-6")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-5")
    assert(analysis_info.request_count == 1, "CASE:2-2-17")
     ###########################################################################
    # 正常ケース：６
    # 初期処理：切り替え有り
    # セッター：切り替え有り、選択して使用
    # 解析情報キャッシュ：新規追加
    ###########################################################################
    # リクエスト解析スケジュール編集
    setting = RequestAnalysisSchedule.new
    setting.gets_start_date = Time.now
    setting.system_id  = 1
    # ホスト情報セッター
    setting.gs_proxy_host = false
    setting.gs_proxy_ip_address = false
    setting.gs_remote_host = true
    setting.gs_ip_address = false
    setting.gs_domain_id = false
    # ブラウザセッター
    setting.gs_browser_id = false
    setting.gs_browser_version_id = false
    # セッション情報セッター
    setting.gs_function_id = false
    setting.gs_function_transition_no = false
    setting.gs_session_id = true
    setting.gs_client_id = false
    # リクエスト解析スケジュール登録
    setting.save
    RequestAnalysisScheduleCache.instance.data_load
    sleep(1)
    # テストデータリクエスト作成
    session_id  = 'dummy_session_id3'
    client_id = 'dummy_client_id3'
    client_host = 'nfmv001068144.uqw.ppp.infoweb.ne.jp'
    client_ip = '124.24.245.144'
    proxy_host = 'proxy.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '124.24.245.145'
    function_state = FunctionState.new(1, 2, nil)
    session = {:function_state=>function_state,
               :session_id=>session_id,
               :client_id=>client_id}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['HTTP_USER_AGENT'] = 'Mozilla/4.0 (compatible; MSIE 4.01; Windows NT)'
    controller.request.headers['Accept-Language'] = 'ja'
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = client_host
    controller.request.headers['HTTP_CLIENT_IP'] = client_ip
    # テスト実行
    received_time = Time.now
    RequestParser.instance.parse(controller)
    sleep(3)
    RequestAnalysisResultCache.instance.eject_all
    sleep(1)
#    print_log("size:" + setting.request_analysis_result.size.to_s)
#    print_log("ID:" + setting.id.to_s)
    analysis_info = setting.request_analysis_result[0]
    assert(analysis_info.system_id == 1, "CASE:2-2-17")
    assert(analysis_info.request_analysis_schedule_id == setting.id, "CASE:2-2-17")
    assert(analysis_info.received_year.nil?, "CASE:2-2-16")
    assert(analysis_info.received_month.nil?, "CASE:2-2-16")
    assert(analysis_info.received_day.nil?, "CASE:2-2-16")
    assert(analysis_info.received_hour.nil?, "CASE:2-2-16")
    assert(analysis_info.received_minute.nil?, "CASE:2-2-16")
#    assert(analysis_info.received_second == received_time.sec, "CASE:2-2-16")
    assert(analysis_info.function_id.nil?, "CASE:2-2-14")
    assert(analysis_info.function_transition_no.nil?, "CASE:2-2-14")
    assert(analysis_info.session_id == session_id, "CASE:2-2-13")
    assert(analysis_info.client_id.nil?, "CASE:2-1-2,2-2-14")
    assert(analysis_info.browser_id.nil?, "CASE:2-2-12")
    assert(analysis_info.browser_version_id.nil?, "CASE:2-2-12")
    assert(analysis_info.accept_language.nil?, "CASE:2-2-10")
    assert(analysis_info.domain_id.nil?, "CASE:2-2-4")
    assert(analysis_info.remote_host == client_host, "CASE:2-2-5")
    assert(analysis_info.ip_address.nil?, "CASE:2-2-6")
    assert(analysis_info.proxy_host.nil?, "CASE:2-2-6")
    assert(analysis_info.proxy_ip_address.nil?, "CASE:2-2-6")
    assert(analysis_info.request_count == 1, "CASE:2-2-17")
    ###########################################################################
    # 正常ケース：７
    # 初期処理：切り替え有り
    # セッター：切り替え有り、選択して使用
    # 解析情報キャッシュ：新規追加
    ###########################################################################
    # リクエスト解析スケジュール編集
    setting = RequestAnalysisSchedule.new
    setting.gets_start_date = Time.now
    setting.system_id  = 1
    # ホスト情報セッター
    setting.gs_proxy_host = false
    setting.gs_proxy_ip_address = false
    setting.gs_remote_host = false
    setting.gs_ip_address = true
    setting.gs_domain_id = false
    # ブラウザセッター
    setting.gs_browser_id = false
    setting.gs_browser_version_id = false
    # セッション情報セッター
    setting.gs_function_id = false
    setting.gs_function_transition_no = false
    setting.gs_session_id = false
    setting.gs_client_id = true
    # リクエスト解析スケジュール登録
    setting.save
    RequestAnalysisScheduleCache.instance.data_load
    sleep(1)
    # テストデータリクエスト作成
    session_id  = 'dummy_session_id3'
    client_id = 'dummy_client_id3'
    client_host = 'nfmv001068144.uqw.ppp.infoweb.ne.jp'
    client_ip = '124.24.245.144'
    proxy_host = 'proxy.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '124.24.245.145'
    function_state = FunctionState.new(1, 2, nil)
    session = {:function_state=>function_state,
               :session_id=>session_id,
               :client_id=>client_id}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['HTTP_USER_AGENT'] = 'Mozilla/4.0 (compatible; MSIE 4.01; Windows NT)'
    controller.request.headers['Accept-Language'] = 'ja'
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = client_host
    controller.request.headers['HTTP_CLIENT_IP'] = client_ip
    # テスト実行
    received_time = Time.now
    RequestParser.instance.parse(controller)
    sleep(3)
    RequestAnalysisResultCache.instance.eject_all
    sleep(1)
#    print_log("size:" + setting.request_analysis_result.size.to_s)
#    print_log("ID:" + setting.id.to_s)
    analysis_info = setting.request_analysis_result[0]
    assert(analysis_info.system_id == 1, "CASE:2-2-17")
    assert(analysis_info.request_analysis_schedule_id == setting.id, "CASE:2-2-17")
    assert(analysis_info.received_year.nil?, "CASE:2-2-16")
    assert(analysis_info.received_month.nil?, "CASE:2-2-16")
    assert(analysis_info.received_day.nil?, "CASE:2-2-16")
    assert(analysis_info.received_hour.nil?, "CASE:2-2-16")
    assert(analysis_info.received_minute.nil?, "CASE:2-2-16")
#    assert(analysis_info.received_second == received_time.sec, "CASE:2-2-16")
    assert(analysis_info.function_id.nil?, "CASE:2-2-17")
    assert(analysis_info.function_transition_no.nil?, "CASE:2-2-13")
    assert(analysis_info.session_id.nil?, "CASE:2-2-13")
    assert(analysis_info.client_id == client_id, "CASE:2-1-1,2-2-13")
    assert(analysis_info.browser_id.nil?, "CASE:2-2-12")
    assert(analysis_info.browser_version_id.nil?, "CASE:2-2-12")
    assert(analysis_info.accept_language.nil?, "CASE:2-2-10")
    assert(analysis_info.domain_id.nil?, "CASE:2-2-3")
    assert(analysis_info.remote_host.nil?, "CASE:2-2-6")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-5")
    assert(analysis_info.proxy_host.nil?, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address.nil?, "CASE:2-2-5")
    assert(analysis_info.request_count == 1, "CASE:2-2-17")
    ###########################################################################
    # 正常ケース：８
    # 初期処理：切り替え有り
    # セッター：切り替え有り、選択して使用
    # 解析情報キャッシュ：新規追加
    ###########################################################################
    # リクエスト解析スケジュール編集
    setting = RequestAnalysisSchedule.new
    setting.gets_start_date = Time.now
    setting.system_id  = 1
    # ホスト情報セッター
    setting.gs_proxy_host = false
    setting.gs_proxy_ip_address = false
    setting.gs_remote_host = false
    setting.gs_ip_address = false
    setting.gs_domain_id = true
    # ブラウザセッター
    setting.gs_browser_id = false
    setting.gs_browser_version_id = false
    # セッション情報セッター
    setting.gs_function_id = false
    setting.gs_function_transition_no = false
    setting.gs_session_id = false
    setting.gs_client_id = true
    # リクエスト解析スケジュール登録
    setting.save
    RequestAnalysisScheduleCache.instance.data_load
    sleep(1)
    # テストデータリクエスト作成
    session_id  = 'dummy_session_id3'
    client_id = 'dummy_client_id3'
    client_host = 'nfmv001068144.uqw.ppp.infoweb.ne.jp'
    client_ip = '124.24.245.144'
    proxy_host = 'proxy.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '124.24.245.145'
    function_state = FunctionState.new(1, 2, nil)
    session = {:function_state=>function_state,
               :session_id=>session_id,
               :client_id=>client_id}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['HTTP_USER_AGENT'] = 'Mozilla/4.0 (compatible; MSIE 4.01; Windows NT)'
    controller.request.headers['Accept-Language'] = 'ja'
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = client_host
    controller.request.headers['HTTP_CLIENT_IP'] = client_ip
    # テスト実行
    received_time = Time.now
    RequestParser.instance.parse(controller)
    sleep(3)
    RequestAnalysisResultCache.instance.eject_all
    sleep(1)
#    print_log("size:" + setting.request_analysis_result.size.to_s)
#    print_log("ID:" + setting.id.to_s)
    analysis_info = setting.request_analysis_result[0]
    assert(analysis_info.system_id == 1, "CASE:2-2-17")
    assert(analysis_info.request_analysis_schedule_id == setting.id, "CASE:2-2-17")
    assert(analysis_info.received_year.nil?, "CASE:2-2-16")
    assert(analysis_info.received_month.nil?, "CASE:2-2-16")
    assert(analysis_info.received_day.nil?, "CASE:2-2-16")
    assert(analysis_info.received_hour.nil?, "CASE:2-2-16")
    assert(analysis_info.received_minute.nil?, "CASE:2-2-16")
#    assert(analysis_info.received_second == received_time.sec, "CASE:2-2-16")
    assert(analysis_info.function_id.nil?, "CASE:2-2-14")
    assert(analysis_info.function_transition_no.nil?, "CASE:2-2-13")
    assert(analysis_info.session_id.nil?, "CASE:2-2-13")
    assert(analysis_info.client_id == client_id, "CASE:2-1-1,2-2-13")
    assert(analysis_info.browser_id.nil?, "CASE:2-2-12")
    assert(analysis_info.browser_version_id.nil?, "CASE:2-2-12")
    assert(analysis_info.accept_language.nil?, "CASE:2-2-10")
    assert(analysis_info.domain_id == 6, "CASE:2-2-3")
    assert(analysis_info.remote_host.nil?, "CASE:2-2-6")
    assert(analysis_info.ip_address.nil?, "CASE:2-2-6")
    assert(analysis_info.proxy_host.nil?, "CASE:2-2-6")
    assert(analysis_info.proxy_ip_address.nil?, "CASE:2-2-6")
    assert(analysis_info.request_count == 1, "CASE:2-2-17")
    # 
    ###########################################################################
    # 異常ケース：１
    # 引数不正
    ###########################################################################
    # テスト実行
    begin
      RequestParser.instance.parse("error test")
    rescue => ex
      assert(ArgumentError === ex, "CASE:2-9-1")
      assert(ex.message == 'invalid argument', "CASE:2-9-2")
    end
  end
end