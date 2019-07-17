# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：言語
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/04 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class LanguageTest < ActiveSupport::TestCase
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
    ents = Language.where(:lang_name_cd=>'tlh')
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.lang_name_cd = 'vot'
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = Language.where(:lang_name_cd=>'tlh')
      assert(ents.length == 0, "CASE:2-1-3")
      ents = Language.where(:lang_name_cd=>'vot')
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = Language.where(:lang_name_cd=> 'vot').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = Language.where(:lang_name_cd=>'vot')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # バリデーションテスト（言語名コード）
  # バリデーションチェックのテストを行う
  test "2-2::lang_name_cd Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.lang_name_cd = 'xho'
      assert(ent.valid?, "CASE:2-2-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-1")
    end
    # 未入力チェック
    begin
      ent = default_data
      ent.lang_name_cd = nil
      assert(!ent.valid?, "CASE:2-2-2")
#      record_err_log(ent)
      assert(ent.errors[:lang_name_cd].size == 2, "CASE:2-2-3")
      assert(ent.errors[:lang_name_cd][0] == 'を入力してください。', "CASE:2-3-2")
      assert(ent.errors[:lang_name_cd][1] == 'は3文字で入力してください。', "CASE:2-2-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      lang_name_cd = 'ABCD'
      ent.lang_name_cd = lang_name_cd
      assert(!ent.valid?, "CASE:2-2-3")
#      record_err_log(ent)
      assert(ent.errors[:lang_name_cd].size == 1, "CASE:2-2-3")
      assert(ent.errors[:lang_name_cd][0] == 'は3文字で入力してください。', "CASE:2-2-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-3")
    end
  end
  
  # バリデーションテスト（言語名）
  # バリデーションチェックのテストを行う
  test "2-3::lang_name Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.lang_name = 'テトゥン語'
      assert(ent.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-1")
    end
    # 未入力チェック
    begin
      ent = default_data
      ent.lang_name = nil
      assert(!ent.valid?, "CASE:2-3-2")
#      record_err_log(ent)
      assert(ent.errors[:lang_name].size == 1, "CASE:2-3-3")
      assert(ent.errors[:lang_name][0] == 'を入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      lang_name = generate_str(CHAR_SET_ALPHABETIC, 256)
      ent.lang_name = lang_name
      assert(!ent.valid?, "CASE:2-3-3")
#      record_err_log(ent)
      assert(ent.errors[:lang_name].size == 1, "CASE:2-3-3")
      assert(ent.errors[:lang_name][0] == 'は255文字以内で入力してください。', "CASE:2-3-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-3")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = Language.new
    ent.lang_name_cd = 'tlh'
    ent.lang_name = 'クリンゴン語'
    return ent
  end
end
