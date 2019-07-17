# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：ScheduleList::ScheduleListController
# アクション：create
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/08/21 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/schedule_list/delete_action'

class DeleteActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::ScheduleList
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
    # テストデータ追加
    ActiveRecord::Base.transaction do
      50.times do |i|
        ent = RequestAnalysisSchedule.new
        ent.system_id = 1
        ent.gets_start_date = local_date_time(2020, 1, 1, 0, 0, i)
        ent.save!
      end
    end
    # 正常（全項目入力）
    begin
      system_id = '1'
      from_datetime = date_time_param(2020, 1, 1, 0, 0, 0)
      to_datetime = date_time_param(2020, 1, 1, 0, 0, 1)
      delete_id = RequestAnalysisSchedule.maximum(:id).to_s
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      # コンストラクタ生成
      delete_action = DeleteAction.new(controller)
      assert(!delete_action.nil?, "CASE:2-1-1-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.valid?, "CASE:2-1-1-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-1-3")
      assert(delete_action.from_datetime == local_date_time(2020, 1, 1, 0, 0, 0), "CASE:2-1-1-4")
      assert(delete_action.to_datetime == local_date_time(2020, 1, 1, 0, 0, 1), "CASE:2-1-1-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-1-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-1-7")
      assert(delete_action.disp_counts == 'ALL', "CASE:2-1-1-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-1-1-9")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 正常（delete_id,To未入力、デフォルト以外の検索条件）
    begin
      system_id = '1'
      from_datetime = date_time_param(2020, 1, 1, 0, 0, 0)
      to_datetime = nil
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
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-2-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.valid?, "CASE:2-1-2-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-2-3")
      assert(delete_action.from_datetime == local_date_time(2020, 1, 1, 0, 0, 0), "CASE:2-1-2-4")
      assert(delete_action.to_datetime.nil?, "CASE:2-1-2-5")
      assert(delete_action.sort_item == 'gets_start_date', "CASE:2-1-2-6")
      assert(delete_action.sort_order == 'DESC', "CASE:2-1-2-7")
      assert(delete_action.disp_counts == '500', "CASE:2-1-2-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-1-2-9")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # 正常（delete_id,From未入力、デフォルト以外の検索条件）
    begin
      system_id = '1'
      from_datetime = nil
      to_datetime = date_time_param(2020, 1, 1, 0, 0, 0)
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
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-3-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.valid?, "CASE:2-1-3-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-3-3")
      assert(delete_action.from_datetime.nil?, "CASE:2-1-3-4")
      assert(delete_action.to_datetime == local_date_time(2020, 1, 1, 0, 0, 0), "CASE:2-1-3-5")
      assert(delete_action.sort_item == 'gets_start_date', "CASE:2-1-3-6")
      assert(delete_action.sort_order == 'DESC', "CASE:2-1-3-7")
      assert(delete_action.disp_counts == '500', "CASE:2-1-3-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-1-3-9")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # 正常（delete_id未入力）
    begin
      system_id = '1'
      from_datetime = date_time_param(2020, 1, 1, 0, 0, 0)
      to_datetime = date_time_param(2020, 1, 1, 0, 0, 1)
      delete_id = nil
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      # コンストラクタ生成
      delete_action = DeleteAction.new(controller)
      assert(!delete_action.nil?, "CASE:2-1-4-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.valid?, "CASE:2-1-4-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-4-3")
      assert(delete_action.from_datetime == local_date_time(2020, 1, 1, 0, 0, 0), "CASE:2-1-4-4")
      assert(delete_action.to_datetime == local_date_time(2020, 1, 1, 0, 0, 1), "CASE:2-1-4-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-4-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-4-7")
      assert(delete_action.disp_counts == 'ALL', "CASE:2-1-4-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-1-4-9")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
    ###########################################################################
    # 単項目チェック
    ###########################################################################
    # 異常（削除条件未入力）
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
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-5-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-5-2")
      # アクセサ
      assert(delete_action.system_id.nil?, "CASE:2-1-5-3")
      assert(delete_action.from_datetime.nil?, "CASE:2-1-5-4")
      assert(delete_action.to_datetime.nil?, "CASE:2-1-5-5")
      assert(delete_action.sort_item == 'gets_start_date', "CASE:2-1-5-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-5-7")
      assert(delete_action.disp_counts == '500', "CASE:2-1-5-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-5-9")
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-5-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-5")
    end
    # 異常（削除ID属性異常）
    begin
      system_id = '1'
      from_datetime = date_time_param(2015, 9, 18, 2, 0, 0)
      to_datetime = nil
      delete_id = 'a'
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-6-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-6-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-6-3")
      assert(delete_action.from_datetime == local_date_time(2015, 9, 18, 2, 0, 0), "CASE:2-1-6-4")
      assert(delete_action.to_datetime.nil?, "CASE:2-1-6-5")
      assert(delete_action.sort_item == 'gets_start_date', "CASE:2-1-6-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-6-7")
      assert(delete_action.disp_counts == '500', "CASE:2-1-6-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-6-9")
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-5-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-6")
    end
    ###########################################################################
    # 異常（ソート項目未入力）
    begin
      system_id = '1'
      from_datetime = date_time_param(2015, 8, 22, 9, 30, 0)
      to_datetime = nil
      delete_id = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>'',
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-7-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-7-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-7-3")
      assert(delete_action.from_datetime == local_date_time(2015, 8, 22, 9, 30, 0), "CASE:2-1-7-4")
      assert(delete_action.to_datetime.nil?, "CASE:2-1-7-5")
      assert(delete_action.sort_item == '', "CASE:2-1-7-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-7-7")
      assert(delete_action.disp_counts == '500', "CASE:2-1-7-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-7-9")
#      print_log('sort_cond:' + delete_action.error_msg_hash[:sort_cond].to_s)
      assert(delete_action.error_msg_hash[:sort_cond] == '検索結果並び順 を入力してください。', "CASE:2-1-7-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-7")
    end
    # 異常（ソート項目が存在しない項目名）
    begin
      system_id = '1'
      from_datetime = date_time_param(2015, 8, 22, 9, 30, 0)
      to_datetime = nil
      delete_id = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>'err_system_id',
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-8-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-8-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-8-3")
      assert(delete_action.from_datetime == local_date_time(2015, 8, 22, 9, 30, 0), "CASE:2-1-8-4")
      assert(delete_action.to_datetime.nil?, "CASE:2-1-8-5")
      assert(delete_action.sort_item == 'err_system_id', "CASE:2-1-8-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-8-7")
      assert(delete_action.disp_counts == '500', "CASE:2-1-8-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-8-9")
#      print_log('sort_cond:' + delete_action.error_msg_hash[:sort_cond].to_s)
      assert(delete_action.error_msg_hash[:sort_cond] == '検索結果並び順 は不正な値です。', "CASE:2-1-8-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-8")
    end
    # 異常（検索件数が空文字）
    begin
      system_id = '1'
      from_datetime = date_time_param(2015, 8, 22, 9, 30, 0)
      to_datetime = nil
      delete_id = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>''}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-9-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-9-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-9-3")
      assert(delete_action.from_datetime == local_date_time(2015, 8, 22, 9, 30, 0), "CASE:2-1-9-4")
      assert(delete_action.to_datetime.nil?, "CASE:2-1-9-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-9-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-9-7")
      assert(delete_action.disp_counts == '', "CASE:2-1-9-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-9-9")
