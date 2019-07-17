# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：国
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/04 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class CountryTest < ActiveSupport::TestCase
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
    ents = Country.where(:country_name_cd=>'JPN')
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.country_name_cd = 'BMU'
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = Country.where(:country_name_cd=>'JPN')
      assert(ents.length == 0, "CASE:2-1-3")
      ents = Country.where(:country_name_cd=>'BMU')
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = Country.where(:country_name_cd=>'UMI').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = Country.where(:country_name_cd=>'UMI')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # バリデーションテスト（国名コード）
  # バリデーションチェックのテストを行う
  test "2-2::country_name_cd Validation Test" do
    # 正常
    begin
      ent = default_data
      country_name_cd = 'KHM'
      ent.country_name_cd = country_name_cd
      assert(ent.valid?, "CASE:2-2-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.country_name_cd = nil
      assert(!ent.valid?, "CASE:2-2-2")
#      record_err_log(ent)
      assert(ent.errors[:country_name_cd].size == 2, "CASE:2-2-2")
      assert(ent.errors[:country_name_cd][0] == 'を入力してください。', "CASE:2-2-2")
      assert(ent.errors[:country_name_cd][1] == 'は3文字で入力してください。', "CASE:2-2-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      country_name_cd = 'JPNG'
      ent.country_name_cd = country_name_cd
      assert(!ent.valid?, "CASE:2-2-3")
#      record_err_log(ent)
      assert(ent.errors[:country_name_cd].size == 1, "CASE:2-2-3")
      assert(ent.errors[:country_name_cd][0] == 'は3文字で入力してください。', "CASE:2-2-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-3")
    end
  end
  
  # バリデーションテスト（国名）
  # バリデーションチェックのテストを行う
  test "2-3::country_name Validation Test" do
    # 正常
    begin
      ent = default_data
      country_name = generate_str(CHAR_SET_ALPHABETIC, 255)
      ent.country_name = country_name
      assert(ent.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-1")
    end
    # 必須チェックエラー
    begin
      ent = default_data
      ent.country_name = nil
      assert(!ent.valid?, "CASE:2-3-2")
      record_err_log(ent)
      assert(ent.errors[:country_name].size == 1, "CASE:2-3-2")
      assert(ent.errors[:country_name][0] == 'を入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      country_name = generate_str(CHAR_SET_ALPHABETIC, 256)
      ent.country_name = country_name
      assert(!ent.valid?, "CASE:2-3-3")
#      record_err_log(ent)
      assert(ent.errors[:country_name].size == 1, "CASE:2-3-3")
      assert(ent.errors[:country_name][0] == 'は255文字以内で入力してください。', "CASE:2-3-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-3")
    end
  end
  
  def default_data
    ent = Country.new
    ent.country_name_cd = 'UMI'
    ent.country_name = '合衆国領有小離島'
    return ent
  end
end
