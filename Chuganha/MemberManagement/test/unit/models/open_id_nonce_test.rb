# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：OpenIDナンス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/05 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class OpenIdNonceTest < ActiveSupport::TestCase
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
    ents = OpenIdNonce.where(:server_url=>'http://test.svr.com')
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.server_url = 'http://new.svr.com'
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = OpenIdNonce.where(:server_url=>'http://test.svr.com')
      assert(ents.length == 0, "CASE:2-1-3")
      ents = OpenIdNonce.where(:server_url=>'http://new.svr.com')
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = OpenIdNonce.where(:server_url=>'http://new.svr.com').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = OpenIdNonce.where(:server_url=>'http://new.svr.com')
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
  
  # バリデーションテスト（ソルト）
  # バリデーションチェックのテストを行う
  test "2-3::salt Validation Test" do
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
      ent.salt = nil
      assert(!ent.valid?, "CASE:2-3-2")
#      record_err_log(ent)
      assert(ent.errors[:salt].size == 1, "CASE:2-3-2")
      assert(ent.errors[:salt][0] == 'を入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
  end
  
  # バリデーションテスト（タイムスタンプ）
  # バリデーションチェックのテストを行う
  test "2-4::timestamp Validation Test" do
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
      ent.timestamp = nil
      assert(!ent.valid?, "CASE:2-4-2")
#      record_err_log(ent)
      assert(ent.errors[:timestamp].size == 1, "CASE:2-4-2")
      assert(ent.errors[:timestamp][0] == 'を入力してください。', "CASE:2-4-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-2")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = OpenIdNonce.new
    ent.server_url = 'http://test.svr.com'
    ent.salt = 'しょっぱいぞー'
    ent.timestamp = '2012-11-05 00:00:00'
    return ent
  end
end
