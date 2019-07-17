# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：規制クッキー情報キャッシュクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'data_cache/regulation_cookie_cache'

class RegulationCookieCacheTest < ActiveSupport::TestCase
  include UnitTestUtil
  include DataCache
  # 前処理
  def setup
    SystemCache.instance.data_load
  end
  # 後処理
  def teardown
  end
  
  # データロードテスト
  test "2-1:RegulationCookieCache Test:instance" do
    # 規制クッキー判定（ロードエラー）
    begin
      RegulationCookieCache.instance
    rescue RuntimeError => ex
      assert(RuntimeError === ex, "CASE:2-1-2:" + ex.class.name)
      flunk("CASE:2-1-1")
    end
    # 規制クッキー判定（正常）
    begin
      RegulationCookie.delete(3)
      cache = RegulationCookieCache.instance
      bef_loaded_at = cache.loaded_at
      sleep(1)
      cache.data_load
      assert(!cache.nil?, "CASE:2-1-1, 2-3-1")
      assert(cache.loaded_at > bef_loaded_at, "CASE:2-3-3")
      assert(cache.regulation?("1"), "CASE:2-2-1")
      assert(cache.regulation?("2"), "CASE:2-2-1")
      assert(cache.regulation?("3"), "CASE:2-2-1")
      assert(!cache.regulation?("4"), "CASE:2-2-2")
      assert(!cache.regulation?("12"), "CASE:2-2-2")
      assert(cache.regulation?("a"), "CASE:2-2-1")
      assert(cache.regulation?("b"), "CASE:2-2-1")
      assert(cache.regulation?("c"), "CASE:2-2-1")
      assert(!cache.regulation?("d"), "CASE:2-2-2")
      assert(!cache.regulation?("cd"), "CASE:2-2-2")
      assert(!cache.regulation?(nil), "CASE:2-2-3")
    rescue => ex
      flunk("CASE:2-1-1->2-3-1")
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # 規制ホスト判定（異常）なし
  end
end
