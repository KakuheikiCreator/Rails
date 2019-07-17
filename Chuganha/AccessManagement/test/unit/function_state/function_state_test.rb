# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：機能状態クラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/03 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'function_state/function_state'

class FunctionStateTest < ActiveSupport::TestCase
  include FunctionState

  # テスト対象メソッド：initialize
  test "CASE:2-1 initialize" do
    # 正常ケース
    state = FunctionState.new("cntr_path", 1, 0, true)
    assert(!state.nil?, "CASE:2-1-1")
    assert(state.cntr_path == "cntr_path", "CASE:2-1-1")
    assert(state.func_tran_no == 1, "CASE:2-1-1")
    assert(state.prev_tran_no == 0, "CASE:2-1-1")
    assert(state.next_tran_no.nil?, "CASE:2-1-1")
    assert(state.sept_flg == true, "CASE:2-1-1")
    assert(state.sync_tkn.length == 40, "CASE:2-1-1")
    # 異常ケース
    begin
      inst = FunctionState.new("cntr_path", 1)
      flunk("CASE:2-1-2")
    rescue ArgumentError
      assert(true, "CASE:2-1-2")
    end
    begin
      inst = FunctionState.new("cntr_path")
      flunk("CASE:2-1-3")
    rescue ArgumentError
      assert(true, "CASE:2-1-3")
    end
    begin
      inst = FunctionState.new
      flunk("CASE:2-1-4")
    rescue ArgumentError
      assert(true, "CASE:2-1-4")
    end
  end

  # テスト対象メソッド：accessor
  test "CASE:2-2 accessor" do
    # 正常ケース
    obj = FunctionState.new("cntr_path", 1000, 2, true)
    assert_equal(obj.cntr_path, "cntr_path", "CASE:2-2-1")
    assert_equal(obj.func_tran_no, 1000, "CASE:2-2-2")
    assert_equal(obj.prev_tran_no, 2, "CASE:2-2-3")
    assert_equal(obj.next_tran_no, nil, "CASE:2-2-4-1")
    assert_equal(obj.sept_flg, true, "CASE:2-2-5")
    assert_equal(obj.sync_tkn.length, 40, "CASE:2-2-6")
    # 異常ケース
    begin
      obj.cntr_path = "test"
      flunk("CASE:2-2-1")
    rescue NoMethodError
      assert(true, "CASE:2-2-1")
    end
    begin
      obj.func_tran_no = 123
      flunk("CASE:2-2-2")
    rescue NoMethodError
      assert(true, "CASE:2-2-2")
    end
    begin
      obj.prev_tran_no = 456
      flunk("CASE:2-2-3")
    rescue NoMethodError
      assert(true, "CASE:2-2-3")
    end
    begin
      obj.next_tran_no = 321
      assert(obj.next_tran_no == 321, "CASE:2-2-4-2")
    rescue NoMethodError
      flunk("CASE:2-2-4-2")
    end
    begin
      obj.sept_flg = false
      flunk("CASE:2-2-5")
    rescue NoMethodError
      assert(true, "CASE:2-2-5")
    end
    begin
      obj.sync_tkn = 'token'
      flunk("CASE:2-2-6")
    rescue NoMethodError
      assert(true, "CASE:2-2-6")
    end
  end

  # テスト対象メソッド：update_token
  test "CASE:2-3 update_token" do
    # 正常ケース
    obj = FunctionState.new("cntr_path", 1000, 2, false)
    # テスト
    before_token = obj.sync_tkn
    sleep(0.001)
    obj.update_token
    assert_equal(obj.sync_tkn.length, 40, "CASE:2-3-1")
    assert(obj.sync_tkn != before_token, "CASE:2-3-1")
    # 再テスト
    before_token = obj.sync_tkn
    sleep(0.001)
    obj.update_token
    assert_equal(obj.sync_tkn.length, 40, "CASE:2-3-1")
    assert(obj.sync_tkn != before_token, "CASE:2-3-1")
  end
end