# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ホスト情報セッター
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/04 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/mock/mock_request'
require 'common/net_util_module'
require 'data_cache/system_cache'
require 'function_state/function_state'
require 'filter/request_analysis/analysis_parameters'
require 'filter/request_analysis/host_info_setter'
require 'filter/request_analysis/termination_setter'

class HostInfoSetterTest < ActiveSupport::TestCase
  include Mock
  include DataCache
  include Common::NetUtilModule
  include FunctionState
  include Filter::RequestAnalysis

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
    # テストパラメータ
#    client_host = 'nfmv001122041.uqw.ppp.infoweb.ne.jp'
    client_host = 'nfmv001012086.uqw.ppp.infoweb.ne.jp'
#    client_ip = '222.158.185.41'
    client_ip = '175.179.198.86'
#    client_ip_0x = 'DE9EB929'
    client_ip_0x = 'AFB3C656'
    proxy_host = 'proxy001066096.uqw.ppp.infoweb.ne.jp'
    proxy_ip = '192.168.254.10'
    ###########################################################################
    # 正常ケース（プロキシ不使用）
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['REMOTE_HOST'] = client_host
    controller.request.headers['REMOTE_ADDR'] = client_ip
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host == client_host, "CASE:2-1-1")
    assert(analysis_info.ip_address == client_ip, "CASE:2-1-3")
    assert(analysis_info.proxy_host.nil?, "CASE:2-1-5")
    assert(analysis_info.proxy_ip_address.nil?, "CASE:2-1-6")
    ###########################################################################
    # 正常ケース（プロキシ不使用）
    # ホスト情報：無し
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['REMOTE_HOST'] = nil
    controller.request.headers['REMOTE_ADDR'] = nil
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host.nil?, "CASE:2-1-2")
    assert(analysis_info.ip_address.nil?, "CASE:2-1-4")
    assert(analysis_info.proxy_host.nil?, "CASE:2-1-5")
    assert(analysis_info.proxy_ip_address.nil?, "CASE:2-1-6")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース１）
    # リモートホスト逆引き:しない
    # クライアントIP逆引き：しない
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = client_host
    controller.request.headers['HTTP_CLIENT_IP'] = client_ip
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host == client_host, "CASE:2-2-1")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-3")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-7")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース２）
    # リモートホスト逆引き:逆引き不可能
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = nil
    controller.request.headers['HTTP_CLIENT_IP'] = nil
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host.nil?, "CASE:2-2-2")
    assert(analysis_info.ip_address.nil?, "CASE:2-2-4")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-7")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース３）
    # リモートホスト逆引き:逆引き可能
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_CACHE_CONTROL'] = 'max-stale=xxxx'
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = nil
    controller.request.headers['HTTP_CLIENT_IP'] = client_ip
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host == client_host, "CASE:2-2-1")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-3")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-7")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース４）
    # リモートホスト逆引き:逆引き可能
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_IF_MODIFIED_SINCE'] = '2012:01:04 09:51:00'
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = nil
    controller.request.headers['HTTP_CLIENTIP'] = client_ip
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host == client_host, "CASE:2-2-1")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-3")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-7")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース５）
    # リモートホスト逆引き:逆引き可能
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_CLIENT_IP'] = client_ip
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = nil
    controller.request.headers['HTTP_FORWARDED'] = client_ip
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host == client_host, "CASE:2-2-1")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-3")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-7")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース６）
    # リモートホスト逆引き:逆引き可能（16進数表現）
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_CLIENTIP'] = client_ip
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = nil
    controller.request.headers['HTTP_FROM'] = client_ip_0x
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host == client_host, "CASE:2-2-1")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-3")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-7")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース７）
    # リモートホスト逆引き:逆引き可能（16進数表現）
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_FORWARDED'] = client_ip_0x
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = nil
    controller.request.headers['HTTP_VIA'] = client_ip_0x
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
#    print("Origin Client Host:" + get_hostname('0.16.102.9').to_s + "\n")
#    print("Client Host:" + analysis_info.remote_host.to_s + "\n")
#    print("Origin Client IP:" + extract_ip_0x(client_ip_0x).to_s + "\n")
#    print("Client IP:" + analysis_info.ip_address.to_s + "\n")
    assert(analysis_info.remote_host == client_host, "CASE:2-2-1")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-3")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-7")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース８）
    # リモートホスト逆引き:逆引き可能
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_FROM'] = client_ip
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = nil
    controller.request.headers['HTTP_VIA'] = client_ip
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host == client_host, "CASE:2-2-1")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-3")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-7")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース９）
    # リモートホスト逆引き:逆引き可能
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_VIA'] = client_ip
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = nil
    controller.request.headers['HTTP_X_FORWARDED_FOR'] = client_ip
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host == client_host, "CASE:2-2-1")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-3")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-7")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース１０）
    # リモートホスト逆引き:逆引き可能
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_X_FORWARDED_FOR'] = client_ip
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = nil
    controller.request.headers['HTTP_X_LOCKING'] = client_ip
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host == client_host, "CASE:2-2-1")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-3")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-7")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース１１）
    # リモートホスト逆引き:逆引き可能
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_X_LOCKING'] = client_ip
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = nil
    controller.request.headers['HTTP_X_LOCKING'] = client_ip
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host == client_host, "CASE:2-2-1")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-3")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-7")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース１２）
    # クライアントIP逆引き
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = proxy_host
    controller.request.headers['REMOTE_ADDR'] = proxy_ip
    controller.request.headers['HTTP_IF_MODIFIED_SINCE'] = '2012:01:04 09:51:00'
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = client_host
    controller.request.headers['HTTP_CLIENTIP'] = nil
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host == client_host, "CASE:2-2-1")
    assert(analysis_info.ip_address == client_ip, "CASE:2-2-3")
    assert(analysis_info.proxy_host == proxy_host, "CASE:2-2-5")
    assert(analysis_info.proxy_ip_address == proxy_ip, "CASE:2-2-7")
    ###########################################################################
    # 正常ケース（プロキシ使用ケース１３）
    # プロキシ情報無し
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    # PROXY情報
    controller.request.headers['REMOTE_HOST'] = nil
    controller.request.headers['REMOTE_ADDR'] = nil
    controller.request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
    # クライアント情報：ホスト情報逆引き、NULL
    controller.request.headers['HTTP_SP_HOST'] = nil
    controller.request.headers['HTTP_CLIENT_IP'] = nil
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    HostInfoSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.remote_host.nil?, "CASE:2-2-2")
    assert(analysis_info.ip_address.nil?, "CASE:2-2-4")
    assert(analysis_info.proxy_host.nil?, "CASE:2-2-6")
    assert(analysis_info.proxy_ip_address.nil?, "CASE:2-2-8")
    # 異常ケースなし
  end
end