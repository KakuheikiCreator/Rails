# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：クライアントIDセッター
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
require 'filter/request_analysis/client_id_setter'
require 'filter/request_analysis/termination_setter'

class ClientIDSetterTest < ActiveSupport::TestCase
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
    # 正常ケース（クライアントIDがセッションに未設定）
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['REMOTE_HOST'] = 'nfmv001066096.uqw.ppp.infoweb.ne.jp'
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    ClientIDSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(session[:client_id].nil? == false, "CASE:2-1-1")
    # 正常ケース（クライアントIDがセッションに設定済）
    session = {:function_state=>FunctionState.new('test_state', 0, nil), :client_id=>'test_id'}
    controller.request.headers['REMOTE_HOST'] = 'nfmv001066096.uqw.ppp.infoweb.ne.jp'
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    ClientIDSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    analysis_info = params.request_analysis_result
    assert(session[:client_id] == 'test_id', "CASE:2-1-2")
    # 異常ケースなし
  end
end