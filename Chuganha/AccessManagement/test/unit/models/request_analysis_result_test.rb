# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：リクエスト解析結果
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/18 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'

class RequestAnalysisResultTest < ActiveSupport::TestCase
  include UnitTestUtil
  # 基本機能テスト
  # 登録・検索・更新・削除のテストを行う
  test "2-1:Basic functions Test" do
    # 登録
    begin
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.session_id = generate_str(CHAR_SET_ZENKAKU, 32)
      info.request_count = 1
      assert(info.save!, "CASE:2-1-1")
    rescue => ex
      error_log("CASE:2-1-1 Exception:" + ex.class.name)
      error_log("CASE:2-1-1 Message  :" + ex.message)
      flunk("CASE:2-1-1")
    end
    # 検索
    infos = RequestAnalysisResult.where(:request_count => 1)
    assert(infos.length == 1, "CASE:2-1-2")
    # 更新
    begin
      info = infos[0]
      info.request_count = 2
      assert(info.save!, "CASE:2-1-3")
      infos = RequestAnalysisResult.where(:request_count => 1)
      assert(infos.length == 0, "CASE:2-1-3")
      infos = RequestAnalysisResult.where(:request_count => 2)
      assert(infos.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("CASE:2-1-3 Exception:" + ex.class.name)
      error_log("CASE:2-1-3 Message  :" + ex.message)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = RequestAnalysisResult.where(:request_count => 2).destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = RequestAnalysisResult.where(:request_count => 2)
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("CASE:2-1-4 Exception:" + ex.class.name)
      error_log("CASE:2-1-4 Message  :" + ex.message)
      flunk("CASE:2-1-4")
    end
  end
  
  # 検索（関連）テスト
  # テーブル間の関連のテストを行う
  test "2-2:Relationship Test" do
    # システム
    infos = RequestAnalysisResult.where(:request_analysis_schedule_id => 1)
    system = infos[0].system
    assert(System === system , "CASE:2-2-1")
    # 機能
    function = infos[0].function
    assert(Function === function , "CASE:2-2-2")
    # ドメイン
    domain = infos[0].domain
    assert(Domain === domain , "CASE:2-2-3")
    # ブラウザ
    browser = infos[0].browser
    assert(Browser === browser , "CASE:2-2-4")
    # ブラウザバージョン
    browser_version = infos[0].browser_version
    assert(BrowserVersion === browser_version , "CASE:2-2-5")
    # リクエスト解析スケジュール
    request_analysis_schedule = infos[0].request_analysis_schedule
    assert(RequestAnalysisSchedule === request_analysis_schedule , "CASE:2-2-6")
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-3:Validation Test:system_id" do
    # 必須チェック
    begin
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      assert(info.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("CASE:2-3-1 Exception:" + ex.class.name)
      error_log("CASE:2-3-1 Message  :" + ex.message)
      flunk("CASE:2-3-1")
    end
    begin
      info = RequestAnalysisResult.new
      info.system_id = nil
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      assert(!info.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("CASE:2-3-1 Exception:" + ex.class.name)
      error_log("CASE:2-3-1 Message  :" + ex.message)
      flunk("CASE:2-3-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-4:Validation Test:request_analysis_schedule_id" do
    # 必須チェック
    begin
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      assert(info.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("CASE:2-4-1 Exception:" + ex.class.name)
      error_log("CASE:2-4-1 Message  :" + ex.message)
      flunk("CASE:2-4-1")
    end
    begin
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = nil
      info.request_count = 1
      assert(!info.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("CASE:2-4-1 Exception:" + ex.class.name)
      error_log("CASE:2-4-1 Message  :" + ex.message)
      flunk("CASE:2-4-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-5:Validation Test::received_year" do
    # 数値チェック
    begin
      # 正常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.received_year = nil
      assert(info.valid?, "CASE:2-5-1")
      info.received_year = 2011
      assert(info.valid?, "CASE:2-5-1")
      info.received_year = 9999
      assert(info.valid?, "CASE:2-5-1")
    rescue => ex
      error_log("CASE:2-5-1 Exception:" + ex.class.name)
      error_log("CASE:2-5-1 Message  :" + ex.message)
      flunk("CASE:2-5-1")
    end
    begin
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.received_year = 2010
      info.request_count = 1
      assert(info.valid?, "CASE:2-5-1")
      info.received_year = -1
      assert(!info.valid?, "CASE:2-5-1")
    rescue => ex
      error_log("CASE:2-5-1 Exception:" + ex.class.name)
      error_log("CASE:2-5-1 Message  :" + ex.message)
      flunk("CASE:2-5-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-6:Validation Test::received_month" do
    # 数値チェック
    begin
      # 正常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.received_month = nil
      assert(info.valid?, "CASE:2-6-1")
      info.received_month = 1
      assert(info.valid?, "CASE:2-6-1")
      info.received_month = 8
      assert(info.valid?, "CASE:2-6-1")
      info.received_month = 12
      assert(info.valid?, "CASE:2-6-1")
    rescue => ex
      error_log("CASE:2-6-1 Exception:" + ex.class.name)
      error_log("CASE:2-6-1 Message  :" + ex.message)
      flunk("CASE:2-6-1")
    end
    begin
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.received_month = 0
      info.request_count = 1
      assert(!info.valid?, "CASE:2-6-1")
      info.received_month = 13
      assert(!info.valid?, "CASE:2-6-1")
    rescue => ex
      error_log("CASE:2-6-1 Exception:" + ex.class.name)
      error_log("CASE:2-6-1 Message  :" + ex.message)
      flunk("CASE:2-6-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-7:Validation Test::received_day" do
    # 数値チェック
    begin
      # 正常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.received_day = nil
      assert(info.valid?, "CASE:2-7-1")
      info.received_day = 1
      assert(info.valid?, "CASE:2-7-1")
      info.received_day = 19
      assert(info.valid?, "CASE:2-7-1")
      info.received_day = 31
      assert(info.valid?, "CASE:2-7-1")
    rescue => ex
      error_log("CASE:2-7-1 Exception:" + ex.class.name)
      error_log("CASE:2-7-1 Message  :" + ex.message)
      flunk("CASE:2-7-1")
    end
    begin
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.received_day = 0
      info.request_count = 1
      assert(!info.valid?, "CASE:2-7-1")
      info.received_day = 32
      assert(!info.valid?, "CASE:2-7-1")
    rescue => ex
      error_log("CASE:2-7-1 Exception:" + ex.class.name)
      error_log("CASE:2-7-1 Message  :" + ex.message)
      flunk("CASE:2-7-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-8:Validation Test::received_hour" do
    # 数値チェック
    begin
      # 正常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.received_hour = nil
      assert(info.valid?, "CASE:2-8-1")
      info.received_hour = 0
      assert(info.valid?, "CASE:2-8-1")
      info.received_hour = 10
      assert(info.valid?, "CASE:2-8-1")
      info.received_hour = 23
      assert(info.valid?, "CASE:2-8-1")
    rescue => ex
      error_log("CASE:2-8-1 Exception:" + ex.class.name)
      error_log("CASE:2-8-1 Message  :" + ex.message)
      flunk("CASE:2-8-1")
    end
    begin
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.received_hour = -1
      info.request_count = 1
      assert(!info.valid?, "CASE:2-8-1")
      info.received_hour = 24
      assert(!info.valid?, "CASE:2-8-1")
    rescue => ex
      error_log("CASE:2-8-1 Exception:" + ex.class.name)
      error_log("CASE:2-8-1 Message  :" + ex.message)
      flunk("CASE:2-8-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-9:Validation Test::received_minute" do
    # 数値チェック
    begin
      # 正常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.received_minute = nil
      assert(info.valid?, "CASE:2-9-1")
      info.received_minute = 0
      assert(info.valid?, "CASE:2-9-1")
      info.received_minute = 10
      assert(info.valid?, "CASE:2-9-1")
      info.received_minute = 59
      assert(info.valid?, "CASE:2-9-1")
    rescue => ex
      error_log("CASE:2-9-1 Exception:" + ex.class.name)
      error_log("CASE:2-9-1 Message  :" + ex.message)
      flunk("CASE:2-9-1")
    end
    begin
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.received_minute = -1
      info.request_count = 1
      assert(!info.valid?, "CASE:2-9-1")
      info.received_minute = 60
      assert(!info.valid?, "CASE:2-9-1")
    rescue => ex
      error_log("CASE:2-9-1 Exception:" + ex.class.name)
      error_log("CASE:2-9-1 Message  :" + ex.message)
      flunk("CASE:2-9-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-10:Validation Test::received_second" do
    # 数値チェック
    begin
      # 正常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.received_second = nil
      assert(info.valid?, "CASE:2-10-1")
      info.received_second = 0
      assert(info.valid?, "CASE:2-10-1")
      info.received_second = 10
      assert(info.valid?, "CASE:2-10-1")
      info.received_second = 59
      assert(info.valid?, "CASE:2-10-1")
    rescue => ex
      error_log("CASE:2-10-1 Exception:" + ex.class.name)
      error_log("CASE:2-10-1 Message  :" + ex.message)
      flunk("CASE:2-10-1")
    end
    begin
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.received_second = -1
      info.request_count = 1
      assert(!info.valid?, "CASE:2-10-1")
      info.received_second = 60
      assert(!info.valid?, "CASE:2-10-1")
    rescue => ex
      error_log("CASE:2-10-1 Exception:" + ex.class.name)
      error_log("CASE:2-10-1 Message  :" + ex.message)
      flunk("CASE:2-10-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-11:Validation Test::function_transition_no" do
    # 数値チェック
    begin
      # 正常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.function_transition_no = nil
      assert(info.valid?, "CASE:2-11-1")
      info.function_transition_no = 0
      assert(info.valid?, "CASE:2-11-1")
      info.function_transition_no = 987
      assert(info.valid?, "CASE:2-11-1")
      info.function_transition_no = 123456
      assert(info.valid?, "CASE:2-11-1")
    rescue => ex
      error_log("CASE:2-11-1 Exception:" + ex.class.name)
      error_log("CASE:2-11-1 Message  :" + ex.message)
      flunk("CASE:2-11-1")
    end
    begin
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.function_transition_no = -1
      info.request_count = 1
      assert(!info.valid?, "CASE:2-11-1")
      info.function_transition_no = -10
      assert(!info.valid?, "CASE:2-11-1")
    rescue => ex
      error_log("CASE:2-11-1 Exception:" + ex.class.name)
      error_log("CASE:2-11-1 Message  :" + ex.message)
      flunk("CASE:2-11-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-12:Validation Test::session_id" do
    # 数値チェック
    begin
      # 正常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.session_id = nil
      assert(info.valid?, "CASE:2-12-1")
      info.session_id = generate_str(CHAR_SET_ALPHANUMERIC, 32)
      assert(info.valid?, "CASE:2-12-1")
    rescue => ex
      error_log("CASE:2-12-1 Exception:" + ex.class.name)
      error_log("CASE:2-12-1 Message  :" + ex.message)
      flunk("CASE:2-12-1")
    end
    begin
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.session_id = generate_str(CHAR_SET_ALPHANUMERIC, 31)
      info.request_count = 1
      assert(!info.valid?, "CASE:2-12-2")
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.session_id = generate_str(CHAR_SET_ALPHANUMERIC, 33)
      info.request_count = 1
      assert(!info.valid?, "CASE:2-12-2")
    rescue => ex
      error_log("CASE:2-12-2 Exception:" + ex.class.name)
      error_log("CASE:2-12-2 Message  :" + ex.message)
      flunk("CASE:2-12-2")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-13:Validation Test::referrer" do
    # 数値チェック
    begin
      # 正常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.referrer = nil
      assert(info.valid?, "CASE:2-13-1")
      info.referrer = "http://www.google.com"
      assert(info.valid?, "CASE:2-13-1")
      info.referrer = "https://login.yahoo.co.jp/config/login?.src=www&.done=http://www.yahoo.co.jp"
#      info.referrer = "http://news.google.com/news/more?pz=1&cf=all&ned=jp&ncl=dUnz_q9l6uRTNOMyGsLJJP9yGCYUM&topic=h"
      assert(info.valid?, "CASE:2-13-1")
      info.referrer = "ftp://ftp1.freebsd.org/pub/FreeBSD/README.TXT"
      assert(info.valid?, "CASE:2-13-1")
      info.referrer = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      assert(info.valid?, "CASE:2-13-1")
    rescue => ex
      error_log("CASE:2-13-1 Exception:" + ex.class.name)
      error_log("CASE:2-13-1 Message  :" + ex.message)
      flunk("CASE:2-13-1")
    end
    begin
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.referrer = generate_str(CHAR_SET_ALPHANUMERIC, 256)
      info.request_count = 1
      assert(!info.valid?, "CASE:2-13-1")
    rescue => ex
      error_log("CASE:2-13-1 Exception:" + ex.class.name)
      error_log("CASE:2-13-1 Message  :", ex)
      flunk("CASE:2-13-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-14:Validation Test:proxy_host" do
    # フォーマットチェック
    
    begin
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.proxy_host = nil
      assert(info.valid?, "CASE:2-14-1")
      info.proxy_host = "test.infoweb.ne.jp"
      assert(info.valid?, "CASE:2-14-1")
      info.proxy_host = generate_str(CHAR_SET_ALPHABETIC, 63) + "." +
                        generate_str(CHAR_SET_ALPHABETIC, 63) + "." +
                        generate_str(CHAR_SET_ALPHABETIC, 63) + "." +
                        generate_str(CHAR_SET_ALPHABETIC, 60) + ".jp"
      assert(info.valid?, "CASE:2-14-1")
    rescue => ex
      error_log("CASE:2-14-1 Exception:" + ex.class.name)
      error_log("CASE:2-14-1 Message  :" + ex.message)
      flunk("CASE:2-14-1")
    end
    begin
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.proxy_host = generate_str(CHAR_SET_ALPHABETIC, 63) + "." +
                        generate_str(CHAR_SET_ALPHABETIC, 63) + "." +
                        generate_str(CHAR_SET_ALPHABETIC, 63) + "." +
                        generate_str(CHAR_SET_ALPHABETIC, 61) + ".jp"
      assert(!info.valid?, "CASE:2-14-1")
#      info.proxy_host = generate_str(CHAR_SET_ALPHABETIC, 64) + "." +
#                        generate_str(CHAR_SET_ALPHABETIC, 60) + "." +
#                        generate_str(CHAR_SET_ALPHABETIC, 60) + "." +
#                        generate_str(CHAR_SET_ALPHABETIC, 60) + ".jp"
#      assert(!info.valid?, "CASE:2-14-1")
    rescue => ex
      error_log("CASE:2-14-1 Exception:" + ex.class.name)
      error_log("CASE:2-14-1 Message  :" + ex.message)
      flunk("CASE:2-14-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-15:Validation Test:proxy_ip_address" do
    # フォーマットチェック
    begin
      # 正常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.proxy_ip_address = nil
      assert(info.valid?, "CASE:2-15-1")
      info.proxy_ip_address = '0.0.0.0'
      assert(info.valid?, "CASE:2-15-1")
      info.proxy_ip_address = '1.10.100.100'
      assert(info.valid?, "CASE:2-15-1")
    rescue => ex
      error_log("CASE:2-15-1 Exception:" + ex.class.name)
      error_log("CASE:2-15-1 Message  :" + ex.message)
      flunk("CASE:2-15-1")
    end
    begin
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.proxy_ip_address = '0.0.0.0.0'
      assert(!info.valid?, "CASE:2-15-1")
      info.proxy_ip_address = '0.0.a.0'
      assert(!info.valid?, "CASE:2-15-1")
      info.proxy_ip_address = '0.0.0'
      assert(!info.valid?, "CASE:2-15-1")
      info.proxy_ip_address = '0.256.0.0'
      assert(!info.valid?, "CASE:2-15-1")
      info.proxy_ip_address = '0.0.0.256'
      assert(!info.valid?, "CASE:2-15-1")
      info.proxy_ip_address = '0.1000.0.0'
      assert(!info.valid?, "CASE:2-15-1")
      info.proxy_ip_address = '0.0.0.1000'
#      info.valid?
#      f = File::open("log.txt", "a") # 追加モード
#      f.print("Message   :", info.errors.full_messages, "\n")
#      f.close
      assert(!info.valid?, "CASE:2-15-1")
    rescue => ex
      error_log("CASE:2-15-1 Exception:" + ex.class.name)
      error_log("CASE:2-15-1 Message  :" + ex.message)
      flunk("CASE:2-15-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-16:Validation Test:remote_host" do
    # フォーマットチェック
    begin
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.remote_host = nil
      assert(info.valid?, "CASE:2-16-1")
      info.remote_host = "test.infoweb.ne.jp"
      assert(info.valid?, "CASE:2-16-1")
      info.remote_host = generate_str(CHAR_SET_ALPHABETIC, 63) + "." +
                         generate_str(CHAR_SET_ALPHABETIC, 63) + "." +
                         generate_str(CHAR_SET_ALPHABETIC, 63) + "." +
                         generate_str(CHAR_SET_ALPHABETIC, 60) + ".jp"
      assert(info.valid?, "CASE:2-16-1")
    rescue => ex
      error_log("CASE:2-16-1 Exception:" + ex.class.name)
      error_log("CASE:2-16-1 Message  :" + ex.message)
      flunk("CASE:2-16-1")
    end
    begin
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.remote_host = generate_str(CHAR_SET_ALPHABETIC, 63) + "." +
                         generate_str(CHAR_SET_ALPHABETIC, 63) + "." +
                         generate_str(CHAR_SET_ALPHABETIC, 63) + "." +
                         generate_str(CHAR_SET_ALPHABETIC, 61) + ".jp"
      assert(!info.valid?, "CASE:2-16-1")
#      info.remote_host = generate_str(CHAR_SET_ALPHABETIC, 64) + "." +
#                         generate_str(CHAR_SET_ALPHABETIC, 60) + "." +
#                         generate_str(CHAR_SET_ALPHABETIC, 60) + "." +
#                         generate_str(CHAR_SET_ALPHABETIC, 60) + ".jp"
#      assert(!info.valid?, "CASE:2-16-1")
    rescue => ex
      error_log("CASE:2-16-1 Exception:" + ex.class.name)
      error_log("CASE:2-16-1 Message  :" + ex.message)
      flunk("CASE:2-16-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-17:Validation Test:ip_address" do
    # フォーマットチェック
    begin
      # 正常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.ip_address = nil
      assert(info.valid?, "CASE:2-17-1")
      info.ip_address = '0.0.0.0'
      assert(info.valid?, "CASE:2-17-1")
      info.ip_address = '1.10.100.100'
      assert(info.valid?, "CASE:2-17-1")
    rescue => ex
      error_log("CASE:2-17-1 Exception:" + ex.class.name)
      error_log("CASE:2-17-1 Message  :" + ex.message)
      flunk("CASE:2-17-1")
    end
    begin
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      info.ip_address = '0.0.0.0.0'
      assert(!info.valid?, "CASE:2-17-1")
      info.ip_address = '0.0.a.0'
      assert(!info.valid?, "CASE:2-17-1")
      info.ip_address = '0.0.0'
      assert(!info.valid?, "CASE:2-17-1")
      info.ip_address = '0.256.0.0'
      assert(!info.valid?, "CASE:2-17-1")
      info.ip_address = '0.0.0.256'
      assert(!info.valid?, "CASE:2-17-1")
      info.ip_address = '0.1000.0.0'
      assert(!info.valid?, "CASE:2-17-1")
      info.ip_address = '0.0.0.1000'
#      info.valid?
#      f = File::open("log.txt", "a") # 追加モード
#      f.print("Message   :", info.errors.full_messages, "\n")
#      f.close
      assert(!info.valid?, "CASE:2-17-1")
    rescue => ex
      error_log("CASE:2-17-1 Exception:" + ex.class.name)
      error_log("CASE:2-17-1 Message  :" + ex.message)
      flunk("CASE:2-17-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-18:Validation Test::request_count" do
    # 必須チェック
    begin
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      assert(info.valid?, "CASE:2-18-1")
    rescue => ex
      error_log("CASE:2-18-1 Exception:" + ex.class.name)
      error_log("CASE:2-18-1 Message  :" + ex.message)
      flunk("CASE:2-18-1")
    end
    begin
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = nil
#      f = File::open("log.txt", "a") # 追加モード
#      f.print("Valid     :", info.valid?, "\n")
#      f.print("Message   :", info.errors.full_messages, "\n")
#      f.close
      assert(!info.valid?, "CASE:2-18-1")
    rescue => ex
      error_log("CASE:2-18-1 Exception:" + ex.class.name)
      error_log("CASE:2-18-1 Message  :" + ex.message)
      flunk("CASE:2-18-1")
    end
    # 数値チェック
    begin
      # 正常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = 1
      assert(info.valid?, "CASE:2-18-2")
      info.request_count = 9999
      assert(info.valid?, "CASE:2-18-2")
    rescue => ex
      error_log("CASE:2-18-2 Exception:" + ex.class.name)
      error_log("CASE:2-18-2 Message  :" + ex.message)
      flunk("CASE:2-18-2")
    end
    begin
      # 異常ケース
      info = RequestAnalysisResult.new
      info.system_id = 1
      info.request_analysis_schedule_id = 1
      info.request_count = -1
      assert(!info.valid?, "CASE:2-18-2")
    rescue => ex
      error_log("CASE:2-18-2 Exception:" + ex.class.name)
      error_log("CASE:2-18-2 Message  :" + ex.message)
      flunk("CASE:2-18-2")
    end
  end
end