#      print_log('disp_counts:' + delete_action.error_msg_hash[:disp_counts].to_s)
      assert(delete_action.error_msg_hash[:disp_counts] == '表示件数 を入力してください。', "CASE:2-1-9-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-9")
    end
    # 異常（検索件数が、汎用コードに存在しない値）
    begin
      system_id = '1'
      from_datetime = date_time_param(2015, 8, 22, 9, 30, 0)
      to_datetime = nil
      delete_id = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>'a'}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-10-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-10-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-10-3")
      assert(delete_action.from_datetime == local_date_time(2015, 8, 22, 9, 30, 0), "CASE:2-1-10-4")
      assert(delete_action.to_datetime.nil?, "CASE:2-1-10-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-10-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-10-7")
      assert(delete_action.disp_counts == 'a', "CASE:2-1-10-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-10-9")
#      print_log('disp_counts:' + delete_action.error_msg_hash[:disp_counts].to_s)
      assert(delete_action.error_msg_hash[:disp_counts] == '表示件数 は不正な値です。', "CASE:2-1-10-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-10")
    end
    ###########################################################################
    # 項目関連チェック
    ###########################################################################
    # 異常（取得開始日時のToがFrom以下）
    begin
      system_id = '1'
      from_datetime = date_time_param(2015, 8, 22, 9, 30, 0)
      to_datetime = date_time_param(2015, 8, 22, 9, 30, 0)
      delete_id = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-11-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-11-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-11-3")
      assert(delete_action.from_datetime == local_date_time(2015, 8, 22, 9, 30, 0), "CASE:2-1-11-4")
      assert(delete_action.to_datetime == local_date_time(2015, 8, 22, 9, 30, 0), "CASE:2-1-11-5")
      assert(delete_action.sort_item == 'gets_start_date', "CASE:2-1-11-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-11-7")
      assert(delete_action.disp_counts == '500', "CASE:2-1-11-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-11-9")
