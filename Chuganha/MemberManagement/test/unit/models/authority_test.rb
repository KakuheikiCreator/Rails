# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：権限
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/04 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class AuthorityTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Common::CodeConv
  
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
    ents = Authority.where(:authority_simple=>'管理')
#    print_log('length:' + ents.length.to_s)
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.authority_simple = '偉い'
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = Authority.where(:authority_simple=>'管理')
      assert(ents.length == 0, "CASE:2-1-3")
      ents = Authority.where(:authority_simple=>'偉い')
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = Authority.where(:authority_simple=>'偉い').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = Authority.where(:authority_simple=>'偉い')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # バリデーションテスト（権限区分）
  # バリデーションチェックのテストを行う
  test "2-2::authority_cls Validation Test" do
    # 正常
    begin
      ent = default_data
      authority_cls = 'ADM'
      ent.authority_cls = authority_cls
      assert(ent.valid?, "CASE:2-2-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.authority_cls = nil
      assert(!ent.valid?, "CASE:2-2-2")
#      record_err_log(ent)
      assert(ent.errors[:authority_cls].size == 2, "CASE:2-2-2")
      assert(ent.errors[:authority_cls][0] == 'を入力してください。', "CASE:2-2-2")
      assert(ent.errors[:authority_cls][1] == 'は3文字で入力してください。', "CASE:2-2-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      authority_cls = 'ADMI'
      ent.authority_cls = authority_cls
      assert(!ent.valid?, "CASE:2-2-3")
#      record_err_log(ent)
      assert(ent.errors[:authority_cls].size == 1, "CASE:2-2-3")
      assert(ent.errors[:authority_cls][0] == 'は3文字で入力してください。', "CASE:2-2-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-3")
    end
  end
  
  # バリデーションテスト（権限）
  # バリデーションチェックのテストを行う
  test "2-3::authority Validation Test" do
    # 正常
    begin
      ent = default_data
      authority = generate_str(CHAR_SET_ALPHABETIC, 255)
      ent.authority = authority
      assert(ent.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.authority = nil
      assert(ent.valid?, "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      authority = generate_str(CHAR_SET_ALPHABETIC, 256)
      ent.authority = authority
      assert(!ent.valid?, "CASE:2-3-3")
#      record_err_log(ent)
      assert(ent.errors[:authority].size == 1, "CASE:2-3-3")
      assert(ent.errors[:authority][0] == 'は255文字以内で入力してください。', "CASE:2-3-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-3")
    end
  end
  
  # バリデーションテスト（権限（簡略））
  # バリデーションチェックのテストを行う
  test "2-４::authority_simple Validation Test" do
    # 正常
    begin
      ent = default_data
      authority_simple = generate_str(CHAR_SET_ALPHABETIC, 255)
      ent.authority_simple = authority_simple
      assert(ent.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.authority_simple = nil
      assert(ent.valid?, "CASE:2-4-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      authority_simple = generate_str(CHAR_SET_ALPHABETIC, 256)
      ent.authority_simple = authority_simple
      assert(!ent.valid?, "CASE:2-4-3")
#      record_err_log(ent)
      assert(ent.errors[:authority_simple].size == 1, "CASE:2-4-3")
      assert(ent.errors[:authority_simple][0] == 'は255文字以内で入力してください。', "CASE:2-4-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-3")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = Authority.new
    ent.authority_cls = 'GOD'
    ent.authority = '神様だよ'
    ent.authority_simple = '神'
    return ent
  end
end
