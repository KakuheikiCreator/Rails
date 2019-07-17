# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：リクエスト言語セッター
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
require 'filter/request_analysis/accept_lang_setter'
require 'filter/request_analysis/termination_setter'

class AcceptLangSetterTest < ActiveSupport::TestCase
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
    # 正常ケース（言語情報無し）
    session = {:function_state=>FunctionState.new('test_state', 0, nil)}
    mock_params = {:controller_name => 'MockController',
                   :controller_path => 'mock/mock',
                   :method=>:get,
                   :session=>session}
    controller = MockController.new(mock_params)
    controller.request.headers['Accept-Language'] = nil
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    AcceptLangSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    request_analysis_result = params.request_analysis_result
    assert(request_analysis_result.accept_language.nil?, "CASE:2-1-1")
    # 正常ケース（リソースを構成する自然言語が単一の場合）
    controller.request.headers['Accept-Language'] = 'ja'
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    AcceptLangSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    request_analysis_result = params.request_analysis_result
    assert(request_analysis_result.accept_language == 'ja', "CASE:2-1-2")
    # 正常ケース（リソースを構成する自然言語が複数の場合）
    controller.request.headers['Accept-Language'] = 'ja, en'
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    AcceptLangSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    request_analysis_result = params.request_analysis_result
    assert(request_analysis_result.accept_language == 'ja', "CASE:2-1-3")
    # 正常ケース（リソースが一度に複数返され、それぞれの自然言語が異なる場合）
    controller.request.headers['Accept-Language'] = 'ja, da, de, el, en, fr, it'
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    AcceptLangSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    request_analysis_result = params.request_analysis_result
    assert(request_analysis_result.accept_language == 'ja', "CASE:2-1-4")
    # 正常ケース（サブタグ付きその１）
    controller.request.headers['Accept-Language'] = 'da;es, de, el, en, fr, it'
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    AcceptLangSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    request_analysis_result = params.request_analysis_result
    assert(request_analysis_result.accept_language == 'da', "CASE:2-1-5")
    # 正常ケース（サブタグ付きその２）
    controller.request.headers['Accept-Language'] = 'ja-de, de, el, en, fr, it'
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    AcceptLangSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    request_analysis_result = params.request_analysis_result
#    print("Lang:" + request_analysis_result.accept_language + "\n")
    assert(request_analysis_result.accept_language == 'ja', "CASE:2-1-6")
    # 正常ケース（サブタグ付きその３）
    controller.request.headers['Accept-Language'] = 'da_el, de, el, en, fr, it'
    params = AnalysisParameters.new(controller)
    terminator = TerminationSetter.new(RequestAnalysisSchedule.new, nil)
    AcceptLangSetter.new(RequestAnalysisSchedule.new, terminator).execute(params)
    request_analysis_result = params.request_analysis_result
#    print("Lang:" + request_analysis_result.accept_language + "\n")
    assert(request_analysis_result.accept_language == 'da', "CASE:2-1-7")
    # 異常ケースなし
  end
end