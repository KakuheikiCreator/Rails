# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：機能状態スタッククラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/03 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'function_state/function_state'
require 'function_state/function_state_hash'

class FunctionStateHashTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Mock
  include FunctionState
  # 前処理
  def setup
    # 業務設定
    @biz_config = Business::BizCommon::BusinessConfig.instance
  end
  # 後処理
  def teardown
  end
  # テスト対象メソッド：initialize
  test "CASE:2-01 initialize" do
    # 正常ケース
    assert(!FunctionStateHash.new.nil?, "CASE:2-1-1")
  end
  
  # テスト対象メソッド：accessor
  test "CASE:2-02 accessor" do
    state_hash = FunctionStateHash.new
    assert(state_hash.max_size == 30, "CASE:2-2-1-1")
    @biz_config.instance_variable_set(:@max_function_state_hash_size, 1000)
    state_hash = FunctionStateHash.new
    assert(state_hash.max_size == 1000, "CASE:2-2-1-2")
    begin
      state_hash.max_size = 30
      flunk("CASE:2-2-2")
    rescue StandardError => ex
      assert(state_hash.max_size == 1000, "CASE:2-2-2")
    end
    @biz_config.instance_variable_set(:@max_function_state_hash_size, 30)
  end
  
  # テスト対象メソッド：max_size?
  test "CASE:2-03 max_size?" do
    # コントローラー生成
    mock_ctrl = MockController.new({:controller_path=>'mock/mock', :session=>Hash.new})
    # 正常ケース
    key_array = Array.new
    state_hash = FunctionStateHash.new
    key_array.push(state_hash.new_state(mock_ctrl, nil, true).func_tran_no)
    29.times do
      assert(!state_hash.max_size?, "CASE:2-3-1")
      key_array.push(state_hash.new_state(mock_ctrl, nil, false).func_tran_no)
    end
    assert(state_hash.max_size?, "CASE:2-3-2")
    # 異常ケース
  end
  
  # テスト対象メソッド：set_max_size?
  test "CASE:2-04 set_max_size?" do
    # コントローラー生成
    mock_ctrl = MockController.new({:controller_path=>'mock/mock', :session=>Hash.new})
    # 正常ケース
    state_hash = FunctionStateHash.new
    assert(!state_hash.new_state(mock_ctrl, nil, true).nil?, "CASE:2-4-1")
    29.times do
      assert(!state_hash.max_size?, "CASE:2-4-1")
      assert(!state_hash.new_state(mock_ctrl, nil, false).nil?, "CASE:2-4-1")
    end
    assert(state_hash.set_max_size?(30), "CASE:2-4-1")
    assert(!state_hash.set_max_size?(29), "CASE:2-4-2")
    # 異常ケース
  end
  
  # テスト対象メソッド：[]
  test "CASE:2-05 []" do
    # コントローラー生成
    mock_ctrl = MockController.new({:controller_path=>'mock/mock', :session=>Hash.new})
    # 正常ケース
    state_list = Array.new
    state_hash = FunctionStateHash.new
    state_list.push(state_hash.new_state(mock_ctrl, nil, true))
    (1..29).each do |idx|
      state_list.push(state_hash.new_state(mock_ctrl, idx, false))
    end
    state_list.each do |state|
      assert(!state.nil?, "CASE:2-5-1-1")
      get_state = state_hash[state.func_tran_no]
      assert(get_state.func_tran_no == state.func_tran_no, "CASE:2-5-1-2")
    end
    begin
      assert(state_hash['dummy'].nil?, "CASE:2-5-2")
    rescue StandardError => ex
      flunk("CASE:2-5-2")
    end
    # 異常ケース
  end
  
  # テスト対象メソッド：previous_state
  test "CASE:2-06 previous_state" do
    # 正常終了（パス指定なし、分離フラグオフ）
    begin
      # 正常ケース
      key_array = Array.new
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      key_array.push(state.func_tran_no)
#      print_log("CASE:2-6:1:" + state.func_tran_no.to_s)
      (2..30).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1)
#        print_log("CASE:2-6:1-1:" + state.func_tran_no.to_s)
        key_array.push(state.func_tran_no)
      end
#      print_log("CASE:2-6:2")
      # 直前の状態を取得
      (1..29).each do |idx|
#        print_log("CASE:2-6:2-1:" + key_array.length.to_s)
        func_tran_no = key_array[30 - idx]
#        print_log("CASE:2-6:2-2:" + func_tran_no.to_s)
        state = state_hash[func_tran_no]
#        print_log("CASE:2-6:2-3:" + state.nil?.to_s)
        previous_state = state_hash.previous_state(state.func_tran_no)
