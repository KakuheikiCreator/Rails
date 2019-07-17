# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：リクエスト解析スケジュール
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/18 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'

class RequestAnalysisScheduleTest < ActiveSupport::TestCase
  include UnitTestUtil
  # 基本機能テスト
  # 登録・検索・更新・削除のテストを行う
  test "2-1:Basic functions Test" do
    # 登録
    begin
      info = RequestAnalysisSchedule.new
      info.gets_start_date = '2011-08-18 17:30:00 +0900'
      info.system_id = 1
      assert(info.save!, "CASE:2-1-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-1")
    end
    # 検索
#    RequestAnalysisSchedule.all.each do |ent|
#      print_log('gets_start_date:' + ent.gets_start_date.to_s)
#    end
    infos = RequestAnalysisSchedule.where(:gets_start_date => '2011-08-18 08:30:00 +0900')
#    print_log('infos.size:' + infos.size.to_s)
    assert(infos.size == 1, "CASE:2-1-2")
    # 更新
    begin
      info = infos[0]
      info.gets_start_date = '2011-08-18 17:40:00 +0900'
      assert(info.save!, "CASE:2-1-3-1")
      infos = RequestAnalysisSchedule.where(:gets_start_date => '2011-08-18 08:30:00 +0900')
      assert(infos.length == 0, "CASE:2-1-3-2")
      infos = RequestAnalysisSchedule.where(:gets_start_date => '2011-08-18 08:40:00 +0900')
      assert(infos.length == 1, "CASE:2-1-3-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = RequestAnalysisSchedule.where(:gets_start_date => '2011-08-18 08:40:00 +0900').destroy_all
      assert(result.length == 1, "CASE:2-1-4-1")
      result = RequestAnalysisSchedule.where(:gets_start_date => '2011-08-18 08:40:00 +0900')
      assert(result.length == 0, "CASE:2-1-4-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-4")
    end
  end
  
  # 検索（関連）テスト
  # テーブル間の関連のテストを行う
  test "2-2:Relationship Test" do
    # システム
    info = RequestAnalysisSchedule.find(1).system
    assert(System === info , "CASE:2-2-1")
    # リクエスト解析結果
    request_infos = RequestAnalysisSchedule.find(1).request_analysis_result
    assert(request_infos.length == 2, "CASE:2-2-2")
    request_infos.each do |ent|
      assert(RequestAnalysisResult === ent , "CASE:2-2-2")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-3:Validation Test:gets_start_date" do
    # 必須チェック
    begin
      info = RequestAnalysisSchedule.new
      info.gets_start_date = '2011-08-18 17:30:00'
      info.system_id = 1
      assert(info.valid?, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
    end
    begin
      info = RequestAnalysisSchedule.new
      info.gets_start_date = nil
      info.system_id = 1
      assert(!info.valid?, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-4:Validation Test:system_id" do
    # 必須チェック
    begin
      info = RequestAnalysisSchedule.new
      info.gets_start_date = '2011-08-18 17:30:00'
      info.system_id = 1
      assert(info.valid?, "CASE:2-4-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-1")
    end
    begin
      info = RequestAnalysisSchedule.new
      info.gets_start_date = '2011-08-18 17:30:00'
      info.system_id = nil
      assert(!info.valid?, "CASE:2-4-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-1")
    end
  end
  
  # 検索条件生成テスト
  # 検索条件のリスト生成テストを行う
  test "2-5:search_condition Test:" do
    # 正常：検索条件なし
    begin
      cond_hash = Hash.new
      cond_list = RequestAnalysisSchedule.find_condition_list(cond_hash)
      assert(cond_list.size == 0, "CASE:2-5-1-1")
      result_list = RequestAnalysisSchedule.find_list(cond_hash)
      assert(result_list.size == 7, "CASE:2-5-1-2")
      assert(result_list[0].id == 1, "CASE:2-5-1-3")
      assert(result_list[1].id == 2, "CASE:2-5-1-4")
      assert(result_list[2].id == 3, "CASE:2-5-1-5")
      assert(result_list[3].id == 4, "CASE:2-5-1-6")
      assert(result_list[4].id == 5, "CASE:2-5-1-7")
      assert(result_list[5].id == 6, "CASE:2-5-1-8")
      assert(result_list[6].id == 7, "CASE:2-5-1-9")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-1")
    end
    # 正常：システムID
    begin
      cond_hash = Hash.new
      cond_hash[:system_id] = 1
      cond_list = RequestAnalysisSchedule.find_condition_list(cond_hash)
      print_log('cond_list:' + cond_list.to_s)
      assert(cond_list.size == 2, "CASE:2-5-2-1")
      assert(cond_list[0] == 'system_id = ?', "CASE:2-5-2-2")
      assert(cond_list[1] == 1, "CASE:2-5-2-3")
      result_list = RequestAnalysisSchedule.find_list(cond_hash)
#      print_log('result_list.size:' + result_list.size.to_s)
      assert(result_list.size == 6, "CASE:2-5-2-4")
      assert(result_list[0].id == 1, "CASE:2-5-2-5")
      assert(result_list[1].id == 2, "CASE:2-5-2-6")
      assert(result_list[2].id == 3, "CASE:2-5-2-7")
      assert(result_list[3].id == 4, "CASE:2-5-2-7")
      assert(result_list[4].id == 5, "CASE:2-5-2-7")
      assert(result_list[5].id == 6, "CASE:2-5-2-7")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-2")
    end
    # 正常：取得開始日時（From）
    begin
      cond_hash = Hash.new
      cond_hash[:from_datetime] = DateTime.new(2011,9,17,0,0,0)
      cond_list = RequestAnalysisSchedule.find_condition_list(cond_hash)
#      print_log('cond_list:' + cond_list.to_s)
      assert(cond_list.size == 2, "CASE:2-5-3-1")
      assert(cond_list[0] == 'gets_start_date >= ?', "CASE:2-5-3-2")
      assert(cond_list[1] == DateTime.new(2011,9,17,0,0,0), "CASE:2-5-3-3")
      result_list = RequestAnalysisSchedule.find_list(cond_hash)
#      print_log('result_list:' + result_list.size.to_s)
      assert(result_list.size == 3, "CASE:2-5-3-4")
      assert(result_list[0].id == 5, "CASE:2-5-3-5")
      assert(result_list[1].id == 6, "CASE:2-5-3-5")
      assert(result_list[2].id == 7, "CASE:2-5-3-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-3")
    end
    # 正常：取得開始日時（To）
    begin
      cond_hash = Hash.new
      cond_hash[:to_datetime] = DateTime.new(2011,9,7,17,0,3)
      cond_list = RequestAnalysisSchedule.find_condition_list(cond_hash)
      assert(cond_list.size == 2, "CASE:2-5-4-1")
      assert(cond_list[0] == 'gets_start_date <= ?', "CASE:2-5-4-2")
      assert(cond_list[1] == DateTime.new(2011,9,7,17,0,3), "CASE:2-5-4-3")
      result_list = RequestAnalysisSchedule.find_list(cond_hash)
#      print_log('result_list:' + result_list.size.to_s)
      assert(result_list.size == 4, "CASE:2-5-4-4")
      assert(result_list[0].id == 1, "CASE:2-5-4-5")
      assert(result_list[1].id == 2, "CASE:2-5-4-6")
      assert(result_list[2].id == 3, "CASE:2-5-4-7")
      assert(result_list[3].id == 4, "CASE:2-5-4-8")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-4")
    end
    # 正常：全項目指定
    begin
      cond_hash = Hash.new
      cond_hash[:system_id] = 1
      cond_hash[:from_datetime] = DateTime.new(2011,9,7,17,0,1)
      cond_hash[:to_datetime] = DateTime.new(2011,9,7,17,0,2)
      ent = RequestAnalysisSchedule.new
      cond_list = RequestAnalysisSchedule.find_condition_list(cond_hash)
      assert(cond_list.size == 4, "CASE:2-5-7-1")
      assert(cond_list[0] == 'system_id = ? and gets_start_date >= ? and gets_start_date <= ?', "CASE:2-5-7-2")
      assert(cond_list[1] == 1, "CASE:2-5-7-3")
      assert(cond_list[2] == DateTime.new(2011,9,7,17,0,1), "CASE:2-5-7-4")
      assert(cond_list[3] == DateTime.new(2011,9,7,17,0,2), "CASE:2-5-7-5")
      result_list = RequestAnalysisSchedule.find_list(cond_hash)
      assert(result_list.size == 2, "CASE:2-5-7-6")
      assert(result_list[0].id == 2, "CASE:2-5-7-7")
      assert(result_list[1].id == 3, "CASE:2-5-7-8")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-7")
    end
  end
  
  # 重複データ検索テスト
  # 重複データ検索テストを行う
  test "2-6:duplicate Test:" do
    # 正常：値無し
    begin
      ent = RequestAnalysisSchedule.new
      cond_list = ent.generate_duplicate_condition
      assert(cond_list.size == 2, "CASE:2-6-1-1")
      assert(cond_list[:system_id].nil?, "CASE:2-6-1-2")
      assert(cond_list[:gets_start_date].nil?, "CASE:2-6-1-3")
      ent_list = RequestAnalysisSchedule.duplicate(ent)
      assert(ent_list.size == 0, "CASE:2-6-1-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-1")
    end
    # 正常：値有り
    begin
      ent = RequestAnalysisSchedule.new
      ent.system_id = 1
      ent.gets_start_date = DateTime.new(2011,9,17,0,0,0)
      cond_list = ent.generate_duplicate_condition
#      print_log('gets_start_date:' + cond_list[:gets_start_date].to_s)
      assert(cond_list.size == 2, "CASE:2-6-2-1")
      assert(cond_list[:system_id] == 1, "CASE:2-6-2-2")
      assert(cond_list[:gets_start_date] == DateTime.new(2011,9,17,0,0,0), "CASE:2-6-2-3")
      ent_list = RequestAnalysisSchedule.duplicate(ent)
      assert(ent_list.size == 1, "CASE:2-6-2-4")
      assert(ent_list[0].id == 5, "CASE:2-6-2-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-2")
    end
  end
end
