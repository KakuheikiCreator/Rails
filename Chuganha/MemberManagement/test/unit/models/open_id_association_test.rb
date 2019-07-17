# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：OpenID組織
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/02 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class OpenIdAssociationTest < ActiveSupport::TestCase
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
    ents = OpenIdAssociation.where(:server_url=>'http://test.server.co.jp')
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.server_url = 'http://new.server.co.jp'
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = OpenIdAssociation.where(:server_url=>'http://test.server.co.jp')
      assert(ents.length == 0, "CASE:2-1-3")
      ents = OpenIdAssociation.where(:server_url=>'http://new.server.co.jp')
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = OpenIdAssociation.where(:server_url=>'http://new.server.co.jp').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = OpenIdAssociation.where(:server_url=>'http://new.server.co.jp')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # バリデーションテスト（サーバーURL）
  # バリデーションチェックのテストを行う
  test "2-2::server_url Validation Test" do
    # 正常
    begin
      ent = default_data
      assert(ent.valid?, "CASE:2-2-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.server_url = nil
      assert(!ent.valid?, "CASE:2-2-2")
#      record_err_log(ent)
      assert(ent.errors[:server_url].size == 1, "CASE:2-2-2")
      assert(ent.errors[:server_url][0] == 'を入力してください。', "CASE:2-2-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-2")
    end
  end
  
  # バリデーションテスト（秘密鍵）
  # バリデーションチェックのテストを行う
  test "2-3::secret Validation Test" do
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
      ent.secret = nil
      assert(!ent.valid?, "CASE:2-3-2")
#      record_err_log(ent)
      assert(ent.errors[:secret].size == 1, "CASE:2-3-2")
      assert(ent.errors[:secret][0] == 'を入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
  end
  
  # バリデーションテスト（ハンドル）
  # バリデーションチェックのテストを行う
  test "2-4::handle Validation Test" do
    # 正常
    begin
      ent = default_data
      handle = generate_str(CHAR_SET_ALPHABETIC, 255)
      ent.handle = handle
      assert(ent.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.handle = nil
      assert(!ent.valid?, "CASE:2-4-2")
#      record_err_log(ent)
      assert(ent.errors[:handle].size == 1, "CASE:2-4-2")
      assert(ent.errors[:handle][0] == 'を入力してください。', "CASE:2-4-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      handle = generate_str(CHAR_SET_ALPHABETIC, 256)
      ent.handle = handle
      assert(!ent.valid?, "CASE:2-4-3")
#      record_err_log(ent)
      assert(ent.errors[:handle].size == 1, "CASE:2-4-3")
      assert(ent.errors[:handle][0] == 'は255文字以内で入力してください。', "CASE:2-4-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-3")
    end
  end
  
  # バリデーションテスト（ハンドル）
  # バリデーションチェックのテストを行う
  test "2-5::assoc_type Validation Test" do
    # 正常
    begin
      ent = default_data
      assoc_type = generate_str(CHAR_SET_ALPHABETIC, 255)
      ent.assoc_type = assoc_type
      assert(ent.valid?, "CASE:2-5-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-5-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.assoc_type = nil
      assert(!ent.valid?, "CASE:2-5-2")
#      record_err_log(ent)
      assert(ent.errors[:assoc_type].size == 1, "CASE:2-5-2")
      assert(ent.errors[:assoc_type][0] == 'を入力してください。', "CASE:2-5-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-5-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      assoc_type = generate_str(CHAR_SET_ALPHABETIC, 256)
      ent.assoc_type = assoc_type
      assert(!ent.valid?, "CASE:2-5-3")
#      record_err_log(ent)
      assert(ent.errors[:assoc_type].size == 1, "CASE:2-5-3")
      assert(ent.errors[:assoc_type][0] == 'は255文字以内で入力してください。', "CASE:2-5-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-5-3")
    end
  end
  
  # バリデーションテスト（発行日時）
  # バリデーションチェックのテストを行う
  test "2-6::issued Validation Test" do
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
      ent.issued = nil
      assert(!ent.valid?, "CASE:2-6-2")
#      record_err_log(ent)
      assert(ent.errors[:issued].size == 1, "CASE:2-6-2")
      assert(ent.errors[:issued][0] == 'を入力してください。', "CASE:2-6-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-6-2")
    end
  end
  
  # バリデーションテスト（有効期限）
  # バリデーションチェックのテストを行う
  test "2-7::lifetime Validation Test" do
    # 正常
    begin
      ent = default_data
      assert(ent.valid?, "CASE:2-7-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-7-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.lifetime = nil
      assert(!ent.valid?, "CASE:2-7-2")
#      record_err_log(ent)
      assert(ent.errors[:lifetime].size == 1, "CASE:2-7-2")
      assert(ent.errors[:lifetime][0] == 'を入力してください。', "CASE:2-7-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-7-2")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = OpenIdAssociation.new
    ent.server_url = 'http://test.server.co.jp'
    ent.secret = 'secret001'
    ent.handle = 'handle001'
    ent.assoc_type = 'assoc001'
    ent.issued = 1
    ent.lifetime = 1
    return ent
  end
end