#      print_log('cookie:' + delete_action.error_msg_hash[:cookie].to_s)
      assert(delete_action.error_msg_hash[:gets_start_date] == '取得開始日時 は不正な値です。', "CASE:2-1-11-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-11")
    end
    ###########################################################################
    # DB関連チェック
    ###########################################################################
    # 異常（削除IDが、マスタに存在しない値）
    begin
      system_id = '1'
      from_datetime = date_time_param(2015, 8, 22, 9, 30, 0)
      to_datetime = nil
      delete_id = '10000'
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-12-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-12-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-12-3")
      assert(delete_action.from_datetime == local_date_time(2015, 8, 22, 9, 30, 0), "CASE:2-1-12-4")
      assert(delete_action.to_datetime.nil?, "CASE:2-1-12-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-12-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-12-7")
      assert(delete_action.disp_counts == 'ALL', "CASE:2-1-12-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-12-9")
#      print_log('disp_counts:' + delete_action.error_msg_hash[:disp_counts].to_s)
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-12-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-12")
    end
    # 異常（From,削除対象データが、マスタに存在しない値）
    begin
      system_id = '1'
      from_datetime = date_time_param(2099, 8, 22, 9, 30, 0)
      to_datetime = nil
      delete_id = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-13-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-13-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-13-3")
      assert(delete_action.from_datetime == local_date_time(2099, 8, 22, 9, 30, 0), "CASE:2-1-13-4")
      assert(delete_action.to_datetime.nil?, "CASE:2-1-13-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-13-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-13-7")
      assert(delete_action.disp_counts == 'ALL', "CASE:2-1-13-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-13-9")
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-13-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-13")
    end
    # 異常（To,削除対象データが、マスタに存在しない値）
    begin
      system_id = '1'
      from_datetime = nil
      to_datetime = date_time_param(2000, 8, 22, 9, 30, 0)
      delete_id = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-14-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-14-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-14-3")
      assert(delete_action.from_datetime.nil?, "CASE:2-1-14-4")
      assert(delete_action.to_datetime == local_date_time(2000, 8, 22, 9, 30, 0), "CASE:2-1-14-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-14-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-14-7")
      assert(delete_action.disp_counts == 'ALL', "CASE:2-1-14-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-14-9")
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-14-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-14")
    end
    # 異常（From,To,削除対象データが、マスタに存在しない値）
    begin
      system_id = '1'
      from_datetime = date_time_param(2099, 8, 22, 9, 30, 0)
      to_datetime = date_time_param(2100, 8, 22, 9, 30, 0)
      delete_id = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-1-15-1")
      # パラメータチェック
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.valid?, "CASE:2-1-15-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-1-15-3")
      assert(delete_action.from_datetime == local_date_time(2099, 8, 22, 9, 30, 0), "CASE:2-1-15-4")
      assert(delete_action.to_datetime == local_date_time(2100, 8, 22, 9, 30, 0), "CASE:2-1-15-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-1-15-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-1-15-7")
      assert(delete_action.disp_counts == 'ALL', "CASE:2-1-15-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-1-15-9")
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-15-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-15")
    end
  end
  
  # 削除処理
  test "2-2:DeleteAction Test:delete_data?" do
    # テストデータ追加
    ActiveRecord::Base.transaction do
      40.times do |i|
        ent = RequestAnalysisSchedule.new
        ent.system_id = 1
        ent.gets_start_date = local_date_time(2020, 1, 1, 0, 0, i)
        ent.save!
