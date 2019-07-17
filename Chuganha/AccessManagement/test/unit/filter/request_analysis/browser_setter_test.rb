# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ブラウザセッター
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/02 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/mock/mock_request'
require 'data_cache/system_cache'
require 'function_state/function_state'
require 'filter/request_analysis/analysis_parameters'
require 'filter/request_analysis/browser_setter'
require 'filter/request_analysis/termination_setter'

class BrowserSetterTest < ActiveSupport::TestCase
  include DataCache
  include Mock
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
    # 正常ケース（ユーザーエージェント無し）
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['HTTP_USER_AGENT'] = nil
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    BrowserSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    request_analysis_result = params.request_analysis_result
    assert(request_analysis_result.browser_id.nil?, "CASE:2-1-1")
    assert(request_analysis_result.browser_version_id.nil?, "CASE:2-1-2")
    # 正常ケース（ユーザーエージェント有り）
    controller.request.headers['HTTP_USER_AGENT'] = 'Mozilla/4.0 (compatible; MSIE 4.01; Windows NT)'
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    BrowserSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    request_analysis_result = params.request_analysis_result
#    print("browser_id:" + request_analysis_result.browser_id.to_s + "\n")
#    print("browser_version_id:" + request_analysis_result.browser_version_id.to_s + "\n")
    assert(request_analysis_result.browser_id == 1, "CASE:2-2-1")
    assert(request_analysis_result.browser_version_id == 1, "CASE:2-2-2")
    # 異常ケースなし
  end
end