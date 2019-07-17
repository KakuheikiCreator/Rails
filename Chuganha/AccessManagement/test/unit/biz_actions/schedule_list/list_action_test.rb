# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：ScheduleList::ScheduleListController
# アクション：list
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/08/20 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/schedule_list/list_action'

class ListActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::ScheduleList
  include Mock
  # 前処理
  def setup
    Time.zone = 3/8
  end
  # 後処理
#  def teardown
#  end
  # バリデーションチェック
  test "2-1:ListAction Test:valid?" do
    # 正常（全件検索）
    begin
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-1-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-1-2")
      # アクセサ
      assert(list_action.system_id.nil?, "CASE:2-1-1-3")
      assert(list_action.from_datetime.nil?, "CASE:2-1-1-4")
      assert(list_action.to_datetime.nil?, "CASE:2-1-1-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-1-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-1-7")
      assert(list_action.disp_counts == 'ALL', "CASE:2-1-1-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-1-9")
      idx = 0
      list_action.schedule_list.each do |ent|
        idx += 1
        assert(ent.id == idx, "CASE:2-1-1-10")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-1-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-2-1")
      # パラメータチェック
      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-2-2")
      # アクセサ
      assert(list_action.system_id == system_id, "CASE:2-1-2-3")
      assert(list_action.from_datetime == local_date_time(2010, 9, 18, 2, 0, 0,), "CASE:2-1-2-4")
      assert(list_action.to_datetime == local_date_time(2010, 9, 19, 2, 0, 0), "CASE:2-1-2-5")
      assert(list_action.sort_item == 'gets_start_date', "CASE:2-1-2-6")
      assert(list_action.sort_order == 'DESC', "CASE:2-1-2-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-2-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 0, "CASE:2-1-2-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-2-10")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-3-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-3-2")
      # アクセサ
#      Rails.logger.debug('system_id:' + regulation_cookie.system_id.to_s)
      assert(list_action.system_id == 'a', "CASE:2-1-3-3")
      assert(list_action.from_datetime.nil?, "CASE:2-1-3-4")
      assert(list_action.to_datetime.nil?, "CASE:2-1-3-5")
      assert(list_action.sort_item == 'gets_start_date', "CASE:2-1-3-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-3-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-3-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-3-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-3-10")
