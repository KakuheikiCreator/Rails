# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：RegulationCookie::RegulationCookieController
# アクション：notify
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/07/20 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'messaging/message_sender'
require 'business/biz_regulation_cookie/biz_notify'
require 'rkvi/rkv_client'

class BizNotify < ActiveSupport::TestCase
  include UnitTestUtil
  include Business::BizRegulationCookie
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
  test "2-1:BizNotify Test:valid?" do
    # 正常（全項目入力）
    begin
      system_id = 1
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name=>'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      biz_notify = BizNotify.new(controller)
      # コンストラクタ生成
      assert(!biz_notify.nil?, "CASE:2-1-1-1")
      # パラメータチェック
#      biz_notify.valid?
#      print_log('error msg:' + biz_notify.error_msg_hash.to_s)
      assert(biz_notify.valid?, "CASE:2-1-1-2")
      # アクセサ
      assert(biz_notify.regulation_cookie.system_id == system_id, "CASE:2-1-1-3")
      assert(biz_notify.regulation_cookie.cookie == cookie, "CASE:2-1-1-4")
      assert(biz_notify.regulation_cookie.remarks == remarks, "CASE:2-1-1-5")
      assert(biz_notify.sort_item == 'system_id', "CASE:2-1-1-6")
      assert(biz_notify.sort_order == 'ASC', "CASE:2-1-1-7")
      assert(biz_notify.disp_counts == 'ALL', "CASE:2-1-1-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_notify.error_msg_hash.to_s)
      assert(biz_notify.error_msg_hash.size == 0, "CASE:2-1-1-9")
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
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      biz_notify = BizNotify.new(controller)
      # コンストラクタ生成
      assert(!biz_notify.nil?, "CASE:2-1-3-1")
      # パラメータチェック
#      print_log('valid?:' + biz_notify.valid?.to_s)
#      print_log('error msg:' + biz_notify.error_msg_hash.to_s)
      assert(!biz_notify.valid?, "CASE:2-1-3-2")
      # アクセサ
      regulation_cookie = biz_notify.regulation_cookie
#      print_log('system_id:' + regulation_cookie.system_id.to_s)
      assert(regulation_cookie.system_id == 0, "CASE:2-1-3-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-3-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-3-5")
      assert(biz_notify.sort_item == 'system_id', "CASE:2-1-3-6")
      assert(biz_notify.sort_order == 'ASC', "CASE:2-1-3-7")
      assert(biz_notify.disp_counts == '500', "CASE:2-1-3-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_notify.error_msg_hash.to_s)
      assert(biz_notify.error_msg_hash.size == 1, "CASE:2-1-3-9")
#      print_log('system_name:' + biz_notify.error_msg_hash[:system_name].to_s)
      assert(biz_notify.error_msg_hash[:system_name] == 'システム名 は不正な値です。', "CASE:2-1-3-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
  end
  
  # 通知処理
  test "2-2:BizNotify Test:notify?" do
    rkv_client = Rkvi::RkvClient.instance
    # 正常（全項目入力）
    begin
      system_id = 1
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name=>'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      # 更新日時
      bef_time = Time.now
      updated_at_hash = rkv_client[:updated_at]
      updated_at_hash[:regulation_cookie] = bef_time
      # コンストラクタ
      biz_notify = BizNotify.new(controller)
      assert(!biz_notify.nil?, "CASE:2-2-1-1")
      # 通知処理
#      biz_notify.notify?
#      print_log('notify?:' + biz_notify.notify?.to_s)
#      print_log('error msg:' + biz_notify.error_msg_hash.to_s)
      assert(biz_notify.notify?, "CASE:2-2-1-2")
      # アクセサ
      assert(biz_notify.regulation_cookie.system_id == system_id, "CASE:2-2-1-3")
      assert(biz_notify.regulation_cookie.cookie == cookie, "CASE:2-2-1-4")
      assert(biz_notify.regulation_cookie.remarks == remarks, "CASE:2-2-1-5")
      assert(biz_notify.sort_item == 'system_id', "CASE:2-2-1-6")
      assert(biz_notify.sort_order == 'ASC', "CASE:2-2-1-7")
      assert(biz_notify.disp_counts == 'ALL', "CASE:2-2-1-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_notify.error_msg_hash.to_s)
      assert(biz_notify.error_msg_hash.size == 0, "CASE:2-2-1-9")
      # 更新日時確認
#      print_log('regulation_cookie:' + updated_at_hash[:regulation_cookie].to_s)
      assert(updated_at_hash[:regulation_cookie] > bef_time, "CASE:2-2-1-13")
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
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name=>'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      # 更新日時
      updated_at_hash = rkv_client[:updated_at]
      bef_time = updated_at_hash[:regulation_cookie]
      # コンストラクタ生成
      biz_notify = BizNotify.new(controller)
      assert(!biz_notify.nil?, "CASE:2-2-2-1")
      # 通知処理
#      print_log('valid?:' + biz_notify.valid?.to_s)
#      print_log('error msg:' + biz_notify.error_msg_hash.to_s)
      assert(!biz_notify.notify?, "CASE:2-2-2-2")
      # アクセサ
#      print_log('system_id:' + biz_notify.regulation_cookie.system_id.to_s)
      assert(biz_notify.regulation_cookie.system_id == 0, "CASE:2-2-2-3")
      assert(biz_notify.regulation_cookie.cookie == cookie, "CASE:2-2-2-4")
      assert(biz_notify.regulation_cookie.remarks == remarks, "CASE:2-2-2-5")
      assert(biz_notify.sort_item == 'system_id', "CASE:2-2-2-6")
      assert(biz_notify.sort_order == 'ASC', "CASE:2-2-2-7")
      assert(biz_notify.disp_counts == 'ALL', "CASE:2-2-2-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_notify.error_msg_hash.to_s)
      assert(biz_notify.error_msg_hash.size == 1, "CASE:2-2-1-9")
      assert(biz_notify.error_msg_hash[:system_name] == 'システム名 は不正な値です。', "CASE:2-2-2-10")
      # 更新日時確認
      assert(updated_at_hash[:regulation_cookie] == bef_time, "CASE:2-2-2-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
  end
end