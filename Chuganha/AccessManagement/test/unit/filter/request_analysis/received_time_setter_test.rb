# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：受信日時セッター
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
require 'filter/request_analysis/received_time_setter'
require 'filter/request_analysis/termination_setter'

class ReceivedTimeSetterTest < ActiveSupport::TestCase
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
    # 正常ケース（受信日時有り）
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    params = AnalysisParameters.new(controller)
    received_time = params.received_time
    print("Received Time:" + received_time.to_s + "\n")
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    ReceivedTimeSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    print("Result Time  :" + analysis_info.received_year.to_s +
          "/" + analysis_info.received_month.to_s +
          "/" + analysis_info.received_day.to_s +
          " " + analysis_info.received_hour.to_s +
          ":" + analysis_info.received_minute.to_s +
          ":" + analysis_info.received_second.to_s + "\n")
    assert(analysis_info.received_year == received_time.year, "CASE:2-1-1")
    assert(analysis_info.received_month == received_time.month, "CASE:2-1-2")
    assert(analysis_info.received_day == received_time.day, "CASE:2-1-3")
    assert(analysis_info.received_hour == received_time.hour, "CASE:2-1-4")
    assert(analysis_info.received_minute == received_time.min, "CASE:2-1-5")
    assert(analysis_info.received_second == received_time.sec, "CASE:2-1-6")
    # 異常ケースなし
  end
end