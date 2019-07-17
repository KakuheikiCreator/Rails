# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：ScheduleList::ScheduleListController
# アクション：update
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/08/22 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/schedule_list/update_action'

class UpdateActionTest < ActiveSupport::TestCase
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
  test "2-1:UpdateAction Test:valid?" do
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
      target_id = '8'
      analysis_schedule = {
        :gs_received_year=>'true',
        :gs_received_month=>'false',
        :gs_received_day=>'true',
        :gs_received_hour=>'false',
        :gs_received_minute=>'true',
        :gs_received_second=>'false',
        :gs_function_id=>true,
        :gs_function_transition_no=>false,
        :gs_session_id=>true,
        :gs_client_id=>false,
        :gs_browser_id=>'false',
        :gs_browser_version_id=>'false',
        :gs_accept_language=>'false',
        :gs_referrer=>'false',
        :gs_domain_id=>'false',
        :gs_proxy_host=>'false',
        :gs_proxy_ip_address=>'false',
        :gs_remote_host=>'true',
        :gs_ip_address=>'false'
      }
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:target_id=>target_id,
                        :analysis_schedule=>analysis_schedule
                       }
             }
      controller = MockController.new(params)
      # コンストラクタ生成
      update_action = UpdateAction.new(controller)
      assert(!update_action.nil?, "CASE:2-1-1-1")
      # パラメータチェック
#      update_action.valid?
#      print_log('error msg:' + update_action.error_msg_hash.to_s)
      assert(update_action.valid?, "CASE:2-1-1-2")
      # アクセサ
      assert(update_action.target_id == target_id, "CASE:2-1-1-3")
#      target_rec = update_action.analysis_schedule
#      print_log('target_rec:' + target_rec.attributes.to_s)
#      assert(!target_rec.gs_received_year, "CASE:2-1-1-4")
#      assert(!target_rec.gs_received_month, "CASE:2-1-1-4")
#      assert(!target_rec.gs_received_day, "CASE:2-1-1-4")
#      assert(!target_rec.gs_received_hour, "CASE:2-1-1-4")
#      assert(!target_rec.gs_received_minute, "CASE:2-1-1-4")
#      assert(!target_rec.gs_received_second, "CASE:2-1-1-4")
#      assert(!target_rec.gs_function_id, "CASE:2-1-1-4")
#      assert(!target_rec.gs_function_transition_no, "CASE:2-1-1-4")
#      assert(!target_rec.gs_session_id, "CASE:2-1-1-4")
#      assert(!target_rec.gs_client_id, "CASE:2-1-1-4")
#      assert(!target_rec.gs_browser_id, "CASE:2-1-1-4")
#      assert(!target_rec.gs_browser_version_id, "CASE:2-1-1-4")
#      assert(!target_rec.gs_accept_language, "CASE:2-1-1-4")
#      assert(!target_rec.gs_referrer, "CASE:2-1-1-4")
#      assert(!target_rec.gs_domain_id, "CASE:2-1-1-4")
#      assert(!target_rec.gs_proxy_host, "CASE:2-1-1-4")
#      assert(!target_rec.gs_proxy_ip_address, "CASE:2-1-1-4")
#      assert(!target_rec.gs_remote_host, "CASE:2-1-1-4")
#      assert(!target_rec.gs_ip_address, "CASE:2-1-1-4")
      # エラーメッセージ
#      print_log('error hash:' + update_action.error_msg_hash.to_s)
      assert(update_action.error_msg_hash.size == 0, "CASE:2-1-1-9")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    ###########################################################################
    # 単項目チェック
    ###########################################################################
    # 対象ID未入力エラー
    begin
      target_id = nil
      analysis_schedule = {
      }
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:target_id=>target_id,
                        :analysis_schedule=>analysis_schedule
                       }
             }
      controller = MockController.new(params)
      # コンストラクタ生成
      update_action = UpdateAction.new(controller)
      assert(!update_action.nil?, "CASE:2-1-2-1")
      # パラメータチェック
#      update_action.valid?
#      print_log('error msg:' + update_action.error_msg_hash.to_s)
      assert(!update_action.valid?, "CASE:2-1-2-2")
      # アクセサ
      assert(update_action.target_id.nil?, "CASE:2-1-2-3")
      # エラーメッセージ
#      print_log('error hash:' + update_action.error_msg_hash.to_s)
      assert(update_action.error_msg_hash.size == 1, "CASE:2-1-2-9")
