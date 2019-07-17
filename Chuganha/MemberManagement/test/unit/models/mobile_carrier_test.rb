# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：携帯キャリア
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/04 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'

class MobileCarrierTest < ActiveSupport::TestCase
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
    ents = MobileCarrier.where(:mobile_carrier_cd=>'07')
    assert(ents.length == 1, "CASE:2-1-2")
    # 更新
    begin
      ent = ents[0]
      ent.mobile_carrier_cd = '08'
      assert(ent.save!, "CASE:2-1-3")
#      Rails.logger.debug("created_at:" + info.created_at.to_s)
#      Rails.logger.debug("updated_at:" + info.updated_at.to_s)
      ents = MobileCarrier.where(:mobile_carrier_cd=>'07')
      assert(ents.length == 0, "CASE:2-1-3")
      ents = MobileCarrier.where(:mobile_carrier_cd=>'08')
      assert(ents.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = MobileCarrier.where(:mobile_carrier_cd=>'08').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = MobileCarrier.where(:mobile_carrier_cd=>'08')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-1-4")
    end
  end
  
  # バリデーションテスト（携帯キャリアコード）
  # バリデーションチェックのテストを行う
  test "2-2::mobile_carrier_cd Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.mobile_carrier_cd = '07'
      assert(ent.valid?, "CASE:2-2-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-1")
    end
    # 未入力チェック
    begin
      ent = default_data
      ent.mobile_carrier_cd = nil
      assert(!ent.valid?, "CASE:2-2-2")
#      record_err_log(ent)
      assert(ent.errors[:mobile_carrier_cd].size == 2, "CASE:2-2-2")
      assert(ent.errors[:mobile_carrier_cd][0] == 'を入力してください。', "CASE:2-2-2")
      assert(ent.errors[:mobile_carrier_cd][1] == 'は2文字で入力してください。', "CASE:2-2-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      mobile_carrier_cd = '071'
      ent.mobile_carrier_cd = mobile_carrier_cd
      assert(!ent.valid?, "CASE:2-2-3")
#      record_err_log(ent)
      assert(ent.errors[:mobile_carrier_cd].size == 1, "CASE:2-2-3")
      assert(ent.errors[:mobile_carrier_cd][0] == 'は2文字で入力してください。', "CASE:2-2-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-2-3")
    end
  end
  
  # バリデーションテスト（携帯ドメイン番号）
  # バリデーションチェックのテストを行う
  test "2-3::mobile_domain_no Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.mobile_domain_no = 1
      assert(ent.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-1")
    end
    # 未入力チェック
    begin
      ent = default_data
      ent.mobile_domain_no = nil
      assert(!ent.valid?, "CASE:2-3-2")
#      record_err_log(ent)
      assert(ent.errors[:mobile_domain_no].size == 1, "CASE:2-3-2")
      assert(ent.errors[:mobile_domain_no][0] == 'を入力してください。', "CASE:2-3-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-3-2")
    end
  end
  
  # バリデーションテスト（携帯キャリア）
  # バリデーションチェックのテストを行う
  test "2-4::mobile_carrier Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.mobile_carrier = 'ナゾ～'
      assert(ent.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-1")
    end
    # 未入力チェック
    begin
      ent = default_data
      ent.mobile_carrier = nil
      assert(!ent.valid?, "CASE:2-4-2")
#      record_err_log(ent)
      assert(ent.errors[:mobile_carrier].size == 1, "CASE:2-4-2")
      assert(ent.errors[:mobile_carrier][0] == 'を入力してください。', "CASE:2-4-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      mobile_carrier = generate_str(CHAR_SET_ALPHABETIC, 256)
      ent.mobile_carrier = mobile_carrier
      assert(!ent.valid?, "CASE:2-4-3")
#      record_err_log(ent)
      assert(ent.errors[:mobile_carrier].size == 1, "CASE:2-4-3")
      assert(ent.errors[:mobile_carrier][0] == 'は255文字以内で入力してください。', "CASE:2-4-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-4-3")
    end
  end
  
  # バリデーションテスト（ドメイン）
  # バリデーションチェックのテストを行う
  test "2-5::domain Validation Test" do
    # 正常
    begin
      ent = default_data
      ent.domain = generate_str(CHAR_SET_ALPHABETIC, 249) + '.co.jp'
      assert(ent.valid?, "CASE:2-5-1")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-5-1")
    end
    # 未入力チェック
    begin
      ent = default_data
      ent.domain = nil
      assert(!ent.valid?, "CASE:2-5-2")
#      record_err_log(ent)
      assert(ent.errors[:domain].size == 1, "CASE:2-5-2")
      assert(ent.errors[:domain][0] == 'を入力してください。', "CASE:2-5-2")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-5-2")
    end
    # 文字数エラー
    begin
      ent = default_data
      domain = generate_str(CHAR_SET_ALPHABETIC, 256)
      ent.domain = domain
      assert(!ent.valid?, "CASE:2-5-3")
#      record_err_log(ent)
      assert(ent.errors[:domain].size == 1, "CASE:2-5-3")
      assert(ent.errors[:domain][0] == 'は255文字以内で入力してください。', "CASE:2-5-3")
    rescue => ex
      error_log("Exception:" + ex.message, ex)
      flunk("CASE:2-5-3")
    end
  end
  
  # デフォルトデータ
  def default_data
    ent = MobileCarrier.new
    ent.mobile_carrier_cd = '07'
    ent.mobile_domain_no = 1
    ent.mobile_carrier = 'nazo'
    ent.domain = 'nazo.co.jp'
    return ent
  end
end