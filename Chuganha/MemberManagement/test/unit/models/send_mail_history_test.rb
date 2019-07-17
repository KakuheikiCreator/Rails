# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：メール送信履歴
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/06 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class SendMailHistoryTest < ActiveSupport::TestCase
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
    ents = SendMailHistory.where(:account_id=>100)
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.account_id = 101
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = SendMailHistory.where(:account_id=>100)
      assert(ents.length == 0, "CASE:2-1-3")
      ents = SendMailHistory.where(:account_id=>101)
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = SendMailHistory.where(:account_id=>101).destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = SendMailHistory.where(:account_id=>101)
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # 検索（関連）テスト
  # テーブル間の関連のテストを行う
  test "2-2:Relationship Test" do
    # 会員状態
    ents = SendMailHistory.where(:account_id=>1)
    account = ents[0].account
    assert(!account.nil?, "CASE:2-2-1")
    assert(Account === account, "CASE:2-2-1")
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
  
  # バリデーションテスト（宛先ID１）
  # バリデーションチェックのテストを行う
  test "2-4::enc_destination_id_1 Validation Test" do
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
      ent.enc_destination_id_1 = nil
      assert(!ent.valid?, "CASE:2-4-2")
#      record_err_log(ent)
      assert(ent.errors[:enc_destination_id_1].size == 1, "CASE:2-4-2")
      assert(ent.errors[:enc_destination_id_1][0] == 'を入力してください。', "CASE:2-4-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-2")
    end
  end
  
  # バリデーションテスト（送信日時１）
  # バリデーションチェックのテストを行う
  test "2-5::send_time_1 Validation Test" do
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
      ent.send_time_1 = nil
      assert(!ent.valid?, "CASE:2-5-2")
#      record_err_log(ent)
      assert(ent.errors[:send_time_1].size == 1, "CASE:2-5-2")
      assert(ent.errors[:send_time_1][0] == 'を入力してください。', "CASE:2-5-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-5-2")
    end
  end
  
  # バリデーションテスト（件名１）
  # バリデーションチェックのテストを行う
  test "2-5::subject_1 Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.subject_1 = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-5-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-5-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.subject_1 = nil
      assert(!ent.valid?, "CASE:2-5-2")
#      record_err_log(ent)
      assert(ent.errors[:subject_1].size == 1, "CASE:2-5-2")
      assert(ent.errors[:subject_1][0] == 'を入力してください。', "CASE:2-5-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-5-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      ent.subject_1 = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!ent.valid?, "CASE:2-5-3")
#      record_err_log(ent)
      assert(ent.errors[:subject_1].size == 1, "CASE:2-5-3")
      assert(ent.errors[:subject_1][0] == 'は255文字以内で入力してください。', "CASE:2-5-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-5-3")
    end
  end
  
  # バリデーションテスト（件名２）
  # バリデーションチェックのテストを行う
  test "2-6::subject_2 Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.subject_2 = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-6-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-6-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.subject_2 = nil
      assert(ent.valid?, "CASE:2-6-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-6-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      ent.subject_2 = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!ent.valid?, "CASE:2-6-3")
#      record_err_log(ent)
      assert(ent.errors[:subject_2].size == 1, "CASE:2-6-3")
      assert(ent.errors[:subject_2][0] == 'は255文字以内で入力してください。', "CASE:2-6-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-6-3")
    end
  end
  
  # バリデーションテスト（件名３）
  # バリデーションチェックのテストを行う
  test "2-7::subject_3 Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.subject_3 = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-7-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-7-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.subject_3 = nil
      assert(ent.valid?, "CASE:2-7-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-7-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      ent.subject_3 = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!ent.valid?, "CASE:2-7-3")
#      record_err_log(ent)
      assert(ent.errors[:subject_3].size == 1, "CASE:2-7-3")
      assert(ent.errors[:subject_3][0] == 'は255文字以内で入力してください。', "CASE:2-7-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-7-3")
    end
  end
  
  # バリデーションテスト（件名４）
  # バリデーションチェックのテストを行う
  test "2-8::subject_4 Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.subject_4 = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-8-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-8-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.subject_4 = nil
      assert(ent.valid?, "CASE:2-8-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-8-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      ent.subject_4 = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!ent.valid?, "CASE:2-8-3")
#      record_err_log(ent)
      assert(ent.errors[:subject_4].size == 1, "CASE:2-8-3")
      assert(ent.errors[:subject_4][0] == 'は255文字以内で入力してください。', "CASE:2-8-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-8-3")
    end
  end
  
  # バリデーションテスト（件名５）
  # バリデーションチェックのテストを行う
  test "2-9::subject_5 Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.subject_5 = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-9-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-9-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.subject_5 = nil
      assert(ent.valid?, "CASE:2-9-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-9-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      ent.subject_5 = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!ent.valid?, "CASE:2-9-3")
#      record_err_log(ent)
      assert(ent.errors[:subject_5].size == 1, "CASE:2-9-3")
      assert(ent.errors[:subject_5][0] == 'は255文字以内で入力してください。', "CASE:2-9-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-9-3")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = SendMailHistory.new
    ent.account_id = 100
    ent.enc_destination_id_1 = CodeConverter.instance.encryption(generate_str(CHAR_SET_HANKAKU, 40))
    ent.enc_destination_id_2 = CodeConverter.instance.encryption(generate_str(CHAR_SET_HANKAKU, 40))
    ent.enc_destination_id_3 = CodeConverter.instance.encryption(generate_str(CHAR_SET_HANKAKU, 40))
    ent.enc_destination_id_4 = CodeConverter.instance.encryption(generate_str(CHAR_SET_HANKAKU, 40))
    ent.enc_destination_id_5 = CodeConverter.instance.encryption(generate_str(CHAR_SET_HANKAKU, 40))
    ent.send_time_1 = DateTime.new(2012,11,6,0,0,0)
    ent.send_time_2 = DateTime.new(2012,11,6,0,0,0)
    ent.send_time_3 = DateTime.new(2012,11,6,0,0,0)
    ent.send_time_4 = DateTime.new(2012,11,6,0,0,0)
    ent.send_time_5 = DateTime.new(2012,11,6,0,0,0)
    ent.subject_1 = generate_str(CHAR_SET_HANKAKU, 40)
    ent.subject_2 = generate_str(CHAR_SET_HANKAKU, 40)
    ent.subject_3 = generate_str(CHAR_SET_HANKAKU, 40)
    ent.subject_4 = generate_str(CHAR_SET_HANKAKU, 40)
    ent.subject_5 = generate_str(CHAR_SET_HANKAKU, 40)
    return ent
  end
end
