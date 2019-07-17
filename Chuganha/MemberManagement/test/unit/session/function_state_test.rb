require 'test_helper'
require 'session/function_state'

###############################################################################
# ユニットテストクラス
# テスト対象：機能状態クラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/07/10 Nakanohito
# 更新日:
###############################################################################
class FunctionStateTest < ActiveSupport::TestCase
  include Session

  # テスト対象メソッド：initialize
  test "CASE:2-1 initialize" do
    # 正常ケース
    assert(FunctionState.new("function_id", 1000, 2), "CASE:2-1-1")
    assert(FunctionState.new("function_id", 1000), "CASE:2-1-2")
    assert(FunctionState.new("function_id"), "CASE:2-1-3")
    # 異常ケース
    begin
      inst = Session::FunctionState.new
      flunk("CASE:2-1-4")
    rescue ArgumentError
      assert(true, "CASE:2-1-4")
    end
  end

  # テスト対象メソッド：accessor
  test "CASE:2-2 accessor" do
    # 正常ケース
    obj = FunctionState.new("function_id", 1000, 2)
    assert_equal(obj.function_id, "function_id", "CASE:2-2-1")
    assert_equal(obj.function_transition_no, 1000, "CASE:2-2-2")
    assert_equal(obj.transaction_no, 2, "CASE:2-2-3")
    obj.transaction_no = 20
    assert_equal(obj.transaction_no, 20, "CASE:2-2-3")
    # 異常ケース
    begin
      obj.function_id = "test"
      flunk("CASE:2-2-1")
    rescue NoMethodError
      assert(true, "CASE:2-2-1")
    end
    begin
      obj.function_transition_no = 123
      flunk("CASE:2-2-2")
    rescue NoMethodError
      assert(true, "CASE:2-2-2")
    end
  end
end