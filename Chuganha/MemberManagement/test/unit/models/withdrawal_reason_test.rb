# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：退会理由
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/06 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class WithdrawalReasonTest < ActiveSupport::TestCase
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
    ents = WithdrawalReason.where(:withdrawal_reason_cls=>'5')
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.withdrawal_reason_cls = '6'
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = WithdrawalReason.where(:withdrawal_reason_cls=>'5')
      assert(ents.length == 0, "CASE:2-1-3")
      ents = WithdrawalReason.where(:withdrawal_reason_cls=>'6')
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = WithdrawalReason.where(:withdrawal_reason_cls=>'6').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = WithdrawalReason.where(:withdrawal_reason_cls=>'6')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # 検索（関連）テスト
  # テーブル間の関連のテストを行う
  test "2-2:Relationship Test" do
    # 退会者
    ents = WithdrawalReason.where(:withdrawal_reason_cls=>"0")
    person_withdrawal = ents[0].person_withdrawal
    assert(person_withdrawal.length == 2, "CASE:2-2-1")
    person_withdrawal.each do |ent|
      assert(PersonWithdrawal === ent, "CASE:2-2-1")
    end
  end
  
  # バリデーションテスト（退会理由区分）
  # バリデーションチェックのテストを行う
  test "2-3::withdrawal_reason_cls Validation Test" do
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
      ent.withdrawal_reason_cls = nil
      assert(!ent.valid?, "CASE:2-3-2")
#      record_err_log(ent)
      assert(ent.errors[:withdrawal_reason_cls].size == 2, "CASE:2-3-2")
      assert(ent.errors[:withdrawal_reason_cls][0] == 'を入力してください。', "CASE:2-3-2")
      assert(ent.errors[:withdrawal_reason_cls][1] == 'は1文字で入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      ent.withdrawal_reason_cls = 'ab'
      assert(!ent.valid?, "CASE:2-3-3")
#      record_err_log(ent)
      assert(ent.errors[:withdrawal_reason_cls].size == 1, "CASE:2-3-3")
      assert(ent.errors[:withdrawal_reason_cls][0] == 'は1文字で入力してください。', "CASE:2-3-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-3")
    end
  end
  
  # バリデーションテスト（退会理由）
  # バリデーションチェックのテストを行う
  test "2-4::withdrawal_reason Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.withdrawal_reason = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.withdrawal_reason = nil
      assert(!ent.valid?, "CASE:2-4-2")
#      record_err_log(ent)
      assert(ent.errors[:withdrawal_reason].size == 1, "CASE:2-4-2")
      assert(ent.errors[:withdrawal_reason][0] == 'を入力してください。', "CASE:2-4-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      ent.withdrawal_reason = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!ent.valid?, "CASE:2-4-3")
#      record_err_log(ent)
      assert(ent.errors[:withdrawal_reason].size == 1, "CASE:2-4-3")
      assert(ent.errors[:withdrawal_reason][0] == 'は255文字以内で入力してください。', "CASE:2-4-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-3")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = WithdrawalReason.new
    ent.withdrawal_reason_cls = '5'
    ent.withdrawal_reason = '神のお告げ'
    return ent
  end
end