#        print_log('sec:' + i.to_s)
      end
    end
    ActiveRecord::Base.transaction do
      10.times do |i|
        ent = RequestAnalysisSchedule.new
        ent.system_id = 2
        ent.gets_start_date = local_date_time(2020, 1, 1, 0, 0, i+40)
        ent.save!
#        print_log('sec:' + i.to_s)
      end
    end
    # 正常（システムID、Fromのみ入力）
    begin
      system_id = '1'
      from_datetime = date_time_param(2020, 1, 1, 0, 0, 30)
      to_datetime = nil
      delete_id = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      assert(RequestAnalysisSchedule.find(:all).count == 57, "CASE:2-2-1-1")
      # コンストラクタ生成
      delete_action = DeleteAction.new(controller)
      assert(!delete_action.nil?, "CASE:2-2-1-2")
      # 永続化処理
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.delete_data?, "CASE:2-2-1-3")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-2-1-4")
      assert(delete_action.from_datetime == local_date_time(2020, 1, 1, 0, 0, 30), "CASE:2-2-1-5")
      assert(delete_action.to_datetime.nil?, "CASE:2-2-1-6")
      assert(delete_action.sort_item == 'system_id', "CASE:2-2-1-7")
      assert(delete_action.sort_order == 'ASC', "CASE:2-2-1-8")
      assert(delete_action.disp_counts == 'ALL', "CASE:2-2-1-9")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-2-1-10")
      # データ確認
      delete_data = RequestAnalysisSchedule.where(:system_id=>system_id.to_i)
      delete_data = delete_data.where("gets_start_date >= ?", local_date_time(2020, 1, 1, 0, 0, 30))
      assert(delete_data.size == 0, "CASE:2-2-1-11")
      assert(RequestAnalysisSchedule.find(:all).count == 47, "CASE:2-2-1-12")
      # 検索結果確認
      schedule_list = delete_action.schedule_list
#      print_log('schedule_list size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 47, "CASE:2-2-1-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    # 正常（システムID、Toのみ入力）
    begin
      system_id = '1'
      from_datetime = nil
      to_datetime = date_time_param(2019, 12, 31, 23, 59, 59)
      delete_id = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>nil,
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      assert(RequestAnalysisSchedule.find(:all).count == 47, "CASE:2-2-2-1")
      # コンストラクタ生成
      delete_action = DeleteAction.new(controller)
      assert(!delete_action.nil?, "CASE:2-2-2-2")
      # 永続化処理
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.delete_data?, "CASE:2-2-2-3")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-2-2-4")
      assert(delete_action.from_datetime.nil?, "CASE:2-2-2-5")
      assert(delete_action.to_datetime == local_date_time(2019, 12, 31, 23, 59, 59), "CASE:2-2-2-6")
      assert(delete_action.sort_item == 'gets_start_date', "CASE:2-2-2-7")
      assert(delete_action.sort_order == 'ASC', "CASE:2-2-2-8")
      assert(delete_action.disp_counts == 'ALL', "CASE:2-2-2-9")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-2-2-10")
      # データ確認
      delete_data = RequestAnalysisSchedule.where(:system_id=>system_id.to_i)
      delete_data = delete_data.where("gets_start_date <= ?", local_date_time(2019, 12, 31, 23, 59, 59))
      assert(delete_data.size == 0, "CASE:2-2-2-11")
