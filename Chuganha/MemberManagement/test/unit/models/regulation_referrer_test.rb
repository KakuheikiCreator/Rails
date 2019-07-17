# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：規制リファラー情報クラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'

class RegulationReferrerTest < ActiveSupport::TestCase
  include UnitTestUtil
  # 基本機能テスト
  # 登録・検索・更新・削除のテストを行う
  test "2-1:Basic functions Test" do
    # 登録
    begin
      info = RegulationReferrer.new
      info.system_id = 1
      info.referrer = '^www\.komatta\.renchu\.minagoros.com$'
      assert(info.save!, "CASE:2-1-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-1")
    end
    # 検索
    infos = RegulationReferrer.where(:referrer => '^www\.komatta\.renchu\.minagoros.com$')
    assert(infos.length == 1, "CASE:2-1-2")
    # 更新
    begin
      info = infos[0]
      info.referrer = '^www\.komatta\.renchu\.igaimo\.minagorosi\.com$'
      assert(info.save!, "CASE:2-1-3")
      infos = RegulationReferrer.where(:referrer => '^www\.komatta\.renchu\.minagoros.com$')
      assert(infos.length == 0, "CASE:2-1-3")
      infos = RegulationReferrer.where(:referrer => '^www\.komatta\.renchu\.igaimo\.minagorosi\.com$')
      assert(infos.length == 1, "CASE:2-1-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = RegulationReferrer.where(:referrer => '^www\.komatta\.renchu\.igaimo\.minagorosi\.com$').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = RegulationReferrer.where(:referrer => '^www\.komatta\.renchu\.igaimo\.minagorosi\.com$')
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
    infos = RegulationReferrer.where(:referrer => '^www\.yahoo\.co\.jp$')
    info = infos[0].system
    assert(System === info , "CASE:2-2-1")
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-3:Validation Test:system_id" do
    # 必須チェック
    begin
      info = RegulationReferrer.new
      info.system_id = 1
      info.referrer = '^www\.komatta\.renchu\.minagorosi\.com$'
      assert(info.valid?, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
    end
    begin
      info = RegulationReferrer.new
      info.system_id = nil
      info.referrer = '^www\.komatta\.renchu\.minagorosi\.com$'
      assert(!info.valid?, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-4:Validation Test:referrer" do
    # 必須チェック
    begin
      info = RegulationReferrer.new
      info.system_id = 1
      info.referrer = '^www\.komatta\.renchu\.minagorosi\.com$'
      assert(info.valid?, "CASE:2-4-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-1")
    end
    begin
      info = RegulationReferrer.new
      info.system_id = 1
      info.referrer = nil
      assert(!info.valid?, "CASE:2-4-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-1")
    end
    # 桁数チェック
    begin
      info = RegulationReferrer.new
      info.system_id = 1
      info.referrer = "a"
      assert(info.valid?, "CASE:2-4-2")
      info.referrer = "^" + generate_str(CHAR_SET_ALPHABETIC, 1023)
      assert(info.valid?, "CASE:2-4-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-2")
    end
    begin
      info = RegulationReferrer.new
      info.system_id = 1
      info.referrer = "^" + generate_str(CHAR_SET_ALPHABETIC, 1024)
      assert(!info.valid?, "CASE:2-4-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-2")
    end
  end
  
  # 検索条件生成テスト
  # 検索条件のリスト生成テストを行う
  test "2-5:search_condition Test:" do
    # 正常：検索条件なし
    begin
      ent = RegulationReferrer.new
      cond_list = ent.search_condition
      assert(cond_list.size == 0, "CASE:2-5-1-1")
      result_list = RegulationReferrer.search_list(ent)
      assert(result_list.size == 4, "CASE:2-5-1-2")
      assert(result_list[0].id == 1, "CASE:2-5-1-3")
      assert(result_list[1].id == 2, "CASE:2-5-1-4")
      assert(result_list[2].id == 3, "CASE:2-5-1-5")
      assert(result_list[3].id == 4, "CASE:2-5-1-6")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-1")
    end
    # 正常：システムID
    begin
      ent = RegulationReferrer.new
      ent.system_id = 1
      cond_list = ent.search_condition
      assert(cond_list.size == 2, "CASE:2-5-2-1")
      assert(cond_list[0] == 'system_id = ?', "CASE:2-5-2-2")
      assert(cond_list[1] == 1, "CASE:2-5-2-3")
      result_list = RegulationReferrer.search_list(ent)
#      print_log('result_list.size:' + result_list.size.to_s)
      assert(result_list.size == 3, "CASE:2-5-2-4")
      assert(result_list[0].id == 1, "CASE:2-5-2-5")
      assert(result_list[1].id == 2, "CASE:2-5-2-6")
      assert(result_list[2].id == 3, "CASE:2-5-2-7")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-2")
    end
    # 正常：リファラー
    begin
      ent = RegulationReferrer.new
      ent.referrer = '^www\.msn\.co\.jp$'
      cond_list = ent.search_condition
#      print_log('cond_list:' + cond_list.to_s)
      assert(cond_list.size == 2, "CASE:2-5-3-1")
      assert(cond_list[0] == 'referrer like ?', "CASE:2-5-3-2")
      assert(cond_list[1] == '%^www\\\\.msn\\\\.co\\\\.jp$%', "CASE:2-5-3-3")
      result_list = RegulationReferrer.search_list(ent)
      assert(result_list.size == 1, "CASE:2-5-3-4")
      assert(result_list[0].id == 2, "CASE:2-5-3-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-3")
    end
    # 正常：備考
    begin
      ent = RegulationReferrer.new
      ent.remarks = 'MyString'
      cond_list = ent.search_condition
      assert(cond_list.size == 2, "CASE:2-5-4-1")
      assert(cond_list[0] == 'remarks like ?', "CASE:2-5-4-2")
      assert(cond_list[1] == '%MyString%', "CASE:2-5-4-3")
      result_list = RegulationReferrer.search_list(ent)
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
    # 正常：システムID＋リファラー
    begin
      ent = RegulationReferrer.new
      ent.system_id = 2
      ent.referrer = '^www\.goo\.co\.jp$'
      cond_list = ent.search_condition
#      Rails.logger.debug('cond_list:' + cond_list.to_s)
      assert(cond_list.size == 3, "CASE:2-5-5-1")
      assert(cond_list[0] == 'system_id = ? and referrer like ?', "CASE:2-5-5-2")
      assert(cond_list[1] == 2, "CASE:2-5-5-3")
      assert(cond_list[2] == '%^www\\\\.goo\\\\.co\\\\.jp$%', "CASE:2-5-5-4")
      result_list = RegulationReferrer.search_list(ent)
      assert(result_list.size == 1, "CASE:2-5-5-5")
      assert(result_list[0].id == 4, "CASE:2-5-5-6")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-5")
    end
    # 正常：システムID＋備考
    begin
      ent = RegulationReferrer.new
      ent.system_id = 2
      ent.remarks = 'MyString'
      cond_list = ent.search_condition
      assert(cond_list.size == 3, "CASE:2-5-6-1")
      assert(cond_list[0] == 'system_id = ? and remarks like ?', "CASE:2-5-6-2")
      assert(cond_list[1] == 2, "CASE:2-5-6-3")
      assert(cond_list[2] == '%MyString%', "CASE:2-5-6-4")
      result_list = RegulationReferrer.search_list(ent)
      assert(result_list.size == 1, "CASE:2-5-6-5")
      assert(result_list[0].id == 4, "CASE:2-5-6-6")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-6")
    end
    # 正常：システムID＋リファラー＋備考
    begin
      ent = RegulationReferrer.new
      ent.system_id = 1
      ent.referrer = '^www\.msn\.co\.jp$'
      ent.remarks = 'MyString'
      cond_list = ent.search_condition
      assert(cond_list.size == 4, "CASE:2-5-7-1")
      assert(cond_list[0] == 'system_id = ? and referrer like ? and remarks like ?', "CASE:2-5-7-2")
      assert(cond_list[1] == 1, "CASE:2-5-7-3")
      assert(cond_list[2] == '%^www\\\\.msn\\\\.co\\\\.jp$%', "CASE:2-5-7-4")
      assert(cond_list[3] == '%MyString%', "CASE:2-5-7-5")
      result_list = RegulationReferrer.search_list(ent)
      assert(result_list.size == 1, "CASE:2-5-7-6")
      assert(result_list[0].id == 2, "CASE:2-5-7-7")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-7")
    end
    # 正常：リファラー＋備考
    begin
      ent = RegulationReferrer.new
      ent.referrer = '^www\.msn\.co\.jp$'
      ent.remarks = 'MyString'
      cond_list = ent.search_condition
      assert(cond_list.size == 3, "CASE:2-5-8-1")
      assert(cond_list[0] == 'referrer like ? and remarks like ?', "CASE:2-5-8-2")
      assert(cond_list[1] == '%^www\\\\.msn\\\\.co\\\\.jp$%', "CASE:2-5-8-3")
      assert(cond_list[2] == '%MyString%', "CASE:2-5-8-4")
      result_list = RegulationReferrer.search_list(ent)
      assert(result_list.size == 1, "CASE:2-5-7-5")
      assert(result_list[0].id == 2, "CASE:2-5-7-6")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-8")
    end
    # 正常：リファラー、備考のエスケープ処理
    begin
      ent = RegulationReferrer.new
      ent.referrer = 'test\referrer%_'
      ent.remarks = 'test\remarks%_'
      cond_list = ent.search_condition
      assert(cond_list.size == 3, "CASE:2-5-9-1")
      assert(cond_list[0] == 'referrer like ? and remarks like ?', "CASE:2-5-9-2")
      assert(cond_list[1] == '%test\\\\referrer\%\_%', "CASE:2-5-9-3")
      assert(cond_list[2] == '%test\\\\remarks\%\_%', "CASE:2-5-9-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-5-9")
    end
  end
  
  # 検索テスト
  # 重複データ検索テストを行う
  test "2-6:duplicate Test:" do
    # 正常：重複データ有り、備考も指定
    begin
      cond_ent = RegulationReferrer.new
      cond_ent.system_id = 1
      cond_ent.referrer = '^[A]$'
      cond_ent.remarks = 'MyString'
      ent_list = RegulationReferrer.duplicate(cond_ent)
      assert(ent_list.size == 1, "CASE:2-6-1-1")
      assert(ent_list[0].id == 3, "CASE:2-6-1-2")
      assert(ent_list[0].system_id == 1, "CASE:2-6-1-3")
      assert(ent_list[0].referrer == '^[A]$', "CASE:2-6-1-4")
      assert(ent_list[0].remarks == 'MyString', "CASE:2-6-1-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-1")
    end
    # 正常：重複データ有り、備考は未指定
    begin
      cond_ent = RegulationReferrer.new
      cond_ent.system_id = 1
      cond_ent.referrer = '^[A]$'
      ent_list = RegulationReferrer.duplicate(cond_ent)
      assert(ent_list.size == 1, "CASE:2-6-2-1")
      assert(ent_list[0].id == 3, "CASE:2-6-2-2")
      assert(ent_list[0].system_id == 1, "CASE:2-6-2-3")
      assert(ent_list[0].referrer == '^[A]$', "CASE:2-6-2-4")
      assert(ent_list[0].remarks == 'MyString', "CASE:2-6-2-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-2")
    end
    # 正常：重複データ無し
    begin
      cond_ent = RegulationReferrer.new
      cond_ent.system_id = 100
      cond_ent.referrer = '^[A]$'
      cond_ent.remarks = 'MyString'
      ent_list = RegulationReferrer.duplicate(cond_ent)
      assert(ent_list.size == 0, "CASE:2-6-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-6-3")
    end
  end
end
