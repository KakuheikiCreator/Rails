# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：タイムゾーン
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/06 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class TimezoneTest < ActiveSupport::TestCase
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
    ents = Timezone.where(:timezone_id=>'heaven')
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.timezone_id = 'hell'
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = Timezone.where(:timezone_id=>'heaven')
      assert(ents.length == 0, "CASE:2-1-3")
      ents = Timezone.where(:timezone_id=>'hell')
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = Timezone.where(:timezone_id=>'hell').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = Timezone.where(:timezone_id=>'hell')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # バリデーションテスト（タイムゾーンID）
  # バリデーションチェックのテストを行う
  test "2-2::timezone_id Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.timezone_id = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-2-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.timezone_id = nil
      assert(!ent.valid?, "CASE:2-2-2")
#      record_err_log(ent)
      assert(ent.errors[:timezone_id].size == 1, "CASE:2-2-2")
      assert(ent.errors[:timezone_id][0] == 'を入力してください。', "CASE:2-2-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      ent.timezone_id = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!ent.valid?, "CASE:2-2-3")
#      record_err_log(ent)
      assert(ent.errors[:timezone_id].size == 1, "CASE:2-2-3")
      assert(ent.errors[:timezone_id][0] == 'は255文字以内で入力してください。', "CASE:2-2-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-3")
    end
  end
  
  # バリデーションテスト（タイムゾーン名）
  # バリデーションチェックのテストを行う
  test "2-3::timezone_name Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.timezone_name = generate_str(CHAR_SET_ALPHABETIC, 255)
      assert(ent.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.timezone_name = nil
      assert(!ent.valid?, "CASE:2-3-2")
#      record_err_log(ent)
      assert(ent.errors[:timezone_name].size == 1, "CASE:2-3-2")
      assert(ent.errors[:timezone_name][0] == 'を入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      ent.timezone_name = generate_str(CHAR_SET_ALPHABETIC, 256)
      assert(!ent.valid?, "CASE:2-3-3")
#      record_err_log(ent)
      assert(ent.errors[:timezone_name].size == 1, "CASE:2-3-3")
      assert(ent.errors[:timezone_name][0] == 'は255文字以内で入力してください。', "CASE:2-3-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-3")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = Timezone.new
    ent.timezone_id = 'heaven'
    ent.timezone_name = '天国'
    return ent
  end
end
