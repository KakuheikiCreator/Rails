# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ブラウザバージョン
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/16 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'

class BrowserVersionTest < ActiveSupport::TestCase
  include UnitTestUtil
  # 基本機能テスト
  # 登録・検索・更新・削除のテストを行う
  test "2-1:Basic functions Test" do
    # 登録
    begin
      info = BrowserVersion.new
      info.browser_id = 1
      info.browser_version = 100
      assert(info.save!, "CASE:2-1-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-1")
    end
    # 検索
    infos = BrowserVersion.where(:browser_version => 'other')
    assert(infos.length == 1, "CASE:2-1-2")
    # 更新
    begin
      info = infos[0]
      info.browser_version = 9
      assert(info.save!, "CASE:2-1-3-1")
      infos = BrowserVersion.where(:browser_version => 1000)
      assert(infos.length == 0, "CASE:2-1-3-2")
      infos = BrowserVersion.where(:browser_version => 5)
      assert(infos.length == 3, "CASE:2-1-3-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = BrowserVersion.where(:browser_version => 100).destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = BrowserVersion.where(:browser_version => 100)
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
    # ブラウザ
    infos = BrowserVersion.where(:browser_version => 4)
    assert(Browser === infos[0].browser , "CASE:2-2-1")
    # リクエスト解析結果
    analysis_infos = infos[0].request_analysis_result
    assert(analysis_infos.length == 2, "CASE:2-2-2")
    analysis_infos.each do |info|
      assert(RequestAnalysisResult === info , "CASE:2-2-2")
    end
  end
  
  # バリデーションテスト（ブラウザID）
  # バリデーションチェックのテストを行う
  test "2-3:Browser Info ID Validation Test" do
    # 必須チェック
    begin
      info = BrowserVersion.new
      info.browser_id = 2000
      info.browser_version = 2000
      assert(info.valid?, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
    end
    begin
      info = BrowserVersion.new
      info.browser_id = nil
      info.browser_version = 2000
      assert(!info.valid?, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
    end
  end
  
  # バリデーションテスト（ブラウザバージョン）
  # バリデーションチェックのテストを行う
  test "2-4:Browser Version Validation Test" do
    # 桁数チェック
    begin
      info = BrowserVersion.new
      info.browser_id = 2000
      info.browser_version = generate_str(CHAR_SET_ALPHABETIC, 1)
      assert(info.valid?, "CASE:2-4-1")
      info.browser_version = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(info.valid?, "CASE:2-4-1")
      info.browser_version = nil
      assert(info.valid?, "CASE:2-4-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-1")
    end
    begin
      info = BrowserVersion.new
      info.browser_id = 2000
      info.browser_version = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!info.valid?, "CASE:2-4-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-1")
    end
  end
end
