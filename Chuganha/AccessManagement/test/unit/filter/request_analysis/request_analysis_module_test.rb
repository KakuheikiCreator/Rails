# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：リクエスト解析モジュール
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/07 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/mock/mock_request'
require 'data_cache/system_cache'
require 'function_state/function_state'
require 'data_cache/request_analysis_result_cache'
require 'filter/request_analysis/analysis_parameters'
require 'filter/request_analysis/session_info_setter'
require 'filter/request_analysis/request_analysis_module'
require 'unit/unit_test_util'

class RequestAnalysisTest < ActiveSupport::TestCase
  include Mock
  include DataCache
  include FunctionState
  include Filter::RequestAnalysis
  include UnitTestUtil

  # 前処理
  def setup
    # 設定情報ロード
    @business_config = Business::BizCommon::BusinessConfig.instance
    SystemCache.instance.data_load
  end
  # 後処理
  def teardown
  end

  # テスト対象メソッド：execute
  test "CASE:2-1 execute" do
    ###########################################################################
    # 正常ケース
    # 初期処理：初回切り替え有り
    # セッター：初回切り替え有り、全セッター
    # 解析情報キャッシュ：新規追加
    ###########################################################################
    login_id  = 'dummy_login_id1'
    client_id = 'dummy_client_id1'
    client_host = 'nfmv001068144.uqw.ppp.infoweb.ne.jp'
    client_ip = '124.24.245.144'
    function_state = FunctionState.new(1, 2, nil)
    session = {:function_state=>function_state,
               :login_id=>login_id,
               :client_id=>client_id}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = TestController.new(mock_params)
    controller.request.headers['HTTP_USER_AGENT'] = 'Mozilla/4.0 (compatible; MSIE 4.01; Windows NT)'
    controller.request.headers['Accept-Language'] = 'ja'
    controller.request.headers['REMOTE_HOST'] = client_host
    controller.request.headers['REMOTE_ADDR'] = client_ip
    received_time = Time.now
    controller.request_analysis
    sleep(3)
    RequestAnalysisResultCache.instance.eject_all
    sleep(3)
    setting = RequestAnalysisSchedule.find(6)
#    print_log("size:" + setting.request_analysis_result.size.to_s)
    analysis_info = setting.request_analysis_result[0]
    assert(analysis_info.system_id == 1, "CASE:2-1-1")
    assert(analysis_info.request_analysis_schedule_id == 6, "CASE:2-1-2")
    assert(analysis_info.received_year == received_time.year, "CASE:2-1-3")
    assert(analysis_info.received_month == received_time.month, "CASE:2-1-4")
    assert(analysis_info.received_day == received_time.day, "CASE:2-1-5")
    assert(analysis_info.received_hour == received_time.hour, "CASE:2-1-6")
    assert(analysis_info.received_minute == received_time.min, "CASE:2-1-7")
#    assert(analysis_info.received_second == received_time.sec, "CASE:2-1-8")
    assert(analysis_info.function_id == 3, "CASE:2-1-9")
    assert(analysis_info.function_transition_no == 2, "CASE:2-1-10")
    assert(analysis_info.login_id == login_id, "CASE:2-1-11")
    assert(analysis_info.client_id == client_id, "CASE:2-1-12")
    assert(analysis_info.browser_id == 1, "CASE:2-1-13")
    assert(analysis_info.browser_version_id == 1, "CASE:2-1-14")
    assert(analysis_info.accept_language == 'ja', "CASE:2-1-15")
    assert(analysis_info.domain_id == 6, "CASE:2-1-16")
    assert(analysis_info.remote_host == client_host, "CASE:2-1-17")
    assert(analysis_info.ip_address == client_ip, "CASE:2-1-18")
    assert(analysis_info.proxy_host.nil?, "CASE:2-1-19")
    assert(analysis_info.proxy_ip_address.nil?, "CASE:2-1-20")
    assert(analysis_info.request_count == 1, "CASE:2-1-21")
    # 異常ケースなし
  end
  # テストコントローラ
  class TestController < MockController
    include Filter::RequestAnalysis::RequestAnalysisModule
  end
end