# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：リクエスト解析結果キャッシュクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/09/16 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/request_analysis_result_cache'
require 'data_cache/system_cache'
require 'date'
require 'test_helper'
require 'unit/unit_test_util'

class RequestAnalysisResultCacheTest < ActiveSupport::TestCase
  include UnitTestUtil
  include DataCache
  # 前処理
  def setup
    SystemCache.instance.data_load
  end
  # 後処理
  def teardown
    
  end
  # パラメータクラステスト
  test "2-1:Parameter Test" do
    # コンストラクタ(正常)
    begin
      analysis_result = RequestAnalysisResult.new
      analysis_result.received_year = 2011
      analysis_result.received_month = 9
      analysis_result.received_day = 16
      analysis_result.function_id = 20
      analysis_result.function_transition_no = 10
      item_list = [:received_year, :received_month, :received_day, :function_id, :function_transition_no]
      param = RequestAnalysisResultCache::Parameter.new(analysis_result, item_list)
      assert(param.current_value == 2011, "CASE:2-1-2")
      assert(param.move_next?, "CASE:2-1-5")
      assert(param.current_value == 9, "CASE:2-1-2")
      assert(param.move_next?, "CASE:2-1-5")
      assert(param.current_value == 16, "CASE:2-1-2")
      assert(param.move_next?, "CASE:2-1-5")
      assert(param.current_value == 20, "CASE:2-1-2")
      assert(param.move_next?, "CASE:2-1-5")
      assert(param.current_value == 10, "CASE:2-1-2")
      assert(!param.move_next?, "CASE:2-1-6")
      assert(param.current_value == 10, "CASE:2-1-2")
      assert(param.move_before?, "CASE:2-1-3")
      assert(param.current_value == 20, "CASE:2-1-2")
      assert(param.move_before?, "CASE:2-1-3")
      assert(param.current_value == 16, "CASE:2-1-2")
      assert(param.move_before?, "CASE:2-1-3")
      assert(param.current_value == 9, "CASE:2-1-2")
      assert(param.move_before?, "CASE:2-1-3")
      assert(param.current_value == 2011, "CASE:2-1-2")
      assert(!param.move_before?, "CASE:2-1-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-1 -> 2-1-3")
      raise ex
    end
  end
  
  # ツリーノードクラステスト：コンストラクタ
  test "2-2:TreeNode Test:initialize" do
    # コンストラクタ（ホスト名設定パラメータ）
    begin
      analysis_result = RequestAnalysisResult.new
      analysis_result.received_year = 2011
      analysis_result.received_month = 9
      analysis_result.received_day = 16
      analysis_result.function_id = 20
      analysis_result.function_transition_no = 10
      item_list = [:received_year, :received_month, :received_day, :function_id, :function_transition_no]
      param = RequestAnalysisResultCache::Parameter.new(analysis_result, item_list)
      top_node = RequestAnalysisResultCache::TreeNode.new(param)
      assert(!top_node.nil?, "CASE:2-2-1")
      param.move_next?
      sub_node = RequestAnalysisResultCache::TreeNode.new(param, top_node)
      assert(!sub_node.nil?, "CASE:2-2-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-2-1->2-2-2")
      raise ex
    end
  end
  
  # ツリーノードクラステスト：ノード追加
  test "2-3:TreeNode Test:add_node" do
    # ノード追加（正常ケース）
    begin
      analysis_result = RequestAnalysisResult.new
      analysis_result.received_year = 2011
      analysis_result.received_month = 9
      analysis_result.received_day = 16
      analysis_result.function_id = 20
      analysis_result.function_transition_no = 10
      item_list = [:received_year, :received_month, :received_day, :function_id, :function_transition_no]
      param = RequestAnalysisResultCache::Parameter.new(analysis_result, item_list)
      top_node = RequestAnalysisResultCache::TreeNode.new(param)
      add_node = top_node.add_node(param)
      assert(top_node.value == 2011, "CASE:2-3-1")
      next_node = top_node.child_node_hash[9]
      assert(next_node.value == 9, "CASE:2-3-1")
      next_node = next_node.child_node_hash[16]
      assert(next_node.value == 16, "CASE:2-3-1")
      next_node = next_node.child_node_hash[20]
      assert(next_node.value == 20, "CASE:2-3-1")
      next_node = next_node.child_node_hash[10]
      assert(next_node.value == 10, "CASE:2-3-1")
      assert(add_node == next_node, "CASE:2-3-1")
      assert(next_node.value == 10, "CASE:2-3-1")
      # 途中の階層の項目値変更
      analysis_result = RequestAnalysisResult.new
      analysis_result.received_year = 2011
      analysis_result.received_month = 9
      analysis_result.received_day = 17
      analysis_result.function_id = 20
      analysis_result.function_transition_no = 10
      param = RequestAnalysisResultCache::Parameter.new(analysis_result, item_list)
      add_node = top_node.add_node(param)
      assert(top_node.value == 2011, "CASE:2-3-1")
      next_node = top_node.child_node_hash[9]
      assert(next_node.value == 9, "CASE:2-3-1")
      next_node = next_node.child_node_hash[17]
      assert(next_node.value == 17, "CASE:2-3-1")
      next_node = next_node.child_node_hash[20]
      assert(next_node.value == 20, "CASE:2-3-1")
      next_node = next_node.child_node_hash[10]
      assert(next_node.value == 10, "CASE:2-3-1")
      assert(add_node == next_node, "CASE:2-3-1")
      assert(next_node.value == 10, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
      raise ex
    end
  end
  
  # ツリーノードクラステスト：ノード削除
  test "2-4:TreeNode Test:delete_node" do
    # ノード削除(単一データ)
    begin
      analysis_result = RequestAnalysisResult.new
      analysis_result.received_year = 2011
      analysis_result.received_month = 9
      analysis_result.received_day = 16
      analysis_result.function_id = 20
      analysis_result.function_transition_no = 10
      item_list = [:received_year, :received_month, :received_day, :function_id, :function_transition_no]
      param = RequestAnalysisResultCache::Parameter.new(analysis_result, item_list)
      top_node = RequestAnalysisResultCache::TreeNode.new(param)
      add_node_1 = top_node.add_node(param)
      assert(top_node.value == 2011, "CASE:2-4-1")
      next_node = top_node.child_node_hash[9]
      assert(next_node.value == 9, "CASE:2-4-1")
      next_node = next_node.child_node_hash[16]
      assert(next_node.value == 16, "CASE:2-4-1")
      next_node = next_node.child_node_hash[20]
      assert(next_node.value == 20, "CASE:2-4-1")
      next_node = next_node.child_node_hash[10]
      assert(next_node.value == 10, "CASE:2-4-1")
      add_node_1.delete_node
      assert(top_node.child_node_hash[9].nil?, "CASE:2-4-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-1")
      raise ex
    end
    # ノード削除(複数データ)
    begin
      # ノード１追加
      item_list = [:received_year, :received_month, :received_day, :function_id, :function_transition_no]
      analysis_result = RequestAnalysisResult.new
      analysis_result.received_year = 2011
      analysis_result.received_month = 9
      analysis_result.received_day = 16
      analysis_result.function_id = 20
      analysis_result.function_transition_no = 10
      param = RequestAnalysisResultCache::Parameter.new(analysis_result, item_list)
      top_node = RequestAnalysisResultCache::TreeNode.new(param)
      add_node_1 = top_node.add_node(param)
      # ノード２追加
      analysis_result.received_year = 2011
      analysis_result.received_month = 9
      analysis_result.received_day = 16
      analysis_result.function_id = 20
      analysis_result.function_transition_no = 30
      param = RequestAnalysisResultCache::Parameter.new(analysis_result, item_list)
      add_node_2 = top_node.add_node(param)
      # ノード１削除
      add_node_1.delete_node
      # ノード３追加
      analysis_result.received_year = 2011
      analysis_result.received_month = 9
      analysis_result.received_day = 16
      analysis_result.function_id = 20
      analysis_result.function_transition_no = 10
      param = RequestAnalysisResultCache::Parameter.new(analysis_result, item_list)
      add_node_3 = top_node.add_node(param)
      # ノード４追加
      analysis_result.received_year = 2011
      analysis_result.received_month = 9
      analysis_result.received_day = 16
      analysis_result.function_id = 20
      analysis_result.function_transition_no = 30
      param = RequestAnalysisResultCache::Parameter.new(analysis_result, item_list)
      add_node_4 = top_node.add_node(param)
      assert(add_node_1 != add_node_3, "CASE:2-4-2")
      assert(add_node_2 == add_node_4, "CASE:2-4-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-2")
      raise ex
    end
  end
  
  # リンクリストノードクラステスト：コンストラクタ
  test "2-5:LinkListNode Test:initialize" do
    # 存在するドメイン名を追加
    begin
      # ツリーノード生成
      item_list = [:received_year, :received_month, :received_day, :function_id, :function_transition_no]
      analysis_result = RequestAnalysisResult.new
      analysis_result.received_year = 2011
      analysis_result.received_month = 9
      analysis_result.received_day = 16
      analysis_result.function_id = 20
      analysis_result.function_transition_no = 10
      param = RequestAnalysisResultCache::Parameter.new(analysis_result, item_list)
      top_node = RequestAnalysisResultCache::TreeNode.new(param)
      tree_node = top_node.add_node(param)
      # リンクリストノード生成
      list_node = RequestAnalysisResultCache::LinkListNode.new(param, tree_node)
      assert(list_node.analysis_result == analysis_result, "CASE:2-5-1")
      assert(list_node.tree_node == tree_node, "CASE:2-5-1")
      assert(list_node.request_count == 1, "CASE:2-5-1")
      assert(list_node.previous_node.nil?, "CASE:2-5-1")
      assert(list_node.next_node.nil?, "CASE:2-5-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-1")
      raise ex
    end
  end
  
  # リンクリストノードクラステスト：ノード追加
  test "2-6:LinkListNode Test:set_next_node" do
    # 存在するドメイン名を追加
    begin
      # ツリーノード１生成
      item_list = [:received_year, :received_month, :received_day, :function_id, :function_transition_no]
      analysis_result_1 = RequestAnalysisResult.new
      analysis_result_1.received_year = 2011
      analysis_result_1.received_month = 9
      analysis_result_1.received_day = 16
      analysis_result_1.function_id = 20
      analysis_result_1.function_transition_no = 10
      param_1 = RequestAnalysisResultCache::Parameter.new(analysis_result_1, item_list)
      top_node = RequestAnalysisResultCache::TreeNode.new(param_1)
      tree_node_1 = top_node.add_node(param_1)
      # リンクリストノード１生成
      list_node_1 = RequestAnalysisResultCache::LinkListNode.new(param_1, tree_node_1)
      # ツリーノード２生成
      analysis_result_2 = RequestAnalysisResult.new
      analysis_result_2.received_year = 2011
      analysis_result_2.received_month = 9
      analysis_result_2.received_day = 16
      analysis_result_2.function_id = 20
      analysis_result_2.function_transition_no = 11
      param_2 = RequestAnalysisResultCache::Parameter.new(analysis_result_2, item_list)
      tree_node_2 = top_node.add_node(param_2)
      # リンクリストノード２生成
      list_node_2 = RequestAnalysisResultCache::LinkListNode.new(param_2, tree_node_2)
      # 次ノードの接続
      list_node_1.set_next_node(list_node_2)
      assert(list_node_1.next_node == list_node_2, "CASE:2-6-1")
      assert(list_node_2.previous_node == list_node_1, "CASE:2-6-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-1")
      raise ex
    end
  end
  
  # リンクリストノードクラステスト：ノード切り離し
  test "2-7:LinkListNode Test:removal_node" do
    # ノード切り離し
    begin
      # ツリーノード１生成
      item_list = [:received_year, :received_month, :received_day, :function_id, :function_transition_no]
      analysis_result_1 = RequestAnalysisResult.new
      analysis_result_1.received_year = 2011
      analysis_result_1.received_month = 9
      analysis_result_1.received_day = 16
      analysis_result_1.function_id = 20
      analysis_result_1.function_transition_no = 10
      param_1 = RequestAnalysisResultCache::Parameter.new(analysis_result_1, item_list)
      top_node = RequestAnalysisResultCache::TreeNode.new(param_1)
      tree_node_1 = top_node.add_node(param_1)
      # リンクリストノード１生成
      list_node_1 = RequestAnalysisResultCache::LinkListNode.new(param_1, tree_node_1)
      # ツリーノード２生成
      analysis_result_2 = RequestAnalysisResult.new
      analysis_result_2.received_year = 2011
      analysis_result_2.received_month = 9
      analysis_result_2.received_day = 16
      analysis_result_2.function_id = 20
      analysis_result_2.function_transition_no = 11
      param_2 = RequestAnalysisResultCache::Parameter.new(analysis_result_2, item_list)
      tree_node_2 = top_node.add_node(param_2)
      # リンクリストノード２生成
      list_node_2 = RequestAnalysisResultCache::LinkListNode.new(param_2, tree_node_2)
      # ツリーノード３生成
      analysis_result_3 = RequestAnalysisResult.new
      analysis_result_3.received_year = 2011
      analysis_result_3.received_month = 9
      analysis_result_3.received_day = 16
      analysis_result_3.function_id = 21
      analysis_result_3.function_transition_no = 10
      param_3 = RequestAnalysisResultCache::Parameter.new(analysis_result_3, item_list)
      tree_node_3 = top_node.add_node(param_2)
      # リンクリストノード３生成
      list_node_3 = RequestAnalysisResultCache::LinkListNode.new(param_3, tree_node_3)
      # ノードの接続
      list_node_1.set_next_node(list_node_2)
      list_node_2.set_next_node(list_node_3)
      # ノード２を切り離す
      list_node_2.removal_node
      #　ノード比較
      assert(list_node_1.next_node == list_node_3, "CASE:2-7-1")
      assert(list_node_3.previous_node == list_node_1, "CASE:2-7-1")
      assert(list_node_2.next_node.nil?, "CASE:2-7-1")
      assert(list_node_2.previous_node.nil?, "CASE:2-7-1")
      # ノードの接続
      list_node_1.set_next_node(list_node_2)
      list_node_2.set_next_node(list_node_3)
      # ノード３を切り離す
      list_node_3.removal_node
      #　ノード比較
      assert(list_node_2.next_node.nil?, "CASE:2-7-2")
      assert(list_node_2.previous_node == list_node_1, "CASE:2-7-2")
      assert(list_node_3.next_node.nil?, "CASE:2-7-2")
      assert(list_node_3.previous_node.nil?, "CASE:2-7-2")
      # ノード１を切り離す
      list_node_1.removal_node
      #　ノード比較
      assert(list_node_2.next_node.nil?, "CASE:2-7-3")
      assert(list_node_2.previous_node.nil?, "CASE:2-7-3")
      assert(list_node_1.next_node.nil?, "CASE:2-7-3")
      assert(list_node_1.previous_node.nil?, "CASE:2-7-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-7-1")
      raise ex
    end
  end
  
  # 設定単位情報クラステスト：コンストラクタ
  test "2-8:SettingUnitInfo:initialize" do
    # コンストラクタ
    begin
      # ツリーノード１生成
      setting = RequestAnalysisSchedule.find(5)
      setting_info = RequestAnalysisResultCache::SettingUnitInfo.new(setting)
      assert(setting_info.data_count == 0, "CASE:2-8-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-8-1")
      raise ex
    end
  end
  
  # 設定単位情報クラステスト：クエスト解析情報カウントアップ
  test "2-9:SettingUnitInfo:request_count_up" do
#    print("2-9:SettingUnitInfo:request_count_up\n")
#    flunk("CASE:2-9:No Execution")
    # クエスト解析情報追加
    start_time = Time.now
    begin
#      f = File::open("log.txt", "a") # 追加モード
#      ActiveRecord::Base.logger = Logger.new(f)
      setting = RequestAnalysisSchedule.find(5)
      setting_info = RequestAnalysisResultCache::SettingUnitInfo.new(setting)
      data_list = Array.new
      # リクエスト解析結果追加
      100000.times do |idx|
        analysis_result = RequestAnalysisResult.new
        analysis_result.system_id = 1
        analysis_result.request_analysis_schedule_id = 5
        analysis_result.received_year = 2012
        analysis_result.received_month = 9
        analysis_result.received_day = 17
        analysis_result.function_id = 21
        analysis_result.function_transition_no = idx % 10000 + 1
#        print("Index:", idx, "\n")
#        print("Data Count:", setting_info.data_count, "\n")
        setting_info.request_count_up(analysis_result)
        data_list.push(analysis_result)
        if (idx + 1) < 10000 then
          assert(setting_info.data_count == (idx + 1), "CASE:2-9-1")
        elsif (idx + 1) >= 10000 then
#          print("Insert Before:", idx, ":", setting_info.data_count, "\n")
          assert(setting_info.data_count == 10000, "CASE:2-9-1")
        end
      end
      node_list = Array.new
      setting_info.eject_node(node_list, 1000)
      assert(node_list.size == 1000, "CASE:2-10-1")
      node_list.size.times do |idx|
        insert_data = data_list[idx]
        chche_data = node_list[idx].analysis_result
        assert(chche_data.system_id == insert_data.system_id, "CASE:2-10-2")
        assert(chche_data.request_analysis_schedule_id == insert_data.request_analysis_schedule_id, "CASE:2-10-2")
        assert(chche_data.received_year == insert_data.received_year, "CASE:2-10-2")
        assert(chche_data.received_month == insert_data.received_month, "CASE:2-10-2")
        assert(chche_data.received_day == insert_data.received_day, "CASE:2-10-2")
        assert(chche_data.function_id == insert_data.function_id, "CASE:2-10-2")
        assert(chche_data.function_transition_no == insert_data.function_transition_no, "CASE:2-10-2")
        assert(node_list[idx].request_count == 10, "CASE:2-10-2")
      end
      node_list = Array.new
      setting_info.eject_node(node_list)
      assert(node_list.size == 9000, "CASE:2-10-2")
#      f.close
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
#      flunk("CASE:2-9-1")
      raise ex
    end
  end
  
  # リクエスト解析結果キャッシュクラステスト：コンストラクタ
  test "2-11:RequestAnalysisResultCache:initialize" do
    # コンストラクタテスト
    begin
      # ツリーノード１生成
      setting = RequestAnalysisSchedule.find(5)
      cache = RequestAnalysisResultCache.instance
      assert(!cache.nil?, "CASE:2-11-1")
      assert(RequestAnalysisResultCache === cache, "CASE:2-11-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
#      flunk("CASE:2-11-1")
      raise ex
    end
  end
  
  # リクエスト解析結果キャッシュクラステスト：キャッシュサイズ設定
  test "2-12:RequestAnalysisResultCache:set_cache_size" do
#    print("2-12:RequestAnalysisResultCache:set_cache_size\n")
#    flunk("CASE:2-12:No Execution")
    # キャッシュサイズ設定：キャッシュサイズ範囲内
    begin
      setting = RequestAnalysisSchedule.find(5)
      cache = RequestAnalysisResultCache.instance
      cache.set_cache_size(1000,100)
      assert(cache.max_data_count == 1000, "CASE:2-12-1")
      assert(cache.persistent_data_count == 100, "CASE:2-12-1")
      cache.set_cache_size(10000,3000)
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
#      flunk("CASE:2-11-1")
      raise ex
    end
    # キャッシュサイズ設定：キャッシュサイズオーバー
    begin
      setting = RequestAnalysisSchedule.find(5)
      cache = RequestAnalysisResultCache.instance
      # 実行前件数
      count = RequestAnalysisResult.where("received_year = ?", 2013).count
      print_log("Count Before:" + count.to_s)
      # リクエスト解析結果追加
      1000.times do |idx|
        analysis_result = RequestAnalysisResult.new
        analysis_result.system_id = 1
        analysis_result.request_analysis_schedule_id = 5
        analysis_result.received_year = 2013
        analysis_result.received_month = 9
        analysis_result.received_day = 17
        analysis_result.function_id = 21
        analysis_result.function_transition_no = idx + 1
        cache.request_count_up(setting, analysis_result)
      end
      cache.set_cache_size(100,10)
      assert(cache.max_data_count == 100, "CASE:2-12-2")
      assert(cache.persistent_data_count == 10, "CASE:2-12-2")
      sleep(40)
#      count = RequestAnalysisResult.where("received_year = ?", 2013).count
      count = RequestAnalysisResult.all.count
      print_log("Count After:" + count.to_s)
      assert(count == 910, "CASE:2-12-2")
      cache.set_cache_size(10000,3000)
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
#      flunk("CASE:2-11-1")
      raise ex
    end
  end
  
  # リクエスト解析結果キャッシュクラステスト：リクエスト回数カウントアップ
  test "2-13:RequestAnalysisResultCache:request_count_up" do
#    print("2-13:RequestAnalysisResultCache:request_count_up\n")
#    flunk("CASE:2-13:No Execution")
    # 正常ケース
    begin
      # キャッシュ生成
      setting = RequestAnalysisSchedule.find(5)
      cache = RequestAnalysisResultCache.instance
      # リクエスト解析結果カウントアップ
      2000.times do |idx|
        analysis_result = RequestAnalysisResult.new
        analysis_result.system_id = 1
        analysis_result.request_analysis_schedule_id = 5
        analysis_result.received_year = 2030
        analysis_result.received_month = 9
        analysis_result.received_day = 10
        analysis_result.function_id = 20
        analysis_result.function_transition_no = idx % 100 + 1
        cache.request_count_up(setting, analysis_result)
      end
      # 設定情報を切り替えて、先程キャッシュに投入した全データを永続化
      setting = RequestAnalysisSchedule.new
      setting.id = 6
      setting.system_id = 1
      analysis_result = RequestAnalysisResult.new
      analysis_result.system_id = 1
      analysis_result.request_analysis_schedule_id = 6
      analysis_result.received_year = 2031
      analysis_result.received_month = 9
      analysis_result.received_day = 10
      analysis_result.function_id = 20
      analysis_result.function_transition_no = 10000
      # データ登録
      cache.request_count_up(setting, analysis_result)
      # 登録完了待ち
      sleep(30)
      infos = RequestAnalysisResult.where("received_year = 2030").order("function_transition_no")
      print("Insert Data Count:", infos.count, "\n")
      assert(infos.size == 100, "CASE:2-13-1")
      100.times do |idx|
#        print("Function Transition No:", infos[idx].function_transition_no, "\n")
        assert(infos[idx].system_id == 1, "CASE:2-13-1")
        assert(infos[idx].request_analysis_schedule_id == 5, "CASE:2-13-1")
        assert(infos[idx].received_year == 2030, "CASE:2-13-1")
        assert(infos[idx].received_month == 9, "CASE:2-13-1")
        assert(infos[idx].received_day == 10, "CASE:2-13-1")
        assert(infos[idx].function_id == 20, "CASE:2-13-1")
        assert(infos[idx].function_transition_no == (idx + 1), "CASE:2-13-1")
        assert(infos[idx].request_count == 20, "CASE:2-13-1")
      end
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
#      flunk("CASE:2-12-1")
      raise ex
    end
    # 正常ケース（設定情報NULL）
    begin
      # キャッシュ生成
      cache = RequestAnalysisResultCache.instance
      # リクエスト解析結果カウントアップ
      2000.times do |idx|
        analysis_result = RequestAnalysisResult.new
        analysis_result.system_id = 1
        analysis_result.request_analysis_schedule_id = 5
        analysis_result.received_year = 2040
        analysis_result.received_month = 9
        analysis_result.received_day = 10
        analysis_result.function_id = 20
        analysis_result.function_transition_no = idx % 100 + 1
        cache.request_count_up(nil, analysis_result)
      end
      # 設定情報を切り替えて、先程キャッシュに投入した全データを永続化
      setting = RequestAnalysisSchedule.new
      setting.id = 6
      analysis_result = RequestAnalysisResult.new
      analysis_result.system_id = 1
      analysis_result.request_analysis_schedule_id = 6
      analysis_result.received_year = 2040
      analysis_result.received_month = 9
      analysis_result.received_day = 10
      analysis_result.function_id = 20
      analysis_result.function_transition_no = 10000
      # データ登録
      cache.request_count_up(setting, analysis_result)
      # 登録完了待ち
      sleep(20)
      infos = RequestAnalysisResult.where("received_year = 2040").order("function_transition_no")
#      print("Insert Data Count:", infos.count, "\n")
      assert(infos.size == 100, "CASE:2-13-2")
      100.times do |idx|
#        print("Function Transition No:", infos[idx].function_transition_no, "\n")
        assert(infos[idx].system_id == 1, "CASE:2-13-2")
        assert(infos[idx].request_analysis_schedule_id == 5, "CASE:2-13-2")
        assert(infos[idx].received_year == 2040, "CASE:2-13-2")
        assert(infos[idx].received_month == 9, "CASE:2-13-2")
        assert(infos[idx].received_day == 10, "CASE:2-13-2")
        assert(infos[idx].function_id == 20, "CASE:2-13-2")
        assert(infos[idx].function_transition_no == (idx + 1), "CASE:2-13-2")
        assert(infos[idx].request_count == 20, "CASE:2-13-2")
      end
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
#      flunk("CASE:2-12-1")
      raise ex
    end
    # 異常ケース（解析情報NULL）
    begin
      # キャッシュ生成
      cache = RequestAnalysisResultCache.instance
      # リクエスト解析結果カウントアップ
      setting = RequestAnalysisSchedule.find(5)
      cache.request_count_up(setting, nil)
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
#      flunk("CASE:2-12-3")
      assert(ArgumentError === ex, "CASE:2-13-3")
#      raise ex
    end
  end
  
  # リクエスト解析結果キャッシュテスト：パフォーマンステスト
  test "3-1:Performance Test:request_count_up" do
#    flunk("CASE:3-1 No Execute")
    ###########################################################################
    # ランダムなドメイン名を生成し、テストデータとしてドメインテーブルに登録
    ###########################################################################
    # クエスト解析情報追加
    begin
#      f = File::open("log.txt", "a") # 追加モード
#      ActiveRecord::Base.logger = Logger.new(f)
      setting = RequestAnalysisSchedule.find(5)
      data_list = Array.new
      # リクエスト解析結果追加
      10000.times do |idx|
        analysis_result = RequestAnalysisResult.new
        analysis_result.system_id = 1
        analysis_result.request_analysis_schedule_id = 5
        analysis_result.received_year = 2050
        analysis_result.received_month = 9
        analysis_result.received_day = 17
        analysis_result.function_id = 21
        analysis_result.function_transition_no = idx % 10000 + 1
        data_list.push(analysis_result)
      end
      # キャッシュ生成
      cache = RequestAnalysisResultCache.instance
      # パフォーマンス測定（カウントアップ）
      start_time = Time.now
      data_list.each do |info|
        cache.request_count_up(setting, info)
      end
      process_time = Time.now.usec - start_time.usec
      print("Count up time:", process_time, "u second\n")
      # 設定情報切り替え
      setting = RequestAnalysisSchedule.find(4)
      analysis_result = RequestAnalysisResult.new
      analysis_result.system_id = 1
      analysis_result.request_analysis_schedule_id = 4
      analysis_result.received_year = 2060
      analysis_result.received_month = 9
      analysis_result.received_day = 17
      # パフォーマンス測定（カウントアップ）
      start_time = Time.now
      cache.request_count_up(setting, analysis_result)
      process_time = Time.now.usec - start_time.usec
      print("Switch time:", process_time, "u second\n")
#      until RequestAnalysisResult.where("received_year = 2050").count == 10000 do
#        sleep(10)
#      end
      process_time = Time.now.usec - start_time.usec
      print("Persistence time:", process_time, "u second\n")
#      f.close
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
#      flunk("CASE:2-9-1")
      raise ex
    end
  end
end
