# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：頻度チェッカー
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/02/10 Nakanohito
# 更新日:
###############################################################################
require 'filter/access_regulation/access_regulation_filter'
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/unit_test_util'

class FrequencyCheckerTest < ActiveSupport::TestCase
  include Filter::AccessRegulation
  include Mock
  include UnitTestUtil

  # 前処理
  def setup
  end
  # 後処理
  def teardown
  end
  
  # FrequencyCheckerクラス：コンストラクタ
  test "2-1:FrequencyChecker Test:initialize" do
    ############################################################################
    # テスト項目：コンストラクタ
    ############################################################################
    begin
      checker = FrequencyChecker.instance
      assert(checker.nil? == false, "CASE:2-1-1")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1-1")
    end
  end
  
  # FrequencyCheckerクラス：頻度チェック
  test "2-2:FrequencyChecker Test:excess_frequency?" do
    ############################################################################
    # テスト項目：頻度チェック
    ############################################################################
    # 頻度チェック
    begin
      checker = FrequencyChecker.instance
      chk_time_list = Array.new
      loop do
        chk_time_list.push(Time.now)
        break if checker.excess_frequency?
      end
      assert(chk_time_list.size == 11, "CASE:2-2-1")
      chk_time_list.each do |time|
        assert(time < (chk_time_list.first + 1), "CASE:2-2-2")
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-2-1=>2-2-2")
    end
    sleep(1)
    # 頻度チェック
    begin
      checker = FrequencyChecker.instance
      chk_time_list = Array.new
      ok_time_list = Array.new
      begin_time = Time.now
      500.times do
        chk_time = Time.now
        chk_time_list.push(chk_time)
        ok_time_list.push(chk_time) unless checker.excess_frequency?
        sleep(0.01)
      end
      process_time = Time.now - begin_time
      print_log("process time:" + process_time.to_s)
      print_log("ok size:" + ok_time_list.size.to_s)
      ok_time_list.each do |time| print_log("ok time:" + time.to_s) end
      assert(ok_time_list.size == (process_time * 10.0).to_i, "CASE:2-2-3")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-2-3")
    end
  end
end
