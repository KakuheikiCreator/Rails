# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：デフォルトセッター
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/03 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/mock/mock_request'
require 'data_cache/system_cache'
require 'function_state/function_state'
require 'filter/request_analysis/analysis_parameters'
require 'filter/request_analysis/default_setter'
require 'filter/request_analysis/termination_setter'

class DefaultSetterTest < ActiveSupport::TestCase
  include Mock
  include DataCache
  include FunctionState
  include Filter::RequestAnalysis
  
  # 前処理
  def setup
    @business_config = BizCommon::BusinessConfig.instance
    SystemCache.instance.data_load
  end

  # テスト対象メソッド：execute
  test "CASE:2-1 execute" do
    # 正常ケース（機能有り）
    cash = SystemCache.instance
    system = cash.get_system(@business_config.system_name,
                             @business_config.subsystem_name)
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'test/request',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    setting = RequestAnalysisSchedule.new
    setting.id = 5
    setting.system_id = system.id
    DefaultSetter.new(setting, terminator).execute(params)
    request_analysis_result = params.request_analysis_result
#    print("id1:" + request_analysis_result.system_id.to_s + "\n")
#    print("id2:" + request_analysis_result.request_analysis_schedule_id.to_s + "\n")
#    print("id3:" + request_analysis_result.function_id.to_s + "\n")
#    print("count:" + request_analysis_result.request_count.to_s + "\n")
    assert(request_analysis_result.system_id == 1, "CASE:2-1-1")
    assert(request_analysis_result.request_analysis_schedule_id == 5, "CASE:2-1-2")
    assert(request_analysis_result.function_id == 4, "CASE:2-1-3")
    assert(request_analysis_result.request_count == 1, "CASE:2-1-5")
    # 正常ケース（機能無し）
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'unknown',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    setting = RequestAnalysisSchedule.new
    setting.id = 5
    setting.system_id = system.id
    DefaultSetter.new(setting, terminator).execute(params)
    request_analysis_result = params.request_analysis_result
#    print("id1:" + request_analysis_result.system_id.to_s + "\n")
#    print("id2:" + request_analysis_result.request_analysis_schedule_id.to_s + "\n")
#    print("id3:" + request_analysis_result.function_id.to_s + "\n")
#    print("count:" + request_analysis_result.request_count.to_s + "\n")
    assert(request_analysis_result.system_id == 1, "CASE:2-1-1")
    assert(request_analysis_result.request_analysis_schedule_id == 5, "CASE:2-1-2")
    assert(request_analysis_result.function_id.nil?, "CASE:2-1-4")
    assert(request_analysis_result.request_count == 1, "CASE:2-1-5")
    # 異常ケースなし
  end
end