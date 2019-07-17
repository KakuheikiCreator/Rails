# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：NULLセッター
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/04 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/mock/mock_request'
require 'data_cache/system_cache'
require 'function_state/function_state'
require 'filter/request_analysis/analysis_parameters'
require 'filter/request_analysis/null_setter'
require 'filter/request_analysis/termination_setter'

class NullSetterTest < ActiveSupport::TestCase
  include Mock
  include DataCache
  include FunctionState
  include Filter::RequestAnalysis

  # 前処理
  def setup
    # 設定情報ロード
#    @business_config = Business::BizCommon::BusinessConfig.instance
    SystemCache.instance.data_load
  end
  # 後処理
  def teardown
  end

  # テスト対象メソッド：execute
  test "CASE:2-1 execute" do
    ###########################################################################
    # 正常ケースその１（全項目クリア）
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    params = AnalysisParameters.new(controller)
    analysis_info = params.request_analysis_result
    setAnalysisInfo(analysis_info)
    # 設定情報
    setting_info = RequestAnalysisSchedule.new
    setting_info.gs_received_year           = false # 受信年のクリア
    setting_info.gs_received_month          = false # 受信月のクリア
    setting_info.gs_received_day            = false # 受信日のクリア
    setting_info.gs_received_hour           = false # 受信時のクリア
    setting_info.gs_received_minute         = false # 受信分のクリア
    setting_info.gs_received_second         = false # 受信秒のクリア
    setting_info.gs_function_id        = false # 機能IDのクリア
    setting_info.gs_function_transition_no  = false # 機能遷移番号のクリア
    setting_info.gs_session_id                = false # セッションIDのクリア
    setting_info.gs_client_id               = false # クライアントIDのクリア
    setting_info.gs_browser_id         = false # ブラウザIDのクリア
    setting_info.gs_browser_version_id = false # ブラウザバージョンIDのクリア
    setting_info.gs_accept_language         = false # 言語のクリア
    setting_info.gs_referrer                = false # リファラーのクリア
    setting_info.gs_domain_id          = false # ドメインIDのクリア
    setting_info.gs_proxy_host              = false # リモートホスト（プロキシ）のクリア
    setting_info.gs_proxy_ip_address        = false # IPアドレス（プロキシ）のクリア
    setting_info.gs_remote_host             = false # リモートホスト（クライアント）のクリア
    setting_info.gs_ip_address              = false # IPアドレス（クライアント）のクリア
    terminator = TerminationSetter.new(setting_info, nil)
    # テスト実行
    NullSetter.new(setting_info, terminator).execute(params)
    # 結果検証
    assert(analysis_info[:received_year].nil?, "CASE:2-1-1")
    assert(analysis_info[:received_month].nil?, "CASE:2-1-3")
    assert(analysis_info[:received_day].nil?, "CASE:2-1-5")
    assert(analysis_info[:received_hour].nil?, "CASE:2-1-7")
    assert(analysis_info[:received_minute].nil?, "CASE:2-1-9")
    assert(analysis_info[:received_second].nil?, "CASE:2-1-11")
    assert(analysis_info[:function_id].nil?, "CASE:2-1-13")
    assert(analysis_info[:function_transition_no].nil?, "CASE:2-1-15")
    assert(analysis_info[:session_id].nil?, "CASE:2-1-17")
    assert(analysis_info[:client_id].nil?, "CASE:2-1-18")
    assert(analysis_info[:browser_id].nil?, "CASE:2-1-20")
    assert(analysis_info[:browser_version_id].nil?, "CASE:2-1-22")
    assert(analysis_info[:accept_language].nil?, "CASE:2-1-24")
    assert(analysis_info[:referrer].nil?, "CASE:2-1-26")
    assert(analysis_info[:domain_id].nil?, "CASE:2-1-28")
    assert(analysis_info[:proxy_host].nil?, "CASE:2-1-30")
    assert(analysis_info[:proxy_ip_address].nil?, "CASE:2-1-32")
    assert(analysis_info[:remote_host].nil?, "CASE:2-1-34")
    assert(analysis_info[:ip_address].nil?, "CASE:2-1-36")
    ###########################################################################
    # 正常ケースその１（全項目未クリア）
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    params = AnalysisParameters.new(controller)
    analysis_info = params.request_analysis_result
    setAnalysisInfo(analysis_info)
    # 設定情報
    setting_info = RequestAnalysisSchedule.new
    setting_info.gs_received_year           = true # 受信年のクリア
    setting_info.gs_received_month          = true # 受信月のクリア
    setting_info.gs_received_day            = true # 受信日のクリア
    setting_info.gs_received_hour           = true # 受信時のクリア
    setting_info.gs_received_minute         = true # 受信分のクリア
    setting_info.gs_received_second         = true # 受信秒のクリア
    setting_info.gs_function_id        = true # 機能IDのクリア
    setting_info.gs_function_transition_no  = true # 機能遷移番号のクリア
    setting_info.gs_session_id              = true # セッションIDのクリア
    setting_info.gs_client_id               = true # クライアントIDのクリア
    setting_info.gs_browser_id         = true # ブラウザIDのクリア
    setting_info.gs_browser_version_id = true # ブラウザバージョンIDのクリア
    setting_info.gs_accept_language         = true # 言語のクリア
    setting_info.gs_referrer                = true # リファラーのクリア
    setting_info.gs_domain_id          = true # ドメインIDのクリア
    setting_info.gs_proxy_host              = true # リモートホスト（プロキシ）のクリア
    setting_info.gs_proxy_ip_address        = true # IPアドレス（プロキシ）のクリア
    setting_info.gs_remote_host             = true # リモートホスト（クライアント）のクリア
    setting_info.gs_ip_address              = true # IPアドレス（クライアント）のクリア
    terminator = TerminationSetter.new(setting_info, nil)
    # テスト実行
    NullSetter.new(setting_info, terminator).execute(params)
    # 結果検証
    assert(analysis_info[:received_year] == 2012, "CASE:2-2-2")
    assert(analysis_info[:received_month] == 1, "CASE:2-2-4")
    assert(analysis_info[:received_day] == 4, "CASE:2-2-6")
    assert(analysis_info[:received_hour] == 10, "CASE:2-2-8")
    assert(analysis_info[:received_minute] == 31, "CASE:2-2-10")
    assert(analysis_info[:received_second] == 30, "CASE:2-2-12")
    assert(analysis_info[:function_id] == 1, "CASE:2-2-14")
    assert(analysis_info[:function_transition_no] == 2, "CASE:2-2-16")
    assert(analysis_info[:session_id] == 'dummy.session.id', "CASE:2-2-18")
    assert(analysis_info[:client_id] == 'dummy.client_id', "CASE:2-2-20")
    assert(analysis_info[:browser_id] == 10, "CASE:2-2-22")
    assert(analysis_info[:browser_version_id] == 20, "CASE:2-2-24")
    assert(analysis_info[:accept_language] == 'ja', "CASE:2-2-26")
    assert(analysis_info[:referrer] == 'http:///www.dummy.com', "CASE:2-2-28")
    assert(analysis_info[:domain_id] == 30, "CASE:2-2-30")
    assert(analysis_info[:proxy_host] == "dummy.proxy.name", "CASE:2-2-32")
    assert(analysis_info[:proxy_ip_address]== '192.168.10.20', "CASE:2-2-34")
    assert(analysis_info[:remote_host] == "dummy.host.name", "CASE:2-2-36")
    assert(analysis_info[:ip_address] == '192.168.10.30', "CASE:2-2-38")
    # 異常ケースなし
  end
  
  def setAnalysisInfo(analysis_info)
    # 受信年
    analysis_info[:received_year] = 2012
    # 受信月
    analysis_info[:received_month] = 1
    # 受信日
    analysis_info[:received_day] = 4
    # 受信時
    analysis_info[:received_hour] = 10
    # 受信分
    analysis_info[:received_minute] = 31
    # 受信秒
    analysis_info[:received_second] = 30
    # 機能ID
    analysis_info[:function_id] = 1
    # 機能遷移番号
    analysis_info[:function_transition_no] = 2
    # セッションID
    analysis_info[:session_id] = 'dummy.session.id'
    # クライアントID
    analysis_info[:client_id] = 'dummy.client_id'
    # ブラウザID
    analysis_info[:browser_id] = 10
    # ブラウザバージョンID
    analysis_info[:browser_version_id] = 20
    # 言語
    analysis_info[:accept_language] = "ja"
    # リファラー
    analysis_info[:referrer] = 'http:///www.dummy.com'
    # ドメインID
    analysis_info[:domain_id] = 30
    # リモートホスト（プロキシ）
    analysis_info[:proxy_host] = "dummy.proxy.name"
    # IPアドレス（プロキシ）
    analysis_info[:proxy_ip_address] = '192.168.10.20'
    # リモートホスト（クライアント）
    analysis_info[:remote_host] = "dummy.host.name"
    # IPアドレス（クライアント）
    analysis_info[:ip_address] = '192.168.10.30'
  end
end