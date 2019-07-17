# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：規制クッキークラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'

class RegulationCookieTest < ActiveSupport::TestCase
  include UnitTestUtil
  # 基本機能テスト
  # 登録・検索・更新・削除のテストを行う
  test "2-1:Basic functions Test" do
    # 登録
    begin
      info = RegulationCookie.new
      info.system_id = 1
      info.cookie = '^test cookie'
      assert(info.save!, "CASE:2-1-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-1")
    end
    # 検索
    infos = RegulationCookie.where(:cookie => '^test cookie')
    assert(infos.length == 1, "CASE:2-1-2")
    # 更新
    begin
      info = infos[0]
      info.cookie = '^next cookie'
      assert(info.save!, "CASE:2-1-3")
      infos = RegulationCookie.where(:cookie => '^test cookie')
      assert(infos.length == 0, "CASE:2-1-3")
      infos = RegulationCookie.where(:cookie => '^next cookie')
      assert(infos.length == 1, "CASE:2-1-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = RegulationCookie.where(:cookie => '^next cookie').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = RegulationCookie.where(:cookie => '^next cookie')
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
    infos = RegulationCookie.where(:cookie => '^[abc]$')
    info = infos[0].system
    assert(System === info , "CASE:2-2-1")
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-3:Validation Test:system_id" do
    # 必須チェック
    begin
      info = RegulationCookie.new
      info.system_id = 1
      info.cookie = '^test cookie'
      assert(info.valid?, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
    end
    begin
      info = RegulationCookie.new
      info.system_id = nil
      info.cookie = '^test cookie'
      assert(!info.valid?, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-4:Validation Test:cookie" do
    # 必須チェック
    begin
      info = RegulationCookie.new
      info.system_id = 1
      info.cookie = '^test cookie'
      assert(info.valid?, "CASE:2-4-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-1")
    end
    begin
      info = RegulationCookie.new
      info.system_id = 1
      info.cookie = nil
      assert(!info.valid?, "CASE:2-4-1")
      info.errors.each do |attribute, error|
        print_log("CASE:2-4-1 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :cookie, "CASE:2-4-1")
        assert_equal(error, "を入力してください。", "CASE:2-4-1")
      end
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-1")
    end
    # 桁数チェック
    begin
      info = RegulationCookie.new
      info.system_id = 1
      info.cookie = "^"
      assert(info.valid?, "CASE:2-4-2")
      info.cookie = "^" + generate_str(CHAR_SET_ALPHABETIC, 1023)
      assert(info.valid?, "CASE:2-4-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-2")
    end
    begin
      info = RegulationCookie.new
      info.system_id = 1
      info.cookie = "^" + generate_str(CHAR_SET_ALPHABETIC, 1024)
      assert(!info.valid?, "CASE:2-4-2")
      info.errors.each do |attribute, error|
        print_log("CASE:2-4-2 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :cookie, "CASE:2-4-2")
        assert_equal(error, "は1024文字以内で入力してください。", "CASE:2-4-2")
      end
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-2")
    end
    # 正規表現チェック
    begin
      info = RegulationCookie.new
      info.system_id = 1
      info.cookie = "^"
      assert(info.valid?, "CASE:2-4-3-1")
      info.cookie = "^[1234]$"
      assert(info.valid?, "CASE:2-4-3-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-3")
    end
    begin
      info = RegulationCookie.new
      info.system_id = 1
      info.cookie = "^["
      assert(!info.valid?, "CASE:2-4-3-3-1")
      info.errors.each do |attribute, error|
        print_log("CASE:2-4-3-3-1 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :cookie, "CASE:2-4-3-3-1")
        assert_equal(error, "は不正な値です。", "CASE:2-4-3-3-1")
      end
      info.cookie = ".["
      assert(!info.valid?, "CASE:2-4-3-3-2")
      info.errors.each do |attribute, error|
        print_log("CASE:2-4-3-3-2 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :cookie, "CASE:2-4-3-3-2")
        assert_equal(error, "は不正な値です。", "CASE:2-4-3-3-2")
      end
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-3")
    end
  end
  
  # 検索条件生成テスト
  # 検索条件のリスト生成テストを行う
  test "2-5:search_condition Test:" do
    # 正常：検索条件なし
    begin
      ent = RegulationCookie.new
      cond_list = ent.search_condition
      assert(cond_list.size == 0, "CASE:2-5-1-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-1")
    end
    # 正常：システムID
    begin
      ent = RegulationCookie.new
      ent.system_id = 1
      cond_list = ent.search_condition
      assert(cond_list.size == 2, "CASE:2-5-2-1")
      assert(cond_list[0] == 'system_id = ?', "CASE:2-5-2-2")
      assert(cond_list[1] == 1, "CASE:2-5-2-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-2")
    end
    # 正常：クッキー
    begin
      ent = RegulationCookie.new
      ent.cookie = 'test cookie'
      cond_list = ent.search_condition
      assert(cond_list.size == 2, "CASE:2-5-3-1")
      assert(cond_list[0] == 'cookie like ?', "CASE:2-5-3-2")
      assert(cond_list[1] == '%test cookie%', "CASE:2-5-3-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-3")
    end
    # 正常：備考
    begin
      ent = RegulationCookie.new
      ent.remarks = 'test remarks'
      cond_list = ent.search_condition
      assert(cond_list.size == 2, "CASE:2-5-4-1")
      assert(cond_list[0] == 'remarks like ?', "CASE:2-5-4-2")
      assert(cond_list[1] == '%test remarks%', "CASE:2-5-4-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-4")
    end
    # 正常：システムID＋クッキー
    begin
      ent = RegulationCookie.new
      ent.system_id = 1
      ent.cookie = 'test cookie'
      cond_list = ent.search_condition
#      Rails.logger.debug('cond_list:' + cond_list.to_s)
      assert(cond_list.size == 3, "CASE:2-5-5-1")
      assert(cond_list[0] == 'system_id = ? and cookie like ?', "CASE:2-5-5-2")
      assert(cond_list[1] == 1, "CASE:2-5-5-3")
      assert(cond_list[2] == '%test cookie%', "CASE:2-5-5-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-5")
    end
    # 正常：システムID＋備考
    begin
      ent = RegulationCookie.new
      ent.system_id = 1
      ent.remarks = 'test remarks'
      cond_list = ent.search_condition
      assert(cond_list.size == 3, "CASE:2-5-6-1")
      assert(cond_list[0] == 'system_id = ? and remarks like ?', "CASE:2-5-6-2")
      assert(cond_list[1] == 1, "CASE:2-5-6-3")
      assert(cond_list[2] == '%test remarks%', "CASE:2-5-6-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-6")
    end
    # 正常：システムID＋クッキー＋備考
    begin
      ent = RegulationCookie.new
      ent.system_id = 1
      ent.cookie = 'test cookie'
      ent.remarks = 'test remarks'
      cond_list = ent.search_condition
      assert(cond_list.size == 4, "CASE:2-5-7-1")
      assert(cond_list[0] == 'system_id = ? and cookie like ? and remarks like ?', "CASE:2-5-7-2")
      assert(cond_list[1] == 1, "CASE:2-5-7-3")
      assert(cond_list[2] == '%test cookie%', "CASE:2-5-7-4")
      assert(cond_list[3] == '%test remarks%', "CASE:2-5-7-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-7")
    end
    # 正常：クッキー＋備考
    begin
      ent = RegulationCookie.new
      ent.cookie = 'test cookie'
      ent.remarks = 'test remarks'
      cond_list = ent.search_condition
      assert(cond_list.size == 3, "CASE:2-5-8-1")
      assert(cond_list[0] == 'cookie like ? and remarks like ?', "CASE:2-5-8-2")
      assert(cond_list[1] == '%test cookie%', "CASE:2-5-8-3")
      assert(cond_list[2] == '%test remarks%', "CASE:2-5-8-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-8")
    end
    # 正常：クッキー、備考のエスケープ処理
    begin
      ent = RegulationCookie.new
      ent.cookie = 'test\cookie%_'
      ent.remarks = 'test\remarks%_'
      cond_list = ent.search_condition
      assert(cond_list.size == 3, "CASE:2-5-9-1")
      assert(cond_list[0] == 'cookie like ? and remarks like ?', "CASE:2-5-9-2")
      assert(cond_list[1] == '%test\\\\cookie\%\_%', "CASE:2-5-9-3")
      assert(cond_list[2] == '%test\\\\remarks\%\_%', "CASE:2-5-9-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-9")
    end
  end
  
  # 検索条件生成テスト
  # 重複データ検索条件生成テストを行う
  test "2-6:generate_duplicate_condition Test:" do
    # 正常：値無し
    begin
      ent = RegulationCookie.new
      cond_list = ent.generate_duplicate_condition
      assert(cond_list.size == 2, "CASE:2-6-1-1")
      assert(cond_list[:system_id].nil?, "CASE:2-6-1-2")
      assert(cond_list[:cookie].nil?, "CASE:2-6-1-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-1")
    end
    # 正常：値有り
    begin
      ent = RegulationCookie.new
      ent.system_id = 1
      ent.cookie = 'test cookie'
      ent.remarks = 'test remarks'
      cond_list = ent.generate_duplicate_condition
      assert(cond_list.size == 2, "CASE:2-6-2-1")
      assert(cond_list[:system_id] == 1, "CASE:2-6-2-2")
      assert(cond_list[:cookie] == 'test cookie', "CASE:2-6-2-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-2")
    end
  end
  
  # 検索テスト
  # 検索処理テスト
  test "2-7:search_list Test:" do
    # 正常：値無し
    begin
      cond_ent = RegulationCookie.new
      ent_list = RegulationCookie.search_list(cond_ent)
      assert(ent_list.size == 4, "CASE:2-7-1-1")
      idx = 0
      ent_list.each do |ent|
        idx += 1
        assert(ent.id == idx, "CASE:2-7-1-2")
      end
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-7-1")
    end
    # 正常：全ての条件指定
    begin
      cond_ent = RegulationCookie.new
      cond_ent.system_id = 1
      cond_ent.cookie = '123'
      cond_ent.remarks = 'Str'
      ent_list = RegulationCookie.search_list(cond_ent)
      assert(ent_list.size == 1, "CASE:2-7-2-1")
      assert(ent_list[0].id == 1, "CASE:2-7-2-2")
      assert(ent_list[0].system_id == 1, "CASE:2-7-2-3")
      assert(ent_list[0].cookie == '^[123]$', "CASE:2-7-2-4")
      assert(ent_list[0].remarks == 'MyString', "CASE:2-7-2-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-7-2")
    end
    # 正常：システムID＋クッキー
    begin
      cond_ent = RegulationCookie.new
      cond_ent.system_id = 1
      cond_ent.cookie = '123'
      ent_list = RegulationCookie.search_list(cond_ent)
      assert(ent_list.size == 1, "CASE:2-7-3-1")
      assert(ent_list[0].id == 1, "CASE:2-7-3-2")
      assert(ent_list[0].system_id == 1, "CASE:2-7-3-3")
      assert(ent_list[0].cookie == '^[123]$', "CASE:2-7-3-4")
      assert(ent_list[0].remarks == 'MyString', "CASE:2-7-3-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-7-3")
    end
    # 正常：クッキー＋備考
    begin
      cond_ent = RegulationCookie.new
      cond_ent.cookie = 'ab'
      cond_ent.remarks = 'Str'
      ent_list = RegulationCookie.search_list(cond_ent)
      assert(ent_list.size == 1, "CASE:2-7-4-1")
      assert(ent_list[0].id == 2, "CASE:2-7-4-2")
      assert(ent_list[0].system_id == 1, "CASE:2-7-4-3")
      assert(ent_list[0].cookie == '^[abc]$', "CASE:2-7-4-4")
      assert(ent_list[0].remarks == 'MyString', "CASE:2-7-4-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-7-4")
    end
  end
  
  # 検索テスト
  # 重複データ検索テストを行う
  test "2-8:duplicate Test:" do
    # 正常：重複データ有り、備考も指定
    begin
      cond_ent = RegulationCookie.new
      cond_ent.system_id = 1
      cond_ent.cookie = '^[123]$'
      cond_ent.remarks = 'MyString'
      ent_list = RegulationCookie.duplicate(cond_ent)
      assert(ent_list.size == 1, "CASE:2-8-1-1")
      assert(ent_list[0].id == 1, "CASE:2-8-1-2")
      assert(ent_list[0].system_id == 1, "CASE:2-8-1-3")
      assert(ent_list[0].cookie == '^[123]$', "CASE:2-8-1-4")
      assert(ent_list[0].remarks == 'MyString', "CASE:2-8-1-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-8-1")
    end
    # 正常：重複データ有り、備考は未指定
    begin
      cond_ent = RegulationCookie.new
      cond_ent.system_id = 1
      cond_ent.cookie = '^[123]$'
      ent_list = RegulationCookie.duplicate(cond_ent)
      assert(ent_list.size == 1, "CASE:2-8-2-1")
      assert(ent_list[0].id == 1, "CASE:2-8-2-2")
      assert(ent_list[0].system_id == 1, "CASE:2-8-2-3")
      assert(ent_list[0].cookie == '^[123]$', "CASE:2-8-2-4")
      assert(ent_list[0].remarks == 'MyString', "CASE:2-8-2-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-8-2")
    end
    # 正常：重複データ無し
    begin
      cond_ent = RegulationCookie.new
      cond_ent.system_id = 100
      cond_ent.cookie = '^[123]$'
      cond_ent.remarks = 'MyString'
      ent_list = RegulationCookie.duplicate(cond_ent)
      assert(ent_list.size == 0, "CASE:2-8-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-8-3")
    end
  end
end
