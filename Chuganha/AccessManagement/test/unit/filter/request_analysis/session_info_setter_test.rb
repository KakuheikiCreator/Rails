# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：セッション情報セッター
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
require 'filter/request_analysis/session_info_setter'
require 'filter/request_analysis/termination_setter'

class SessionInfoSetterTest < ActiveSupport::TestCase
  include Mock
  include DataCache
  include FunctionState
  include Filter::RequestAnalysis

  # 前処理
  def setup
    # 設定情報ロード
    @business_config = BizCommon::BusinessConfig.instance
    SystemCache.instance.data_load
  end
  # 後処理
  def teardown
  end
  
  # テスト対象メソッド：execute
  test "CASE:2-1 execute" do
    ###########################################################################
    # 正常ケース
    # セッションID：有り
    # クライアントID：有り
    ###########################################################################
    session_id  = 'dummy_session_id'
    client_id = 'dummy_client_id'
    session = {:session_id=>session_id,
               :client_id=>client_id}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers[:session_id] = session_id
    params = AnalysisParameters.new(controller)
    setting_info = RequestAnalysisSchedule.new
    terminator = TerminationSetter.new(setting_info, nil)
    SessionInfoSetter.new(setting_info, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.session_id == session_id, "CASE:2-1-1")
    assert(analysis_info.client_id == client_id, "CASE:2-1-3")
    ###########################################################################
    # 正常ケース
    # セッションID：無し
    # クライアントID：無し
    ###########################################################################
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>Hash.new}
    controller = MockController.new(mock_params)
    params = AnalysisParameters.new(controller)
    setting_info = RequestAnalysisSchedule.new
    terminator = TerminationSetter.new(setting_info, nil)
    SessionInfoSetter.new(setting_info, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert_nil(analysis_info.session_id, "CASE:2-1-2")
    assert_nil(analysis_info.client_id, "CASE:2-1-4")
    # 異常ケースなし
  end
end