#        print_log("CASE:2-6:2-4:" + previous_state.nil?.to_s)
        assert(previous_state.func_tran_no == state.prev_tran_no, "CASE:2-6-1")
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-6-1")
    end
    # 正常終了（パス指定なし、分離フラグオン）
    begin
      # 正常ケース
      key_array = Array.new
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_2', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, 1, true)
      # 直前の状態を取得
      previous_state = state_hash.previous_state(state.func_tran_no)
      assert(previous_state.nil?, "CASE:2-6-2")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-6-2")
    end
    # 正常終了（パス指定あり、分離フラグオフ）
    begin
      # 正常ケース
      key_array = Array.new
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path=>'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      key_array.push(state.func_tran_no)
      (2..30).each do |idx|
        mock_ctrl = MockController.new({:controller_path=>'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1)
        key_array.push(state.func_tran_no)
      end
      # 取得するパスを指定して直前の状態を取得
      previous_state = state_hash.previous_state(key_array[20], "mock/mock_10")
      assert(previous_state.cntr_path == "mock/mock_10", "CASE:2-6-3")
      assert(previous_state.func_tran_no == 10, "CASE:2-6-3")
      assert(previous_state.sept_flg == false, "CASE:2-6-3")
      previous_state = state_hash.previous_state(key_array[10], "mock/mock_5")
      assert(previous_state.cntr_path == "mock/mock_5", "CASE:2-6-3")
      assert(previous_state.func_tran_no == 5, "CASE:2-6-3")
      assert(previous_state.sept_flg == false, "CASE:2-6-3")
      previous_state = state_hash.previous_state(key_array[29], "mock/mock_none")
      assert(previous_state.nil?, "CASE:2-6-5")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-6-3=>2-6-5")
    end
    # 正常終了（パス指定あり、分離フラグオン）
    begin
      # 正常ケース
      key_array = Array.new
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      key_array.push(state.func_tran_no)
      (2..30).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, (idx%6)==0)
        key_array.push(state.func_tran_no)
      end
      # 取得するパスを指定して直前の状態を取得
#      print_log("CASE:2-6-5:" + key_array[29].to_s)
#      print_log("CASE:2-6-4:" + previous_state.func_tran_no.to_s)
      previous_state = state_hash.previous_state(key_array[22], "mock/mock_18")
      assert(previous_state.cntr_path == "mock/mock_18", "CASE:2-6-6")
      assert(previous_state.func_tran_no == 18, "CASE:2-6-6")
      assert(previous_state.sept_flg == true, "CASE:2-6-6")
      previous_state = state_hash.previous_state(key_array[23], "mock/mock_19")
      assert(previous_state.nil?, "CASE:2-6-4")
      previous_state = state_hash.previous_state(key_array[29], "mock/mock_23")
      assert(previous_state.nil?, "CASE:2-6-4")
      previous_state = state_hash.previous_state(key_array[29], "mock/mock_none")
      assert(previous_state.nil?, "CASE:2-6-6")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-6-5=>2-6-8")
    end
    # 正常終了（引数異常）
    begin
      # 遷移番号異常
      previous_state = state_hash.previous_state(31)
      assert(previous_state.nil?, "CASE:2-6-5")
      previous_state = state_hash.previous_state(-1)
      assert(previous_state.nil?, "CASE:2-6-5")
      previous_state = state_hash.previous_state(nil)
      assert(previous_state.nil?, "CASE:2-6-5")
      # コントローラーパス異常
      previous_state = state_hash.previous_state(key_array[20], "cntr_path_none")
      assert(previous_state.nil?, "CASE:2-6-6")
      previous_state = state_hash.previous_state(key_array[20], 100)
      assert(previous_state.nil?, "CASE:2-6-6")
      # 遷移番号・コントローラーパス異常
      previous_state = state_hash.previous_state(31, "cntr_path_none")
      assert(previous_state.nil?, "CASE:2-6-7")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-6-5=>2-6-7")
    end
    # 異常ケース
  end
  
  # テスト対象メソッド：new_state
  test "CASE:2-07 new_state" do
    # 正常ケース（前機能状態無し）
    begin
      key_array = Array.new
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      # 前機能状態無し、分離フラグ指定なし
      state = state_hash.new_state(mock_ctrl, nil)
      assert(!state.nil?, "CASE:2-7-1")
      assert(state.cntr_path == 'mock/mock_1', "CASE:2-7-1")
      assert(state.func_tran_no == 1, "CASE:2-7-1")
      assert(state.prev_tran_no.nil?, "CASE:2-7-1")
      assert(state.next_tran_no.nil?, "CASE:2-7-1")
      assert(state.sept_flg, "CASE:2-7-1")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-1")
      # 前機能状態無し、分離フラグオン
      state = state_hash.new_state(mock_ctrl, nil, true)
      assert(!state.nil?, "CASE:2-7-2")
      assert(state.cntr_path == 'mock/mock_1', "CASE:2-7-2")
      assert(state.func_tran_no == 2, "CASE:2-7-2")
      assert(state.prev_tran_no.nil?, "CASE:2-7-2")
      assert(state.next_tran_no.nil?, "CASE:2-7-2")
      assert(state.sept_flg, "CASE:2-7-2")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-2")
      # 前機能状態無し、分離フラグオフ
      state = state_hash.new_state(mock_ctrl, nil, false)
      assert(!state.nil?, "CASE:2-7-3")
      assert(state.cntr_path == 'mock/mock_1', "CASE:2-7-3")
      assert(state.func_tran_no == 3, "CASE:2-7-3")
      assert(state.prev_tran_no.nil?, "CASE:2-7-3")
      assert(state.next_tran_no.nil?, "CASE:2-7-3")
      assert(state.sept_flg, "CASE:2-7-3")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-3")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-1=>2-7-3")
    end
    # 正常ケース（前機能状態有り）
    begin
      key_array = Array.new
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      prev_state = state_hash.new_state(mock_ctrl, nil)
      # 前機能状態無し、分離フラグ指定なし
      state = state_hash.new_state(mock_ctrl, prev_state.func_tran_no)
      assert(!state.nil?, "CASE:2-7-4")
      assert(state.cntr_path == 'mock/mock_1', "CASE:2-7-4")
      assert(state.func_tran_no == 2, "CASE:2-7-4")
      assert(state.prev_tran_no == 1, "CASE:2-7-4")
      assert(state.next_tran_no.nil?, "CASE:2-7-4")
      assert(state.sept_flg == false, "CASE:2-7-4")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-4")
      # 前機能状態無し、分離フラグオン
      state = state_hash.new_state(mock_ctrl, prev_state.func_tran_no, true)
      assert(!state.nil?, "CASE:2-7-5")
      assert(state.cntr_path == 'mock/mock_1', "CASE:2-7-5")
      assert(state.func_tran_no == 3, "CASE:2-7-5")
      assert(state.prev_tran_no == 1, "CASE:2-7-5")
      assert(state.next_tran_no.nil?, "CASE:2-7-5")
      assert(state.sept_flg, "CASE:2-7-5")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-5")
      # 前機能状態無し、分離フラグオフ
      state = state_hash.new_state(mock_ctrl, prev_state.func_tran_no, false)
      assert(!state.nil?, "CASE:2-7-6")
      assert(state.cntr_path == 'mock/mock_1', "CASE:2-7-6")
      assert(state.func_tran_no == 4, "CASE:2-7-6")
      assert(state.prev_tran_no == 1, "CASE:2-7-6")
      assert(state.next_tran_no.nil?, "CASE:2-7-6")
      assert(state.sept_flg == false, "CASE:2-7-6")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-6")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-4=>2-7-6")
    end
    # 正常ケース（存在しない前機能遷移番号）
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      # 前機能状態無し、分離フラグオン
      assert(state_hash.new_state(mock_ctrl, 1, true).nil?, "CASE:2-7-7")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-7")
    end
    # 正常ケース（最大サイズオーバー）
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      (2..30).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        sept_flg = (idx%6)==0
        state = state_hash.new_state(mock_ctrl, idx-1, sept_flg)
        unless sept_flg then
          # 分離フラグオフ・末端の機能状態から遷移・最大サイズ以内
          assert(!state.nil?, "CASE:2-7-10")
        end
      end
      # 分離フラグオン
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_31', :session=>Hash.new})
      assert(state_hash.new_state(mock_ctrl, 1, true).nil?, "CASE:2-7-8")
      # 分離フラグオフ・末端の機能状態から遷移
      assert(state_hash.new_state(mock_ctrl, 30, false).nil?, "CASE:2-7-9")
      # 分離フラグオフ・途中の機能状態から遷移
      state = state_hash.new_state(mock_ctrl, 27, false)
