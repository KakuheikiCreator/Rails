# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：RegulationHost::RegulationHostController
# アクション：notify
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/09/11 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'messaging/message_sender'
require 'biz_actions/regulation_host_list/notify_action'
require 'rkvi/rkv_client'

class NotifyActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::RegulationHostList
  include Messaging
  include Mock
  # 前処理
  def setup
    MessageSender.instance.logger = Rails.logger
  end
  # 後処理
#  def teardown
#  end
  # バリデーションチェック
  test "2-1:NotifyAction Test:valid?" do
    print_log("Begin:2-1:NotifyAction Test:valid?")
    # 正常（全項目入力）
    begin
      system_id = '1'
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      proxy_ip_address = generate_str(CHAR_SET_NUMERIC, 15)
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      ip_address = generate_str(CHAR_SET_NUMERIC, 15)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name=>'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-1-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.valid?, "CASE:2-1-1-2")
      # アクセサ
#      print_log('system_id:' + notify_action.reg_host.system_id.to_s)
      reg_host = notify_action.reg_host
      assert(reg_host.system_id == system_id.to_i, "CASE:2-1-1-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-2-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-2-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-2-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-2-7")
      assert(reg_host.remarks == remarks, "CASE:2-1-1-8")
      assert(notify_action.sort_item == 'system_id', "CASE:2-1-1-9")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-1-10")
      assert(notify_action.disp_counts == 'ALL', "CASE:2-1-1-11")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 0, "CASE:2-1-1-12")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    ###########################################################################
    # 単項目チェック
    ###########################################################################
    # 異常（システムID）
    begin
      system_id = 'a'
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      proxy_ip_address = generate_str(CHAR_SET_NUMERIC, 15)
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      ip_address = generate_str(CHAR_SET_NUMERIC, 15)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-3-1")
      # パラメータチェック
#      print_log('valid?:' + notify_action.valid?.to_s)
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(!notify_action.valid?, "CASE:2-1-3-2")
      # アクセサ
      reg_host = notify_action.reg_host
#      print_log('system_id:' + regulation_host.system_id.to_s)
      assert(reg_host.system_id == 0, "CASE:2-1-3-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-3-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-3-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-3-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-3-7")
      assert(reg_host.remarks == remarks, "CASE:2-1-3-8")
      assert(notify_action.sort_item == 'system_id', "CASE:2-1-3-9")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-3-10")
      assert(notify_action.disp_counts == '500', "CASE:2-1-3-11")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 1, "CASE:2-1-3-12")
#      print_log('system_id:' + notify_action.error_msg_hash[:system_id].to_s)
      assert(notify_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-3-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    print_log("End:2-1:NotifyAction Test:valid?")
  end
  
  # 通知処理
  test "2-2:NotifyAction Test:notify?" do
    print_log("Begin:2-2:NotifyAction Test:notify?")
    rkv_client = Rkvi::RkvClient.instance
    updated_at_hash = rkv_client[:updated_at]
    # 正常（全項目入力）
    begin
      system_id = 1
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      proxy_ip_address = '192.168.200.1'
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      ip_address = '192.168.100.1'
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name=>'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      # 更新日時
      bef_time = Time.now
      updated_at_hash[:regulation_host] = bef_time
#      print_log('object_id:' + updated_at_hash.wrap_obj.object_id.to_s)
      # コンストラクタ
      notify_action = NotifyAction.new(controller)
      assert(!notify_action.nil?, "CASE:2-2-1-1")
      # 通知処理
#      notify_action.notify?
#      print_log('notify?:' + notify_action.notify?.to_s)
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.notify?, "CASE:2-2-1-2")
      # アクセサ
      reg_host = notify_action.reg_host
#      print_log('system_id:' + notify_action.reg_host.system_id.to_s)
      assert(reg_host.system_id == system_id.to_i, "CASE:2-2-1-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-2-1-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-2-1-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-2-1-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-2-1-7")
      assert(reg_host.remarks == remarks, "CASE:2-2-1-8")
      assert(notify_action.sort_item == 'system_id', "CASE:2-2-1-9")
      assert(notify_action.sort_order == 'ASC', "CASE:2-2-1-10")
      assert(notify_action.disp_counts == 'ALL', "CASE:2-2-1-11")
      # 検索結果確認
      reg_host_list = notify_action.reg_host_list
      assert(reg_host_list.size == 11, "CASE:2-2-1-12")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 0, "CASE:2-2-1-13")
      # 更新日時確認
#      updated_at_hash[:regulation_host]
#      print_log('object_id:' + updated_at_hash.wrap_obj.object_id.to_s)
#      print_log('regulation_host:' + updated_at_hash[:regulation_host].to_s)
#      assert(updated_at_hash[:regulation_host] > bef_time, "CASE:2-2-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    ###########################################################################
    # 異常ケース
    ###########################################################################
    # 異常（system_id）
    begin
      system_id = 'c'
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      proxy_ip_address = '192.168.200.1'
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      ip_address = '192.168.100.1'
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name=>'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      # 更新日時
      updated_at_hash = rkv_client[:updated_at]
      bef_time = updated_at_hash[:regulation_host]
      # コンストラクタ生成
      notify_action = NotifyAction.new(controller)
      assert(!notify_action.nil?, "CASE:2-2-2-1")
      # 通知処理
#      print_log('valid?:' + notify_action.valid?.to_s)
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(!notify_action.notify?, "CASE:2-2-2-2")
      # アクセサ
      reg_host = notify_action.reg_host
#      print_log('system_id:' + notify_action.reg_host.system_id.to_s)
      assert(reg_host.system_id == 0, "CASE:2-2-2-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-2-2-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-2-2-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-2-2-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-2-2-7")
      assert(notify_action.reg_host.remarks == remarks, "CASE:2-2-2-8")
      assert(notify_action.sort_item == 'system_id', "CASE:2-2-2-9")
      assert(notify_action.sort_order == 'ASC', "CASE:2-2-2-10")
      assert(notify_action.disp_counts == 'ALL', "CASE:2-2-2-11")
      # 検索結果確認
      reg_host_list = notify_action.reg_host_list
      assert(reg_host_list.size == 11, "CASE:2-2-1-12")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 1, "CASE:2-2-2-13")
      assert(notify_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-2-2-14")
      # 更新日時確認
      assert(updated_at_hash[:regulation_host] == bef_time, "CASE:2-2-2-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    print_log("End:2-2:NotifyAction Test:notify?")
  end
end