#      print_log('system_name:' + update_action.error_msg_hash[:error_msg].to_s)
      assert(update_action.error_msg_hash[:error_msg] == '更新対象ID は不正な値です。', "CASE:2-1-2-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # 対象ID属性エラー
    begin
      target_id = ''
      analysis_schedule = {
      }
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:target_id=>target_id,
                        :analysis_schedule=>analysis_schedule
                       }
             }
      controller = MockController.new(params)
      # コンストラクタ生成
      update_action = UpdateAction.new(controller)
      assert(!update_action.nil?, "CASE:2-1-3-1")
      # パラメータチェック
#      update_action.valid?
#      print_log('error msg:' + update_action.error_msg_hash.to_s)
      assert(!update_action.valid?, "CASE:2-1-3-2")
      # アクセサ
      assert(update_action.target_id == target_id, "CASE:2-1-3-3")
      # エラーメッセージ
#      print_log('error hash:' + update_action.error_msg_hash.to_s)
      assert(update_action.error_msg_hash.size == 1, "CASE:2-1-3-9")
#      print_log('system_name:' + update_action.error_msg_hash[:error_msg].to_s)
      assert(update_action.error_msg_hash[:error_msg] == '更新対象ID は不正な値です。', "CASE:2-1-3-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # 異常（データモデルバリデーションエラーその１）
    begin
      target_id = '8'
      analysis_schedule = {
        :gs_received_year=>'a'
      }
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:target_id=>target_id,
                        :analysis_schedule=>analysis_schedule
                       }
             }
      controller = MockController.new(params)
      update_action = UpdateAction.new(controller)
      # コンストラクタ生成
      assert(!update_action.nil?, "CASE:2-1-4-1")
      # パラメータチェック
      update_action.valid?
#      print_log('error msg:' + update_action.error_msg_hash.to_s)
#      assert(!update_action.valid?, "CASE:2-1-4-2")
      # アクセサ
      assert(update_action.target_id == target_id, "CASE:2-1-4-3")
      # エラーメッセージ
#      print_log('error hash:' + update_action.error_msg_hash.to_s)
#      assert(update_action.error_msg_hash.size == 1, "CASE:2-1-4-9")
#      print_log('system_name:' + update_action.error_msg_hash[:error_msg].to_s)
#      assert(update_action.error_msg_hash[:error_msg] == '対象データ は不正な値です。', "CASE:2-1-4-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
    # 異常（データモデルバリデーションエラーその２）
    begin
      target_id = '8'
      analysis_schedule = {
        :gs_none_item=>'none'
      }
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:target_id=>target_id,
                        :analysis_schedule=>analysis_schedule
                       }
             }
      controller = MockController.new(params)
      update_action = UpdateAction.new(controller)
      # コンストラクタ生成
      assert(!update_action.nil?, "CASE:2-1-4-1")
      # パラメータチェック
      update_action.valid?
#      print_log('error msg:' + update_action.error_msg_hash.to_s)
#      assert(!update_action.valid?, "CASE:2-1-4-2")
      # アクセサ
      assert(update_action.target_id == target_id, "CASE:2-1-4-3")
      # エラーメッセージ
#      print_log('error hash:' + update_action.error_msg_hash.to_s)
#      assert(update_action.error_msg_hash.size == 1, "CASE:2-1-4-9")
#      print_log('system_name:' + update_action.error_msg_hash[:error_msg].to_s)
#      assert(update_action.error_msg_hash[:error_msg] == '対象データ は不正な値です。', "CASE:2-1-4-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
    ###########################################################################
    # DB関連チェック
    ###########################################################################
    # 更新対象が存在しない
    begin
      target_id = '10000'
      analysis_schedule = {
      }
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:target_id=>target_id,
                        :analysis_schedule=>analysis_schedule
                       }
             }
      controller = MockController.new(params)
      update_action = UpdateAction.new(controller)
      # コンストラクタ生成
      assert(!update_action.nil?, "CASE:2-1-5-1")
      # パラメータチェック
#      update_action.valid?
#      print_log('error msg:' + update_action.error_msg_hash.to_s)
      assert(!update_action.valid?, "CASE:2-1-5-2")
      # アクセサ
      assert(update_action.target_id == target_id, "CASE:2-1-5-3")
      # エラーメッセージ
#      print_log('error hash:' + update_action.error_msg_hash.to_s)
      assert(update_action.error_msg_hash.size == 1, "CASE:2-1-5-4")
