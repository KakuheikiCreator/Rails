# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：規制ホスト情報キャッシュクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'data_cache/regulation_host_cache'

class RegulationHostCacheTest < ActiveSupport::TestCase
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
  test "2-1:RegulationHostCache Test:instance" do
    # 規制ホスト判定（ロードエラー）
    begin
      RegulationHostCache.instance
      flunk("CASE:2-3-2-1")
    rescue RuntimeError => ex
      assert(RuntimeError === ex, "CASE:2-3-2-1:" + ex.class.name)
    end
    begin
      RegulationHost.delete(7)
      RegulationHostCache.instance
      flunk("CASE:2-3-2-2")
    rescue RuntimeError => ex
      assert(RuntimeError === ex, "CASE:2-3-2-2:" + ex.class.name)
    end
    # 規制ホスト判定（正常）
    begin
      RegulationHost.delete(8)
      cache = RegulationHostCache.instance
      bef_loaded_at = cache.loaded_at
      sleep(1)
      cache.data_load
      assert(!cache.nil?, "CASE:2-1-1, 2-3-1")
      assert(cache.loaded_at > bef_loaded_at, "CASE:2-3-4")
      # 規制対象
      assert(cache.regulation?("client1.ne.jp", "192.168.255.1", "proxy1.ne.jp", "192.168.254.1"), "CASE:2-2-1")
      assert(cache.regulation?("client2.ne.jp", "192.168.255.2", "proxy2.ne.jp", "192.168.254.2"), "CASE:2-2-1")
      assert(cache.regulation?("client3.ne.jp", "192.168.255.3", nil, "192.168.254.3"), "CASE:2-2-1")
      assert(cache.regulation?("client4.ne.jp", "192.168.255.4", "proxy4.ne.jp", nil), "CASE:2-2-1")
      assert(cache.regulation?(nil, "192.168.255.5", "proxy5.ne.jp", "192.168.254.5"), "CASE:2-2-1")
      assert(cache.regulation?("client6.ne.jp", nil, "proxy6.ne.jp", "192.168.254.6"), "CASE:2-2-1")
      # 規制対象外
      assert(!cache.regulation?("client1.ne.jp", "192.168.255.2", "proxy2.ne.jp", "192.168.254.2"), "CASE:2-2-2")
      assert(!cache.regulation?("client2.ne.jp", "192.168.255.1", "proxy2.ne.jp", "192.168.254.2"), "CASE:2-2-2")
      assert(!cache.regulation?("client2.ne.jp", "192.168.255.2", "proxy1.ne.jp", "192.168.254.2"), "CASE:2-2-2")
      assert(!cache.regulation?("client2.ne.jp", "192.168.255.2", "proxy2.ne.jp", "192.168.254.1"), "CASE:2-2-2")
      assert(!cache.regulation?("client3.ne.jp", "192.168.255.3", "proxy3.ne.jp", "192.168.254.3"), "CASE:2-2-2")
      assert(!cache.regulation?("client5.ne.jp", "192.168.255.5", "proxy5.ne.jp", "192.168.254.5"), "CASE:2-2-2")
      assert(!cache.regulation?(nil, "192.168.255.2", "proxy2.ne.jp", "192.168.254.2"), "CASE:2-2-2")
      assert(!cache.regulation?("client2.ne.jp", nil, "proxy2.ne.jp", "192.168.254.2"), "CASE:2-2-2")
      assert(!cache.regulation?("client2.ne.jp", "192.168.255.2", nil, "192.168.254.2"), "CASE:2-2-2")
      assert(!cache.regulation?("client2.ne.jp", "192.168.255.2", "proxy2.ne.jp", nil), "CASE:2-2-2")
      assert(!cache.regulation?(nil, nil, nil, nil), "CASE:2-2-3")
    rescue => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1->2-3-1")
    end
    # 規制ホスト判定（異常）なし
  end
end
