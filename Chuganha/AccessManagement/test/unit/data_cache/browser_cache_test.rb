# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ブラウザキャッシュクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/08/26 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/browser_cache'
require 'date'
require 'test_helper'
require 'unit/unit_test_util'

class BrowserCacheTest < ActiveSupport::TestCase
  include UnitTestUtil
  include DataCache
  # 前処理
  def setup
#    BrowserVersion.delete_all
#    Browser.delete_all
  end
  # 後処理
  def teardown
  end
  # パラメータクラステスト
  test "2-01:BrowserCache Test:instance" do
    # コンストラクタ
    begin
      cache = BrowserCache.instance
      # DB検索結果とマッチング
#      info_list = Browser.all
#      print("List:", info_list.class.name, "\n")
#      print("Size:", info_list.size, "\n")
      Browser.all.each do |browser|
        name = browser.browser_name
        assert(browser == cache.get_info(name), "CASE:2-1-1")
#        version_info_list = browser.browser_version
#        print("List:", version_info_list.class.name, "\n")
#        print("Size:", version_info_list.size, "\n")
        browser.browser_version.each do |version_info|
          version = version_info.browser_version
          assert(version_info == cache.get_version_info(name, version), "CASE:2-1-1")
        end
      end
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # テスト：ブラウザ検索
  test "2-02:BrowserCache Test:get_info" do
    # コンストラクタ
    begin
      cache = BrowserCache.instance
      info = cache.get_info('Internet Explorer')
      assert(info.browser_name == 'Internet Explorer', "CASE:2-2-1")
      info = cache.get_info(nil)
      assert(info.nil?, "CASE:2-2-2")
      info = cache.get_info('Internet Exporer')
      assert(info.nil?, "CASE:2-2-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # テスト：ブラウザバージョン検索
  test "2-03:BrowserCache Test:get_version_info" do
    # コンストラクタ
    begin
      cache = BrowserCache.instance
      info = cache.get_version_info('Internet Explorer', '6')
      assert(info.browser_version == '6', "CASE:2-3-1")
      info = cache.get_version_info('Internet Explorer', nil)
      assert(info.nil?, "CASE:2-3-2")
      info = cache.get_version_info(nil, '6')
      assert(info.nil?, "CASE:2-3-3")
      info = cache.get_version_info(nil, nil)
      assert(info.nil?, "CASE:2-3-4")
      info = cache.get_version_info('Internet Exporer', '6')
      assert(info.nil?, "CASE:2-3-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # テスト：ブラウザ登録
  test "2-04:BrowserCache Test:add_info" do
    # コンストラクタ
    begin
      cache = BrowserCache.instance
      # 既存ブラウザに追加
      target_time = Time.now
      info = cache.add_info('Internet Explorer', 'omega')
      assert(info[0].browser_name == 'Internet Explorer', "CASE:2-4-1")
      assert(info[1].browser_version == 'omega', "CASE:2-4-1")
      # 新規ブラウザを追加
      target_time = Time.now
      info = cache.add_info('Food Explorer', 'first')
      assert(info[0].browser_name == 'Food Explorer', "CASE:2-4-2")
      assert(info[1].browser_version == 'first', "CASE:2-4-2")
      # ブラウザnilが追加されない事を確認
      target_time = Time.now
      info = cache.add_info(nil, '2011')
      assert(info.nil?, "CASE:2-4-3")
      # バージョンnilが追加される事を確認
      target_time = Time.now
      info = cache.add_info('Criminal Explorer', nil)
      assert(info[0].browser_name == 'Criminal Explorer', "CASE:2-4-4")
      assert(info[1].browser_version == nil, "CASE:2-4-4")
      # 両方nilが追加されない事を確認
      target_time = Time.now
      info = cache.add_info(nil, nil)
      assert(info.nil?, "CASE:2-4-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # パラメータクラステスト
  test "2-05:BrowserCache Test:data_load" do
    # データリロード
    begin
      cache = BrowserCache.instance
      bef_loaded_at = cache.loaded_at
      sleep(1)
      cache.data_load
      # DB検索結果とマッチング
#      info_list = Browser.all
#      print("List:", info_list.class.name, "\n")
#      print("Size:", info_list.size, "\n")
      Browser.all.each do |browser|
        name = browser.browser_name
        assert(browser == cache.get_info(name), "CASE:2-5-1")
#        version_info_list = browser.browser_version
#        print("List:", version_info_list.class.name, "\n")
#        print("Size:", version_info_list.size, "\n")
        browser.browser_version.each do |version_info|
          version = version_info.browser_version
          assert(version_info == cache.get_version_info(name, version), "CASE:2-5-1")
        end
      end
      assert(cache.loaded_at > bef_loaded_at, "CASE:2-5-3")
      assert(cache.browser_data.count == Browser.all.count, "CASE:2-5-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # データリロード（0件）
    begin
      list = Browser.all
      # 全件削除
      Browser.delete_all
      # 再度データロード
      cache = BrowserCache.instance
      bef_loaded_at = cache.loaded_at
      sleep(1)
      cache.data_load
      # DB検索結果とマッチング
      list.each do |browser|
        name = browser.browser_name
        assert(cache.get_info(name).nil?, "CASE:2-5-2")
      end
      assert(cache.loaded_at > bef_loaded_at, "CASE:2-5-3")
      assert(cache.browser_data.count == Browser.all.count, "CASE:2-5-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
end