#      print_log('disp_counts:' + update_action.error_msg_hash[:disp_counts].to_s)
      assert(update_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-5-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-5")
    end
    # 対象データが過去データ
    begin
      target_id = '1'
      analysis_schedule = {
      }
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:target_id=>target_id,
                        :analysis_schedule=>analysis_schedule
                       }
             }
      controller = MockController.new(params)
      update_action = UpdateAction.new(controller)
      # コンストラクタ生成
      assert(!update_action.nil?, "CASE:2-1-6-1")
      # パラメータチェック
#      update_action.valid?
#      print_log('error msg:' + update_action.error_msg_hash.to_s)
      assert(!update_action.valid?, "CASE:2-1-6-2")
      # アクセサ
      assert(update_action.target_id == target_id, "CASE:2-1-6-3")
      # エラーメッセージ
#      print_log('error hash:' + update_action.error_msg_hash.to_s)
      assert(update_action.error_msg_hash.size == 1, "CASE:2-1-6-4")
#      print_log('disp_counts:' + update_action.error_msg_hash[:disp_counts].to_s)
      assert(update_action.error_msg_hash[:error_msg] == '更新対象ID は不正な値です。', "CASE:2-1-6-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-6")
    end
    # テストデータ追加
    ent = RequestAnalysisSchedule.new
    ActiveRecord::Base.transaction do
      ent.system_id = 100
      ent.gets_start_date = DateTime.now
      ent.save!
    end
    # 直前のデータ保存
    begin
      target_id = ent.id
      analysis_schedule = {
      }
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:target_id=>target_id,
                        :analysis_schedule=>analysis_schedule
                       }
             }
      controller = MockController.new(params)
      update_action = UpdateAction.new(controller)
      # コンストラクタ生成
      assert(!update_action.nil?, "CASE:2-1-7-1")
      # パラメータチェック
#      update_action.valid?
#      print_log('error msg:' + update_action.error_msg_hash.to_s)
      assert(!update_action.valid?, "CASE:2-1-7-2")
      # アクセサ
      assert(update_action.target_id == target_id, "CASE:2-1-7-3")
      # エラーメッセージ
#      print_log('error hash:' + update_action.error_msg_hash.to_s)
      assert(update_action.error_msg_hash.size == 1, "CASE:2-1-7-4")
#      print_log('disp_counts:' + update_action.error_msg_hash[:disp_counts].to_s)
      assert(update_action.error_msg_hash[:error_msg] == '更新対象ID は不正な値です。', "CASE:2-1-7-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-7")
    end
  end
  
  # 更新処理
  test "2-2:UpdateAction Test:update_data?" do
    # テストデータ追加
    ActiveRecord::Base.transaction do
      50.times do |i|
        ent = RequestAnalysisSchedule.new
        ent.system_id = 1
        ent.gets_start_date = local_date_time(2020, 1, 1, 0, 0, i)
        ent.save!
      end
    end
    # 正常（全項目指定ケース１）
    begin
      target_id = RequestAnalysisSchedule.maximum(:id).to_s
      analysis_schedule = {
        :gs_received_year=>'true',
        :gs_received_month=>'false',
        :gs_received_day=>'true',
        :gs_received_hour=>'false',
        :gs_received_minute=>'true',
        :gs_received_second=>'false',
        :gs_function_id=>true,
        :gs_function_transition_no=>false,
        :gs_session_id=>true,
        :gs_client_id=>false,
        :gs_browser_id=>'false',
        :gs_browser_version_id=>'false',
        :gs_accept_language=>'false',
        :gs_referrer=>'false',
        :gs_domain_id=>'false',
        :gs_proxy_host=>'false',
        :gs_proxy_ip_address=>'false',
        :gs_remote_host=>'true',
        :gs_ip_address=>'false'
      }
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:target_id=>target_id,
                        :analysis_schedule=>analysis_schedule
              }
      }
#      print_log('target_id:' + target_id)
      controller = MockController.new(params)
      # コンストラクタ生成
      update_action = UpdateAction.new(controller)
      assert(!update_action.nil?, "CASE:2-2-1-1")
      # 永続化処理
      update_action.update_data?
