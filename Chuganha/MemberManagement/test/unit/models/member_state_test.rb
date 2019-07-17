# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：会員状態
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/04 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class MemberStateTest < ActiveSupport::TestCase
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
    ents = MemberState.where(:member_state_cls=>'PWR')
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.member_state_cls = 'SOQ'
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = MemberState.where(:member_state_cls=>'PWR')
      assert(ents.length == 0, "CASE:2-1-3")
      ents = MemberState.where(:member_state_cls=>'SOQ')
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = MemberState.where(:member_state_cls=>'SOQ').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = MemberState.where(:member_state_cls=>'SOQ')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # 検索（関連）テスト
  # テーブル間の関連のテストを行う
  test "2-2:Relationship Test" do
    ents = MemberState.where(:member_state_cls=>"PRG")
    # アカウント
    accounts = ents[0].account
    assert(accounts.length == 2, "CASE:2-2-2")
    accounts.each do |ent|
      assert(Account === ent, "CASE:2-2-2")
    end
    # 退会者
    person_withdrawals = ents[0].person_withdrawal
    assert(person_withdrawals.length == 2, "CASE:2-2-2")
    person_withdrawals.each do |ent|
      assert(PersonWithdrawal === ent, "CASE:2-2-2")
    end
  end
  
  # バリデーションテスト（会員状態区分）
  # バリデーションチェックのテストを行う
  test "2-3::member_state_cls Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.member_state_cls = 'PWR'
      assert(ent.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.member_state_cls = nil
      assert(!ent.valid?, "CASE:2-3-2")
#      record_err_log(ent)
      assert(ent.errors[:member_state_cls].size == 2, "CASE:2-3-2")
      assert(ent.errors[:member_state_cls][0] == 'を入力してください。', "CASE:2-3-2")
      assert(ent.errors[:member_state_cls][1] == 'は3文字で入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      member_state_cls = 'PWRN'
      ent.member_state_cls = member_state_cls
      assert(!ent.valid?, "CASE:2-3-3")
#      record_err_log(ent)
      assert(ent.errors[:member_state_cls].size == 1, "CASE:2-3-3")
      assert(ent.errors[:member_state_cls][0] == 'は3文字で入力してください。', "CASE:2-3-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-3")
    end
  end
  
  # バリデーションテスト（会員状態）
  # バリデーションチェックのテストを行う
  test "2-4::member_state Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.member_state = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.member_state = nil
      assert(!ent.valid?, "CASE:2-4-2")
#      record_err_log(ent)
      assert(ent.errors[:member_state].size == 1, "CASE:2-4-2")
      assert(ent.errors[:member_state][0] == 'を入力してください。', "CASE:2-4-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      member_state = generate_str(CHAR_SET_ALPHABETIC, 256)
      ent.member_state = member_state
      assert(!ent.valid?, "CASE:2-4-3")
#      record_err_log(ent)
      assert(ent.errors[:member_state].size == 1, "CASE:2-4-3")
      assert(ent.errors[:member_state][0] == 'は255文字以内で入力してください。', "CASE:2-4-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-3")
    end
  end
  
  # バリデーションテスト（会員状態（簡略））
  # バリデーションチェックのテストを行う
  test "2-4::member_state_simple Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.member_state_simple = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.member_state_simple = nil
      assert(!ent.valid?, "CASE:2-4-2")
#      record_err_log(ent)
      assert(ent.errors[:member_state_simple].size == 1, "CASE:2-4-2")
      assert(ent.errors[:member_state_simple][0] == 'を入力してください。', "CASE:2-4-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      member_state_simple = generate_str(CHAR_SET_ALPHABETIC, 256)
      ent.member_state_simple = member_state_simple
      assert(!ent.valid?, "CASE:2-4-3")
#      record_err_log(ent)
      assert(ent.errors[:member_state_simple].size == 1, "CASE:2-4-3")
      assert(ent.errors[:member_state_simple][0] == 'は255文字以内で入力してください。', "CASE:2-4-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-3")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = MemberState.new
    ent.member_state_cls = 'PWR'
    ent.member_state = 'パスワードリセット'
    ent.member_state_simple = 'パ'
    return ent
  end
end
