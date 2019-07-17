# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：リクエスト解析スケジュールキャッシュクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/09/06 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'data_cache/request_analysis_schedule_cache'
require 'data_cache/system_cache'

class RequestAnalysisScheduleCacheTest < ActiveSupport::TestCase
  include UnitTestUtil
  include DataCache
  # 前処理
  def setup
    SystemCache.instance.data_load
  end
  # 後処理
  def teardown
  end
  # コンストラクタテスト
  test "2-1:RequestAnalysisScheduleCache Test:instance" do
    # コンストラクタ
    begin
      cache = RequestAnalysisScheduleCache.instance
      standard_time = Time.parse('2011-09-07 17:00:01 UTC')
      setting = cache.get_setting(standard_time)
      assert(setting['gets_start_date'] == standard_time, "CASE:2-1-1")
      standard_time = Time.parse('2011-09-08 02:00:02')
      setting = cache.get_setting(standard_time)
      assert(setting.gets_start_date == standard_time, "CASE:2-1-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # データ取得
  test "2-2:RequestAnalysisScheduleCache Test:get_setting" do
    cache = RequestAnalysisScheduleCache.instance
    begin
      # 先頭データ
      standard_time = Time.parse('2011-09-07 17:00:00 UTC')
      before_time = Time.parse('2011-09-07 16:59:59 UTC')
#      print("standard_time:", standard_time, "\n")
#      print("before_time  :", before_time, "\n")
      setting = cache.get_setting(standard_time)
      assert(setting.gets_start_date <= standard_time, "CASE:2-2-1")
      assert(setting.gets_start_date > before_time, "CASE:2-2-1")
      # 末端データ
      standard_time = Time.parse('2011-09-07 17:00:03 UTC')
      before_time = Time.parse('2011-09-07 17:00:02 UTC')
      setting = cache.get_setting(standard_time)
      assert(setting.gets_start_date <= standard_time, "CASE:2-2-2")
      assert(setting.gets_start_date > before_time, "CASE:2-2-2")
      # 末端データ
      standard_time = Time.parse('2011-09-08 17:00:03 UTC')
      before_time = Time.parse('2011-09-07 17:00:02 UTC')
      setting = cache.get_setting(standard_time)
      assert(setting.gets_start_date <= standard_time, "CASE:2-2-3")
      assert(setting.gets_start_date > before_time, "CASE:2-2-3")
      # データが存在しない日時（以前）
      standard_time = Time.parse('2011-09-07 16:00:59 UTC')
      setting = cache.get_setting(standard_time)
      assert(setting.nil?, "CASE:2-2-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # テスト：データロード
  test "2-3:RequestAnalysisScheduleCache Test:data_load" do
    cache = RequestAnalysisScheduleCache.instance
    # 正常ケース（データ有り）
    begin
      bef_loaded_at = cache.loaded_at
      # データロード
      cache.data_load
      standard_time = Time.parse('2011-09-07 17:00:01 UTC')
      setting = cache.get_setting(standard_time)
      assert(setting.gets_start_date == standard_time, "CASE:2-3-1")
      standard_time = Time.parse('2011-09-07 17:00:02 UTC')
      setting = cache.get_setting(standard_time)
      assert(setting.gets_start_date == standard_time, "CASE:2-3-1")
      assert(cache.loaded_at > bef_loaded_at, "CASE:2-3-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # 正常ケース（データ無）
    begin
      bef_loaded_at = cache.loaded_at
      # データロード
      RequestAnalysisSchedule.delete_all
      cache.data_load
      standard_time = Time.parse('2011-09-07 17:00:01 UTC')
      setting = cache.get_setting(standard_time)
      assert(setting.nil?, "CASE:2-3-2")
      assert(cache.loaded_at > bef_loaded_at, "CASE:2-3-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
end
