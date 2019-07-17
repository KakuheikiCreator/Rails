# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ブラウザ
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/16 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'

class BrowserTest < ActiveSupport::TestCase
  include UnitTestUtil
  # 基本機能テスト
  # 登録・検索・更新・削除のテストを行う
  test "2-1:Basic functions Test" do
    # 登録
    begin
      info = Browser.new
      info.browser_name = 'FireMouse'
      assert(info.save!, "CASE:2-1-1")
      Rails.logger.debug("created_at:" + info.created_at.to_s)
      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-1")
    end
    # 検索
    infos = Browser.where(:browser_name => 'FireMouse')
    assert(infos.length == 1, "CASE:2-1-2")
    # 更新
    begin
      info = infos[0]
      info.browser_name = 'FireBird'
      assert(info.save!, "CASE:2-1-3")
      Rails.logger.debug("created_at:" + info.created_at.to_s)
      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      infos = Browser.where(:browser_name => 'FireMouse')
      assert(infos.length == 0, "CASE:2-1-3")
      infos = Browser.where(:browser_name => 'FireBird')
      assert(infos.length == 1, "CASE:2-1-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = Browser.where(:browser_name => 'FireBird').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = Browser.where(:browser_name => 'FireBird')
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
    # ブラウザバージョン
    infos = Browser.where(:browser_name => 'Internet Explorer')
    versions = infos[0].browser_version
    assert(versions.length == 6, "CASE:2-2-1")
    versions.each do |info|
      assert(BrowserVersion === info , "CASE:2-2-1")
    end
    # リクエスト解析結果
    analysis_infos = infos[0].request_analysis_result
    assert(analysis_infos.length == 2, "CASE:2-2-2")
    analysis_infos.each do |info|
      assert(RequestAnalysisResult === info , "CASE:2-2-2")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-3:Validation Test" do
    # 必須チェック
    begin
      info = Browser.new
      info.browser_name = "test"
      assert(info.valid?, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
    end
    begin
      info = Browser.new
      info.browser_name = nil
      assert(!info.valid?, "CASE:2-3-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-1")
    end
    # 桁数チェック
    begin
      info = Browser.new
      info.browser_name = generate_str(CHAR_SET_ALPHABETIC, 1)
      assert(info.valid?, "CASE:2-3-2")
      info.browser_name = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(info.valid?, "CASE:2-3-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-2")
    end
    begin
      info = Browser.new
      info.browser_name = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!info.valid?, "CASE:2-3-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-3-2")
    end
  end
end