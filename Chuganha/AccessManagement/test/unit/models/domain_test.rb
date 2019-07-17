# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ドメイン
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/17 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'

class DomainTest < ActiveSupport::TestCase
  include UnitTestUtil
  # 基本機能テスト
  # 登録・検索・更新・削除のテストを行う
  test "2-1:Basic functions Test" do
    # 登録
    begin
      info = Domain.new
      info.domain_name = 'test.co.jp'
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      assert(info.save!, "CASE:2-1-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-1-1")
    end
    # 検索
    infos = Domain.where(:domain_name => 'test.co.jp')
    assert(infos.length == 1, "CASE:2-1-2")
    # 更新
    begin
      info = infos[0]
      info.domain_name = 'next.co.jp'
      assert(info.save!, "CASE:2-1-3")
      infos = Domain.where(:domain_name => 'test.co.jp')
      assert(infos.length == 0, "CASE:2-1-3")
      infos = Domain.where(:domain_name => 'next.co.jp')
      assert(infos.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = Domain.where(:domain_name => 'next.co.jp').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = Domain.where(:domain_name => 'next.co.jp')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-1-4")
    end
  end
  
  # 検索（関連）テスト
  # テーブル間の関連のテストを行う
  test "2-2:Relationship Test" do
    infos = Domain.where(:domain_name => 'ne.jp')
    # リクエスト解析結果
    analysis_infos = infos[0].request_analysis_result
    assert(analysis_infos.length == 1, "CASE:2-2-1")
    analysis_infos.each do |info|
      assert(RequestAnalysisResult === info , "CASE:2-2-1")
    end
  end
  
  # バリデーションテスト
  # ドメイン名のバリデーションチェックのテストを行う
  test "2-3:Validation Test:domain_name" do
    # 必須チェック
    begin
      info = Domain.new
      info.domain_name = 'test.no.co.jp'
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      assert(info.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-3-1")
    end
    begin
      info = Domain.new
      info.domain_name = nil
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      assert(!info.valid?, "CASE:2-3-1")
      info.errors.each do |attribute, error|
        print_log("CASE:2-3-1 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :domain_name, "CASE:2-3-1")
        assert_equal(error, "を入力してください。", "CASE:2-3-1")
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-3-1")
    end
    # フォーマットチェック
    begin
      # 正常ケース
      info = Domain.new
      info.domain_name = 'test.no.co.jp'
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      assert(info.valid?, "CASE:2-3-2")
      info.domain_name = 'ne.jp'
      assert(info.valid?, "CASE:2-3-2")
      info.domain_name = 'nfmv001076248.uqw.ppp.infoweb.ne.jp'
      assert(info.valid?, "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-3-2")
    end
    begin
      # 異常ケース
      info = Domain.new
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      info.domain_name = 'ｔｅｓｔ.no.co.jp'
      assert(!info.valid?, "CASE:2-3-2-1")
      info.errors.each do |attribute, error|
#        print_log("CASE:2-3-2-1 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :domain_name, "CASE:2-3-2-1")
        assert_equal(error, "は不正な値です。", "CASE:2-3-2-1")
      end
      info.domain_name = 'test.no..co.jp'
      assert(!info.valid?, "CASE:2-3-2-2")
      info.errors.each do |attribute, error|
#        print_log("CASE:2-3-2-2 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :domain_name, "CASE:2-3-2-2")
        assert_equal(error, "は不正な値です。", "CASE:2-3-2-2")
      end
      info.domain_name = '.no.co.jp'
      assert(!info.valid?, "CASE:2-3-2-3")
      info.errors.each do |attribute, error|
#        print_log("CASE:2-3-2-3 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :domain_name, "CASE:2-3-2-3")
        assert_equal(error, "は不正な値です。", "CASE:2-3-2-3")
      end
      info.domain_name = 'test.-123.co.jp'
      assert(!info.valid?, "CASE:2-3-2-4")
      info.errors.each do |attribute, error|
#        print_log("CASE:2-3-2-4 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :domain_name, "CASE:2-3-2-4")
        assert_equal(error, "は不正な値です。", "CASE:2-3-2-4")
      end
      info.domain_name = 'test.123.co-.jp'
      assert(!info.valid?, "CASE:2-3-2-4")
      info.errors.each do |attribute, error|
#        print_log("CASE:2-3-2-4 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :domain_name, "CASE:2-3-2-4")
        assert_equal(error, "は不正な値です。", "CASE:2-3-2-4")
      end
      info.domain_name = generate_str(CHAR_SET_ALPHABETIC, 62) + '.' +
                         generate_str(CHAR_SET_ALPHABETIC, 62) + '.' +
                         generate_str(CHAR_SET_ALPHABETIC, 62) + '.' +
                         generate_str(CHAR_SET_ALPHABETIC, 61) + '.co.jp'
      assert(!info.valid?, "CASE:2-3-2-5-1")
      info.errors.each do |attribute, error|
        print_log("CASE:2-3-2-1 SIZE:" + info.domain_name.length.to_s)
        print_log("CASE:2-3-2-1 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :domain_name, "CASE:2-3-2-5-2")
        assert_equal(error, "は不正な値です。", "CASE:2-3-2-5-3")
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-3-3")
    end
  end
  
  # バリデーションテスト
  # ドメイン区分のバリデーションチェックのテストを行う
  test "2-4:Validation Test:domain_class" do
    # 必須チェック
    begin
      info = Domain.new
      info.domain_name = "test"
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      assert(info.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-4-1")
    end
    begin
      info = Domain.new
      info.domain_name = "test"
      info.domain_class = nil
      assert(!info.valid?, "CASE:2-4-1")
      info.errors.each do |attribute, error|
        if attribute == :domain_class then
#          print_log("CASE:2-4-1 Error:" + attribute.to_s + ":" + error.to_s)
          assert_equal(attribute, :domain_class, "CASE:2-4-1")
          assert_equal(error, "を入力してください。", "CASE:2-4-1")
        end
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-4-1")
    end
    # 値の範囲チェック
    begin
      # 正常ケース
      info = Domain.new
      info.domain_name = "test"
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      info.date_confirmed = nil
      assert(info.valid?, "CASE:2-4-2")
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      info.date_confirmed = DateTime.now
      assert(info.valid?, "CASE:2-4-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-4-2")
    end
    begin
      # 異常ケース
      info = Domain.new
      info.domain_name = "test"
      info.domain_class = 2
      info.date_confirmed = DateTime.now
      assert(!info.valid?, "CASE:2-4-2")
      info.errors.each do |attribute, error|
        if attribute == :domain_class then
          print_log("CASE:2-4-2 Error:" + attribute.to_s + ":" + error.to_s)
          assert_equal(attribute, :domain_class, "CASE:2-4-2")
          assert_equal(error, "は一覧にありません。", "CASE:2-4-2")
        end
      end
      info.domain_class = -1
      info.date_confirmed = DateTime.now
      assert(!info.valid?, "CASE:2-4-2")
      info.errors.each do |attribute, error|
        if attribute == :domain_class then
          print_log("CASE:2-4-2 Error:" + attribute.to_s + ":" + error.to_s)
          assert_equal(attribute, :domain_class, "CASE:2-4-2")
          assert_equal(error, "は一覧にありません。", "CASE:2-4-2")
        end
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-4-2")
    end
  end
  
  # バリデーションテスト
  # 確認日時のバリデーションチェックのテストを行う
  test "2-5:Validation Test:date_confirmed" do
    # 項目関連チェック
    # 正常ケース
    begin
      info = Domain.new
      info.domain_name = "test"
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      info.date_confirmed = nil
      assert(info.valid?, "CASE:2-5-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-5-1")
    end
    begin
      info = Domain.new
      info.domain_name = "test"
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      info.date_confirmed = DateTime.now
      assert(info.valid?, "CASE:2-5-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-5-2")
    end
    # 異常ケース
    begin
      I18n.locale = :ja
      info = Domain.new
      info.domain_name = "test"
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      info.date_confirmed = DateTime.now
      assert(!info.valid?, "CASE:2-5-1-1")
      info.errors.each do |attribute, error|
        print_log("CASE:2-5-1 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :date_confirmed, "CASE:2-5-1-2")
        assert_equal(error, "はドメイン区分との整合性に問題があります。", "CASE:2-5-1-3")
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-5-1")
    end
    begin
      I18n.locale = :ja
      info = Domain.new
      info.domain_name = "test"
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      info.date_confirmed = nil
      assert(!info.valid?, "CASE:2-5-2-1")
      info.errors.each do |attribute, error|
        print_log("CASE:2-5-2 Error:" + attribute.to_s + ":" + error.to_s)
        assert_equal(attribute, :date_confirmed, "CASE:2-5-2-2")
        assert_equal(error, "はドメイン区分との整合性に問題があります。", "CASE:2-5-2-3")
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-5-2")
    end
  end
  
  # バリデーションテスト
  # 確認日時のバリデーションチェックのテストを行う
  test "2-6:Method Test:fixed?" do
    # 項目関連チェック
    # 正常ケース
    begin
      info = Domain.new
      info.domain_name = "test"
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      info.date_confirmed = nil
      assert(info.fixed?, "CASE:2-6-1")
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      assert(!info.fixed?, "CASE:2-6-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      flunk("CASE:2-6-1")
    end
    # 異常ケース
  end
end