# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：RegulationReferrer::RegulationReferrerController
# アクション：delete
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/06/28 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/regulation_referrer_list/delete_action'
require 'rkvi/rkv_client'

class DeleteActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::RegulationReferrerList
  include Mock
  # 前処理
#  def setup
#    BizNotifyList.instance.data_load
#  end
  # 後処理
#  def teardown
#  end
  # バリデーションチェック
  test "2-1:DeleteAction Test:valid?" do
    # データ更新日時ハッシュ更新
    loaded_at_hash = Rkvi::RkvClient.instance[:updated_at]
    # 更新日時
    bef_time = Time.now
    loaded_at_hash[:regulation_referrer] = bef_time
    # 正常（全項目入力）
    begin
      target_data = RegulationReferrer.where({:referrer => '^www\.msn\.co\.jp$'})
      delete_id = target_data[0].id
      params={:controller_name=>'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:delete_id=>delete_id}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-1-1")
      # パラメータチェック
      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.valid?, "CASE:2-1-1-2")
      # アクセサ
      assert(delete_action.reg_referrer.system_id.nil?, "CASE:2-1-1-3")
      assert(delete_action.reg_referrer.referrer.nil?, "CASE:2-1-1-4")
      assert(delete_action.reg_referrer.remarks.nil?, "CASE:2-1-1-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-1-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-1-7")
      assert(delete_action.disp_counts == '500', "CASE:2-1-1-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-1-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    ###########################################################################
    # 単項目チェック
    ###########################################################################
    # 異常（ID未入力）
    begin
      delete_id = nil
      params={:controller_name=>'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:delete_id=>delete_id}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-2-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-2-2")
      # アクセサ
      regulation_referrer = delete_action.reg_referrer
#      print_log('system_id:' + regulation_referrer.system_id.to_s)
      assert(regulation_referrer.system_id.nil?, "CASE:2-1-2-3")
      assert(regulation_referrer.referrer.nil?, "CASE:2-1-2-4")
      assert(regulation_referrer.remarks.nil?, "CASE:2-1-2-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-2-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-2-7")
      assert(delete_action.disp_counts == '500', "CASE:2-1-2-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-2-10")
#      print_log('error_msg:' + delete_action.error_msg_hash[:error_msg].to_s)
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # 異常（数値以外のID）
    begin
      delete_id = 'a'
      params={:controller_name=>'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:delete_id=>delete_id}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-3-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-3-2")
      # アクセサ
      regulation_referrer = delete_action.reg_referrer
#      print_log('system_id:' + regulation_referrer.system_id.to_s)
      assert(regulation_referrer.system_id.nil?, "CASE:2-1-3-3")
      assert(regulation_referrer.referrer.nil?, "CASE:2-1-3-4")
      assert(regulation_referrer.remarks.nil?, "CASE:2-1-3-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-3-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-3-7")
      assert(delete_action.disp_counts == '500', "CASE:2-1-3-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-3-10")
#      print_log('error_msg:' + delete_action.error_msg_hash[:error_msg].to_s)
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-3-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    ###########################################################################
    # DB関連チェック
    ###########################################################################
    # 異常（対象データ無し）
    begin
      delete_id = 100
      params={:controller_name=>'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:delete_id=>delete_id}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-4-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-4-2")
      # アクセサ
      regulation_referrer = delete_action.reg_referrer
      assert(regulation_referrer.system_id.nil?, "CASE:2-1-4-3")
      assert(regulation_referrer.referrer.nil?, "CASE:2-1-4-4")
      assert(regulation_referrer.remarks.nil?, "CASE:2-1-4-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-4-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-4-7")
      assert(delete_action.disp_counts == '500', "CASE:2-1-4-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-4-10")
#      print_log('error_msg:' + delete_action.error_msg_hash[:error_msg].to_s)
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-4-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
  end
  
  # 削除処理
  test "2-2:DeleteAction Test:delete_data?" do
    # 正常（全項目入力）
    begin
      target_data = RegulationReferrer.where({:referrer => '^www\.msn\.co\.jp$'})
      delete_id = target_data[0].id
      params={:controller_name=>'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:delete_id=>delete_id}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-2-1-1")
      # 削除処理
      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.delete_data?, "CASE:2-2-1-2")
      # アクセサ
      assert(delete_action.reg_referrer.system_id.nil?, "CASE:2-2-1-3")
      assert(delete_action.reg_referrer.referrer.nil?, "CASE:2-2-1-4")
      assert(delete_action.reg_referrer.remarks.nil?, "CASE:2-2-1-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-2-1-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-2-1-7")
      assert(delete_action.disp_counts == '500', "CASE:2-2-1-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-2-1-9")
      # 削除データ確認
      delete_data = RegulationReferrer.where(:id=>delete_id)
      assert(delete_data.size == 0, "CASE:2-2-1-10")
      # 検索結果確認
      reg_referrer_list = delete_action.reg_referrer_list
      assert(reg_referrer_list.size == 3, "CASE:2-2-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    ###########################################################################
    # 異常ケース
    ###########################################################################
    # 異常（対象データが存在しない）
    begin
      delete_id = 100
      params={:controller_name=>'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:delete_id=>delete_id}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-2-2-1")
      # 削除処理
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.delete_data?, "CASE:2-2-2-2")
      # アクセサ
      assert(delete_action.reg_referrer.system_id.nil?, "CASE:2-2-2-3")
      assert(delete_action.reg_referrer.referrer.nil?, "CASE:2-2-2-4")
      assert(delete_action.reg_referrer.remarks.nil?, "CASE:2-2-2-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-2-2-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-2-2-7")
      assert(delete_action.disp_counts == '500', "CASE:2-2-2-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-2-2-9")
#      print_log('error_msg:' + delete_action.error_msg_hash[:error_msg].to_s)
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-2-2-10")
      # 検索結果確認
#      print_log('Result Size:' + delete_action.reg_referrer_list.size.to_s)
      assert(delete_action.reg_referrer_list.size == 3, "CASE:2-2-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
  end
end