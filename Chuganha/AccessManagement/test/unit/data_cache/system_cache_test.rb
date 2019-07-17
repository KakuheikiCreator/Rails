# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：システムキャッシュクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/09/05 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'data_cache/system_cache'

class SystemCacheTest < ActiveSupport::TestCase
  include UnitTestUtil
  include DataCache
  # 前処理
  def setup
    SystemCache.instance.data_load
  end
  # 後処理
#  def teardown
#  end
  # パラメータクラステスト
  test "2-1:SystemCache Test:instance" do
    # コンストラクタ
    begin
      cache = SystemCache.instance
      # DB検索結果とマッチング
      System.all.each do |system|
#        print_log("System Name:" + system.system_name)
#        print_log("Subsystem Name:" + system.subsystem_name)
        system_name = system.system_name
        subsystem_name = system.subsystem_name
        get_system = cache.get_system(system_name, subsystem_name)
        assert(system.id == get_system.id, "CASE:2-1-1")
        system.function.each do |function|
          function_path = function.function_path
          get_function = cache.get_function(system_name, subsystem_name, function_path)
          assert(function.id == get_function.id, "CASE:2-1-1")
        end
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # テスト：システム検索
  test "2-2:SystemCache Test:get_system" do
    # コンストラクタ
    begin
      cache = SystemCache.instance
      # デフォルト
      get_system = cache.get_system
      system = System.find(get_system.id)
      assert(system.id == get_system.id, "CASE:2-2-1")
      assert(get_system.system_name == '仲観派', "CASE:2-2-1")
      assert(get_system.subsystem_name == 'Access Management', "CASE:2-2-1")
      # アクセス管理
      get_system = cache.get_system('仲観派', 'Access Management')
      system = System.find(get_system.id)
      assert(system.id == get_system.id, "CASE:2-2-1")
      assert(get_system.system_name == '仲観派', "CASE:2-2-1")
      assert(get_system.subsystem_name == 'Access Management', "CASE:2-2-1")
      # 会員管理
      get_system = cache.get_system('仲観派', 'Member Management')
      system = System.find(get_system.id)
      assert(system.id == get_system.id, "CASE:2-2-1")
      assert(get_system.system_name == '仲観派', "CASE:2-2-1")
      assert(get_system.subsystem_name == 'Member Management', "CASE:2-2-1")
      # 防犯秘密結社
      get_system = cache.get_system('防犯秘密結社', 'Member Management')
      system = System.find(get_system.id)
      assert(system.id == get_system.id, "CASE:2-2-1")
      assert(get_system.system_name == '防犯秘密結社', "CASE:2-2-1")
      assert(get_system.subsystem_name == 'Member Management', "CASE:2-2-1")
      # NULL
      system = cache.get_system(nil, 'Member Management')
      assert(system.nil?, "CASE:2-2-2-1")
      system = cache.get_system('仲観派', nil)
      assert(system.nil?, "CASE:2-2-2-2")
      system = cache.get_system(nil, nil)
      assert(!system.nil?, "CASE:2-2-2-3")
      # 存在しない条件
      get_system = cache.get_system('陰陽寮', 'Access Management')
      assert(get_system.nil?, "CASE:2-2-3")
      get_system = cache.get_system('仲観派', 'NTDS')
      assert(get_system.nil?, "CASE:2-2-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # テスト：機能検索
  test "2-3:SystemCache Test:get_function" do
    # コンストラクタ
    begin
      cache = SystemCache.instance
      # アクセス管理
      funcion_info = Function.find(1)
      get_function = cache.get_function('仲観派', 'Access Management', 'access_total/access_total')
      assert(funcion_info.id == get_function.id, "CASE:2-3-1")
      assert(get_function.function_path == 'access_total/access_total', "CASE:2-3-1")
      # ダミーパスを追加して一階層深くしてテスト
      get_function = cache.get_function('仲観派', 'Access Management', 'access_total/access_total/test')
      assert(funcion_info.id == get_function.id, "CASE:2-3-2")
      assert(get_function.function_path == 'access_total/access_total', "CASE:2-3-2")
      # パラメータを追加してテスト
      get_function = cache.get_function('仲観派', 'Access Management', 'access_total/access_total?param=100')
      assert(funcion_info.id == get_function.id, "CASE:2-3-2")
      assert(get_function.function_path == 'access_total/access_total', "CASE:2-3-2")
      # NULL
      get_function = cache.get_function(nil, 'Access Management', 'access_total/access_total')
      assert(get_function.nil?, "CASE:2-3-3")
      get_function = cache.get_function('仲観派', nil, 'access_total/access_total')
      assert(get_function.nil?, "CASE:2-3-3")
      get_function = cache.get_function('仲観派', 'Access Management', nil)
      assert(get_function.nil?, "CASE:2-3-3")
      # 存在しない条件
      get_function = cache.get_function('陰陽寮', 'Access Management', 'access_total/access_total')
      assert(get_function.nil?, "CASE:2-3-4")
      get_function = cache.get_function('仲観派', 'NTDS', 'access_total/access_total')
      assert(get_function.nil?, "CASE:2-3-4")
      get_function = cache.get_function('仲観派', 'Access Management', 'FCS')
      assert(get_function.nil?, "CASE:2-3-4")
      get_function = cache.get_function('仲観派', 'Access Management', 'access_total/access_total_param=100')
      assert(get_function.nil?, "CASE:2-3-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # データロードテスト
  test "2-4:SystemCache Test:data_load" do
    # コンストラクタ
    begin
      list = System.all
      cache = SystemCache.instance
      cache.data_load
      # DB検索結果とマッチング
      list.each do |system|
        system_name = system.system_name
        subsystem_name = system.subsystem_name
        get_system = cache.get_system(system_name, subsystem_name)
        assert(system.id == get_system.id, "CASE:2-4-1")
        system.function.each do |function|
          function_path = function.function_path
          get_function = cache.get_function(system_name, subsystem_name, function_path)
          assert(function.id == get_function.id, "CASE:2-4-1")
        end
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    # コンストラクタ
    begin
      list = System.all
      System.delete_all
      cache = SystemCache.instance
      cache.data_load
      # DB検索結果とマッチング
      list.each do |system|
        system_name = system.system_name
        subsystem_name = system.subsystem_name
        get_system = cache.get_system(system_name, subsystem_name)
        assert(get_system.nil?, "CASE:2-4-2")
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
end