#      print_log('Count:' + RequestAnalysisSchedule.where("gets_start_date >= ?", local_date_time(2020, 1, 1, 0, 0, 0)).count.to_s)
#      list = RequestAnalysisSchedule.find(:all)
#      print_log('All Count:' + list.count.to_s)
#      list.each do |ent|
#        print_log('id:' + ent.id.to_s)
#      end
      assert(RequestAnalysisSchedule.find(:all).count == 41, "CASE:2-2-2-12")
      # 検索結果確認
      schedule_list = delete_action.schedule_list
#      print_log('schedule_list size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 41, "CASE:2-2-2-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    # 正常（SystemID,From,Toのみ入力）
    begin
      system_id = '1'
      from_datetime = date_time_param(2020, 1, 1, 0, 0, 28)
      to_datetime = date_time_param(2020, 1, 1, 0, 0, 52)
      delete_id = nil
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>nil,
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      assert(RequestAnalysisSchedule.find(:all).count == 41, "CASE:2-2-3-1")
      # コンストラクタ生成
      delete_action = DeleteAction.new(controller)
      assert(!delete_action.nil?, "CASE:2-2-3-2")
      # 永続化処理
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.delete_data?, "CASE:2-2-3-3")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-2-3-4")
      assert(delete_action.from_datetime == local_date_time(2020, 1, 1, 0, 0, 28), "CASE:2-2-3-5")
      assert(delete_action.to_datetime == local_date_time(2020, 1, 1, 0, 0, 52), "CASE:2-2-3-6")
      assert(delete_action.sort_item == 'gets_start_date', "CASE:2-2-3-7")
      assert(delete_action.sort_order == 'ASC', "CASE:2-2-3-8")
      assert(delete_action.disp_counts == 'ALL', "CASE:2-2-3-9")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-2-3-10")
      # データ確認
      delete_data = RequestAnalysisSchedule.where(:system_id=>system_id.to_i)
      delete_data = delete_data.where("gets_start_date >= ?", local_date_time(2020, 1, 1, 0, 0, 28))
      delete_data = delete_data.where("gets_start_date <= ?", local_date_time(2020, 1, 1, 0, 0, 52))
      assert(delete_data.size == 0, "CASE:2-2-3-11")
#      print_log('Count:' + RequestAnalysisSchedule.where("gets_start_date >= ?", local_date_time(2020, 1, 1, 0, 0, 0)).count.to_s)
#      list = RequestAnalysisSchedule.find(:all)
#      print_log('All Count:' + list.count.to_s)
#      list.each do |ent|
#        print_log('id:' + ent.id.to_s)
#      end
      assert(RequestAnalysisSchedule.find(:all).count == 39, "CASE:2-2-3-12")
      # 検索結果確認
      schedule_list = delete_action.schedule_list
#      print_log('schedule_list size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 39, "CASE:2-2-3-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-3")
    end
    # 正常（delete_idのみを入力）
    begin
      system_id = nil
      from_datetime = nil
      to_datetime = nil
      delete_id = RequestAnalysisSchedule.maximum(:id).to_s
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      # コンストラクタ生成
      delete_action = DeleteAction.new(controller)
      assert(!delete_action.nil?, "CASE:2-2-4-1")
      # 永続化処理
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.delete_data?, "CASE:2-2-4-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-2-4-3")
      assert(delete_action.from_datetime.nil?, "CASE:2-2-4-4")
      assert(delete_action.to_datetime.nil?, "CASE:2-2-4-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-2-4-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-2-4-7")
      assert(delete_action.disp_counts == 'ALL', "CASE:2-2-4-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-2-4-9")
      # データ確認
      assert(RequestAnalysisSchedule.where(:id=>delete_id.to_i).count == 0, "CASE:2-2-4-10")
      assert(RequestAnalysisSchedule.find(:all).count == 38, "CASE:2-2-4-11")
      # 検索結果確認
      schedule_list = delete_action.schedule_list
