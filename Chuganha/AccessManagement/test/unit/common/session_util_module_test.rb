# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：セッションユーティリティモジュール
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/02/06 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'test_helper'
require 'common/session_util_module'
require 'data_cache/system_cache'
require 'function_state/function_state'
require 'function_state/function_state_hash'
require 'unit/mock/mock_controller'
require 'unit/unit_test_util'

class SessionUtilModuleTest < ActiveSupport::TestCase
  include Common::SessionUtilModule
  include DataCache
  include FunctionState
  include Mock
  include UnitTestUtil

  # 前処理
  def setup
    # 設定情報ロード
    @business_config = Business::BizCommon::BusinessConfig.instance
    SystemCache.instance.data_load
  end

  # テスト対象メソッド：create_scr_trans_params
  test "CASE:2-1 MessageUtilModule Test:create_scr_trans_params" do
    ############################################################################
    # テスト項目：復元先の機能遷移番号指定無し
    ############################################################################
    begin
      # コントローラ生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態
      state = state_hash.new_state(mock_controller, nil)
      mock_controller.session[:function_state] = state
      # パラメータ生成(復元する機能遷移番号の指定なし)
      params = create_scr_trans_params(mock_controller, TRANS_PTN_NEW)
      assert(params[:screen_transition_pattern] == TRANS_PTN_NEW, "CASE:2-1-1-1")
      assert(params[:function_transition_no] == state.func_tran_no.to_s, "CASE:2-1-1-2")
      assert(params[:synchronous_token] == state.sync_tkn, "CASE:2-1-1-3")
      assert(params[:restored_transition_no].nil?, "CASE:2-1-1-4")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1")
    end
    ############################################################################
    # テスト項目：復元先の機能遷移番号指定有り
    ############################################################################
    begin
      # コントローラ生成
      params = {:controller_path => 'mock/mock',
                :controller_name => 'MockController',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態
      state = state_hash.new_state(mock_controller, nil)
      mock_controller.session[:function_state] = state
      # パラメータ生成(復元する機能遷移番号の指定有り)
      rest_no = 100
      params = create_scr_trans_params(mock_controller, TRANS_PTN_REST, rest_no)
      assert(params[:screen_transition_pattern] == TRANS_PTN_REST, "CASE:2-1-2-1")
      assert(params[:function_transition_no] == state.func_tran_no.to_s, "CASE:2-1-2-2")
      assert(params[:synchronous_token] == state.sync_tkn, "CASE:2-1-2-3")
      assert(params[:restored_transition_no] == rest_no.to_s, "CASE:2-1-2-4")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1")
    end
    # 異常ケース
  end

  # テスト対象メソッド：function_state_init?
  test "CASE:2-2 MessageUtilModule Test:function_state_init?" do
    ############################################################################
    # テスト項目：セッション初期化処理（正常）
    ############################################################################
    begin
      # コントローラ生成
      params = {:controller_path => 'mock/mock',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # セッション初期化
      result = function_state_init?(mock_controller)
      state = mock_controller.session[:function_state]
      hash = mock_controller.session[:function_state_hash]
      assert(result, "CASE:2-2-1-1")
      assert(FunctionState === state, "CASE:2-2-1-2")
      assert(FunctionStateHash === hash, "CASE:2-2-1-3")
      assert(!hash[state.func_tran_no].nil?, "CASE:2-2-1-4")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-2-1")
    end
    ############################################################################
    # テスト項目：セッション初期化処理（生成異常）
    ############################################################################
    begin
      # コントローラ生成
      params = {:controller_path => 'mock/mock',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = ErrController.new(params)
      # セッション初期化
      result = function_state_init?(mock_controller)
      state = mock_controller.session[:function_state]
      hash = mock_controller.session[:function_state_hash]
      assert(result == false, "CASE:2-2-2-1")
      assert(state.nil?, "CASE:2-2-2-2")
      assert(hash.nil?, "CASE:2-2-2-3")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-2-2")
    end
    # 異常ケース
  end
  
  class ErrController < MockController
   # コンストラクタ
    def initialize(params)
      super(params)
    end
    
    def create_function_state(controller_path, trans_no, start_trans_no)
      return nil
    end
  end
end
