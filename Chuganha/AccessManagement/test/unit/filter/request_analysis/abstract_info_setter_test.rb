# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：抽象セッタークラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/03 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/system_cache'
require 'filter/request_analysis/abstract_info_setter'
require 'filter/request_analysis/accept_lang_setter'
require 'filter/update_session/update_session_filter'
require 'function_state/function_state'
require 'function_state/function_state_hash'
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/unit_test_util'

class AbstractInfoSetterTest < ActiveSupport::TestCase
  include DataCache
  include Filter::RequestAnalysis
  include Filter::UpdateSession
  include FunctionState
  include Mock
  include UnitTestUtil

  # 前処理
  def setup
    # 設定情報ロード
    @business_config = Business::BizCommon::BusinessConfig.instance
    SystemCache.instance.data_load
  end
  # 後処理
  def teardown
  end
  # パラメータクラステスト
  test "2-1:Parameter Test:instance" do
    begin
      AbstractInfoSetter.new(nil, nil)
      AcceptLangSetter.new(nil, nil)
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # 正常ケース：画面遷移パターン
    begin
      token = '12345abcde12345abcde12345abcde12345abcde'
      params = create_params('1', '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-1")
      assert(parameter.error_message.nil?, "CASE:2-1-1")
      assert(parameter.screen_transition_pattern == '1', "CASE:2-1-1")
      assert(parameter.function_transition_no == 1, "CASE:2-1-1")
      assert(parameter.restored_transition_no.nil?, "CASE:2-1-1")
      assert(parameter.synchronous_token == token, "CASE:2-1-1")
      params = create_params('2', '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-2")
      assert(parameter.error_message.nil?, "CASE:2-1-2")
      params = create_params('3', '2', '1', token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-3")
      assert(parameter.error_message.nil?, "CASE:2-1-3")
      assert(parameter.screen_transition_pattern == '3', "CASE:2-1-3")
      assert(parameter.function_transition_no == 2, "CASE:2-1-3")
      assert(parameter.restored_transition_no == 1, "CASE:2-1-3")
      assert(parameter.synchronous_token == token, "CASE:2-1-3")
      params = create_params('4', '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-4")
      assert(parameter.error_message.nil?, "CASE:2-1-4")
      params = create_params('5', '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-5")
      assert(parameter.error_message.nil?, "CASE:2-1-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # 異常ケース：画面遷移パターン
    begin
      token = '12345abcde12345abcde12345abcde12345abcde'
      params = create_params(1, '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-6-1")
      assert(parameter.error_message == 'screen_transition_pattern invalid', "CASE:2-1-6-2")
      params = create_params('0', '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-6-3")
      assert(parameter.error_message == 'screen_transition_pattern invalid', "CASE:2-1-6-4")
      params = create_params('6', '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-6-5")
      assert(parameter.error_message == 'screen_transition_pattern invalid', "CASE:2-1-6-6")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # 異常ケース：遷移元機能遷移番号
    begin
      token = '12345abcde12345abcde12345abcde12345abcde'
      params = create_params('1', 1, nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-7")
      assert(parameter.error_message == 'function_transition_no invalid', "CASE:2-1-7")
      params = create_params('1', 'a', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-7")
      assert(parameter.error_message == 'function_transition_no invalid', "CASE:2-1-7")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # 異常ケース：遷移先機能遷移番号
    begin
      token = '12345abcde12345abcde12345abcde12345abcde'
      params = create_params('1', '2', '1', token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-8")
      assert(parameter.error_message == 'restored_transition_no invalid', "CASE:2-1-8")
      params = create_params('3', '2', 1, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-8")
      assert(parameter.error_message == 'restored_transition_no invalid', "CASE:2-1-8")
      params = create_params('3', '2', 'a', token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-8")
      assert(parameter.error_message == 'restored_transition_no invalid', "CASE:2-1-8")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # 異常ケース：同期トークン
    begin
      params = create_params('1', '1', nil, nil)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-9")
      assert(parameter.error_message == 'synchronous_token invalid', "CASE:2-1-9")
      token = '12345abcde12345abcde12345abcde12345abcd'
      params = create_params('1', '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-9")
      assert(parameter.error_message == 'synchronous_token invalid', "CASE:2-1-9")
      token = '12345abcde12345abcde12345abcde12345abcdef'
      params = create_params('1', '1', nil, token)
      parameter = UpdateSessionFilter::Parameter.new(params)
      assert(!parameter.nil?, "CASE:2-1-9")
      assert(parameter.error_message == 'synchronous_token invalid', "CASE:2-1-9")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：コンストラクタ
  test "2-2:UpdateSessionFilter Test:initialize" do
    # コンストラクタ
    begin
      filter = UpdateSessionFilter.new
      assert(!filter.nil?, "CASE:2-2-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：フィルタ処理
  test "2-3:UpdateSessionFilter Test:filter GETメソッド" do
    # フィルタ処理
    begin
      mock_controller = MockController.new
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-3-1-1")
        assert(mock_controller.params.size == 0, "CASE:2-3-1-2")
        assert(mock_controller.session.size == 0, "CASE:2-3-1-3")
      end
      assert(execute_flg, "CASE:2-3-1-4")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-3-1-5")
      assert(mock_controller.request.size == 0, "CASE:2-3-1-6")
      assert(mock_controller.params.size == 0, "CASE:2-3-1-7")
      assert(mock_controller.session.size == 0, "CASE:2-3-1-8")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # UpdateSessionFilterクラス：フィルタ処理（新規遷移）
  test "2-4:UpdateSessionFilter Test:filter TRANS_PTN_NEW" do
    # 正常：未ログイン状態
    begin
      mock_controller = MockController.new(:post)
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-1")
        assert(mock_controller.params.size == 0, "CASE:2-4-1")
        assert(mock_controller.session.size == 0, "CASE:2-4-1")
      end
      assert(execute_flg, "CASE:2-4-1")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-4-1")
      assert(mock_controller.request.size == 0, "CASE:2-4-1")
      assert(mock_controller.params.size == 0, "CASE:2-4-1")
      assert(mock_controller.session.size == 0, "CASE:2-4-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # 正常：ログイン状態
    begin
      # コントローラー生成
      mock_controller = MockController.new(:post)
      # ログイン状態
      mock_controller.session[:login_id] = 'dummy_id'
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      cache = SystemCache.instance
      info  = cache.get_function(@business_config.system_name,
                                      @business_config.subsystem_name,
                                      'MockController')
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, nil)
      state_hash.add?(state)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params('1', '1', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-3")
        assert(mock_controller.params.size == 3, "CASE:2-4-4")
        assert(mock_controller.params[:screen_transition_pattern] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-4-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-4-4")
        assert(mock_controller.session.size == 4, "CASE:2-4-5")
        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-4-5")
        assert(mock_controller.session[:error_message].nil?, "CASE:2-4-5")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-4-5")
        assert(state == state_hash.get(1), "CASE:2-4-5")
        new_state = mock_controller.session[:function_state]
        assert(new_state == state_hash.get(2), "CASE:2-4-6")
        assert(FunctionState === new_state, "CASE:2-4-6")
        assert(new_state.function_id == 3, "CASE:2-4-6")
        assert(new_state.func_tran_no == 2, "CASE:2-4-6")
        assert(new_state.str_tran_no == 1, "CASE:2-4-6")
        assert(new_state.sync_tkn.length == 40, "CASE:2-4-6")
        assert(new_state.sync_tkn != token, "CASE:2-4-6")
      end
      assert(execute_flg, "CASE:2-4-2")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-4-5")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 2, "CASE:2-4-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # 正常：機能状態生成メソッド有り
    begin
      # コントローラー生成
      mock_controller = SubController.new(:post)
      # ログイン状態
      mock_controller.session[:login_id] = 'dummy_id'
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      cache = SystemCache.instance
      info  = cache.get_function(@business_config.system_name,
                                      @business_config.subsystem_name,
                                      'MockController')
      next_no = state_hash.next_function_transition_no
      state = SubFunctionState.new(info.id, next_no, nil)
      state_hash.add?(state)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params('1', '1', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-3")
        assert(mock_controller.params.size == 3, "CASE:2-4-4")
        assert(mock_controller.params[:screen_transition_pattern] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-4-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-4-4")
        assert(mock_controller.session.size == 4, "CASE:2-4-5")
        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-4-5")
        assert(mock_controller.session[:error_message].nil?, "CASE:2-4-5")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-4-5")
        assert(state == state_hash.get(1), "CASE:2-4-5")
        new_state = mock_controller.session[:function_state]
        assert(SubFunctionState === new_state, "CASE:2-4-7")
        assert(new_state.function_id == 3, "CASE:2-4-7")
        assert(new_state.func_tran_no == 2, "CASE:2-4-7")
        assert(new_state.str_tran_no == 1, "CASE:2-4-7")
        assert(new_state.sync_tkn.length == 40, "CASE:2-4-7")
        assert(new_state.sync_tkn != token, "CASE:2-4-7")
      end
      assert(execute_flg, "CASE:2-4-2")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-4-5")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 2, "CASE:2-4-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    ###########################################################################
    # 異常：機能名エラー
    ###########################################################################
    begin
      # コントローラー生成
      mock_controller = MockController.new(:post)
      mock_controller.controller_name = 'ErrorName'
      # ログイン状態
      mock_controller.session[:login_id] = 'dummy_id'
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      cache = SystemCache.instance
      info  = cache.get_function(@business_config.system_name,
                                      @business_config.subsystem_name,
                                      'MockController')
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, nil)
      state_hash.add?(state)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params('1', '1', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-3")
        assert(mock_controller.params.size == 3, "CASE:2-4-4")
        assert(mock_controller.params[:screen_transition_pattern] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-4-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-4-4")
        assert(mock_controller.session.size == 3, "CASE:2-4-5")
        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-4-5")
        assert(mock_controller.session[:error_message] == 'controller invalid', "CASE:2-4-8")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-4-5")
        assert(state == state_hash.get(1), "CASE:2-4-5")
      end
      assert(execute_flg, "CASE:2-4-2")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-4-5")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 2, "CASE:2-4-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    ###########################################################################
    # 異常：パラメータエラー
    ###########################################################################
    begin
      # コントローラー生成
      mock_controller = MockController.new(:post)
      # ログイン状態
      mock_controller.session[:login_id] = 'dummy_id'
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      cache = SystemCache.instance
      info  = cache.get_function(@business_config.system_name,
                                      @business_config.subsystem_name,
                                      'MockController')
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, nil)
      state_hash.add?(state)
      # パラメータ生成（エラー）
      token = state.sync_tkn
      mock_controller.params = create_params('6', '1', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-3")
        assert(mock_controller.params.size == 3, "CASE:2-4-4")
        assert(mock_controller.params[:screen_transition_pattern] == '6', "CASE:2-4-4")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-4-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-4-4")
        assert(mock_controller.session.size == 3, "CASE:2-4-5")
        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-4-5")
        assert(mock_controller.session[:error_message] == 'screen_transition_pattern invalid', "CASE:2-4-9")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-4-5")
        assert(state == state_hash.get(1), "CASE:2-4-5")
      end
      assert(execute_flg, "CASE:2-4-2")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-4-5")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 2, "CASE:2-4-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end

    ###########################################################################
    # 異常：送信元機能遷移番号エラー
    ###########################################################################
    begin
      # コントローラー生成
      mock_controller = MockController.new(:post)
      # ログイン状態
      mock_controller.session[:login_id] = 'dummy_id'
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      cache = SystemCache.instance
      info  = cache.get_function(@business_config.system_name,
                                      @business_config.subsystem_name,
                                      'MockController')
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, nil)
      state_hash.add?(state)
      # パラメータ生成（エラー）
      token = state.sync_tkn
      mock_controller.params = create_params('1', '10', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-3")
        assert(mock_controller.params.size == 3, "CASE:2-4-4")
        assert(mock_controller.params[:screen_transition_pattern] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:function_transition_no] == '10', "CASE:2-4-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-4-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-4-4")
        assert(mock_controller.session.size == 3, "CASE:2-4-5")
        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-4-5")
        assert(mock_controller.session[:error_message] == 'function_transition_no invalid', "CASE:2-4-10")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-4-5")
        assert(state == state_hash.get(1), "CASE:2-4-5")
      end
      assert(execute_flg, "CASE:2-4-2")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-4-5")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 2, "CASE:2-4-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end

    ###########################################################################
    # 異常：同期トークンエラー
    ###########################################################################
    begin
      # コントローラー生成
      mock_controller = MockController.new(:post)
      # ログイン状態
      mock_controller.session[:login_id] = 'dummy_id'
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      cache = SystemCache.instance
      info  = cache.get_function(@business_config.system_name,
                                      @business_config.subsystem_name,
                                      'MockController')
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, nil)
      state_hash.add?(state)
      # パラメータ生成（エラー）
      token = '1234567890123456789012345678901234567890'
      mock_controller.params = create_params('1', '1', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-3")
        assert(mock_controller.params.size == 3, "CASE:2-4-4")
        assert(mock_controller.params[:screen_transition_pattern] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-4-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-4-4")
        assert(mock_controller.session.size == 3, "CASE:2-4-5")
        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-4-5")
        assert(mock_controller.session[:error_message] == 'synchronous_token invalid', "CASE:2-4-11")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-4-5")
        assert(state == state_hash.get(1), "CASE:2-4-5")
      end
      assert(execute_flg, "CASE:2-4-2")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-4-5")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 2, "CASE:2-4-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    
    ###########################################################################
    # 異常：機能状態ハッシュオーバーフロー
    ###########################################################################
    begin
      # コントローラー生成
      mock_controller = MockController.new(:post)
      # ログイン状態
      mock_controller.session[:login_id] = 'dummy_id'
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成（ハッシュ数フル）
      cache = SystemCache.instance
      info  = cache.get_function(@business_config.system_name,
                                      @business_config.subsystem_name,
                                      'MockController')
      before_no = nil
      while(!state_hash.max_size?) do
        next_no = state_hash.next_function_transition_no
        state = FunctionState.new(info.id, next_no, before_no)
        state_hash.add?(state)
        before_no = next_no
      end
      # パラメータ生成
      token = state.sync_tkn
      trans_no = state.func_tran_no.to_s
      mock_controller.params = create_params('1', trans_no, nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-4-3")
        assert(mock_controller.params.size == 3, "CASE:2-4-4")
        assert(mock_controller.params[:screen_transition_pattern] == '1', "CASE:2-4-4")
        assert(mock_controller.params[:function_transition_no] == trans_no, "CASE:2-4-4")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-4-4")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-4-4")
        assert(mock_controller.session.size == 3, "CASE:2-4-5")
        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-4-5")
        assert(mock_controller.session[:error_message] == 'session overflow', "CASE:2-4-12")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-4-5")
        assert(state == state_hash.get(trans_no.to_i), "CASE:2-4-5")
      end
      assert(execute_flg, "CASE:2-4-2")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-4-5")
      assert(mock_controller.request.size == 0, "CASE:2-4-3")
      assert(mock_controller.params.size == 3, "CASE:2-4-4")
      assert(mock_controller.session.size == 2, "CASE:2-4-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  # UpdateSessionFilterクラス：フィルタ処理（現在機能内遷移）
  test "2-5:UpdateSessionFilter Test:filter TRANS_PTN_NOW" do
    # 正常：ログイン状態
    begin
      # コントローラー生成
      mock_controller = MockController.new(:post)
      # ログイン状態
      mock_controller.session[:login_id] = 'dummy_id'
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      cache = SystemCache.instance
      info  = cache.get_function(@business_config.system_name,
                                      @business_config.subsystem_name,
                                      'MockController')
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, nil)
      state_hash.add?(state)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params('2', '1', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-5-1")
        assert(mock_controller.params.size == 3, "CASE:2-5-2")
        assert(mock_controller.params[:screen_transition_pattern] == '2', "CASE:2-5-2")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-5-2")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-5-2")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-5-2")
        assert(mock_controller.session.size == 4, "CASE:2-5-3")
        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-5-3")
        assert(mock_controller.session[:error_message].nil?, "CASE:2-5-3")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-5-3")
        assert(state == state_hash.get(1), "CASE:2-5-3")
        now_state = mock_controller.session[:function_state]
        assert(state_hash.get(2).nil?, "CASE:2-5-4")
        assert(FunctionState === now_state, "CASE:2-5-4")
        assert(now_state.function_id == 3, "CASE:2-5-4")
        assert(now_state.func_tran_no == 1, "CASE:2-5-4")
        assert(now_state.str_tran_no.nil?, "CASE:2-5-4")
        assert(now_state.sync_tkn == token, "CASE:2-5-4")
      end
      assert(execute_flg, "CASE:2-5-1")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-5-3")
      assert(mock_controller.request.size == 0, "CASE:2-5-1")
      assert(mock_controller.params.size == 3, "CASE:2-5-2")
      assert(mock_controller.session.size == 2, "CASE:2-5-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  # UpdateSessionFilterクラス：フィルタ処理（復元遷移）
  test "2-6:UpdateSessionFilter Test:filter TRANS_PTN_REST" do
    # 正常：ログイン状態
    begin
      # コントローラー生成
      mock_controller = MockController.new(:post)
      # ログイン状態
      mock_controller.session[:login_id] = 'dummy_id'
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      cache = SystemCache.instance
      info  = cache.get_function(@business_config.system_name,
                                      @business_config.subsystem_name,
                                      'MockController')
      next_no = state_hash.next_function_transition_no
      top_state = FunctionState.new(info.id, next_no, nil)
      state_hash.add?(top_state)
      next_no = state_hash.next_function_transition_no
      target_state = FunctionState.new(info.id, next_no, nil)
      state_hash.add?(target_state)
      target_token = target_state.sync_tkn
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, next_no - 1)
      state_hash.add?(state)
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, next_no - 1)
      state_hash.add?(state)
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, next_no - 1)
      state_hash.add?(state)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params('3', '5', '2', token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-6-1")
        assert(mock_controller.params.size == 4, "CASE:2-6-2")
        assert(mock_controller.params[:screen_transition_pattern] == '3', "CASE:2-6-2")
        assert(mock_controller.params[:function_transition_no] == '5', "CASE:2-6-2")
        assert(mock_controller.params[:restored_transition_no] == '2', "CASE:2-6-2")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-6-2")
        assert(mock_controller.session.size == 4, "CASE:2-6-3")
        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-6-3")
        assert(mock_controller.session[:error_message].nil?, "CASE:2-6-3")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-6-4")
        assert(top_state == state_hash.get(1), "CASE:2-6-4")
        assert(target_state == state_hash.get(2), "CASE:2-6-4")
        assert(state_hash.get(3).nil?, "CASE:2-6-4")
        assert(state_hash.get(4).nil?, "CASE:2-6-4")
        assert(state_hash.get(5).nil?, "CASE:2-6-4")
        now_state = mock_controller.session[:function_state]
        assert(FunctionState === now_state, "CASE:2-6-5")
        assert(target_state === now_state, "CASE:2-6-5")
        assert(now_state.function_id == 3, "CASE:2-6-5")
        assert(now_state.func_tran_no == 2, "CASE:2-6-5")
        assert(now_state.str_tran_no.nil?, "CASE:2-6-5")
        assert(now_state.sync_tkn == target_token, "CASE:2-6-5")
      end
      assert(execute_flg, "CASE:2-6-1")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-6-3")
      assert(mock_controller.request.size == 0, "CASE:2-6-1")
      assert(mock_controller.params.size == 4, "CASE:2-6-2")
      assert(mock_controller.session.size == 2, "CASE:2-6-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # 異常：履歴削除エラー
    begin
      # コントローラー生成
      mock_controller = MockController.new(:post)
      # ログイン状態
      mock_controller.session[:login_id] = 'dummy_id'
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      cache = SystemCache.instance
      info  = cache.get_function(@business_config.system_name,
                                      @business_config.subsystem_name,
                                      'MockController')
      next_no = state_hash.next_function_transition_no
      target_state = FunctionState.new(info.id, next_no, nil)
      state_hash.add?(target_state)
      target_token = target_state.sync_tkn
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, next_no - 1)
      state_hash.add?(state)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params('3', '2', '0', token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-6-1")
        assert(mock_controller.params.size == 4, "CASE:2-6-2")
        assert(mock_controller.params[:screen_transition_pattern] == '3', "CASE:2-6-2")
        assert(mock_controller.params[:function_transition_no] == '2', "CASE:2-6-2")
        assert(mock_controller.params[:restored_transition_no] == '0', "CASE:2-6-2")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-6-2")
        assert(mock_controller.session.size == 3, "CASE:2-6-3")
        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-6-3")
        assert(mock_controller.session[:error_message] == 'function_transition_no and restored_transition_no invalid', "CASE:2-6-6")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-6-3")
        assert(target_state == state_hash.get(1), "CASE:2-6-3")
        assert(state == state_hash.get(2), "CASE:2-6-3")
        now_state = mock_controller.session[:function_state]
        assert(now_state.nil?, "CASE:2-6-3")
      end
      assert(execute_flg, "CASE:2-6-1")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-6-3")
      assert(mock_controller.request.size == 0, "CASE:2-6-1")
      assert(mock_controller.params.size == 4, "CASE:2-6-2")
      assert(mock_controller.session.size == 2, "CASE:2-6-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  # UpdateSessionFilterクラス：フィルタ処理（置換遷移）
  test "2-7:UpdateSessionFilter Test:filter TRANS_PTN_REP" do
    # 正常：ログイン状態
    begin
      # コントローラー生成
      mock_controller = MockController.new(:post)
      # ログイン状態
      mock_controller.session[:login_id] = 'dummy_id'
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      cache = SystemCache.instance
      info  = cache.get_function(@business_config.system_name,
                                      @business_config.subsystem_name,
                                      'MockController')
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, nil)
      state_hash.add?(state)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params('4', '1', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-7-1")
        assert(mock_controller.params.size == 3, "CASE:2-7-2")
        assert(mock_controller.params[:screen_transition_pattern] == '4', "CASE:2-7-2")
        assert(mock_controller.params[:function_transition_no] == '1', "CASE:2-7-2")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-7-2")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-7-2")
        assert(mock_controller.session.size == 4, "CASE:2-7-3")
        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-7-3")
        assert(mock_controller.session[:error_message].nil?, "CASE:2-7-3")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-7-4")
        assert(state_hash.get(1).nil?, "CASE:2-7-4")
        now_state = mock_controller.session[:function_state]
        assert(FunctionState === now_state, "CASE:2-7-5")
        assert(now_state == state_hash.get(2), "CASE:2-7-5")
        assert(now_state.function_id == 3, "CASE:2-7-5")
        assert(now_state.func_tran_no == 2, "CASE:2-7-5")
        assert(now_state.str_tran_no.nil?, "CASE:2-7-5")
        assert(now_state.sync_tkn == state_hash.get(2).sync_tkn, "CASE:2-7-5")
      end
      assert(execute_flg, "CASE:2-7-1")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-7-3")
      assert(mock_controller.request.size == 0, "CASE:2-7-1")
      assert(mock_controller.params.size == 3, "CASE:2-7-2")
      assert(mock_controller.session.size == 2, "CASE:2-7-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end


  # UpdateSessionFilterクラス：フィルタ処理（全状態クリア後新規遷移）
  test "2-8:UpdateSessionFilter Test:filter TRANS_PTN_CLR" do
    # 正常：ログイン状態
    begin
      # コントローラー生成
      mock_controller = MockController.new(:post)
      # ログイン状態
      mock_controller.session[:login_id] = 'dummy_id'
      # 機能状態ハッシュ生成
      state_hash = FunctionStateHash.new
      mock_controller.session[:function_state_hash] = state_hash
      # 機能状態生成
      cache = SystemCache.instance
      info  = cache.get_function(@business_config.system_name,
                                      @business_config.subsystem_name,
                                      'MockController')
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, nil)
      state_hash.add?(state)
      next_no = state_hash.next_function_transition_no
      state = FunctionState.new(info.id, next_no, next_no - 1)
      state_hash.add?(state)
      # パラメータ生成
      token = state.sync_tkn
      mock_controller.params = create_params('5', '2', nil, token)
      # テスト実行
      filter_obj = UpdateSessionFilter.new
      execute_flg = false
      filter_obj.filter(mock_controller) do
        execute_flg = true
        assert(mock_controller.request.size == 0, "CASE:2-8-1")
        assert(mock_controller.params.size == 3, "CASE:2-8-2")
        assert(mock_controller.params[:screen_transition_pattern] == '5', "CASE:2-8-2")
        assert(mock_controller.params[:function_transition_no] == '2', "CASE:2-8-2")
        assert(mock_controller.params[:restored_transition_no].nil?, "CASE:2-8-2")
        assert(mock_controller.params[:synchronous_token] == token, "CASE:2-8-2")
        assert(mock_controller.session.size == 4, "CASE:2-8-3")
        assert(mock_controller.session[:login_id] == 'dummy_id', "CASE:2-8-3")
        assert(mock_controller.session[:error_message].nil?, "CASE:2-8-3")
        state_hash = mock_controller.session[:function_state_hash]
        assert(FunctionStateHash === state_hash, "CASE:2-8-4")
        assert(state_hash.get(1).nil?, "CASE:2-8-4")
        assert(state_hash.get(2).nil?, "CASE:2-8-4")
        now_state = mock_controller.session[:function_state]
        assert(FunctionState === now_state, "CASE:2-8-5")
        assert(now_state == state_hash.get(3), "CASE:2-8-5")
        assert(now_state.function_id == 3, "CASE:2-8-5")
        assert(now_state.func_tran_no == 3, "CASE:2-8-5")
        assert(now_state.str_tran_no.nil?, "CASE:2-8-5")
        assert(now_state.sync_tkn == state_hash.get(3).sync_tkn, "CASE:2-8-5")
      end
      assert(execute_flg, "CASE:2-8-1")
      assert(mock_controller.session[:error_message].nil?, "CASE:2-8-3")
      assert(mock_controller.request.size == 0, "CASE:2-8-1")
      assert(mock_controller.params.size == 3, "CASE:2-8-2")
      assert(mock_controller.session.size == 2, "CASE:2-8-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end



  # パラメータオブジェクト生成処理
  def create_params(ptn, trans_no, rest_no, token)
    params = Hash.new
    params[:screen_transition_pattern] = ptn
    params[:function_transition_no] = trans_no
    params[:restored_transition_no] = rest_no unless rest_no.nil?
    params[:synchronous_token] = token
    return params
  end
  # 機能状態
  class SubFunctionState < FunctionState
    # アクセスメソッド定義
    attr_reader :function_id,
                :function_transition_no,
                :start_former_transition_no,
                :synchronous_token
    
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期化メソッド
    def initialize(function_id, transition_no, start_former_transition_no)
      @function_id           = function_id       # 機能ID
      @function_transition_no     = transition_no          # 機能遷移番号
      @start_former_transition_no = start_former_transition_no  # 起動元機能遷移番号
      @synchronous_token          = generate_token         # 同期トークン
    end
  end
  # コントローラー
  class SubController < MockController
    ##########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize(method)
      super(method)
    end
    # 機能状態生成処理
    def create_function_state(function_id, trans_no, start_former_trans_no)
      return SubFunctionState.new(function_id, trans_no, start_former_trans_no)
    end
  end
end
