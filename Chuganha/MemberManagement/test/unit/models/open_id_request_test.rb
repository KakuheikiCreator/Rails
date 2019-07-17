# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：アカウント
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/02 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class OpenIdRequestTest < ActiveSupport::TestCase
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
    ents = OpenIdRequest.where(:token=>'test token')
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.token = 'new token'
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = OpenIdRequest.where(:token=>'test token')
      assert(ents.length == 0, "CASE:2-1-3")
      ents = OpenIdRequest.where(:token=>'new token')
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = OpenIdRequest.where(:token=>'new token').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = OpenIdRequest.where(:token=>'new token')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # バリデーションテスト（トークン）
  # バリデーションチェックのテストを行う
  test "2-2::token Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.token = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-2-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.token = nil
      assert(!ent.valid?, "CASE:2-2-2")
#      record_err_log(ent)
      assert(ent.errors[:token].size == 1, "CASE:2-2-2")
      assert(ent.errors[:token][0] == 'を入力してください。', "CASE:2-2-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      ent.token = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!ent.valid?, "CASE:2-2-3")
#      record_err_log(ent)
      assert(ent.errors[:token].size == 1, "CASE:2-2-3")
      assert(ent.errors[:token][0] == 'は255文字以内で入力してください。', "CASE:2-2-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-3")
    end
  end
  
  # バリデーションテスト（パラメータ）
  # バリデーションチェックのテストを行う
  test "2-3::parameters Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.parameters = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.parameters = nil
      assert(!ent.valid?, "CASE:2-3-2")
#      record_err_log(ent)
      assert(ent.errors[:parameters].size == 1, "CASE:2-3-2")
      assert(ent.errors[:parameters][0] == 'を入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = OpenIdRequest.new
    ent.token = 'test token'
    ent.parameters = 'parameters'
    return ent
  end
end
