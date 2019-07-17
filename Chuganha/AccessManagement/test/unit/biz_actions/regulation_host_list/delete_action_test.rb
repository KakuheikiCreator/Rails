# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：RegulationHost::RegulationHostController
# アクション：delete
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/09/11 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/regulation_host_list/delete_action'
require 'rkvi/rkv_client'

class DeleteActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::RegulationHostList
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
    # 正常（全項目入力）
    begin
      target_data = RegulationHost.where({:proxy_host => '^proxy2\.ne\.jp$'})
      delete_id = target_data[0].id
      params={:controller_name=>'regulation_host_list',
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
      reg_host = delete_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-1-3")
#      print_log('proxy_host:' + reg_host.proxy_host.to_s)
      assert(reg_host.proxy_host.nil?, "CASE:2-1-1-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-1-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-1-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-1-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-1-8")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-1-9")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-1-10")
      assert(delete_action.disp_counts == '500', "CASE:2-1-1-11")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-1-1-12")
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
      params={:controller_name=>'regulation_host_list',
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
      reg_host = delete_action.reg_host
#      print_log('system_id:' + regulation_host.system_id.to_s)
      assert(reg_host.system_id.nil?, "CASE:2-1-2-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-2-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-2-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-2-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-2-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-2-8")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-2-9")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-2-10")
      assert(delete_action.disp_counts == '500', "CASE:2-1-2-11")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-2-12")
#      print_log('error_msg:' + delete_action.error_msg_hash[:error_msg].to_s)
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-2-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # 異常（数値以外のID）
    begin
      delete_id = 'a'
      params={:controller_name=>'regulation_host_list',
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
      reg_host = delete_action.reg_host
#      print_log('system_id:' + reg_host.system_id.to_s)
      assert(reg_host.system_id.nil?, "CASE:2-1-3-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-3-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-3-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-3-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-3-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-3-8")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-3-9")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-3-10")
      assert(delete_action.disp_counts == '500', "CASE:2-1-3-11")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-3-12")
#      print_log('error_msg:' + delete_action.error_msg_hash[:error_msg].to_s)
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-3-13")
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
      params={:controller_name=>'regulation_host_list',
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
      reg_host = delete_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-4-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-4-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-4-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-4-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-4-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-4-8")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-4-9")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-4-10")
      assert(delete_action.disp_counts == '500', "CASE:2-1-4-11")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-4-12")
#      print_log('error_msg:' + delete_action.error_msg_hash[:error_msg].to_s)
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-4-13")
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
      target_data = RegulationHost.where({:remote_host => '^client3\.ne\.jp$'})
      delete_id = target_data[0].id
      params={:controller_name=>'regulation_host_list',
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
      reg_host = delete_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-2-1-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-2-1-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-2-1-5")
      assert(reg_host.remote_host.nil?, "CASE:2-2-1-6")
      assert(reg_host.ip_address.nil?, "CASE:2-2-1-7")
      assert(reg_host.remarks.nil?, "CASE:2-2-1-8")
      assert(delete_action.sort_item == 'system_id', "CASE:2-2-1-9")
      assert(delete_action.sort_order == 'ASC', "CASE:2-2-1-10")
      assert(delete_action.disp_counts == '500', "CASE:2-2-1-11")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-2-1-12")
      # 削除データ確認
      delete_data = RegulationHost.where(:id=>delete_id)
      assert(delete_data.size == 0, "CASE:2-2-1-13")
      # 検索結果確認
      reg_host_list = delete_action.reg_host_list
      assert(reg_host_list.size == 10, "CASE:2-2-1-14")
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
      params={:controller_name=>'regulation_host_list',
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
      reg_host = delete_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-2-2-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-2-2-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-2-2-5")
      assert(reg_host.remote_host.nil?, "CASE:2-2-2-6")
      assert(reg_host.ip_address.nil?, "CASE:2-2-2-7")
      assert(delete_action.reg_host.remarks.nil?, "CASE:2-2-2-8")
      assert(delete_action.sort_item == 'system_id', "CASE:2-2-2-9")
      assert(delete_action.sort_order == 'ASC', "CASE:2-2-2-10")
      assert(delete_action.disp_counts == '500', "CASE:2-2-2-11")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-2-2-10")
#      print_log('error_msg:' + delete_action.error_msg_hash[:error_msg].to_s)
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-2-2-11")
      # 検索結果確認
#      print_log('Result Size:' + delete_action.reg_host_list.size.to_s)
      assert(delete_action.reg_host_list.size == 10, "CASE:2-2-2-12")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
  end
end