# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：リクエスト解析パラメータ
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/12/31 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/mock/mock_request'
require 'data_cache/system_cache'
require 'function_state/function_state'
require 'filter/request_analysis/analysis_parameters'

class AnalysisParametersTest < ActiveSupport::TestCase
  include DataCache
  include Mock
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

  # テスト対象メソッド：initialize
  test "CASE:2-1 initialize" do
    # 正常ケース（セッション情報無し）
    mock_params = {:controller_path => 'MockController',
                   :method=>:get}
    controller = MockController.new(mock_params)
    params = AnalysisParameters.new(controller)
    assert(params.received_time, "CASE:2-1-1")
    assert(params.setting_info, "CASE:2-1-2")
    assert(params.controller_path == 'MockController', "CASE:2-1-3")
    assert(MockRequest === params.request, "CASE:2-1-4")
    assert(params.session.nil?, "CASE:2-1-5")
    assert(RequestAnalysisResult === params.request_analysis_result, "CASE:2-1-9")
    # 正常ケース（セッション情報有り）
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_path => 'MockController',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    params = AnalysisParameters.new(controller)
    assert(params.received_time, "CASE:2-1-1")
    assert(Time === params.received_time, "CASE:2-1-1")
    assert(params.setting_info, "CASE:2-1-2")
    assert(RequestAnalysisSchedule === params.setting_info, "CASE:2-1-2")
    assert(params.controller_path == 'MockController', "CASE:2-1-3")
    assert(MockRequest === params.request, "CASE:2-1-4")
    assert(Hash === params.session, "CASE:2-1-6")
    assert(RequestAnalysisResult === params.request_analysis_result, "CASE:2-1-9")
    # 異常ケースなし
  end
  # テスト対象メソッド：performance
  test "CASE:2-1 performance" do
    # 生成パフォーマンステスト
    mock_params = {:controller_path => 'MockController',
                   :method=>:get}
    controller = MockController.new(mock_params)
    # インスタンス生成
    start_time = Time.now
#    10000.times do
    100.times do
      params = AnalysisParameters.new(controller)
    end
    process_time = Time.now.usec - start_time.usec
    print("Processing Time:", process_time, "usec\n")
  end
end