#      print_log("CASE:2-7-9-1:" + state.func_tran_no.to_s)
      assert(!state.nil?, "CASE:2-7-9-1")
      assert(state_hash[28].nil?, "CASE:2-7-9-2")
      assert(state_hash[29].nil?, "CASE:2-7-9-3")
      assert(!state_hash[30].nil?, "CASE:2-7-9-4")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-8=>2-7-10")
    end
    # 正常ケース（機能状態の関連の更新）
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      (2..10).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, (idx%5)==0)
      end
#      print_log("CASE:2-7-11-1:" + state.func_tran_no.to_s)
      # 前機能状態：無し
      # 分離フラグ：オフ
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_11', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil, false)
      assert(!state.nil?, "CASE:2-7-11-1")
      assert(state.cntr_path == 'mock/mock_11', "CASE:2-7-11-2")
      assert(state.func_tran_no == 11, "CASE:2-7-11-3")
      assert(state.prev_tran_no.nil?, "CASE:2-7-11-4")
      assert(state.next_tran_no.nil?, "CASE:2-7-11-5")
      assert(state.sept_flg == true, "CASE:2-7-11-6")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-11-7")
#      print_log("CASE:2-7-11-2:" + state.func_tran_no.to_s)
      (1..10).each do |idx|
        state = state_hash[idx]
        assert(!state.nil?, "CASE:2-7-11-1")
        assert(state.cntr_path == 'mock/mock_' + idx.to_s, "CASE:2-7-11-2")
        assert(state.func_tran_no == idx, "CASE:2-7-11-3")
        if idx == 1 || idx == 11 then
          assert(state.prev_tran_no.nil?, "CASE:2-7-11-4")
          assert(state.sept_flg == true, "CASE:2-7-11-6")
        else
          assert(state.prev_tran_no == (idx-1), "CASE:2-7-11-4")
          assert(state.sept_flg == ((idx%5) == 0), "CASE:2-7-11-6")
        end
#      print_log("CASE:2-7-11-5:" + idx.to_s + ":" + state.next_tran_no.to_s)
        if idx == 10 || (idx+1)%5 == 0 then
          assert(state.next_tran_no.nil?, "CASE:2-7-11-5-1")
        else
          assert(state.next_tran_no == (idx+1), "CASE:2-7-11-5-2")
        end
        assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-11-7")
      end
      # 前機能状態：有り（分離ポイント、末端）
      # 分離フラグ：オン
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_12', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, 11, true)
#      print_log("CASE:2-7-12-1:" + state.func_tran_no.to_s)
      assert(!state.nil?, "CASE:2-7-12-1")
      assert(state.cntr_path == 'mock/mock_12', "CASE:2-7-12-2")
      assert(state.func_tran_no == 12, "CASE:2-7-12-3")
      assert(state.prev_tran_no == 11, "CASE:2-7-12-4")
      assert(state.next_tran_no.nil?, "CASE:2-7-12-5")
      assert(state.sept_flg == true, "CASE:2-7-12-6")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-12-7")
      assert(state == state_hash[12], "CASE:2-7-12-8")
