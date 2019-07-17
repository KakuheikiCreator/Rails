# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ログフォーマッター
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/06/30 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'test_helper'

class LogFormatterTest < ActiveSupport::TestCase
  include Common

  # テスト対象メソッド：blank?
  test "CASE:2-1 formatter" do
    # 正常ケース
    formatter = LogFormatter.new
    today = Date.today
    debug_msg = formatter.call("DEBUG", Date.new(2011, 7, 7), "ProgramName","TEST MESSAGE")
    assert_equal(debug_msg, "[2011-07-07 00:00:00] DEBUG:ProgramName: TEST MESSAGE\n","CASE:2-1-1")
    info_msg = formatter.call("INFO", Date.new(2011, 7, 7), "ProgramName","TEST MESSAGE")
    assert_equal(info_msg, "[2011-07-07 00:00:00] INFO :ProgramName: TEST MESSAGE\n","CASE:2-1-2")
    warn_msg = formatter.call("WARN", Date.new(2011, 7, 7), "ProgramName","TEST MESSAGE")
    assert_equal(warn_msg, "[2011-07-07 00:00:00] WARN :ProgramName: TEST MESSAGE\n","CASE:2-1-3")
    error_msg = formatter.call("ERROR", Date.new(2011, 7, 7), "ProgramName","TEST MESSAGE")
    assert_equal(error_msg, "[2011-07-07 00:00:00] ERROR:ProgramName: TEST MESSAGE\n","CASE:2-1-4")
    fatal_msg = formatter.call("FATAL", Date.new(2011, 7, 7), "ProgramName","TEST MESSAGE")
    assert_equal(fatal_msg, "[2011-07-07 00:00:00] FATAL:ProgramName: TEST MESSAGE\n","CASE:2-1-5")
    # 異常ケース
  end
end