#      print_log('error msg:' + update_action.error_msg_hash.to_s)
      assert(update_action.update_data?, "CASE:2-2-1-2")
      # アクセサ
      assert(update_action.target_id == target_id, "CASE:2-2-1-3")
      assert(update_action.system_id.nil?, "CASE:2-2-1-3")
      assert(update_action.from_datetime.nil?, "CASE:2-2-1-4")
      assert(update_action.to_datetime.nil?, "CASE:2-2-1-5")
      assert(update_action.sort_item == 'gets_start_date', "CASE:2-2-1-6")
      assert(update_action.sort_order == 'ASC', "CASE:2-2-1-7")
      assert(update_action.disp_counts == '500', "CASE:2-2-1-8")
      # エラーメッセージ
#      print_log('error hash:' + update_action.error_msg_hash.to_s)
      assert(update_action.error_msg_hash.size == 0, "CASE:2-2-1-9")
      # 保存データ確認
      create_data = RequestAnalysisSchedule.where(:id=>target_id)
      assert(create_data.size == 1, "CASE:2-2-1-10")
      assert(create_data[0].system_id == 1, "CASE:2-2-1-11")
      assert(create_data[0].gets_start_date == local_date_time(2020, 1, 1, 0, 0, 49), "CASE:2-2-1-12")
      assert(create_data[0].gs_received_year == true, "CASE:2-2-1-13")
      assert(create_data[0].gs_received_month == false, "CASE:2-2-1-13")
      assert(create_data[0].gs_received_day == true, "CASE:2-2-1-14")
      assert(create_data[0].gs_received_hour == false, "CASE:2-2-1-15")
      assert(create_data[0].gs_received_minute == true, "CASE:2-2-1-16")
      assert(create_data[0].gs_received_second == false, "CASE:2-2-1-17")
      assert(create_data[0].gs_function_id == true, "CASE:2-2-1-18")
      assert(create_data[0].gs_function_transition_no == false, "CASE:2-2-1-19")
      assert(create_data[0].gs_session_id == true, "CASE:2-2-1-20")
      assert(create_data[0].gs_client_id == false, "CASE:2-2-1-21")
      assert(create_data[0].gs_browser_id == false, "CASE:2-2-1-22")
      assert(create_data[0].gs_browser_version_id == false, "CASE:2-2-1-23")
      assert(create_data[0].gs_accept_language == false, "CASE:2-2-1-24")
      assert(create_data[0].gs_referrer == false, "CASE:2-2-1-25")
      assert(create_data[0].gs_domain_id == false, "CASE:2-2-1-26")
      assert(create_data[0].gs_proxy_host == false, "CASE:2-2-1-27")
      assert(create_data[0].gs_proxy_ip_address == false, "CASE:2-2-1-28")
      assert(create_data[0].gs_remote_host == true, "CASE:2-2-1-29")
      assert(create_data[0].gs_ip_address == false, "CASE:2-2-1-30")
      # 検索結果確認
      schedule_list = update_action.schedule_list
      assert(schedule_list.size == 57, "CASE:2-2-1-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    # 正常（全項目指定ケース2）
    begin
      target_id = RequestAnalysisSchedule.maximum(:id).to_s
      analysis_schedule = {
        :gs_received_year=>'false',
        :gs_received_month=>'true',
        :gs_received_day=>'false',
        :gs_received_hour=>'true',
        :gs_received_minute=>'false',
        :gs_received_second=>'true',
        :gs_function_id=>false,
        :gs_function_transition_no=>true,
        :gs_session_id=>false,
        :gs_client_id=>true,
        :gs_browser_id=>'true',
        :gs_browser_version_id=>'true',
        :gs_accept_language=>'true',
        :gs_referrer=>'true',
        :gs_domain_id=>'true',
        :gs_proxy_host=>'true',
        :gs_proxy_ip_address=>'true',
        :gs_remote_host=>'false',
        :gs_ip_address=>'true'
      }
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:target_id=>target_id,
                        :analysis_schedule=>analysis_schedule
              }
      }
#      print_log('target_id:' + target_id)
      controller = MockController.new(params)
      # コンストラクタ生成
      update_action = UpdateAction.new(controller)
      assert(!update_action.nil?, "CASE:2-2-2-1")
      # 永続化処理
      update_action.update_data?
