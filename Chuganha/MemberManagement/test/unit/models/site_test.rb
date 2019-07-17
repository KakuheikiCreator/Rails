# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：サイト
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/02 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class SiteTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Common
  # 基本機能テスト
  # 登録・検索・更新・削除のテストを行う
  test "2-1:Basic functions Test" do
    # 登録
    begin
      ent = default_data
      assert(ent.save!, "CASE:2-1-1")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-1")
    end
    # 検索
    ents = Site.where(:account_id=>3)
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.account_id = 4
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = Site.where(:account_id=>3)
      assert(ents.length == 0, "CASE:2-1-3")
      ents = Site.where(:account_id=>4)
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = Site.where(:account_id=>4).destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = Site.where(:account_id=>4)
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # 検索（関連）テスト
  # テーブル間の関連のテストを行う
  test "2-2:Relationship Test" do
    # アカウント
    ents = Site.where(:account_id=>2)
    account = ents[0].account
    assert(!account.nil?, "CASE:2-2-1")
    assert(Account === account, "CASE:2-2-1")
    # ペルソナ
    persona = ents[0].persona
    assert(!persona.nil?, "CASE:2-2-1")
    assert(Persona === persona, "CASE:2-2-1")
  end
  
  # バリデーションテスト（アカウントID）
  # バリデーションチェックのテストを行う
  test "2-3::account_id Validation Test" do
    # 正常
    begin
      ent = default_data
      assert(ent.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.account_id = nil
      assert(!ent.valid?, "CASE:2-3-2")
#      record_err_log(ent)
      assert(ent.errors[:account_id].size == 1, "CASE:2-3-2")
      assert(ent.errors[:account_id][0] == 'を入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
  end
  
  # バリデーションテスト（ペルソナID）
  # バリデーションチェックのテストを行う
  test "2-4::persona_id Validation Test" do
    # 正常
    begin
      ent = default_data
      assert(ent.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.persona_id = nil
      assert(!ent.valid?, "CASE:2-4-2")
#      record_err_log(ent)
      assert(ent.errors[:persona_id].size == 1, "CASE:2-4-2")
      assert(ent.errors[:persona_id][0] == 'を入力してください。', "CASE:2-4-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-2")
    end
  end
  
  # バリデーションテスト（連番）
  # バリデーションチェックのテストを行う
  test "2-5::seq_no Validation Test" do
    # 正常
    begin
      ent = default_data
      assert(ent.valid?, "CASE:2-5-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-5-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.seq_no = nil
      assert(!ent.valid?, "CASE:2-5-2")
#      record_err_log(ent)
      assert(ent.errors[:seq_no].size == 1, "CASE:2-5-2")
      assert(ent.errors[:seq_no][0] == 'を入力してください。', "CASE:2-5-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-5-2")
    end
  end
  
  # バリデーションテスト（URL）
  # バリデーションチェックのテストを行う
  test "2-6::url Validation Test" do
    # 正常
    begin
      ent = default_data
      assert(ent.valid?, "CASE:2-6-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-6-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.url = nil
      assert(!ent.valid?, "CASE:2-6-2")
#      record_err_log(ent)
      assert(ent.errors[:url].size == 2, "CASE:2-6-2")
      assert(ent.errors[:url][0] == 'を入力してください。', "CASE:2-6-2")
      assert(ent.errors[:url][1] == 'は不正な値です。', "CASE:2-6-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-6-2")
    end
    # URIエラー
    begin
      ent = default_data
      ent.url = 'ttp://' + generate_str(CHAR_SET_ALPHABETIC, 243) + '.co.jp'
      assert(!ent.valid?, "CASE:2-6-3")
#      record_err_log(ent)
      assert(ent.errors[:url].size == 1, "CASE:2-6-3")
      assert(ent.errors[:url][0] == 'は不正な値です。', "CASE:2-6-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-6-3")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = Site.new
    ent.account_id = 3
    ent.persona_id = 3
    ent.seq_no = 1
    ent.url = 'http://www.nakayan.com'
    return ent
  end
end
