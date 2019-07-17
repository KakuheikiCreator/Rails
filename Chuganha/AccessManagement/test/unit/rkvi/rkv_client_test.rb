# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：リクエストパーサー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/04 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'unit/mock/mock_request'
require 'rkvi/rkv_client'
require 'rkvi/rkv_wrapper'
require 'business/biz_common/biz_rkv_initializer'
require 'data_cache/request_analysis_result_cache'

class RkvClientTest < ActiveSupport::TestCase
  include Mock
  include DataCache
  include FunctionState
  include Filter::RequestAnalysis
  include UnitTestUtil
  
  # 前処理
  def setup
    ###########################################################################
    # RKVオブジェクトの初期化
    ###########################################################################
    # ローカルサーバー停止
    DRb.stop_service
    rkv_client = Rkvi::RkvClient.instance
    rkv_client.svr_initializer = Business::BizCommon::BizRkvInitializer.new
    # RKVクライアント初期化
    rkv_client.refresh
  end
  
  # テスト対象メソッド：[],[]=
  test "CASE:2-1 [],[]=" do
    begin
      #########################################################################
      # 正常ケース
      # 接続：リモート接続
      # テスト内容：サーバーのデフォルト値確認
      #########################################################################
      rkv_client = Rkvi::RkvClient.instance
      rkv_client.svr_initializer = Business::BizCommon::BizRkvInitializer.new
      assert(!rkv_client.service_provider?, "CASE:2-1-1")
      # キャッシュロード日時ハッシュ
      loaded_at_hash = rkv_client[:updated_at]
      assert(!loaded_at_hash.nil?, "CASE:2-1-2")
      assert(Rkvi::RkvWrapper === loaded_at_hash, "CASE:2-1-3")
      # 通知リスト
      biz_notify_list = rkv_client[:biz_notify_list]
      assert(!biz_notify_list.nil?, "CASE:2-1-4")
      assert(Rkvi::RkvWrapper === biz_notify_list, "CASE:2-1-5")
      nodes = biz_notify_list.proc_nodes('TestProc2')
      assert(nodes.size == 2, "CASE:2-1-6")
    rescue=>ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
    begin
      #########################################################################
      # 正常ケース
      # 接続：リモート接続
      # テスト内容：ゲッター、セッター確認
      #########################################################################
      rkv_client = Rkvi::RkvClient.instance
      rkv_client.svr_initializer = Business::BizCommon::BizRkvInitializer.new
      assert(!rkv_client.service_provider?, "CASE:2-1-1")
      # []=
      test_data_1 = 'test_data_1'
      test_data_2 = Time.now
      test_data_3 = 3
      rkv_client[:test_data_1] = test_data_1
      rkv_client[:test_data_2] = test_data_2
      rkv_client[:test_data_3] = test_data_3
      # []
      assert(rkv_client[:test_data_1] == test_data_1, "CASE:2-1-7")
      assert(rkv_client[:test_data_2] == test_data_2, "CASE:2-1-8")
      assert(rkv_client[:test_data_3] == test_data_3, "CASE:2-1-9")
    rescue=>ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # テスト対象メソッド：service_provider?
  test "CASE:2-2-1 service_provider?" do
    begin
      #########################################################################
      # 正常ケース
      # 接続：リモート接続
      #########################################################################
      rkv_client = Rkvi::RkvClient.instance
      rkv_client.refresh
#      assert(rkv_client.service_provider?, "CASE:2-2-1")
    rescue=>ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # テスト対象メソッド：service_provider?
  test "CASE:2-2-2 service_provider?" do
    begin
      #########################################################################
      # 正常ケース
      # 接続：ローカル接続
      #########################################################################
      DRb.stop_service
      rkv_client = Rkvi::RkvClient.instance
      rkv_client.refresh
      # リモート接続不可能なので検証回避
      assert(!rkv_client.service_provider?, "CASE:2-2-2")
    rescue=>ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # テスト対象メソッド：refresh
  test "CASE:2-3 refresh" do
    begin
      #########################################################################
      # 正常ケース
      # 接続：リモート接続
      #########################################################################
      DRb.stop_service
      rkv_client = Rkvi::RkvClient.instance
      rkv_client.refresh
      assert(!rkv_client.service_provider?, "CASE:2-3-1")
    rescue=>ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
  
  # テスト対象メソッド：Performance
  test "CASE:3-1 Performance" do
    begin
      #########################################################################
      # 正常ケース
      # 初期処理：初回切り替え有り
      # セッター：初回切り替え有り、全セッター
      # 解析情報キャッシュ：新規追加
      #########################################################################
      rkv_client = Rkvi::RkvClient.instance
      # 大量データ生成
      DATA_COUNT = 1000
      data_list = Array.new
      DATA_COUNT.times do
        data_list.push(generate_str(CHAR_SET_ALPHABETIC, 1024))
      end
      # パフォーマンスチェック[]=
      begin_time = Time.now
      DATA_COUNT.times do |idx|
        rkv_client[idx.to_s] = data_list[idx]
      end
      execute_time = (Time.now.to_f - begin_time.to_f) * 1000
      Rails.logger.debug(DATA_COUNT.to_s + ' counts Set:' + execute_time.to_s + ' ms')
      # パフォーマンスチェック[]
      begin_time = Time.now
      DATA_COUNT.times do |idx|
        break unless rkv_client[idx.to_s] == data_list[idx]
      end
      execute_time = (Time.now.to_f - begin_time.to_f) * 1000
      Rails.logger.debug(DATA_COUNT.to_s + ' counts Get:' + execute_time.to_s + ' ms')
    rescue=>ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      raise ex
    end
  end
end