# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：ScheduleList::ScheduleListController
# アクション：notify
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/08/20 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/schedule_list/notify_action'

class NotifyActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::ScheduleList
  include Mock
  # 前処理
  def setup
    Time.zone = 3/8
    # リモートオブジェクト
    @rkv_client = Rkvi::RkvClient.instance
  end
  # 後処理
#  def teardown
#  end
  # バリデーションチェック
  test "2-1:NotifyAction Test:valid?" do
    # 正常（抽出条件指定なし）
    begin
      # 更新日時更新
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>nil,
                        :from_datetime=>nil,
                        :to_datetime=>nil,
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
      assert(notify_action.system_id.nil?, "CASE:2-1-1-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-1-1-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-1-1-5")
      assert(notify_action.sort_item == 'system_id', "CASE:2-1-1-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-1-7")
      assert(notify_action.disp_counts == 'ALL', "CASE:2-1-1-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-1-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 0, "CASE:2-1-1-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 正常（全検索条件指定、検索結果無し）
    begin
      system_id = '1'
      from_datetime = date_time_param(2010, 9, 18, 2, 0, 0)
      to_datetime = date_time_param(2010, 9, 19, 2, 0, 0)
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'gets_start_date',
                        :sort_order=>'DESC',
                        :disp_counts=>'500'}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-2-1")
      # パラメータチェック
      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.valid?, "CASE:2-1-2-2")
      # アクセサ
      assert(notify_action.system_id == system_id, "CASE:2-1-2-3")
      assert(notify_action.from_datetime == local_date_time(2010, 9, 18, 2, 0, 0,), "CASE:2-1-2-4")
      assert(notify_action.to_datetime == local_date_time(2010, 9, 19, 2, 0, 0), "CASE:2-1-2-5")
      assert(notify_action.sort_item == 'gets_start_date', "CASE:2-1-2-6")
      assert(notify_action.sort_order == 'DESC', "CASE:2-1-2-7")
      assert(notify_action.disp_counts == '500', "CASE:2-1-2-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-2-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 0, "CASE:2-1-2-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # 異常（システムID）
    begin
      system_id = 'a'
      from_datetime = nil
      to_datetime = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-3-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(!notify_action.valid?, "CASE:2-1-3-2")
      # アクセサ
#      Rails.logger.debug('system_id:' + regulation_cookie.system_id.to_s)
      assert(notify_action.system_id == 'a', "CASE:2-1-3-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-1-3-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-1-3-5")
      assert(notify_action.sort_item == 'gets_start_date', "CASE:2-1-3-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-3-7")
      assert(notify_action.disp_counts == '500', "CASE:2-1-3-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-3-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 1, "CASE:2-1-3-10")
#      print_log('system_id:' + notify_action.error_msg_hash[:system_id].to_s)
      assert(notify_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-3-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # 異常（年項目不正）
    begin
      system_id = nil
      from_datetime = date_time_param('test year', 9, 17, 9, 0, 0)
      to_datetime = date_time_param('a', 9, 17, 9, 0, 1)
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-4-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.valid?, "CASE:2-1-4-2")
      # アクセサ
      rcv_from_date = local_date_time(0, 9, 17, 9, 0, 0)
      rcv_to_date = local_date_time(0, 9, 17, 9, 0, 1)
#      print_log('from_datetime:' + notify_action.from_datetime.to_s)
      assert(notify_action.system_id.nil?, "CASE:2-1-4-3")
      assert(notify_action.from_datetime == rcv_from_date, "CASE:2-1-4-4")
      assert(notify_action.to_datetime == rcv_to_date, "CASE:2-1-4-5")
      assert(notify_action.sort_item == 'gets_start_date', "CASE:2-1-4-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-4-7")
      assert(notify_action.disp_counts == '500', "CASE:2-1-4-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-4-9")
      # エラーメッセージ
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 0, "CASE:2-1-4-10")
#      print_log('cookie:' + notify_action.error_msg_hash[:cookie].to_s)
#      assert(notify_action.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-7-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
    # 異常（月項目不正）
    begin
      system_id = nil
      from_datetime = date_time_param(2010, 'a', 17, 9, 0, 0)
      to_datetime = date_time_param(2020, '-', 17, 9, 0, 1)
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-5-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.valid?, "CASE:2-1-5-2")
      # アクセサ