#      print_log("CASE:2-7-12-2:" + state.func_tran_no.to_s)
      (1..10).each do |idx|
        state = state_hash[idx]
        assert(!state.nil?, "CASE:2-7-12-1")
        assert(state.cntr_path == 'mock/mock_' + idx.to_s, "CASE:2-7-12-2")
        assert(state.func_tran_no == idx, "CASE:2-7-12-3")
        if idx == 1 || idx == 11 then
          assert(state.prev_tran_no.nil?, "CASE:2-7-12-4")
          assert(state.sept_flg == true, "CASE:2-7-12-6")
        else
          assert(state.prev_tran_no == (idx-1), "CASE:2-7-12-4")
          assert(state.sept_flg == ((idx%5) == 0), "CASE:2-7-12-6")
        end
#      print_log("CASE:2-7-11-5:" + idx.to_s + ":" + state.next_tran_no.to_s)
        if idx == 10 || (idx+1)%5 == 0 then
          assert(state.next_tran_no.nil?, "CASE:2-7-12-5-1")
        else
          assert(state.next_tran_no == (idx+1), "CASE:2-7-12-5-2")
        end
        assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-12-7")
      end
#      print_log("CASE:2-7-12-3:" + state.func_tran_no.to_s)
      state = state_hash[11]
      assert(!state.nil?, "CASE:2-7-12-1")
      assert(state.cntr_path == 'mock/mock_11', "CASE:2-7-12-2")
      assert(state.func_tran_no == 11, "CASE:2-7-12-3")
      assert(state.prev_tran_no.nil?, "CASE:2-7-12-4")
      assert(state.next_tran_no.nil?, "CASE:2-7-12-5")
      assert(state.sept_flg == true, "CASE:2-7-12-6")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-12-7")
      # 前機能状態：有り（途中）
      # 分離フラグ：オフ
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_13', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, 7, false)
#      print_log("CASE:2-7-13-1:" + state.func_tran_no.to_s)
      assert(!state.nil?, "CASE:2-7-13-1")
      assert(state.cntr_path == 'mock/mock_13', "CASE:2-7-13-2")
      assert(state.func_tran_no == 13, "CASE:2-7-13-3")
      assert(state.prev_tran_no == 7, "CASE:2-7-13-4")
      assert(state.next_tran_no.nil?, "CASE:2-7-13-5")
      assert(state.sept_flg == false, "CASE:2-7-13-6")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-13-7")
      assert(state == state_hash[13], "CASE:2-7-13-8")
      # 前機能状態
      state = state_hash[7]
#      print_log("CASE:2-7-13-2:" + state.func_tran_no.to_s)
      assert(!state.nil?, "CASE:2-7-13-1")
      assert(state.cntr_path == 'mock/mock_7', "CASE:2-7-13-2")
      assert(state.func_tran_no == 7, "CASE:2-7-13-3")
      assert(state.prev_tran_no == 6, "CASE:2-7-13-4")
      assert(state.next_tran_no == 13, "CASE:2-7-13-5")
      assert(state.sept_flg == false, "CASE:2-7-13-6")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-13-7")
#      print_log("CASE:2-7-13-3:" + state.func_tran_no.to_s)
      # 削除済み確認
      (8..9).each do |idx|
        state = state_hash[idx]
        assert(state.nil?, "CASE:2-7-13-1")
      end
#      print_log("CASE:2-7-13-4:")
      # 分離ポイントが削除されていない事を確認
      assert(!state_hash[11].nil?, "CASE:2-7-13-1")
      assert(!state_hash[12].nil?, "CASE:2-7-13-1")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-11=>2-7-13")
    end
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      (2..10).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, (idx%5)==0)
      end
      # 前機能状態：有り（途中）
      # 分離フラグ：オン
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_11', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, 2, true)
#      print_log("CASE:2-7-14-1:" + state.func_tran_no.to_s)
      assert(!state.nil?, "CASE:2-7-14-1")
      assert(state.cntr_path == 'mock/mock_11', "CASE:2-7-14-2")
      assert(state.func_tran_no == 11, "CASE:2-7-14-3")
      assert(state.prev_tran_no == 2, "CASE:2-7-14-4")
      assert(state.next_tran_no.nil?, "CASE:2-7-14-5")
      assert(state.sept_flg == true, "CASE:2-7-14-6")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-14-7")
      assert(state == state_hash[11], "CASE:2-7-14-8")
#      print_log("CASE:2-7-14-2:" + state.func_tran_no.to_s)
      (1..10).each do |idx|
        state = state_hash[idx]
        assert(!state.nil?, "CASE:2-7-14-1")
        assert(state.cntr_path == 'mock/mock_' + idx.to_s, "CASE:2-7-14-2")
        assert(state.func_tran_no == idx, "CASE:2-7-14-3")
#      print_log("CASE:2-7-14-4:" + idx.to_s + ":" + state.prev_tran_no.to_s)
        if idx == 1 then
          assert(state.prev_tran_no.nil?, "CASE:2-7-14-4-1")
        else
          assert(state.prev_tran_no == (idx-1), "CASE:2-7-14-4-2")
        end
        assert(state.sept_flg == (idx==1 || idx==5 || idx==10), "CASE:2-7-14-6")
