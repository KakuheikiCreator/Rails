# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：リファラーセッター
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
require 'filter/request_analysis/referrer_setter'
require 'filter/request_analysis/termination_setter'

class ReferrerSetterTest < ActiveSupport::TestCase
  include Mock
  include DataCache
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
    ###########################################################################
    # 正常ケース（リファラー情報有り）
    ###########################################################################
    test_referrer = 'dummy_referrer'
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['HTTP_REFERER'] = test_referrer
    params = AnalysisParameters.new(controller)
    setting_info = RequestAnalysisSchedule.new
    terminator = TerminationSetter.new(setting_info, nil)
    ReferrerSetter.new(setting_info, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.referrer == test_referrer, "CASE:2-1-1")
    ###########################################################################
    # 正常ケース（リファラー情報有り）
    ###########################################################################
    test_referrer = '1234567890'
    29.times do
      test_referrer = test_referrer + '1234567890'
    end
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['HTTP_REFERER'] = test_referrer
    params = AnalysisParameters.new(controller)
    setting_info = RequestAnalysisSchedule.new
    terminator = TerminationSetter.new(setting_info, nil)
    ReferrerSetter.new(setting_info, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(analysis_info.referrer == test_referrer.unpack('a255a*')[0], "CASE:2-1-2")
    assert(analysis_info.referrer.length == 255, "CASE:2-1-2")
    ###########################################################################
    # 正常ケース（リファラー情報無し）
    ###########################################################################
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['HTTP_REFERER'] = nil
    params = AnalysisParameters.new(controller)
    setting_info = RequestAnalysisSchedule.new
    terminator = TerminationSetter.new(setting_info, nil)
    ReferrerSetter.new(setting_info, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert_nil(analysis_info.referrer, "CASE:2-1-3")
    # 異常ケースなし
  end
end