#      print_log('schedule_list size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 38, "CASE:2-2-4-12")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-4")
    end
    # 正常（全項目入力）
    begin
      system_id = '1'
      from_datetime = date_time_param(2000, 1, 1, 0, 0, 0)
      to_datetime = date_time_param(2021, 1, 1, 0, 0, 0)
      delete_id = RequestAnalysisSchedule.maximum(:id).to_s
      params={:controller_name => 'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :delete_id=>delete_id,
                        :sort_item=>nil,
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      assert(RequestAnalysisSchedule.find(:all).count == 38, "CASE:2-2-5-1")
      # コンストラクタ生成
      delete_action = DeleteAction.new(controller)
      assert(!delete_action.nil?, "CASE:2-2-5-2")
      # 永続化処理
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.delete_data?, "CASE:2-2-5-3")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-2-3-4")
      assert(delete_action.from_datetime == local_date_time(2000, 1, 1, 0, 0, 0), "CASE:2-2-5-5")
      assert(delete_action.to_datetime == local_date_time(2021, 1, 1, 0, 0, 0), "CASE:2-2-5-6")
      assert(delete_action.sort_item == 'gets_start_date', "CASE:2-2-5-7")
      assert(delete_action.sort_order == 'ASC', "CASE:2-2-5-8")
      assert(delete_action.disp_counts == 'ALL', "CASE:2-2-5-9")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 0, "CASE:2-2-5-10")
      # データ確認
      assert(RequestAnalysisSchedule.where(:id=>delete_id.to_i).count == 0, "CASE:2-2-5-11")
      assert(RequestAnalysisSchedule.find(:all).count == 37, "CASE:2-2-5-12")
      # 検索結果確認
      schedule_list = delete_action.schedule_list
#      print_log('schedule_list size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 37, "CASE:2-2-5-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-5")
    end
    ###########################################################################
    # 異常ケース
    ###########################################################################
    # 異常（存在しないsystem_id）
    begin
      system_id = '100'
      from_datetime = date_time_param(2020, 2, 4, 0, 0, 0)
      to_datetime = date_time_param(2020, 2, 5, 0, 0, 0)
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:system_id=>system_id,
                        :from_datetime=>from_datetime,
                        :to_datetime=>to_datetime,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      delete_action = DeleteAction.new(controller)
      # コンストラクタ生成
      assert(!delete_action.nil?, "CASE:2-2-6-1")
      # 永続化処理
#      delete_action.valid?
#      print_log('error msg:' + delete_action.error_msg_hash.to_s)
      assert(!delete_action.delete_data?, "CASE:2-2-6-2")
      # アクセサ
      assert(delete_action.system_id == system_id, "CASE:2-2-6-3")
      assert(delete_action.from_datetime == local_date_time(2020, 2, 4, 0, 0, 0), "CASE:2-2-6-4")
      assert(delete_action.to_datetime == local_date_time(2020, 2, 5, 0, 0, 0), "CASE:2-2-6-5")
      assert(delete_action.sort_item == 'system_id', "CASE:2-2-6-6")
      assert(delete_action.sort_order == 'ASC', "CASE:2-2-6-7")
      assert(delete_action.disp_counts == 'ALL', "CASE:2-2-6-8")
      # エラーメッセージ
#      print_log('error hash:' + delete_action.error_msg_hash.to_s)
      assert(delete_action.error_msg_hash.size == 1, "CASE:2-2-6-9")
#      print_log('disp_counts:' + delete_action.error_msg_hash[:disp_counts].to_s)
      assert(delete_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-2-6-10")
      # データ確認
      assert(RequestAnalysisSchedule.find(:all).count == 37, "CASE:2-2-6-11")
      # 検索結果確認
      schedule_list = delete_action.schedule_list
#      print_log('schedule_list size:' + schedule_list.size.to_s)
      assert(schedule_list.size == 37, "CASE:2-2-6-12")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-6")
    end
  end
end