#      rcv_from_date = local_date_time(2010, 9, 17, 9, 0, 0)
#      rcv_to_date = local_date_time(2020, 9, 17, 9, 0, 1)
#      print_log('from_datetime:' + notify_action.from_datetime.to_s)
      assert(notify_action.system_id.nil?, "CASE:2-1-5-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-1-5-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-1-5-5")
      assert(notify_action.sort_item == 'gets_start_date', "CASE:2-1-5-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-5-7")
      assert(notify_action.disp_counts == '500', "CASE:2-1-5-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-5-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 0, "CASE:2-1-5-10")
#      print_log('cookie:' + notify_action.error_msg_hash[:cookie].to_s)
#      assert(notify_action.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-7-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-5")
    end
    # 異常（日項目不正）
    begin
      system_id = nil
      from_datetime = date_time_param(2010, 1, 'a', 9, 0, 0)
      to_datetime = date_time_param(2020, 1, '*', 9, 0, 1)
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-6-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.valid?, "CASE:2-1-6-2")
      # アクセサ
#      rcv_from_date = local_date_time(2010, 9, 17, 9, 0, 0)
#      rcv_to_date = local_date_time(2020, 9, 17, 9, 0, 1)
#      print_log('from_datetime:' + notify_action.from_datetime.to_s)
      assert(notify_action.system_id.nil?, "CASE:2-1-6-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-1-6-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-1-6-5")
      assert(notify_action.sort_item == 'gets_start_date', "CASE:2-1-6-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-6-7")
      assert(notify_action.disp_counts == '500', "CASE:2-1-6-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-6-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 0, "CASE:2-1-6-10")
#      print_log('cookie:' + notify_action.error_msg_hash[:cookie].to_s)
#      assert(notify_action.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-7-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-6")
    end
    # 異常（時項目不正）
    begin
      system_id = nil
      from_datetime = date_time_param(2010, 1, 1, 'a', 0, 0)
      to_datetime = date_time_param(2020, 1, 1, '24', 0, 1)
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-7-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.valid?, "CASE:2-1-7-2")
      # アクセサ
      rcv_from_date = local_date_time(2010, 1, 1, 0, 0, 0)
#      rcv_to_date = local_date_time(2020, 1, 1, 0, 0, 1)
#      print_log('to_datetime:' + notify_action.to_datetime.to_s)
      assert(notify_action.system_id.nil?, "CASE:2-1-7-3")
      assert(notify_action.from_datetime == rcv_from_date, "CASE:2-1-7-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-1-7-5")
      assert(notify_action.sort_item == 'gets_start_date', "CASE:2-1-7-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-7-7")
      assert(notify_action.disp_counts == '500', "CASE:2-1-7-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-7-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 0, "CASE:2-1-7-10")
#      print_log('cookie:' + notify_action.error_msg_hash[:cookie].to_s)
#      assert(notify_action.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-7-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-7")
    end
    # 異常（分項目不正）
    begin
      system_id = nil
      from_datetime = date_time_param(2010, 1, 1, 0, '60', 0)
      to_datetime = date_time_param(2020, 1, 1, 0, 'abc', 1)
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-8-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.valid?, "CASE:2-1-8-2")
      # アクセサ
#      rcv_from_date = local_date_time(2010, 1, 1, 0, 0, 0)
      rcv_to_date = local_date_time(2020, 1, 1, 0, 0, 1)
#      print_log('from_datetime:' + notify_action.from_datetime.to_s)
      assert(notify_action.system_id.nil?, "CASE:2-1-8-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-1-8-4")
      assert(notify_action.to_datetime == rcv_to_date, "CASE:2-1-8-5")
      assert(notify_action.sort_item == 'gets_start_date', "CASE:2-1-8-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-8-7")
      assert(notify_action.disp_counts == '500', "CASE:2-1-8-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-8-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 0, "CASE:2-1-8-10")
#      print_log('cookie:' + notify_action.error_msg_hash[:cookie].to_s)
#      assert(notify_action.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-7-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-8")
    end
    # 異常（秒項目不正）
    begin
      system_id = nil
      from_datetime = date_time_param(2010, 1, 1, 0, 0, 'rty')
      to_datetime = date_time_param(2020, 1, 1, 0, 1, '60')
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-9-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.valid?, "CASE:2-1-9-2")
      # アクセサ
      rcv_from_date = local_date_time(2010, 1, 1, 0, 0, 0)
