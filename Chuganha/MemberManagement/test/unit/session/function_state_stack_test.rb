require 'test_helper'
require 'session/function_state'
require 'session/function_state_stack'

###############################################################################
# ユニットテストクラス
# テスト対象：機能状態スタッククラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/07/10 Nakanohito
# 更新日:
###############################################################################
class FunctionStateStackTest < ActiveSupport::TestCase
  include Session

  # テスト対象メソッド：initialize
  test "CASE:2-1 initialize" do
    # 正常ケース
    assert(FunctionStateStack.new(10), "CASE:2-1-1")
    # 異常ケース
    begin
      FunctionStateStack.new
      flunk("CASE:2-1-2")
    rescue ArgumentError
      assert(true, "CASE:2-1-2")
    end
  end

  # テスト対象メソッド：push?
  test "CASE:2-2 push?" do
    # 正常ケース
    stack = FunctionStateStack.new(5)
    assert(stack.push?(FunctionState.new("function_id_1")), "CASE:2-2-1")
    assert(stack.push?(FunctionState.new("function_id_2")), "CASE:2-2-1")
    assert(stack.push?(FunctionState.new("function_id_3")), "CASE:2-2-1")
    assert(stack.push?(FunctionState.new("function_id_4")), "CASE:2-2-1")
    assert(stack.push?(FunctionState.new("function_id_5")), "CASE:2-2-1")
    assert_equal(stack.push?(FunctionState.new("function_id_6")), false, "CASE:2-2-2")
    # 異常ケース
    begin
      stack.clear
      stack.push?("String")
      flunk("CASE:2-2-3")
    rescue ArgumentError
      assert(true, "CASE:2-2-3")
    end
  end

  # テスト対象メソッド：pop
  test "CASE:2-3 pop" do
    # 正常ケース
    stack = FunctionStateStack.new(3)
    state_1 = FunctionState.new("function_id_1")
    state_2 = FunctionState.new("function_id_2")
    state_3 = FunctionState.new("function_id_3")
    stack.push?(state_1)
    stack.push?(state_2)
    stack.push?(state_3)
    assert_equal(stack.pop, state_3, "CASE:2-3-1")
    assert_equal(stack.pop("function_id_1"), state_1, "CASE:2-3-2")
    # 異常ケース
    stack.clear
    begin
      stack.pop
      flunk("CASE:2-3-3")
    rescue RuntimeError => ex
      assert_equal(ex.message, "Empty Stack Error", "CASE:2-3-3")
    end
    stack.clear
    stack.push?(state_1)
    stack.push?(state_2)
    stack.push?(state_3)
    begin
      stack.pop("function_id_5")
      flunk("CASE:2-3-4")
    rescue RuntimeError => ex
      assert_equal(ex.message, "No target data Error", "CASE:2-3-4")
    end
  end

  # テスト対象メソッド：top
  test "CASE:2-4 top" do
    # 正常ケース
    stack = FunctionStateStack.new(3)
    state_1 = FunctionState.new("function_id_1")
    state_2 = FunctionState.new("function_id_2")
    state_3 = FunctionState.new("function_id_3")
    stack.push?(state_1)
    stack.push?(state_2)
    stack.push?(state_3)
    assert_equal(stack.top, state_3, "CASE:2-4-1")
    stack.clear
    assert_equal(stack.top, nil, "CASE:2-4-2")
    # 異常ケース
  end

  # テスト対象メソッド：clear
  test "CASE:2-5 clear" do
    # 正常ケース
    stack = FunctionStateStack.new(3)
    state_1 = FunctionState.new("function_id_1")
    state_2 = FunctionState.new("function_id_2")
    state_3 = FunctionState.new("function_id_3")
    stack.push?(state_1)
    stack.push?(state_2)
    stack.push?(state_3)
    assert_equal(stack.size, 3, "CASE:2-5-1")
    stack.clear
    assert_equal(stack.size, 0, "CASE:2-5-1")
    # 異常ケース
  end

  # テスト対象メソッド：size
  test "CASE:2-6 size" do
    # 正常ケース
    stack = FunctionStateStack.new(3)
    assert_equal(stack.size, 0, "CASE:2-6-1")
    state_1 = FunctionState.new("function_id_1")
    state_2 = FunctionState.new("function_id_2")
    state_3 = FunctionState.new("function_id_3")
    stack.push?(state_1)
    stack.push?(state_2)
    stack.push?(state_3)
    assert_equal(stack.size, 3, "CASE:2-6-1")
    stack.pop
    assert_equal(stack.size, 2, "CASE:2-6-1")
    # 異常ケース
  end

  # テスト対象メソッド：attr_accessor
  test "CASE:2-7 attr_accessor" do
    # 正常ケース
    stack = FunctionStateStack.new(3)
    assert_equal(stack.stack_max_size, 3, "CASE:2-7-1")
    stack.stack_max_size = 5
    assert_equal(stack.stack_max_size, 5, "CASE:2-7-2")
    # 異常ケース
  end
end