#      print_log("CASE:2-7-14-5:" + idx.to_s + ":" + state.next_tran_no.to_s)
        if idx == 4 || idx == 9 || idx == 10 then
          assert(state.next_tran_no.nil?, "CASE:2-7-14-5-1")
        else
          assert(state.next_tran_no == (idx+1), "CASE:2-7-14-5-2")
        end
        assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-14-7")
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-14")
    end
    # コントローラーの生成メソッドで生成
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      (2..10).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, false)
      end
      mock_ctrl = SubController.new({:controller_path => 'mock/mock_11', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, 2, true)
      assert(SubFunctionState === state, "CASE:2-7-15-1")
      assert(state.cntr_path == 'mock/mock_11', "CASE:2-7-15-2")
      assert(state.func_tran_no == 11, "CASE:2-7-15-3")
      assert(state.prev_tran_no == 2, "CASE:2-7-15-4")
      assert(state.next_tran_no.nil?, "CASE:2-7-15-5")
      assert(state.sept_flg == true, "CASE:2-7-15-6")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-7-15-7")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-15")
    end
  end
  
  # テスト対象メソッド：replace_state
  test "CASE:2-08 replace_state" do
    # 正常ケース（パラメータチェック）
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      (2..10).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, (idx%5)==0)
      end
      # 置換対象の機能遷移番号：nil
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_nil', :session=>Hash.new})
      state = state_hash.replace_state(mock_ctrl, nil)
      assert(state.nil?, "CASE:2-8-1")
      # 置換対象の機能遷移番号：存在しない番号
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_11', :session=>Hash.new})
      state = state_hash.replace_state(mock_ctrl, 11)
      assert(state.nil?, "CASE:2-8-2")
#      print_log("CASE:2-8-2:" + state.func_tran_no.to_s)
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-1=>2-8-2")
    end
    # 正常ケース（置換箇所によるパターン）
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      (2..10).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, false)
      end
      # 置換対象：末端
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_11', :session=>Hash.new})
      before_state = state_hash[10]
#      print_log("CASE:2-8-3:1:" + state.prev_tran_no.to_s)
      state = state_hash.replace_state(mock_ctrl, 10)
      assert(!state.nil?, "CASE:2-8-3-1")
      assert(state.cntr_path == 'mock/mock_11', "CASE:2-8-3-2")
      assert(state.func_tran_no == 11, "CASE:2-8-3-3")
      assert(state.prev_tran_no == before_state.prev_tran_no, "CASE:2-8-3-4")
      assert(state.next_tran_no == before_state.next_tran_no, "CASE:2-8-3-5")
      assert(state.sept_flg == before_state.sept_flg, "CASE:2-8-3-6")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-8-3-7")
#      print_log("CASE:2-8-3:2:" + state.prev_tran_no.to_s)
      (1..9).each do |idx|
        state = state_hash[idx]
        assert(!state.nil?, "CASE:2-8-3-8")
        assert(state.cntr_path == 'mock/mock_' + idx.to_s, "CASE:2-8-3-8")
        assert(state.func_tran_no == idx, "CASE:2-8-3-9")
#      print_log("CASE:2-8-2-4:" + idx.to_s + ":" + state.prev_tran_no.to_s)
        if idx == 1 then
          assert(state.prev_tran_no.nil?, "CASE:2-8-3-10")
          assert(state.sept_flg, "CASE:2-8-3-11")
        else
          assert(state.prev_tran_no == (idx-1), "CASE:2-8-3-10")
          assert(!state.sept_flg, "CASE:2-8-3-11")
        end
