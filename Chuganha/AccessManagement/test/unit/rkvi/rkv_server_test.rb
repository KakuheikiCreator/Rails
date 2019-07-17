# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：RKVサーバー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/07/16 Nakanohito
# 更新日:
###############################################################################
require 'drb/drb'
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_logger'
require 'rkvi/rkv_server'
require 'rkvi/rkv_wrapper'

class RkvServerTest < ActiveSupport::TestCase
  include Mock
  include UnitTestUtil
  
  # 前処理
  def setup
    ###########################################################################
    # サーバー起動
    ###########################################################################
    DRb.stop_service
    @uri = 'druby://localhost:12345'
  end
  
  # テスト対象メソッド：コンストラクタ
  test "CASE:2-1 initialize" do
    begin
      #########################################################################
      # 正常ケース
      # 初期処理：ロガー指定
      #########################################################################
      logger = Mock::MockLogger.new
      rkv_server = Rkvi::RkvServer.new(@uri, logger)
      assert(!rkv_server.nil?, "CASE:2-1-1")
      # 値取得
      assert(rkv_server.instance_variable_get(:@server_uri) == @uri, "CASE:2-1-2")
      assert(rkv_server.instance_variable_get(:@logger) == logger, "CASE:2-1-3")
    rescue=>ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    begin
      #########################################################################
      # 正常ケース
      # 初期処理：ロガー指定なし
      #########################################################################
      logger = Mock::MockLogger.new
      rkv_server = Rkvi::RkvServer.new(@uri)
      assert(!rkv_server.nil?, "CASE:2-1-1")
      # 値取得
      assert(rkv_server.instance_variable_get(:@server_uri) == @uri, "CASE:2-1-2")
      assert(rkv_server.instance_variable_get(:@logger).nil?, "CASE:2-1-4")
    rescue=>ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # テスト対象メソッド：アクセサー
  test "CASE:2-2 [], []=" do
    begin
      #########################################################################
      # 正常ケース
      # アクセサー：セッター、ゲッター
      #########################################################################
      logger = Mock::MockLogger.new
      rkv_server = Rkvi::RkvServer.new(@uri, logger)
      assert(!rkv_server.nil?, "CASE:2-2-1")
      # 値設定
      test_data_1 = Time.now
      rkv_server[:test_data_1] = test_data_1
      test_data_2 = "TestData2"
      rkv_server[:test_data_2] = test_data_2
      test_data_3 = :TestData3
      rkv_server[nil] = test_data_3
      # 値取得
      assert(rkv_server[:test_data_1] == test_data_1, "CASE:2-2-1")
      assert(rkv_server[:test_data_2] == test_data_2, "CASE:2-2-1")
      assert(rkv_server[nil] == test_data_3, "CASE:2-2-2")
      assert(rkv_server[:test_data_4].nil?, "CASE:2-2-3")
      assert(logger.warn_msg_list.size == 2, "CASE:2-2-4")
      assert(logger.warn_msg_list[0] == 'Rkvi::RkvServer Key is null', "CASE:2-2-4")
      assert(logger.warn_msg_list[1] == 'Rkvi::RkvServer Key is null', "CASE:2-2-4")
    rescue=>ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # テスト対象メソッド：サーバー起動
  test "CASE:2-3 boot_server?" do
    begin
      #########################################################################
      # 正常ケース
      # 起動：正常起動
      #########################################################################
      DRb.stop_service
      logger = Mock::MockLogger.new
      rkv_server = Rkvi::RkvServer.new(@uri, logger)
      assert(!rkv_server.nil?, "CASE:2-3-1")
      # サーバー起動
      assert(rkv_server.boot_server?, "CASE:2-3-2")
      boot_time = rkv_server[:boot_time]
      assert(boot_time <= Time.now, "CASE:2-3-3")
      server_obj = DRbObject.new_with_uri(@uri)
      assert(boot_time == server_obj[:boot_time], "CASE:2-3-4")
      server_obj[:test_data] = "test_data"
      assert(server_obj[:test_data] == "test_data", "CASE:2-3-4")
    rescue=>ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    begin
      #########################################################################
      # 正常ケース
      # 起動：多重起動
      #########################################################################
      DRb.stop_service
      logger = Mock::MockLogger.new
      rkv_server = Rkvi::RkvServer.new(@uri, logger)
      assert(!rkv_server.nil?, "CASE:2-3-1")
      # サーバー起動
      assert(rkv_server.boot_server?, "CASE:2-3-2")
      assert(rkv_server.boot_server?, "CASE:2-3-5")
    rescue=>ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    begin
      #########################################################################
      # 異常ケース
      # 起動：サービスURL異常
      #########################################################################
      DRb.stop_service
      logger = Mock::MockLogger.new
      rkv_server = Rkvi::RkvServer.new("none", logger)
      assert(!rkv_server.nil?, "CASE:2-3-1")
      # サーバー起動
      assert(!rkv_server.boot_server?, "CASE:2-3-6")
    rescue=>ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # テスト対象メソッド：Performance
  test "CASE:3-1 Performance" do
    large_list = Array.new
    1000.times do
      large_list.push(generate_str(CHAR_SET_ALPHANUMERIC, 1024))
    end
    begin
      #########################################################################
      # ケース１
      # 大きなサイズのデータの設定および参照
      #########################################################################
      # サーバー起動
      DRb.stop_service
      logger = Mock::MockLogger.new
      rkv_server = Rkvi::RkvServer.new(@uri, logger)
      assert(rkv_server.boot_server?, "CASE:3-1-1")
      boot_time = rkv_server[:boot_time]
      assert(boot_time <= Time.now, "CASE:3-1-2")
      # リモート接続
      server_obj = DRbObject.new_with_uri(@uri)
      # データ設定
      before_time = Time.now
      1000.times do |idx|
        server_obj[idx] = large_list
      end
      proc_time = (Time.now.to_f - before_time.to_f) * 1000.0
      print_log('Set proc time:' + proc_time.to_s + " msec")
      # データ参照
      before_time = Time.now
      1000.times do |idx|
        get_large_list = server_obj[idx]
      end
      proc_time = (Time.now.to_f - before_time.to_f) * 1000.0
      print_log('Get proc time:' + proc_time.to_s + " msec")
    rescue=>ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
end