#      print_log('error msg:' + update_action.error_msg_hash.to_s)
      assert(update_action.update_data?, "CASE:2-2-2-2")
      # アクセサ
      assert(update_action.target_id == target_id, "CASE:2-2-2-3")
      assert(update_action.system_id.nil?, "CASE:2-2-2-3")
      assert(update_action.from_datetime.nil?, "CASE:2-2-2-4")
      assert(update_action.to_datetime.nil?, "CASE:2-2-2-5")
      assert(update_action.sort_item == 'gets_start_date', "CASE:2-2-2-6")
      assert(update_action.sort_order == 'ASC', "CASE:2-2-2-7")
      assert(update_action.disp_counts == '500', "CASE:2-2-2-8")
      # エラーメッセージ
#      print_log('error hash:' + update_action.error_msg_hash.to_s)
      assert(update_action.error_msg_hash.size == 0, "CASE:2-2-2-9")
      # 保存データ確認
      create_data = RequestAnalysisSchedule.where(:id=>target_id)
      assert(create_data.size == 1, "CASE:2-2-2-10")
      assert(create_data[0].system_id == 1, "CASE:2-2-2-11")
      assert(create_data[0].gets_start_date == local_date_time(2020, 1, 1, 0, 0, 49), "CASE:2-2-2-12")
      assert(create_data[0].gs_received_year == false, "CASE:2-2-2-13")
      assert(create_data[0].gs_received_month == true, "CASE:2-2-2-13")
      assert(create_data[0].gs_received_day == false, "CASE:2-2-2-14")
      assert(create_data[0].gs_received_hour == true, "CASE:2-2-2-15")
      assert(create_data[0].gs_received_minute == false, "CASE:2-2-2-16")
      assert(create_data[0].gs_received_second == true, "CASE:2-2-2-17")
      assert(create_data[0].gs_function_id == false, "CASE:2-2-2-18")
      assert(create_data[0].gs_function_transition_no == true, "CASE:2-2-2-19")
      assert(create_data[0].gs_session_id == false, "CASE:2-2-2-20")
      assert(create_data[0].gs_client_id == true, "CASE:2-2-2-21")
      assert(create_data[0].gs_browser_id == true, "CASE:2-2-2-22")
      assert(create_data[0].gs_browser_version_id == true, "CASE:2-2-2-23")
      assert(create_data[0].gs_accept_language == true, "CASE:2-2-2-24")
      assert(create_data[0].gs_referrer == true, "CASE:2-2-2-25")
      assert(create_data[0].gs_domain_id == true, "CASE:2-2-2-26")
      assert(create_data[0].gs_proxy_host == true, "CASE:2-2-2-27")
      assert(create_data[0].gs_proxy_ip_address == true, "CASE:2-2-2-28")
      assert(create_data[0].gs_remote_host == false, "CASE:2-2-2-29")
      assert(create_data[0].gs_ip_address == true, "CASE:2-2-2-30")
      # 検索結果確認
      schedule_list = update_action.schedule_list
      assert(schedule_list.size == 57, "CASE:2-2-2-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    # 正常（一部項目指定ケース１）
    begin
      target_id = RequestAnalysisSchedule.maximum(:id).to_s
#      target_id = (target_id.to_i - 1).to_s
      analysis_schedule = {
        :gs_received_year=>'true',
        :gs_received_month=>'false',
        :gs_received_day=>'true',
        :gs_session_id=>true,
        :gs_client_id=>false,
        :gs_referrer=>'false',
        :gs_domain_id=>'false',
        :gs_remote_host=>'true',
        :gs_ip_address=>'false'
      }
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:target_id=>target_id,
                        :analysis_schedule=>analysis_schedule
              }
      }
#      print_log('target_id:' + target_id)
      controller = MockController.new(params)
      # コンストラクタ生成
      update_action = UpdateAction.new(controller)
      assert(!update_action.nil?, "CASE:2-2-3-1")
      # 永続化処理
      update_action.update_data?
#      print_log('error msg:' + update_action.error_msg_hash.to_s)
      assert(update_action.update_data?, "CASE:2-2-3-2")
      # アクセサ
      assert(update_action.target_id == target_id, "CASE:2-2-3-3")
      assert(update_action.system_id.nil?, "CASE:2-2-3-3")
      assert(update_action.from_datetime.nil?, "CASE:2-2-3-4")
      assert(update_action.to_datetime.nil?, "CASE:2-2-3-5")
      assert(update_action.sort_item == 'gets_start_date', "CASE:2-2-3-6")
      assert(update_action.sort_order == 'ASC', "CASE:2-2-3-7")
      assert(update_action.disp_counts == '500', "CASE:2-2-3-8")
      # エラーメッセージ
