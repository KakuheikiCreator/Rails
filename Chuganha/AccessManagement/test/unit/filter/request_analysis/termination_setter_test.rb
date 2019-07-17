# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：終端セッター
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

class TerminationSetterTest < ActiveSupport::TestCase
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
    # 正常ケース
    ###########################################################################
    function_state = FunctionState.new(1, 2, nil)
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>Hash.new}
    controller = MockController.new(mock_params)
    params = AnalysisParameters.new(controller)
    setting_info = RequestAnalysisSchedule.new
    ret_params = TerminationSetter.new(setting_info, nil).execute(params)
    assert(ret_params == params, "CASE:2-1-1")
    # 異常ケースなし
  end
end