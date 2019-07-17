# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ドメインセッター
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
require 'filter/request_analysis/domain_setter'
require 'filter/request_analysis/termination_setter'

class DomainSetterTest < ActiveSupport::TestCase
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
    # 正常ケース（ドメイン無し）
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    request_analysis_result = params.request_analysis_result
    DomainSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    print("domain_id:" + request_analysis_result.domain_id.to_s + "\n")
    assert(request_analysis_result.domain_id.nil?, "CASE:2-1-1")
    # 正常ケース（ドメイン有り）
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    request_analysis_result = params.request_analysis_result
    request_analysis_result.remote_host = "nfmv001066096.uqw.ppp.infoweb.ne.jp"
    DomainSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    print("domain_id:" + request_analysis_result.domain_id.to_s + "\n")
    assert(request_analysis_result.domain_id == 6, "CASE:2-1-2")
    # 異常ケースなし
  end
end