#      rcv_to_date = local_date_time(2020, 1, 1, 0, 1, 0)
#      print_log('from_datetime:' + notify_action.from_datetime.to_s)
      assert(notify_action.system_id.nil?, "CASE:2-1-9-3")
      assert(notify_action.from_datetime == rcv_from_date, "CASE:2-1-9-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-1-9-5")
      assert(notify_action.sort_item == 'gets_start_date', "CASE:2-1-9-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-9-7")
      assert(notify_action.disp_counts == '500', "CASE:2-1-9-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-9-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 0, "CASE:2-1-9-10")
#      print_log('cookie:' + notify_action.error_msg_hash[:cookie].to_s)
#      assert(notify_action.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-7-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-9")
    end
    # 異常（取得開始日時関連不正）
    begin
      system_id = nil
      from_datetime = date_time_param(2010, 1, 1, 0, 0, 0)
      to_datetime = date_time_param(2010, 1, 1, 0, 0, 0)
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-10-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(!notify_action.valid?, "CASE:2-1-10-2")
      # アクセサ
      rcv_from_date = local_date_time(2010, 1, 1, 0, 0, 0)
      rcv_to_date = local_date_time(2010, 1, 1, 0, 0, 0)
#      print_log('from_datetime:' + notify_action.from_datetime.to_s)
      assert(notify_action.system_id.nil?, "CASE:2-1-10-3")
      assert(notify_action.from_datetime == rcv_from_date, "CASE:2-1-10-4")
      assert(notify_action.to_datetime == rcv_to_date, "CASE:2-1-10-5")
      assert(notify_action.sort_item == 'gets_start_date', "CASE:2-1-10-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-10-7")
      assert(notify_action.disp_counts == '500', "CASE:2-1-10-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-10-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 1, "CASE:2-1-10-10")
#      print_log('gets_start_date:' + notify_action.error_msg_hash[:gets_start_date].to_s)
      assert(notify_action.error_msg_hash[:gets_start_date] == '取得開始日時 は不正な値です。', "CASE:2-1-10-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-10")
    end
    # 異常（ソート項目が空文字）
    begin
      system_id = nil
      from_datetime = nil
      to_datetime = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'',
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-11-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(!notify_action.valid?, "CASE:2-1-11-2")
      # アクセサ
      assert(notify_action.system_id.nil?, "CASE:2-1-11-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-1-11-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-1-11-5")
      assert(notify_action.sort_item == '', "CASE:2-1-11-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-11-7")
      assert(notify_action.disp_counts == '500', "CASE:2-1-11-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-11-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 1, "CASE:2-1-11-10")
#      print_log('sort_cond:' + notify_action.error_msg_hash[:sort_cond].to_s)
      assert(notify_action.error_msg_hash[:sort_cond] == '検索結果並び順 を入力してください。', "CASE:2-1-11-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-11")
    end
    # 異常（存在しないソート項目）
    begin
      system_id = nil
      from_datetime = nil
      to_datetime = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'err_system_id',
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-12-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(!notify_action.valid?, "CASE:2-1-12-2")
      # アクセサ
      assert(notify_action.system_id.nil?, "CASE:2-1-12-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-1-12-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-1-12-5")
      assert(notify_action.sort_item == 'err_system_id', "CASE:2-1-12-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-12-7")
      assert(notify_action.disp_counts == '500', "CASE:2-1-12-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-12-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 1, "CASE:2-1-12-10")
#      print_log('sort_cond:' + notify_action.error_msg_hash[:sort_cond].to_s)
      assert(notify_action.error_msg_hash[:sort_cond] == '検索結果並び順 は不正な値です。', "CASE:2-1-12-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-12")
    end
    # 異常（ソート条件が汎用コードテーブルにない）
    begin
      system_id = nil
      from_datetime = nil
      to_datetime = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'system_id',
                        :sort_order=>'ADSC',
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-13-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(!notify_action.valid?, "CASE:2-1-13-2")
      # アクセサ
      assert(notify_action.system_id.nil?, "CASE:2-1-13-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-1-13-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-1-13-5")
      assert(notify_action.sort_item == 'system_id', "CASE:2-1-13-6")
      assert(notify_action.sort_order == 'ADSC', "CASE:2-1-13-7")
      assert(notify_action.disp_counts == '500', "CASE:2-1-13-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-13-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 1, "CASE:2-1-13-10")
#      print_log('remarks:' + notify_action.error_msg_hash[:remarks].to_s)
      assert(notify_action.error_msg_hash[:sort_cond] == '検索結果並び順 は不正な値です。', "CASE:2-1-13-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-13")
    end
    # 異常（検索件数・ソート条件共に指定なし）
    begin
      system_id = nil
      from_datetime = nil
      to_datetime = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>''}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-14-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(!notify_action.valid?, "CASE:2-1-14-2")
      # アクセサ
      assert(notify_action.system_id.nil?, "CASE:2-1-14-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-1-14-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-1-14-5")
      assert(notify_action.sort_item == 'system_id', "CASE:2-1-14-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-14-7")
      assert(notify_action.disp_counts == '', "CASE:2-1-14-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-14-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 1, "CASE:2-1-14-10")
#      print_log('disp_counts:' + notify_action.error_msg_hash[:disp_counts].to_s)
      assert(notify_action.error_msg_hash[:disp_counts] == '表示件数 を入力してください。', "CASE:2-1-14-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-14")
    end
    # 異常（検索件数が、汎用コードに存在しない値）
    begin
      system_id = nil
      from_datetime = nil
      to_datetime = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>'a'}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-15-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(!notify_action.valid?, "CASE:2-1-15-2")
      # アクセサ
      assert(notify_action.system_id.nil?, "CASE:2-1-15-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-1-15-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-1-15-5")
      assert(notify_action.sort_item == 'system_id', "CASE:2-1-15-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-15-7")
      assert(notify_action.disp_counts == 'a', "CASE:2-1-15-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-15-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 1, "CASE:2-1-15-10")
#      print_log('disp_counts:' + notify_action.error_msg_hash[:disp_counts].to_s)
      assert(notify_action.error_msg_hash[:disp_counts] == '表示件数 は不正な値です。', "CASE:2-1-15-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-15")
    end
    # 異常（システムIDが、マスタに存在しない値）
    begin
      system_id = '100'
      from_datetime = nil
      to_datetime = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-1-16-1")
      # パラメータチェック
#      notify_action.valid?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(!notify_action.valid?, "CASE:2-1-16-2")
      # アクセサ
      assert(notify_action.system_id == '100', "CASE:2-1-16-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-1-16-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-1-16-5")
      assert(notify_action.sort_item == 'system_id', "CASE:2-1-16-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-1-16-7")
      assert(notify_action.disp_counts == 'ALL', "CASE:2-1-16-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-1-16-9")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 1, "CASE:2-1-16-10")
#      print_log('disp_counts:' + notify_action.error_msg_hash[:disp_counts].to_s)
      assert(notify_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-16-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-16")
    end
  end
  
  # 検索処理
  test "2-2:NotifyAction Test:notify?" do
    # 正常（全件検索）
    begin
      updated_at_hash = @rkv_client[:updated_at]
#      print_log('updated_at_hash:' + updated_at_hash.class.name)
#      bef_loaded_at = updated_at_hash[:request_analysis_schedule]
      bef_loaded_at = DateTime.now
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>nil,
                        :from_datetime=>nil,
                        :to_datetime=>nil,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-2-1-1")
      # パラメータチェック
#      notify_action.notify?
#      print_log('error msg:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.notify?, "CASE:2-2-1-2")
      # アクセサ
      assert(notify_action.system_id.nil?, "CASE:2-2-1-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-2-1-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-2-1-5")
      assert(notify_action.sort_item == 'system_id', "CASE:2-2-1-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-2-1-7")
      assert(notify_action.disp_counts == 'ALL', "CASE:2-2-1-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-2-1-9")
      idx = 0
      notify_action.schedule_list.each do |ent|
        idx += 1
        assert(ent.id == idx, "CASE:2-2-1-10")
      end
      # ロード日時更新確認
#      assert(bef_loaded_at.nil?, "CASE:2-2-1-11")
#      print_log('request_analysis_schedule:' + updated_at_hash[:request_analysis_schedule].to_s)
      aft_loaded_at = updated_at_hash[:request_analysis_schedule]
#      print_log('aft_loaded_at:' + aft_loaded_at.to_s)
#      print_log('aft_loaded_at class:' + aft_loaded_at.class.name)
#      assert(!aft_loaded_at.nil?, "CASE:2-2-1-12")
      assert(aft_loaded_at > bef_loaded_at, "CASE:2-2-1-11")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 0, "CASE:2-2-1-12")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    # 正常（対象データの無い検索条件指定、検索結果に影響なし）
    begin
      updated_at_hash = @rkv_client[:updated_at]
#      bef_loaded_at = updated_at_hash[:request_analysis_schedule]
#      print_log('bef_loaded_at:' + bef_loaded_at.to_s)
#      print_log('bef_loaded_at class:' + bef_loaded_at.class.name)
      bef_loaded_at = DateTime.now
      system_id = '1'
      from_datetime = date_time_param(2100, 9, 18, 2, 0, 0)
      to_datetime = date_time_param(2100, 9, 19, 2, 0, 0)
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'gets_start_date',
                        :sort_order=>'DESC',
                        :disp_counts=>'500'}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-2-2-1")
      # パラメータチェック
      assert(notify_action.notify?, "CASE:2-2-2-2")
      # アクセサ
      assert(notify_action.system_id == system_id, "CASE:2-2-2-3")
      assert(notify_action.from_datetime == local_date_time(2100, 9, 18, 2, 0, 0,), "CASE:2-2-2-4")
      assert(notify_action.to_datetime == local_date_time(2100, 9, 19, 2, 0, 0), "CASE:2-2-2-5")
      assert(notify_action.sort_item == 'gets_start_date', "CASE:2-2-2-6")
      assert(notify_action.sort_order == 'DESC', "CASE:2-2-2-7")
      assert(notify_action.disp_counts == '500', "CASE:2-2-2-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      assert(notify_action.schedule_list.size == 7, "CASE:2-2-2-9")
      idx = 0
      notify_action.schedule_list.each do |ent|
        idx += 1
        assert(ent.id == idx, "CASE:2-2-2-10")
      end
      # ロード日時の更新確認
      aft_loaded_at = updated_at_hash[:request_analysis_schedule]
#      print_log('aft_loaded_at:' + aft_loaded_at.to_s)
#      print_log('aft_loaded_at class:' + aft_loaded_at.class.name)
      assert(aft_loaded_at > bef_loaded_at, "CASE:2-2-2-11")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 0, "CASE:2-2-2-12")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    ###########################################################################
    # 異常
    ###########################################################################
    # 異常（システムID異常）
    begin
      system_id = 'a'
      from_datetime = nil
      to_datetime = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'gets_start_date',
                        :sort_order=>'ASC',
                        :disp_counts=>'10'}}
      controller = MockController.new(params)
      notify_action = NotifyAction.new(controller)
      # コンストラクタ生成
      assert(!notify_action.nil?, "CASE:2-2-3-1")
      # パラメータチェック
#      notify_action.notify?
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(!notify_action.notify?, "CASE:2-2-3-2")
      # アクセサ
      assert(notify_action.system_id == system_id, "CASE:2-2-3-3")
      assert(notify_action.from_datetime.nil?, "CASE:2-2-3-4")
      assert(notify_action.to_datetime.nil?, "CASE:2-2-3-5")
      assert(notify_action.sort_item == 'gets_start_date', "CASE:2-2-3-6")
      assert(notify_action.sort_order == 'ASC', "CASE:2-2-3-7")
      assert(notify_action.disp_counts == '10', "CASE:2-2-3-8")
#      print_log('schedule_list:' + notify_action.schedule_list.size.to_s)
      result_list = notify_action.schedule_list
#      print_log('Search Test Begin!!!')
      assert(result_list.size == 7, "CASE:2-2-3-9")
#      print_log('Search Test 1 End!!!')
      idx = 0
      result_list.each do |ent|
        idx += 1
        assert(ent.id == idx, "CASE:2-2-3-10")
      end
      # ロード日時の更新確認
      aft_loaded_at = updated_at_hash[:request_analysis_schedule]
      assert(aft_loaded_at.nil?, "CASE:2-2-3-11")
      # エラーメッセージ
#      print_log('error hash:' + notify_action.error_msg_hash.to_s)
      assert(notify_action.error_msg_hash.size == 1, "CASE:2-2-3-12")
      assert(notify_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-2-3-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-3")
    end
  end
end