#      print_log("CASE:2-8-2-5:" + idx.to_s + ":" + state.next_tran_no.to_s)
        if idx == 9 then
          assert(state.next_tran_no == 11, "CASE:2-8-3-12")
        else
          assert(state.next_tran_no == (idx+1), "CASE:2-8-3-12")
        end
        assert(state.sync_tkn.split(//).length == 40, "CASE:2-8-3-13")
      end
#      print_log("CASE:2-8-4:1:" + state.prev_tran_no.to_s)
      # 置換対象：途中
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_12', :session=>Hash.new})
      new_state = state_hash.new_state(mock_ctrl, 5, true)
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_13', :session=>Hash.new})
      before_state = state_hash[7]
      state = state_hash.replace_state(mock_ctrl, 7)
      assert(!state.nil?, "CASE:2-8-4-1")
      assert(state.cntr_path == 'mock/mock_13', "CASE:2-8-4-2")
      assert(state.func_tran_no == 13, "CASE:2-8-4-3")
      assert(state.prev_tran_no == before_state.prev_tran_no, "CASE:2-8-4-4")
      assert(state.next_tran_no.nil?, "CASE:2-8-4-5")
      assert(state.sept_flg == before_state.sept_flg, "CASE:2-8-4-6")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-8-4-7")
#      print_log("CASE:2-8-4:2:" + state.func_tran_no.to_s)
      (1..6).each do |idx|
        state = state_hash[idx]
        assert(!state.nil?, "CASE:2-8-4-8")
        assert(state.cntr_path == 'mock/mock_' + idx.to_s, "CASE:2-8-4-8")
        assert(state.func_tran_no == idx, "CASE:2-8-4-9")
#      print_log("CASE:2-8-4:3:" + idx.to_s + ":" + state.prev_tran_no.to_s)
        if idx == 1 then
          assert(state.prev_tran_no.nil?, "CASE:2-8-4-10")
          assert(state.sept_flg, "CASE:2-8-4-11")
        else
          assert(state.prev_tran_no == (idx-1), "CASE:2-8-4-10")
          assert(!state.sept_flg, "CASE:2-8-4-11")
        end
#      print_log("CASE:2-8-4:4:" + idx.to_s + ":" + state.next_tran_no.to_s)
        if idx == 6 then
          assert(state.next_tran_no == 13, "CASE:2-8-4-12-1")
        else
          assert(state.next_tran_no == (idx+1), "CASE:2-8-4-12-2")
        end
        assert(state.sync_tkn.split(//).length == 40, "CASE:2-8-4-13")
      end
#      print_log("CASE:2-8-4:5:" + state.prev_tran_no.to_s)
      # 置き換えた先が削除されている事を確認
      assert(state_hash[7].nil?, "CASE:2-8-4-14")
      assert(state_hash[8].nil?, "CASE:2-8-4-14")
      assert(state_hash[9].nil?, "CASE:2-8-4-14")
      assert(state_hash[10].nil?, "CASE:2-8-4-14")
      assert(state_hash[11].nil?, "CASE:2-8-4-14")
      assert(!state_hash[12].nil?, "CASE:2-8-4-15")
      assert(state_hash[12] == new_state, "CASE:2-8-4-15")
      # 分離ポイントとして起動された状態が削除されていない事を確認
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-3=>2-8-4")
    end
    # コントローラーの生成メソッドで生成して置換
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      (2..10).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, false)
      end
      mock_ctrl = SubController.new({:controller_path => 'mock/mock_11', :session=>Hash.new})
      state = state_hash.replace_state(mock_ctrl, 7)
      assert(SubFunctionState === state, "CASE:2-8-5-1")
      assert(state.cntr_path == 'mock/mock_11', "CASE:2-8-5-2")
      assert(state.func_tran_no == 11, "CASE:2-8-5-3")
      assert(state.prev_tran_no == 6, "CASE:2-8-5-4")
      assert(state.next_tran_no.nil?, "CASE:2-8-5-5")
      assert(state.sept_flg == false, "CASE:2-8-5-6")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-8-5-7")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-5")
    end
  end
  
  # テスト対象メソッド：delete?
  test "CASE:2-09 delete?" do
    # 正常ケース
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      (2..10).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, false)
      end
      #########################################################################
      # 削除対象：末端
      #########################################################################
#      print_log("CASE:2-9-1:1:")
      assert(state_hash.delete?(10), "CASE:2-9-1")
      assert(state_hash[10].nil?, "CASE:2-9-1")
#      print_log("CASE:2-9-1:2:")
      (1..9).each do |idx|
        state = state_hash[idx]
        assert(!state.nil?, "CASE:2-9-1-2")
        assert(state.cntr_path == 'mock/mock_' + idx.to_s, "CASE:2-9-1-3")
        assert(state.func_tran_no == idx, "CASE:2-9-1-4")
        if idx == 1 then
          assert(state.prev_tran_no.nil?, "CASE:2-9-1-5")
          assert(state.sept_flg, "CASE:2-9-1-6")
        else
          assert(state.prev_tran_no == (idx-1), "CASE:2-9-1-7")
          assert(!state.sept_flg, "CASE:2-9-1-8")
        end
#      print_log("CASE:2-9-1:3:" + state.next_tran_no.to_s)
        if idx == 9 then
          assert(state.next_tran_no.nil?, "CASE:2-9-1-9")
        else
          assert(state.next_tran_no == (idx+1), "CASE:2-9-1-10")
        end
        assert(state.sync_tkn.split(//).length == 40, "CASE:2-9-1-11")
      end
#      print_log("CASE:2-9-1:4:" + state.next_tran_no.to_s)
      #########################################################################
      # 削除対象：途中
      #########################################################################
#      print_log("CASE:2-9-2:1:")
      assert(state_hash.delete?(7), "CASE:2-9-2")
      assert(state_hash[7].nil?, "CASE:2-9-2")
#      print_log("CASE:2-9-2:2:")
      (1..6).each do |idx|
        state = state_hash[idx]
        assert(!state.nil?, "CASE:2-9-2-2")
        assert(state.cntr_path == 'mock/mock_' + idx.to_s, "CASE:2-9-2-3")
        assert(state.func_tran_no == idx, "CASE:2-9-2-4")
        if idx == 1 then
          assert(state.prev_tran_no.nil?, "CASE:2-9-2-5")
          assert(state.sept_flg, "CASE:2-9-2-6")
        else
          assert(state.prev_tran_no == (idx-1), "CASE:2-9-2-7")
          assert(!state.sept_flg, "CASE:2-9-2-8")
        end
#      print_log("CASE:2-9-2:3:" + state.next_tran_no.to_s)
        if idx == 6 then
          assert(state.next_tran_no.nil?, "CASE:2-9-2-9")
        else
          assert(state.next_tran_no == (idx+1), "CASE:2-9-2-10")
        end
        assert(state.sync_tkn.split(//).length == 40, "CASE:2-9-2-11")
      end
      assert(state_hash[8].nil?, "CASE:2-9-2-12")
      assert(state_hash[9].nil?, "CASE:2-9-2-13")
#      print_log("CASE:2-9-2:4:")
      #########################################################################
      # 削除対象：存在しない遷移番号
      #########################################################################
#      print_log("CASE:2-9-3:1:")
      assert(!state_hash.delete?(7), "CASE:2-9-3")
      assert(state_hash[7].nil?, "CASE:2-9-3")
#      print_log("CASE:2-9-3:2:")
      (1..6).each do |idx|
        state = state_hash[idx]
        assert(!state.nil?, "CASE:2-9-3-2")
        assert(state.cntr_path == 'mock/mock_' + idx.to_s, "CASE:2-9-3-3")
        assert(state.func_tran_no == idx, "CASE:2-9-3-4")
        if idx == 1 then
          assert(state.prev_tran_no.nil?, "CASE:2-9-3-5")
          assert(state.sept_flg, "CASE:2-9-3-6")
        else
          assert(state.prev_tran_no == (idx-1), "CASE:2-9-3-7")
          assert(!state.sept_flg, "CASE:2-9-3-8")
        end
#      print_log("CASE:2-9-3:3:" + state.next_tran_no.to_s)
        if idx == 6 then
          assert(state.next_tran_no.nil?, "CASE:2-9-3-9")
        else
          assert(state.next_tran_no == (idx+1), "CASE:2-9-3-10")
        end
        assert(state.sync_tkn.split(//).length == 40, "CASE:2-9-3-11")
      end
#      print_log("CASE:2-9-3:4:")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-9-1=>2-9-3")
    end
  end

  # テスト対象メソッド：delete_history?
  test "CASE:2-10 delete_history?" do
    # 正常ケース（戻る先の遷移番号指定）
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      (2..10).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, false)
      end
      #########################################################################
      # 起点の遷移番号：末端
      # 戻る先の遷移番号：途中
      #########################################################################
      assert(state_hash.delete_history?(10, 7), "CASE:2-10-1-1")
      (1..7).each do |idx|
        state = state_hash[idx]
        assert(!state.nil?, "CASE:2-10-1-2")
        assert(state.cntr_path == 'mock/mock_' + idx.to_s, "CASE:2-10-1-3")
        assert(state.func_tran_no == idx, "CASE:2-10-1-4")
        if idx == 1 then
          assert(state.prev_tran_no.nil?, "CASE:2-10-1-5")
          assert(state.sept_flg, "CASE:2-10-1-6")
        else
          assert(state.prev_tran_no == (idx-1), "CASE:2-10-1-7")
          assert(!state.sept_flg, "CASE:2-10-1-8")
        end
#      print_log("CASE:2-10-1:3:" + state.next_tran_no.to_s)
        if idx == 7 then
          assert(state.next_tran_no.nil?, "CASE:2-10-1-9")
        else
          assert(state.next_tran_no == (idx+1), "CASE:2-10-1-10")
        end
        assert(state.sync_tkn.split(//).length == 40, "CASE:2-10-1-11")
      end
      assert(state_hash[8].nil?, "CASE:2-10-1-12")
      assert(state_hash[9].nil?, "CASE:2-10-1-13")
      assert(state_hash[10].nil?, "CASE:2-10-1-14")
      #########################################################################
      # 起点の遷移番号：途中
      # 戻る先の遷移番号：途中
      #########################################################################
      assert(state_hash.delete_history?(6, 3), "CASE:2-10-2-1")
      (1..3).each do |idx|
        state = state_hash[idx]
        assert(!state.nil?, "CASE:2-10-2-2")
        assert(state.cntr_path == 'mock/mock_' + idx.to_s, "CASE:2-10-2-3")
        assert(state.func_tran_no == idx, "CASE:2-10-2-4")
        if idx == 1 then
          assert(state.prev_tran_no.nil?, "CASE:2-10-2-5")
          assert(state.sept_flg, "CASE:2-10-2-6")
        else
          assert(state.prev_tran_no == (idx-1), "CASE:2-10-2-7")
          assert(!state.sept_flg, "CASE:2-10-2-8")
        end
#      print_log("CASE:2-10-2:3:" + state.next_tran_no.to_s)
        if idx == 3 then
          assert(state.next_tran_no.nil?, "CASE:2-10-2-9")
        else
          assert(state.next_tran_no == (idx+1), "CASE:2-10-2-10")
        end
        assert(state.sync_tkn.split(//).length == 40, "CASE:2-10-2-11")
      end
      assert(state_hash[4].nil?, "CASE:2-10-2-12")
      assert(state_hash[5].nil?, "CASE:2-10-2-13")
      assert(state_hash[6].nil?, "CASE:2-10-2-14")
      assert(state_hash[7].nil?, "CASE:2-10-2-15")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-10-1=>2-10-2")
    end
    # 正常ケース（戻る先の遷移番号指定、戻る先の分離フラグオン）
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path=>'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      mock_ctrl = MockController.new({:controller_path=>'mock/mock_2', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, 1)
      mock_ctrl = MockController.new({:controller_path=>'mock/mock_3', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, 2, true)
      (4..10).each do |idx|
        mock_ctrl = MockController.new({:controller_path=>'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, false)
      end
      #########################################################################
      # 起点の遷移番号：先頭
      # 戻る先の遷移番号：途中（分離フラグ）
      #########################################################################
      assert(state_hash.delete_history?(8, 3), "CASE:2-10-3-1")
      state = state_hash[3]
      assert(FunctionState === state, "CASE:2-10-3-2")
      assert(state.cntr_path == 'mock/mock_3', "CASE:2-10-3-3")
      assert(state.func_tran_no == 3, "CASE:2-10-3-4")
      assert(state.prev_tran_no == 2, "CASE:2-10-3-5")
      assert(state.next_tran_no.nil?, "CASE:2-10-3-6")
      assert(state.sept_flg == true, "CASE:2-10-3-7")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-10-3-8")
      # 戻る先の機能状態以前の判定
      state = state_hash[1]
      assert(FunctionState === state, "CASE:2-10-3-9")
      assert(state.cntr_path == 'mock/mock_1', "CASE:2-10-3-9")
      assert(state.func_tran_no == 1, "CASE:2-10-3-9")
      assert(state.prev_tran_no.nil?, "CASE:2-10-3-9")
      assert(state.next_tran_no == 2, "CASE:2-10-3-9")
      assert(state.sept_flg == true, "CASE:2-10-3-9")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-10-3-9")
      state = state_hash[2]
      assert(FunctionState === state, "CASE:2-10-3-9")
      assert(state.cntr_path == 'mock/mock_2', "CASE:2-10-3-9")
      assert(state.func_tran_no == 2, "CASE:2-10-3-9")
      assert(state.prev_tran_no == 1, "CASE:2-10-3-9")
      assert(state.next_tran_no.nil?, "CASE:2-10-3-9")
      assert(state.sept_flg == false, "CASE:2-10-3-9")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-10-3-9")
      # 戻る先の機能状態以降の判定
      (4..10).each do |idx|
        assert(state_hash[idx].nil?, "CASE:2-10-3-10")
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-10-3")
    end
    # 正常ケース（戻る先の遷移番号未指定、戻る先の分離フラグオン）
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_2', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, 1)
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_3', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, 2, true)
      (4..10).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, false)
      end
      #########################################################################
      # 起点の遷移番号：先頭
      # 戻る先の遷移番号：途中（分離フラグ）
      #########################################################################
      assert(state_hash.delete_history?(8), "CASE:2-10-4-1")
      # 戻る先の機能状態以前の判定
      state = state_hash[1]
      assert(FunctionState === state, "CASE:2-10-4-9")
      assert(state.cntr_path == 'mock/mock_1', "CASE:2-10-4-9")
      assert(state.func_tran_no == 1, "CASE:2-10-4-9")
      assert(state.prev_tran_no.nil?, "CASE:2-10-4-9")
      assert(state.next_tran_no == 2, "CASE:2-10-4-9")
      assert(state.sept_flg == true, "CASE:2-10-4-9")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-10-4-9")
      state = state_hash[2]
      assert(FunctionState === state, "CASE:2-10-4-9")
      assert(state.cntr_path == 'mock/mock_2', "CASE:2-10-4-9")
      assert(state.func_tran_no == 2, "CASE:2-10-4-9")
      assert(state.prev_tran_no == 1, "CASE:2-10-4-9")
      assert(state.next_tran_no.nil?, "CASE:2-10-4-9")
      assert(state.sept_flg == false, "CASE:2-10-4-9")
      assert(state.sync_tkn.split(//).length == 40, "CASE:2-10-4-9")
      # 戻る先の機能状態以降の判定
      (3..10).each do |idx|
        assert(state_hash[idx].nil?, "CASE:2-10-4-10")
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-10-4")
    end
    # 正常ケース（パラメータチェック）
    begin
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_2', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, 1)
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_3', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, 2, true)
      (4..10).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, false)
      end
      #########################################################################
      # 機能遷移番号：存在しない値
      # 戻る先の遷移番号：指定しない
      #########################################################################
      assert(!state_hash.delete_history?(100), "CASE:2-10-5-1")
      (1..10).each do |idx|
        assert(!state_hash[idx].nil?, "CASE:2-10-5-2")
      end
      #########################################################################
      # 機能遷移番号：存在する値
      # 戻る先の遷移番号：存在する値（分離フラグ以前）
      #########################################################################
      assert(!state_hash.delete_history?(10, 1), "CASE:2-10-6-1")
      (1..10).each do |idx|
        assert(!state_hash[idx].nil?, "CASE:2-10-6-2")
      end
      #########################################################################
      # 機能遷移番号：存在する値
      # 戻る先の遷移番号：存在する値（起点と同値）
      #########################################################################
      assert(!state_hash.delete_history?(10, 10), "CASE:2-10-7-1")
      (1..10).each do |idx|
        assert(!state_hash[idx].nil?, "CASE:2-10-7-2")
      end
      #########################################################################
      # 機能遷移番号：存在する値
      # 戻る先の遷移番号：存在しない値（起点以降）
      #########################################################################
      assert(!state_hash.delete_history?(10, 11), "CASE:2-10-8-1")
      (1..10).each do |idx|
        assert(!state_hash[idx].nil?, "CASE:2-10-8-2")
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-10-4=>2-10-8")
    end
    # 異常ケース
  end
  
  # テスト対象メソッド：delete_all
  test "CASE:2-11 delete_all" do
    begin
      key_array = Array.new
      state_hash = FunctionStateHash.new
      mock_ctrl = MockController.new({:controller_path => 'mock/mock_1', :session=>Hash.new})
      state = state_hash.new_state(mock_ctrl, nil)
      key_array.push(state.func_tran_no)
      (2..10).each do |idx|
        mock_ctrl = MockController.new({:controller_path => 'mock/mock_' + idx.to_s, :session=>Hash.new})
        state = state_hash.new_state(mock_ctrl, idx-1, false)
        key_array.push(state.func_tran_no)
      end
      state_hash.delete_all
      key_array.each do |key|
        assert(state_hash[key].nil?, "CASE:2-11-1")
      end
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-11-1")
    end
    # 異常ケース
  end
  # 機能状態
  class SubFunctionState < FunctionState
    # アクセスメソッド定義
    attr_reader :cntr_path, :func_tran_no, :prev_tran_no, :sept_flg, :sync_tkn
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期化メソッド
    def initialize(cntr_path, func_tran_no, prev_tran_no, sept_flg=false)
      super(cntr_path, func_tran_no, prev_tran_no, sept_flg)
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
    def create_function_state(cntr_path, new_trans_no, prev_trans_no, sept_flg)
      return SubFunctionState.new(cntr_path, new_trans_no, prev_trans_no, sept_flg)
    end
  end
  # コントローラー（エラー）
  class ErrorController < MockController
    ##########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize(method)
      super(method)
    end
    # 機能状態生成処理
    def create_function_state(cntr_path, new_trans_no, prev_trans_no, sept_flg)
      return SubFunctionState.new(cntr_path, new_trans_no, prev_trans_no, sept_flg)
    end
  end
end