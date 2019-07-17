# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：機能
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/17 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'

class FunctionTest < ActiveSupport::TestCase
  include UnitTestUtil
  # 基本機能テスト
  # 登録・検索・更新・削除のテストを行う
  test "2-1:Basic functions Test" do
    # 登録
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test/test'
      info.function_name = '機能名'
      assert(info.save!, "CASE:2-1-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-1")
    end
    # 検索
    infos = Function.where(:function_name => '機能名')
    assert(infos.length == 1, "CASE:2-1-2")
    # 更新
    begin
      info = infos[0]
      info.function_path = 'test/test'
      info.function_name = '次の機能名'
      assert(info.save!, "CASE:2-1-3")
      infos = Function.where(:function_name => '機能名')
      assert(infos.length == 0, "CASE:2-1-3")
      infos = Function.where(:function_name => '次の機能名')
      assert(infos.length == 1, "CASE:2-1-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = Function.where(:function_name => '次の機能名').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = Function.where(:function_name => '次の機能名')
      assert(result.length == 0, "CASE:2-1-4")
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
    infos = Function.where(:function_name => 'アクセス解析')
    system = infos[0].system
    assert(!system.nil?, "CASE:2-2-1")
    assert(System === system , "CASE:2-2-1")
    # リクエスト解析結果
    analysis_infos = infos[0].request_analysis_result
    assert(analysis_infos.length == 2, "CASE:2-2-2")
    analysis_infos.each do |info|
      assert(RequestAnalysisResult === info , "CASE:2-2-2")
    end
  end
  
  # バリデーションテスト
  # システムIDのバリデーションチェックのテストを行う
  test "2-3:Validation Test:system_id" do
    # 必須チェック
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test/test'
      info.function_name = 'test'
      assert(info.valid?, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
    end
    begin
      info = Function.new
      info.system_id = nil
      info.function_path = 'test/test'
      info.function_name = 'test'
      assert(!info.valid?, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
    end
  end
  
  # バリデーションテスト
  # 機能パスのバリデーションチェックのテストを行う
  test "2-4:Validation Test:function_path" do
    # 必須チェック
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test/test'
      info.function_name = "test"
      assert(info.valid?, "CASE:2-4-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-1")
    end
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = nil
      info.function_name = 'test'
      assert(!info.valid?, "CASE:2-4-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-1")
    end
    # 桁数チェック
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = generate_str(CHAR_SET_ALPHABETIC, 1)
      info.function_name = 'test'
      assert(info.valid?, "CASE:2-4-2")
      info.function_path = generate_str(CHAR_SET_ALPHABETIC, 255)
      info.function_name = 'test'
      assert(info.valid?, "CASE:2-4-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-2")
    end
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = generate_str(CHAR_SET_ALPHABETIC, 256)
      info.function_name = 'test'
      assert(!info.valid?, "CASE:2-4-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-2")
    end
  end
  
  # バリデーションテスト
  # 機能名のバリデーションチェックのテストを行う
  test "2-5:Validation Test:function_name" do
    # 必須チェック
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test/test'
      info.function_name = "test"
      assert(info.valid?, "CASE:2-5-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-1")
    end
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test/test'
      info.function_name = nil
      assert(!info.valid?, "CASE:2-5-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-1")
    end
    # 桁数チェック
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test/test'
      info.function_name = generate_str(CHAR_SET_ALPHABETIC, 1)
      assert(info.valid?, "CASE:2-5-2")
      info.function_path = 'test/test'
      info.function_name = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(info.valid?, "CASE:2-5-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-2")
    end
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test/test'
      info.function_name = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!info.valid?, "CASE:2-5-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-2")
    end
  end

  
  # 機能パスチェックテスト
  # 機能パスの一致判定のテストを行う
  test "2-6:Test:function_path?" do
    # 引数チェック（文字列）
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test/test'
      info.function_name = "test"
      assert(info.function_path?('test/test'), "CASE:2-6-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-1")
    end
    # 引数チェック（数値）
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test/test'
      info.function_name = "test"
      assert(!info.function_path?(10), "CASE:2-6-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-2")
    end
    # 引数チェック（NULL）
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test/test'
      info.function_name = "test"
      assert(!info.function_path?(nil), "CASE:2-6-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-2")
    end
    # 機能パス判定（一致）
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test1/test2/test3'
      info.function_name = "test"
      assert(info.function_path?("test1/test2/test3"), "CASE:2-6-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-3")
    end
    # 機能パス判定（一致）
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test1/test2/test3'
      info.function_name = "test"
      assert(info.function_path?("test1/test2/test3/test4"), "CASE:2-6-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-3")
    end
    # 機能パス判定（一致）
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test1/test2/test3'
      info.function_name = "test"
      assert(info.function_path?("test1/test2/test3?test4"), "CASE:2-6-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-3")
    end
    # 機能パス判定（不一致）
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test1/test2/test3'
      info.function_name = "test"
      assert(!info.function_path?("test1/test2/test4"), "CASE:2-6-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-4")
    end
    # 機能パス判定（不一致）
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test1/test2/test3'
      info.function_name = "test"
      assert(!info.function_path?("test1/test2/test3_test4"), "CASE:2-6-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-4")
    end
    # 機能パス判定（不一致）
    begin
      info = Function.new
      info.system_id = 1
      info.function_path = 'test1/test2/test3'
      info.function_name = "test"
      assert(!info.function_path?("test1/test2/"), "CASE:2-6-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-4")
    end
  end


end
