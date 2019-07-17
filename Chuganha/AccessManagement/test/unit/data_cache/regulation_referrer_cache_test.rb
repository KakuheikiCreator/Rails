# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：規制リファラー情報キャッシュクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'data_cache/regulation_referrer_cache'

class RegulationReferrerCacheTest < ActiveSupport::TestCase
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
  test "2-1:RegulationReferrerCache Test:instance" do
    # 規制リファラー判定（ロードエラー）
    begin
      RegulationReferrerCache.instance
      flunk("CASE:2-3-2")
    rescue RuntimeError => ex
      assert(RuntimeError === ex, "CASE:2-3-2:" + ex.class.name)
    end
    # 規制リファラー判定（正常）
    begin
      RegulationReferrer.delete(3)
      cache = RegulationReferrerCache.instance
      bef_loaded_at = cache.loaded_at
      sleep(1)
      cache.data_load
      assert(!cache.nil?, "CASE:2-1-1, 2-3-1")
      assert(cache.loaded_at > bef_loaded_at, "CASE:2-3-3")
      assert(cache.regulation?("www.yahoo.co.jp"), "CASE:2-2-1")
      assert(cache.regulation?("www.msn.co.jp"), "CASE:2-2-1")
      assert(!cache.regulation?("www.goo.co.jp"), "CASE:2-2-2")
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
