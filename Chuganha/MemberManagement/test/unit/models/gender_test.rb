# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：性別
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/04 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class GenderTest < ActiveSupport::TestCase
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
    ents = Gender.where(:gender_cls=>'M')
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.gender_cls = 'N'
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = Gender.where(:gender_cls=>'M')
      assert(ents.length == 0, "CASE:2-1-3")
      ents = Gender.where(:gender_cls=>'N')
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = Gender.where(:gender_cls=> 'G').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = Gender.where(:gender_cls=>'G')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # バリデーションテスト（性別区分）
  # バリデーションチェックのテストを行う
  test "2-2::gender_cls Validation Test" do
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
      ent.gender_cls = nil
      assert(!ent.valid?, "CASE:2-2-2")
#      record_err_log(ent)
      assert(ent.errors[:gender_cls].size == 2, "CASE:2-2-2")
      assert(ent.errors[:gender_cls][0] == 'を入力してください。', "CASE:2-2-2")
      assert(ent.errors[:gender_cls][1] == 'は1文字で入力してください。', "CASE:2-2-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      gender_cls = 'AH'
      ent.gender_cls = gender_cls
      assert(!ent.valid?, "CASE:2-2-3")
#      record_err_log(ent)
      assert(ent.errors[:gender_cls].size == 1, "CASE:2-2-3")
      assert(ent.errors[:gender_cls][0] == 'は1文字で入力してください。', "CASE:2-2-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-3")
    end
  end
  
  # バリデーションテスト（性別）
  # バリデーションチェックのテストを行う
  test "2-3::gender Validation Test" do
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
      ent.gender = nil
      assert(!ent.valid?, "CASE:2-3-2")
#      record_err_log(ent)
      assert(ent.errors[:gender].size == 1, "CASE:2-3-2")
      assert(ent.errors[:gender][0] == 'を入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      gender = generate_str(CHAR_SET_ALPHABETIC, 256)
      ent.gender = gender
      assert(!ent.valid?, "CASE:2-3-3")
#      record_err_log(ent)
      assert(ent.errors[:gender].size == 1, "CASE:2-3-3")
      assert(ent.errors[:gender][0] == 'は255文字以内で入力してください。', "CASE:2-3-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-3")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = Gender.new
    ent.gender_cls = 'G'
    ent.gender = 'ゲイ'
    return ent
  end
end