#      print_log('system_id:' + list_action.error_msg_hash[:system_id].to_s)
      assert(list_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-3-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-4-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-4-2")
      # アクセサ
      rcv_from_date = local_date_time(0, 9, 17, 9, 0, 0)
      rcv_to_date = local_date_time(0, 9, 17, 9, 0, 1)
#      print_log('from_datetime:' + list_action.from_datetime.to_s)
      assert(list_action.system_id.nil?, "CASE:2-1-4-3")
      assert(list_action.from_datetime == rcv_from_date, "CASE:2-1-4-4")
      assert(list_action.to_datetime == rcv_to_date, "CASE:2-1-4-5")
      assert(list_action.sort_item == 'gets_start_date', "CASE:2-1-4-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-4-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-4-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 0, "CASE:2-1-4-9")
      # エラーメッセージ
      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-4-10")
#      print_log('cookie:' + list_action.error_msg_hash[:cookie].to_s)
#      assert(list_action.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-4-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-5-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-5-2")
      # アクセサ
#      rcv_from_date = local_date_time(2010, 9, 17, 9, 0, 0)
#      rcv_to_date = local_date_time(2020, 9, 17, 9, 0, 1)
#      print_log('from_datetime:' + list_action.from_datetime.to_s)
      assert(list_action.system_id.nil?, "CASE:2-1-5-3")
      assert(list_action.from_datetime.nil?, "CASE:2-1-5-4")
      assert(list_action.to_datetime.nil?, "CASE:2-1-5-5")
      assert(list_action.sort_item == 'gets_start_date', "CASE:2-1-5-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-5-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-5-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-5-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-5-10")
#      print_log('cookie:' + list_action.error_msg_hash[:cookie].to_s)
#      assert(list_action.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-4-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-6-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-6-2")
      # アクセサ
#      rcv_from_date = local_date_time(2010, 9, 17, 9, 0, 0)
#      rcv_to_date = local_date_time(2020, 9, 17, 9, 0, 1)
#      print_log('from_datetime:' + list_action.from_datetime.to_s)
      assert(list_action.system_id.nil?, "CASE:2-1-6-3")
      assert(list_action.from_datetime.nil?, "CASE:2-1-6-4")
      assert(list_action.to_datetime.nil?, "CASE:2-1-6-5")
      assert(list_action.sort_item == 'gets_start_date', "CASE:2-1-6-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-6-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-6-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-6-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-6-10")
#      print_log('cookie:' + list_action.error_msg_hash[:cookie].to_s)
#      assert(list_action.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-4-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-7-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-7-2")
      # アクセサ
      rcv_from_date = local_date_time(2010, 1, 1, 0, 0, 0)
#      rcv_to_date = local_date_time(2020, 1, 1, 0, 0, 1)
#      print_log('to_datetime:' + list_action.to_datetime.to_s)
      assert(list_action.system_id.nil?, "CASE:2-1-7-3")
      assert(list_action.from_datetime == rcv_from_date, "CASE:2-1-7-4")
      assert(list_action.to_datetime.nil?, "CASE:2-1-7-5")
      assert(list_action.sort_item == 'gets_start_date', "CASE:2-1-7-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-7-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-7-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-7-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-7-10")
#      print_log('cookie:' + list_action.error_msg_hash[:cookie].to_s)
#      assert(list_action.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-4-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-8-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-8-2")
      # アクセサ
#      rcv_from_date = local_date_time(2010, 1, 1, 0, 0, 0)
      rcv_to_date = local_date_time(2020, 1, 1, 0, 0, 1)
#      print_log('from_datetime:' + list_action.from_datetime.to_s)
      assert(list_action.system_id.nil?, "CASE:2-1-8-3")
      assert(list_action.from_datetime.nil?, "CASE:2-1-8-4")
      assert(list_action.to_datetime == rcv_to_date, "CASE:2-1-8-5")
      assert(list_action.sort_item == 'gets_start_date', "CASE:2-1-8-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-8-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-8-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-8-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-8-10")
#      print_log('cookie:' + list_action.error_msg_hash[:cookie].to_s)
#      assert(list_action.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-4-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-9-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-9-2")
      # アクセサ
      rcv_from_date = local_date_time(2010, 1, 1, 0, 0, 0)
#      rcv_to_date = local_date_time(2020, 1, 1, 0, 1, 0)
#      print_log('from_datetime:' + list_action.from_datetime.to_s)
      assert(list_action.system_id.nil?, "CASE:2-1-9-3")
      assert(list_action.from_datetime == rcv_from_date, "CASE:2-1-9-4")
      assert(list_action.to_datetime.nil?, "CASE:2-1-9-5")
      assert(list_action.sort_item == 'gets_start_date', "CASE:2-1-9-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-9-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-9-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-9-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-9-10")
#      print_log('cookie:' + list_action.error_msg_hash[:cookie].to_s)
#      assert(list_action.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-4-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-10-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-10-2")
      # アクセサ
      rcv_from_date = local_date_time(2010, 1, 1, 0, 0, 0)
      rcv_to_date = local_date_time(2010, 1, 1, 0, 0, 0)
#      print_log('from_datetime:' + list_action.from_datetime.to_s)
      assert(list_action.system_id.nil?, "CASE:2-1-10-3")
      assert(list_action.from_datetime == rcv_from_date, "CASE:2-1-10-4")
      assert(list_action.to_datetime == rcv_to_date, "CASE:2-1-10-5")
      assert(list_action.sort_item == 'gets_start_date', "CASE:2-1-10-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-10-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-10-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-10-9")
      # エラーメッセージ
      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-10-10")
#      print_log('gets_start_date:' + list_action.error_msg_hash[:gets_start_date].to_s)
      assert(list_action.error_msg_hash[:gets_start_date] == '取得開始日時 は不正な値です。', "CASE:2-1-4-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-11-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-11-2")
      # アクセサ
      assert(list_action.system_id.nil?, "CASE:2-1-11-3")
      assert(list_action.from_datetime.nil?, "CASE:2-1-11-4")
      assert(list_action.to_datetime.nil?, "CASE:2-1-11-5")
      assert(list_action.sort_item == '', "CASE:2-1-11-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-11-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-11-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-11-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-11-10")
#      print_log('sort_cond:' + list_action.error_msg_hash[:sort_cond].to_s)
      assert(list_action.error_msg_hash[:sort_cond] == '検索結果並び順 を入力してください。', "CASE:2-1-11-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-12-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-12-2")
      # アクセサ
      assert(list_action.system_id.nil?, "CASE:2-1-12-3")
      assert(list_action.from_datetime.nil?, "CASE:2-1-12-4")
      assert(list_action.to_datetime.nil?, "CASE:2-1-12-5")
      assert(list_action.sort_item == 'err_system_id', "CASE:2-1-12-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-12-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-12-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-12-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-12-10")
#      print_log('sort_cond:' + list_action.error_msg_hash[:sort_cond].to_s)
      assert(list_action.error_msg_hash[:sort_cond] == '検索結果並び順 は不正な値です。', "CASE:2-1-12-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-13-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-13-2")
      # アクセサ
      assert(list_action.system_id.nil?, "CASE:2-1-13-3")
      assert(list_action.from_datetime.nil?, "CASE:2-1-13-4")
      assert(list_action.to_datetime.nil?, "CASE:2-1-13-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-13-6")
      assert(list_action.sort_order == 'ADSC', "CASE:2-1-13-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-13-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-13-9")
      # エラーメッセージ
      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-13-10")
#      print_log('remarks:' + list_action.error_msg_hash[:remarks].to_s)
      assert(list_action.error_msg_hash[:sort_cond] == '検索結果並び順 は不正な値です。', "CASE:2-1-13-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-14-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-14-2")
      # アクセサ
      assert(list_action.system_id.nil?, "CASE:2-1-14-3")
      assert(list_action.from_datetime.nil?, "CASE:2-1-14-4")
      assert(list_action.to_datetime.nil?, "CASE:2-1-14-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-14-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-14-7")
      assert(list_action.disp_counts == '', "CASE:2-1-14-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-14-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-14-10")
#      print_log('disp_counts:' + list_action.error_msg_hash[:disp_counts].to_s)
      assert(list_action.error_msg_hash[:disp_counts] == '表示件数 を入力してください。', "CASE:2-1-14-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-15-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-15-2")
      # アクセサ
      assert(list_action.system_id.nil?, "CASE:2-1-15-3")
      assert(list_action.from_datetime.nil?, "CASE:2-1-15-4")
      assert(list_action.to_datetime.nil?, "CASE:2-1-15-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-15-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-15-7")
      assert(list_action.disp_counts == 'a', "CASE:2-1-15-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-15-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-15-10")
#      print_log('disp_counts:' + list_action.error_msg_hash[:disp_counts].to_s)
      assert(list_action.error_msg_hash[:disp_counts] == '表示件数 は不正な値です。', "CASE:2-1-15-11")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-16-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-1-16-2")
      # アクセサ
      assert(list_action.system_id == '100', "CASE:2-1-16-3")
      assert(list_action.from_datetime.nil?, "CASE:2-1-16-4")
      assert(list_action.to_datetime.nil?, "CASE:2-1-16-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-16-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-16-7")
      assert(list_action.disp_counts == 'ALL', "CASE:2-1-16-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-1-16-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-16-10")
#      print_log('disp_counts:' + list_action.error_msg_hash[:disp_counts].to_s)
      assert(list_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-16-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-16")
    end
  end
  
  # 検索処理
  test "2-2:ListAction Test:schedule_list" do
    # 正常（全件検索）
    begin
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-1-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-2-1-2")
      # アクセサ
      assert(list_action.system_id.nil?, "CASE:2-2-1-3")
      assert(list_action.from_datetime.nil?, "CASE:2-2-1-4")
      assert(list_action.to_datetime.nil?, "CASE:2-2-1-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-2-1-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-2-1-7")
      assert(list_action.disp_counts == 'ALL', "CASE:2-2-1-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 7, "CASE:2-2-1-9")
      idx = 0
      list_action.schedule_list.each do |ent|
        idx += 1
        assert(ent.id == idx, "CASE:2-2-1-10")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-2-1")
      # パラメータチェック
      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-2-2-2")
      # アクセサ
      assert(list_action.system_id == system_id, "CASE:2-2-2-3")
      assert(list_action.from_datetime == local_date_time(2010, 9, 18, 2, 0, 0,), "CASE:2-2-2-4")
      assert(list_action.to_datetime == local_date_time(2010, 9, 19, 2, 0, 0), "CASE:2-2-2-5")
      assert(list_action.sort_item == 'gets_start_date', "CASE:2-2-2-6")
      assert(list_action.sort_order == 'DESC', "CASE:2-2-2-7")
      assert(list_action.disp_counts == '500', "CASE:2-2-2-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      assert(list_action.schedule_list.size == 0, "CASE:2-2-2-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-2-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    # 正常（検索条件：システムID）
    begin
      system_id = '1'
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-3-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-2-3-2")
      # アクセサ
      assert(list_action.system_id == system_id, "CASE:2-2-3-3")
      assert(list_action.from_datetime.nil?, "CASE:2-2-3-4")
      assert(list_action.to_datetime.nil?, "CASE:2-2-3-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-2-3-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-2-3-7")
      assert(list_action.disp_counts == 'ALL', "CASE:2-2-3-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      schedule_list = list_action.schedule_list
      assert(schedule_list.size == 6, "CASE:2-2-3-9")
      schedule_list.each do |ent|
        assert(ent.system_id == 1, "CASE:2-2-3-10")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-3-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-3")
    end
    # 正常（検索条件：取得開始日時（from））
    begin
      system_id = nil
      from_datetime = date_time_param(2012, 1, 4, 9, 0, 0)
      to_datetime = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'gets_start_date',
                        :sort_order=>'ASC',
                        :disp_counts=>'100'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-4-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-2-4-2")
      # アクセサ
      rcv_from_date = local_date_time(2012, 1, 4, 9, 0, 0)
      assert(list_action.system_id.nil?, "CASE:2-2-4-3")
      assert(list_action.from_datetime == rcv_from_date, "CASE:2-2-4-4")
      assert(list_action.to_datetime.nil?, "CASE:2-2-4-5")
      assert(list_action.sort_item == 'gets_start_date', "CASE:2-2-4-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-2-4-7")
      assert(list_action.disp_counts == '100', "CASE:2-2-4-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      schedule_list = list_action.schedule_list
      assert(schedule_list.size == 2, "CASE:2-2-4-9")
      schedule_list.each do |ent|
        assert(ent.gets_start_date >= rcv_from_date, "CASE:2-2-4-10")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-4-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-4")
    end
    # 正常（検索条件：取得開始日時（to））
    begin
      system_id = nil
      from_datetime = nil
      to_datetime = date_time_param(2011, 9, 17, 9, 0, 0)
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-5-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-2-5-2")
      # アクセサ
      rcv_to_date = local_date_time(2011, 9, 17, 9, 0, 0)
#      print_log('to_datetime:' + list_action.to_datetime.to_s)
      assert(list_action.system_id.nil?, "CASE:2-2-5-3")
      assert(list_action.from_datetime.nil?, "CASE:2-2-5-4")
      assert(list_action.to_datetime == rcv_to_date, "CASE:2-2-5-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-2-5-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-2-5-7")
      assert(list_action.disp_counts == 'ALL', "CASE:2-2-5-8")
      schedule_list = list_action.schedule_list
#      print_log('schedule_list:' + schedule_list.size.to_s)
      assert(schedule_list.size == 5, "CASE:2-2-5-9")
      schedule_list.each do |ent|
        assert(ent.gets_start_date <= rcv_to_date, "CASE:2-2-5-10")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-5-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-5")
    end
    # 正常（検索条件：取得開始日時（from,to））
    begin
      system_id = nil
      from_datetime = date_time_param(2011, 9, 8, 2, 0, 1)
      to_datetime = date_time_param(2011, 9, 8, 2, 0, 2)
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'gets_start_date',
                        :sort_order=>'ASC',
                        :disp_counts=>'100'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-6-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-2-6-2")
      # アクセサ
      rcv_from_date = local_date_time(2011, 9, 8, 2, 0, 1)
      rcv_to_date = local_date_time(2011, 9, 8, 2, 0, 2)
      assert(list_action.system_id.nil?, "CASE:2-2-6-3")
      assert(list_action.from_datetime == rcv_from_date, "CASE:2-2-6-4")
      assert(list_action.to_datetime == rcv_to_date, "CASE:2-2-6-5")
      assert(list_action.sort_item == 'gets_start_date', "CASE:2-2-6-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-2-6-7")
      assert(list_action.disp_counts == '100', "CASE:2-2-6-8")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      schedule_list = list_action.schedule_list
      assert(schedule_list.size == 2, "CASE:2-2-6-9")
      schedule_list.each do |ent|
        assert(ent.gets_start_date >= rcv_from_date, "CASE:2-2-6-10")
        assert(ent.gets_start_date <= rcv_to_date, "CASE:2-2-6-10")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-6-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-6")
    end
    # 正常（ソート条件：システムID 昇順）
    begin
      system_id = nil
      from_datetime = date_time_param(2012, 1, 1, 0, 0, 0)
      to_datetime = date_time_param(2012, 1, 5, 0, 0, 0)
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-7-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-2-7-2")
#      print_log('schedule_list:' + list_action.to_s)
      result_list = list_action.schedule_list
#      print_log('Search Test Begin!!!')
      assert(result_list.size == 2, "CASE:2-2-7-3")
#      print_log('Search Test 1 End!!!')
      assert(result_list[0].id == 6, "CASE:2-2-7-4")
      assert(result_list[0].system_id == 1, "CASE:2-2-7-5")
#      print_log('Search Test 2 End!!!')
      assert(result_list[1].id == 7, "CASE:2-2-7-4")
      assert(result_list[1].system_id == 2, "CASE:2-2-7-5")
#      print_log('Search Test 5 End!!!')
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-7-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-7")
    end
    # 正常（ソート条件：取得開始日時降順）
    begin
      system_id = nil
      from_datetime = date_time_param(2011, 9, 8, 2, 0, 0)
      to_datetime = date_time_param(2011, 9, 8, 2, 0, 3)
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'gets_start_date',
                        :sort_order=>'DESC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-8-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-2-8-2")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      result_list = list_action.schedule_list
#      print_log('Search Test Begin!!!')
      assert(result_list.size == 4, "CASE:2-2-8-3")
#      print_log('Search Test 1 End!!!')
      assert(result_list[0].id == 4, "CASE:2-2-8-4")
      assert(result_list[0].system_id == 1, "CASE:2-2-8-5")
      assert(result_list[0].gets_start_date == local_date_time(2011, 9, 8, 2, 0, 3), "CASE:2-2-8-6")
#      print_log('Search Test 2 End!!!')
      assert(result_list[1].id == 3, "CASE:2-2-8-4")
      assert(result_list[1].system_id == 1, "CASE:2-2-8-5")
      assert(result_list[1].gets_start_date == local_date_time(2011, 9, 8, 2, 0, 2), "CASE:2-2-8-6")
#      print_log('Search Test 3 End!!!')
      assert(result_list[2].id == 2, "CASE:2-2-8-4")
      assert(result_list[2].system_id == 1, "CASE:2-2-8-5")
      assert(result_list[2].gets_start_date == local_date_time(2011, 9, 8, 2, 0, 1), "CASE:2-2-8-6")
#      print_log('Search Test 4 End!!!')
      assert(result_list[3].id == 1, "CASE:2-2-8-4")
      assert(result_list[3].system_id == 1, "CASE:2-2-8-5")
      assert(result_list[3].gets_start_date == local_date_time(2011, 9, 8, 2, 0, 0), "CASE:2-2-8-6")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-8-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-8")
    end
    # テストデータ更新
    ActiveRecord::Base.transaction do
      RequestAnalysisSchedule.delete_all
      20.times do |i|
        ent = RequestAnalysisSchedule.new
        ent.system_id = 1
        ent.gets_start_date = local_date_time(2010, 1, 1, i, 0, 0)
        ent.save!
#        print_log('cookie :' + ent.cookie)
#        print_log('remarks:' + ent.remarks)
      end
    end
    # 正常（取得開始日時　昇順、検索結果件数）
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
                        :sort_item=>'gets_start_date',
                        :sort_order=>'ASC',
                        :disp_counts=>'10'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-9-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.search_list, "CASE:2-2-9-2")
#      print_log('schedule_list:' + list_action.schedule_list.size.to_s)
      result_list = list_action.schedule_list
#      print_log('Search Test Begin!!!')
      assert(result_list.size == 10, "CASE:2-2-9-3")
#      print_log('Search Test 1 End!!!')
      result_list.size.times do |i|
#        print_log('remarks:' + result_list[idx].remarks)
        assert(result_list[i].system_id == 1, "CASE:2-2-9-4")
        assert(result_list[i].gets_start_date == local_date_time(2010, 1, 1, i, 0, 0), "CASE:2-2-9-5")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-9-7")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-9")
    end
  end
end