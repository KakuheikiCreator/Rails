# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：拒否アカウント
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/04 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class BlockedAccountTest < ActiveSupport::TestCase
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
    ents = BlockedAccount.where(:seq_no=>1)
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.seq_no = 10
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = BlockedAccount.where(:seq_no=>1)
      assert(ents.length == 0, "CASE:2-1-3")
      ents = BlockedAccount.where(:seq_no=>10)
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = BlockedAccount.where(:seq_no=>100).destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = BlockedAccount.where(:seq_no=>100)
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
    infos = BlockedAccount.where(:seq_no=>2)
    ent = infos[0].account
    assert(!ent.nil?, "CASE:2-2-1")
    assert(Account === ent, "CASE:2-2-1")
  end
  
  # バリデーションテスト（対象者ID１）
  # バリデーションチェックのテストを行う
  test "2-3::enc_target_id_1 Validation Test" do
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
      ent.enc_target_id_1 = nil
      assert(!ent.valid?, "CASE:2-3-2")
#      record_err_log(ent)
      assert(ent.errors[:enc_target_id_1].size == 1, "CASE:2-3-2")
      assert(ent.errors[:enc_target_id_1][0] == 'を入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = BlockedAccount.new
    ent.account_id = 100
    ent.seq_no = 100
    ent.enc_target_id_1 = 1001
    ent.enc_target_id_2 = 1002
    ent.enc_target_id_3 = 1003
    ent.enc_target_id_4 = 1004
    ent.enc_target_id_5 = 1005
    ent.enc_target_id_6 = 1006
    ent.enc_target_id_7 = 1007
    ent.enc_target_id_8 = 1008
    ent.enc_target_id_9 = 1009
    ent.enc_target_id_10 = 1010
    return ent
  end
end
