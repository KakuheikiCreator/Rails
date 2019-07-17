# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：システム
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/17 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'

class SystemTest < ActiveSupport::TestCase
  include UnitTestUtil
  # 基本機能テスト
  # 登録・検索・更新・削除のテストを行う
  test "2-1:Basic functions Test" do
    # 登録
    begin
      info = System.new
      info.system_name = 'システム名'
      info.subsystem_name = 'サブシステム名'
      assert(info.save!, "CASE:2-1-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 検索
    infos = System.where(:system_name => 'システム名')
    assert(infos.length == 1, "CASE:2-1-2")
    # 更新
    begin
      info = infos[0]
      info.system_name = '次のシステム名'
      assert(info.save!, "CASE:2-1-3")
      infos = System.where(:system_name => 'システム名')
      assert(infos.length == 0, "CASE:2-1-3")
      infos = System.where(:system_name => '次のシステム名')
      assert(infos.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = System.where(:system_name => '次のシステム名').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = System.where(:system_name => '次のシステム名')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
  end
  
  # 検索（関連）テスト
  # テーブル間の関連のテストを行う
  test "2-2:Relationship Test" do
    # 機能
    infos = System.where(:system_name => '仲観派')
    functions = infos[0].function
#    print_log("CASE:2-2-1 SIZE:" + functions.length.to_s)
    assert(functions.length == 5, "CASE:2-2-1")
    functions.each do |info|
      assert(Function === info , "CASE:2-2-1")
    end
    # リクエスト解析スケジュール
    request_analysis_schedules = infos[0].request_analysis_schedule
#    print_log("CASE:2-2-2 SIZE:" + request_analysis_schedules.length.to_s)
    assert(request_analysis_schedules.length == 6, "CASE:2-2-2")
    request_analysis_schedules.each do |info|
      assert(RequestAnalysisSchedule === info , "CASE:2-2-2")
    end
    # リクエスト解析結果
    request_analysis_results = infos[0].request_analysis_result
#    print_log("CASE:2-2-3 SIZE:" + analysis_infos.length.to_s)
    assert(request_analysis_results.length == 2, "CASE:2-2-3")
    request_analysis_results.each do |info|
      assert(RequestAnalysisResult === info , "CASE:2-2-3")
    end
    # 規制ホスト
    regulation_hosts = infos[0].regulation_host
#    print_log("CASE:2-2-4 SIZE:" + host_regulatory_infos.length.to_s)
    assert(regulation_hosts.length == 10, "CASE:2-2-4")
    regulation_hosts.each do |info|
      assert(RegulationHost === info , "CASE:2-2-4")
    end
    # 規制クッキー
    regulation_cookies = infos[0].regulation_cookie
#    print_log("CASE:2-2-5 SIZE:" + cookies_regulatory_infos.length.to_s)
    assert(regulation_cookies.length == 3, "CASE:2-2-5")
    regulation_cookies.each do |info|
      assert(RegulationCookie === info , "CASE:2-2-5")
    end
    # 規制リファラー
    regulation_referrers = infos[0].regulation_referrer
#    print_log("CASE:2-2-6 SIZE:" + referrer_regulatory_infos.length.to_s)
    assert(regulation_referrers.length == 3, "CASE:2-2-6")
    regulation_referrers.each do |info|
      assert(RegulationReferrer === info , "CASE:2-2-6")
    end
  end
  
  # バリデーションテスト
  # システム名のバリデーションチェックのテストを行う
  test "2-3:Validation Test:system_name" do
    # 必須チェック
    begin
      info = System.new
      info.system_name = "test"
      assert(info.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-1")
    end
    begin
      info = System.new
      info.system_name = nil
      assert(!info.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-1")
    end
    # 桁数チェック
    begin
      info = System.new
      info.system_name = generate_str(CHAR_SET_ALPHABETIC, 1)
      assert(info.valid?, "CASE:2-3-2")
      info.system_name = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(info.valid?, "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-2")
    end
    begin
      info = System.new
      info.system_name = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!info.valid?, "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-2")
    end
  end
  
  # バリデーションテスト
  # サブシステム名のバリデーションチェックのテストを行う
  test "2-4:Validation Test:subsystem_name" do
    # NULLの時にバリデーションチェックがされないか
    begin
      info = System.new
      info.system_name = "test"
      info.subsystem_name = nil
      assert(info.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-1")
    end
    # 桁数チェック
    begin
      info = System.new
      info.system_name = "test"
      info.subsystem_name = generate_str(CHAR_SET_ALPHABETIC, 1)
      assert(info.valid?, "CASE:2-4-2")
      info.subsystem_name = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(info.valid?, "CASE:2-4-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-2")
    end
    begin
      info = System.new
      info.system_name = "test"
      info.subsystem_name = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!info.valid?, "CASE:2-4-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-2")
    end
  end
end
