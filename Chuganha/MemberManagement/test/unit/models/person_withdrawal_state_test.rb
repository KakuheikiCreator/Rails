# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：退会者状態
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/05 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class PersonWithdrawalStateTest < ActiveSupport::TestCase
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
    ents = PersonWithdrawalState.where(:person_withdrawal_state_cls=>'2')
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.person_withdrawal_state_cls = '3'
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = PersonWithdrawalState.where(:person_withdrawal_state_cls=>'2')
      assert(ents.length == 0, "CASE:2-1-3")
      ents = PersonWithdrawalState.where(:person_withdrawal_state_cls=>'3')
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = PersonWithdrawalState.where(:person_withdrawal_state_cls=>'3').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = PersonWithdrawalState.where(:person_withdrawal_state_cls=>'3')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # バリデーションテスト（退会者状態区分）
  # バリデーションチェックのテストを行う
  test "2-2::person_withdrawal_state_cls Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.person_withdrawal_state_cls = '2'
      assert(ent.valid?, "CASE:2-2-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-1")
    end
    # 未入力チェック
    begin
      ent = default_data
      ent.person_withdrawal_state_cls = nil
      assert(!ent.valid?, "CASE:2-2-2")
#      record_err_log(ent)
      assert(ent.errors[:person_withdrawal_state_cls].size == 2, "CASE:2-2-2")
      assert(ent.errors[:person_withdrawal_state_cls][0] == 'を入力してください。', "CASE:2-2-2")
      assert(ent.errors[:person_withdrawal_state_cls][1] == 'は1文字で入力してください。', "CASE:2-2-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      person_withdrawal_state_cls = '00'
      ent.person_withdrawal_state_cls = person_withdrawal_state_cls
      assert(!ent.valid?, "CASE:2-2-3")
#      record_err_log(ent)
      assert(ent.errors[:person_withdrawal_state_cls].size == 1, "CASE:2-2-3")
      assert(ent.errors[:person_withdrawal_state_cls][0] == 'は1文字で入力してください。', "CASE:2-2-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-3")
    end
  end
  
  # バリデーションテスト（退会者状態）
  # バリデーションチェックのテストを行う
  test "2-3::person_withdrawal_state Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.person_withdrawal_state = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-1")
    end
    # 未入力チェック
    begin
      ent = default_data
      ent.person_withdrawal_state = nil
      assert(!ent.valid?, "CASE:2-3-2")
#      record_err_log(ent)
      assert(ent.errors[:person_withdrawal_state].size == 1, "CASE:2-3-2")
      assert(ent.errors[:person_withdrawal_state][0] == 'を入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      person_withdrawal_state = generate_str(CHAR_SET_ALPHABETIC, 256)
      ent.person_withdrawal_state = person_withdrawal_state
      assert(!ent.valid?, "CASE:2-3-3")
#      record_err_log(ent)
      assert(ent.errors[:person_withdrawal_state].size == 1, "CASE:2-3-3")
      assert(ent.errors[:person_withdrawal_state][0] == 'は255文字以内で入力してください。', "CASE:2-3-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-3")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = PersonWithdrawalState.new
    ent.person_withdrawal_state_cls = '2'
    ent.person_withdrawal_state = '告訴済み'
    return ent
  end
  
end