#      print_log('error hash:' + update_action.error_msg_hash.to_s)
      assert(update_action.error_msg_hash.size == 0, "CASE:2-2-3-9")
      # 保存データ確認
      create_data = RequestAnalysisSchedule.where(:id=>target_id)
      assert(create_data.size == 1, "CASE:2-2-3-10")
      assert(create_data[0].system_id == 1, "CASE:2-2-3-11")
      assert(create_data[0].gets_start_date == local_date_time(2020, 1, 1, 0, 0, 49), "CASE:2-2-3-12")
      assert(create_data[0].gs_received_year == true, "CASE:2-2-3-13")
      assert(create_data[0].gs_received_month == false, "CASE:2-2-3-13")
      assert(create_data[0].gs_received_day == true, "CASE:2-2-3-14")
      assert(create_data[0].gs_received_hour == true, "CASE:2-2-3-15")
      assert(create_data[0].gs_received_minute == false, "CASE:2-2-3-16")
      assert(create_data[0].gs_received_second == true, "CASE:2-2-3-17")
      assert(create_data[0].gs_function_id == false, "CASE:2-2-3-18")
      assert(create_data[0].gs_function_transition_no == true, "CASE:2-2-3-19")
      assert(create_data[0].gs_session_id == true, "CASE:2-2-3-20")
      assert(create_data[0].gs_client_id == false, "CASE:2-2-3-21")
      assert(create_data[0].gs_browser_id == true, "CASE:2-2-3-22")
      assert(create_data[0].gs_browser_version_id == true, "CASE:2-2-3-23")
      assert(create_data[0].gs_accept_language == true, "CASE:2-2-3-24")
      assert(create_data[0].gs_referrer == false, "CASE:2-2-3-25")
      assert(create_data[0].gs_domain_id == false, "CASE:2-2-3-26")
      assert(create_data[0].gs_proxy_host == true, "CASE:2-2-3-27")
      assert(create_data[0].gs_proxy_ip_address == true, "CASE:2-2-3-28")
      assert(create_data[0].gs_remote_host == true, "CASE:2-2-3-29")
      assert(create_data[0].gs_ip_address == false, "CASE:2-2-3-30")
      # 検索結果確認
      schedule_list = update_action.schedule_list
      assert(schedule_list.size == 57, "CASE:2-2-3-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-3")
    end
    ###########################################################################
    # 異常ケース(バリデーションチェックの疎通確認)
    ###########################################################################
    # 異常（存在しないid）
    begin
      target_id = '10000'
      analysis_schedule = {
        :gs_received_year=>'true',
        :gs_received_month=>'false',
        :gs_received_day=>'true',
        :gs_session_id=>true,
        :gs_client_id=>false,
        :gs_referrer=>'false',
        :gs_domain_id=>'false',
        :gs_remote_host=>'true',
        :gs_ip_address=>'false'
      }
      params={:controller_name=>'schedule_list',
              :method=>:POST,
              :session=>{},
              :params=>{:target_id=>target_id,
                        :analysis_schedule=>analysis_schedule
              }
      }
#      print_log('target_id:' + target_id)
      controller = MockController.new(params)
      # コンストラクタ生成
      update_action = UpdateAction.new(controller)
      assert(!update_action.nil?, "CASE:2-2-3-1")
      # 永続化処理
      update_action.update_data?
#      print_log('error msg:' + update_action.error_msg_hash.to_s)
      assert(!update_action.update_data?, "CASE:2-2-3-2")
      # アクセサ
      assert(update_action.target_id == target_id, "CASE:2-2-3-3")
      assert(update_action.system_id.nil?, "CASE:2-2-3-3")
      assert(update_action.from_datetime.nil?, "CASE:2-2-3-4")
      assert(update_action.to_datetime.nil?, "CASE:2-2-3-5")
      assert(update_action.sort_item == 'gets_start_date', "CASE:2-2-3-6")
      assert(update_action.sort_order == 'ASC', "CASE:2-2-3-7")
      assert(update_action.disp_counts == '500', "CASE:2-2-3-8")
      # エラーメッセージ
#      print_log('error hash:' + update_action.error_msg_hash.to_s)
      assert(update_action.error_msg_hash.size == 1, "CASE:2-2-3-9")
      assert(update_action.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-7-5")
      # 検索結果確認
      schedule_list = update_action.schedule_list
      assert(schedule_list.size == 57, "CASE:2-2-3-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-3")
    end
  end
end