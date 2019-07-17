# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：AccessTotal::AccessTotalController
# アクション：list
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/10/15 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'unit/biz_actions/access_total/totalization_data'
require 'biz_actions/access_total/totalization_action'

class TotalizationActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::AccessTotal
  include Mock
  # 前処理
  def setup
    Time.zone = 3/8
    # データ生成オブジェクト
    @generator = TotalizationData.new
  end
  # 後処理
#  def teardown
#  end

  # 受信日時リスト生成
  test "2-1:TotalizationAction Test:received_date_list" do
    ###########################################################################
    # 受信日時リスト生成処理
    ###########################################################################
    # CASE:2-1-1
    # 正常ケース
    # 受信日時：2007/10/09 10:20:30
    # 時間単位：年
    # 単位数：５
    # 機関数：１０
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>nil,
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'5',
                        :time_unit=>'year',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>'test',
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-1-1-1")
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 日時リスト検証
      10.times do |idx|
        date_val = action.date_list[idx]
        assert(date_val == (2007 + (idx * 5)).to_s, "CASE:2-1-1-2")
      end
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-1-1-3")
      assert(action.item_2.nil?, "CASE:2-1-1-3")
      assert(action.item_3.nil?, "CASE:2-1-1-3")
      assert(action.item_4.nil?, "CASE:2-1-1-3")
      assert(action.item_5.nil?, "CASE:2-1-1-3")
      assert(action.disp_number == '8', "CASE:2-1-1-3")
      assert(action.disp_order == 'DESC', "CASE:2-1-1-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-1-1-3")
      assert(action.time_unit_num == '5', "CASE:2-1-1-3")
      assert(action.time_unit == 'year', "CASE:2-1-1-3")
      assert(action.aggregation_period == '10', "CASE:2-1-1-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-1-1-3")
      assert(action.function_id.nil?, "CASE:2-1-1-4")
      assert(action.function_trans_no.nil?, "CASE:2-1-1-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-1-1-6")
      assert(action.session_id.nil?, "CASE:2-1-1-6")
      assert(action.client_id.nil?, "CASE:2-1-1-6")
      assert(action.browser_id.nil?, "CASE:2-1-1-6")
      assert(action.browser_version_id.nil?, "CASE:2-1-1-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-1-1-6")
      assert(action.accept_language.nil?, "CASE:2-1-1-6")
      assert(action.referrer.nil?, "CASE:2-1-1-6")
      assert(action.referrer_match == 'F', "CASE:2-1-1-6")
      assert(action.domain_name == 'test', "CASE:2-1-1-6")
      assert(action.domain_name_match == 'F', "CASE:2-1-1-6")
      assert(action.proxy_host.nil?, "CASE:2-1-1-6")
      assert(action.proxy_host_match == 'F', "CASE:2-1-1-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-1-1-6")
      assert(action.remote_host.nil?, "CASE:2-1-1-6")
      assert(action.remote_host_match == 'F', "CASE:2-1-1-6")
      assert(action.ip_address.nil?, "CASE:2-1-1-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-1-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # CASE:2-1-2
    # 正常ケース
    # 受信日時：2007/10/09 10:20:30
    # 時間単位：月
    # 単位数：５
    # 機関数：１０
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>nil,
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'2',
                        :time_unit=>'month',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>'test',
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-1-2-1")
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 日時リスト検証
      assert(action.date_list[0] == '2007/10', "CASE:2-1-2-2")
      assert(action.date_list[1] == '2007/12', "CASE:2-1-2-2")
      assert(action.date_list[2] == '2008/02', "CASE:2-1-2-2")
      assert(action.date_list[3] == '2008/04', "CASE:2-1-2-2")
      assert(action.date_list[4] == '2008/06', "CASE:2-1-2-2")
      assert(action.date_list[5] == '2008/08', "CASE:2-1-2-2")
      assert(action.date_list[6] == '2008/10', "CASE:2-1-2-2")
      assert(action.date_list[7] == '2008/12', "CASE:2-1-2-2")
      assert(action.date_list[8] == '2009/02', "CASE:2-1-2-2")
      assert(action.date_list[9] == '2009/04', "CASE:2-1-2-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-1-2-3")
      assert(action.item_2.nil?, "CASE:2-1-2-3")
      assert(action.item_3.nil?, "CASE:2-1-2-3")
      assert(action.item_4.nil?, "CASE:2-1-2-3")
      assert(action.item_5.nil?, "CASE:2-1-2-3")
      assert(action.disp_number == '8', "CASE:2-1-2-3")
      assert(action.disp_order == 'DESC', "CASE:2-1-2-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-1-2-3")
      assert(action.time_unit_num == '2', "CASE:2-1-2-3")
      assert(action.time_unit == 'month', "CASE:2-1-2-3")
      assert(action.aggregation_period == '10', "CASE:2-1-2-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-1-2-3")
      assert(action.function_id.nil?, "CASE:2-1-2-4")
      assert(action.function_trans_no.nil?, "CASE:2-1-2-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-1-2-6")
      assert(action.session_id.nil?, "CASE:2-1-2-6")
      assert(action.client_id.nil?, "CASE:2-1-2-6")
      assert(action.browser_id.nil?, "CASE:2-1-2-6")
      assert(action.browser_version_id.nil?, "CASE:2-1-2-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-1-2-6")
      assert(action.accept_language.nil?, "CASE:2-1-2-6")
      assert(action.referrer.nil?, "CASE:2-1-2-6")
      assert(action.referrer_match == 'F', "CASE:2-1-2-6")
      assert(action.domain_name == 'test', "CASE:2-1-2-6")
      assert(action.domain_name_match == 'F', "CASE:2-1-2-6")
      assert(action.proxy_host.nil?, "CASE:2-1-2-6")
      assert(action.proxy_host_match == 'F', "CASE:2-1-2-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-1-2-6")
      assert(action.remote_host.nil?, "CASE:2-1-2-6")
      assert(action.remote_host_match == 'F', "CASE:2-1-2-6")
      assert(action.ip_address.nil?, "CASE:2-1-2-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-1-2-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # CASE:2-1-3
    # 正常ケース
    # 受信日時：2007/10/09 10:20:30
    # 時間単位：日
    # 単位数：7
    # 機関数：１０
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>nil,
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'7',
                        :time_unit=>'day',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>'test',
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-1-3-1")
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 日時リスト検証
      assert(action.date_list[0] == '2007/10/09', "CASE:2-1-3-2")
      assert(action.date_list[1] == '2007/10/16', "CASE:2-1-3-2")
      assert(action.date_list[2] == '2007/10/23', "CASE:2-1-3-2")
      assert(action.date_list[3] == '2007/10/30', "CASE:2-1-3-2")
      assert(action.date_list[4] == '2007/11/06', "CASE:2-1-3-2")
      assert(action.date_list[5] == '2007/11/13', "CASE:2-1-3-2")
      assert(action.date_list[6] == '2007/11/20', "CASE:2-1-3-2")
      assert(action.date_list[7] == '2007/11/27', "CASE:2-1-3-2")
      assert(action.date_list[8] == '2007/12/04', "CASE:2-1-3-2")
      assert(action.date_list[9] == '2007/12/11', "CASE:2-1-3-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-1-3-3")
      assert(action.item_2.nil?, "CASE:2-1-3-3")
      assert(action.item_3.nil?, "CASE:2-1-3-3")
      assert(action.item_4.nil?, "CASE:2-1-3-3")
      assert(action.item_5.nil?, "CASE:2-1-3-3")
      assert(action.disp_number == '8', "CASE:2-1-3-3")
      assert(action.disp_order == 'DESC', "CASE:2-1-3-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-1-3-3")
      assert(action.time_unit_num == '7', "CASE:2-1-3-3")
      assert(action.time_unit == 'day', "CASE:2-1-3-3")
      assert(action.aggregation_period == '10', "CASE:2-1-3-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-1-3-3")
      assert(action.function_id.nil?, "CASE:2-1-3-4")
      assert(action.function_trans_no.nil?, "CASE:2-1-3-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-1-3-6")
      assert(action.session_id.nil?, "CASE:2-1-3-6")
      assert(action.client_id.nil?, "CASE:2-1-3-6")
      assert(action.browser_id.nil?, "CASE:2-1-3-6")
      assert(action.browser_version_id.nil?, "CASE:2-1-3-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-1-3-6")
      assert(action.accept_language.nil?, "CASE:2-1-3-6")
      assert(action.referrer.nil?, "CASE:2-1-3-6")
      assert(action.referrer_match == 'F', "CASE:2-1-3-6")
      assert(action.domain_name == 'test', "CASE:2-1-3-6")
      assert(action.domain_name_match == 'F', "CASE:2-1-3-6")
      assert(action.proxy_host.nil?, "CASE:2-1-3-6")
      assert(action.proxy_host_match == 'F', "CASE:2-1-3-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-1-3-6")
      assert(action.remote_host.nil?, "CASE:2-1-3-6")
      assert(action.remote_host_match == 'F', "CASE:2-1-3-6")
      assert(action.ip_address.nil?, "CASE:2-1-3-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-1-3-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # CASE:2-1-4
    # 正常ケース
    # 受信日時：2007/10/09 10:20:30
    # 時間単位：時間
    # 単位数：3
    # 機関数：20
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>nil,
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'3',
                        :time_unit=>'hour',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>'test',
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-1-4-1")
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 日時リスト検証
      assert(action.date_list[0] == '2007/10/09 10', "CASE:2-1-4-2")
      assert(action.date_list[1] == '2007/10/09 13', "CASE:2-1-4-2")
      assert(action.date_list[2] == '2007/10/09 16', "CASE:2-1-4-2")
      assert(action.date_list[3] == '2007/10/09 19', "CASE:2-1-4-2")
      assert(action.date_list[4] == '2007/10/09 22', "CASE:2-1-4-2")
      assert(action.date_list[5] == '2007/10/10 01', "CASE:2-1-4-2")
      assert(action.date_list[6] == '2007/10/10 04', "CASE:2-1-4-2")
      assert(action.date_list[7] == '2007/10/10 07', "CASE:2-1-4-2")
      assert(action.date_list[8] == '2007/10/10 10', "CASE:2-1-4-2")
      assert(action.date_list[9] == '2007/10/10 13', "CASE:2-1-4-2")
      assert(action.date_list[10] == '2007/10/10 16', "CASE:2-1-4-2")
      assert(action.date_list[11] == '2007/10/10 19', "CASE:2-1-4-2")
      assert(action.date_list[12] == '2007/10/10 22', "CASE:2-1-4-2")
      assert(action.date_list[13] == '2007/10/11 01', "CASE:2-1-4-2")
      assert(action.date_list[14] == '2007/10/11 04', "CASE:2-1-4-2")
      assert(action.date_list[15] == '2007/10/11 07', "CASE:2-1-4-2")
      assert(action.date_list[16] == '2007/10/11 10', "CASE:2-1-4-2")
      assert(action.date_list[17] == '2007/10/11 13', "CASE:2-1-4-2")
      assert(action.date_list[18] == '2007/10/11 16', "CASE:2-1-4-2")
      assert(action.date_list[19] == '2007/10/11 19', "CASE:2-1-4-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-1-4-3")
      assert(action.item_2.nil?, "CASE:2-1-4-3")
      assert(action.item_3.nil?, "CASE:2-1-4-3")
      assert(action.item_4.nil?, "CASE:2-1-4-3")
      assert(action.item_5.nil?, "CASE:2-1-4-3")
      assert(action.disp_number == '8', "CASE:2-1-4-3")
      assert(action.disp_order == 'DESC', "CASE:2-1-4-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-1-4-3")
      assert(action.time_unit_num == '3', "CASE:2-1-4-3")
      assert(action.time_unit == 'hour', "CASE:2-1-4-3")
      assert(action.aggregation_period == '20', "CASE:2-1-4-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-1-4-3")
      assert(action.function_id.nil?, "CASE:2-1-4-4")
      assert(action.function_trans_no.nil?, "CASE:2-1-4-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-1-4-6")
      assert(action.session_id.nil?, "CASE:2-1-4-6")
      assert(action.client_id.nil?, "CASE:2-1-4-6")
      assert(action.browser_id.nil?, "CASE:2-1-4-6")
      assert(action.browser_version_id.nil?, "CASE:2-1-4-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-1-4-6")
      assert(action.accept_language.nil?, "CASE:2-1-4-6")
      assert(action.referrer.nil?, "CASE:2-1-4-6")
      assert(action.referrer_match == 'F', "CASE:2-1-4-6")
      assert(action.domain_name == 'test', "CASE:2-1-4-6")
      assert(action.domain_name_match == 'F', "CASE:2-1-4-6")
      assert(action.proxy_host.nil?, "CASE:2-1-4-6")
      assert(action.proxy_host_match == 'F', "CASE:2-1-4-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-1-4-6")
      assert(action.remote_host.nil?, "CASE:2-1-4-6")
      assert(action.remote_host_match == 'F', "CASE:2-1-4-6")
      assert(action.ip_address.nil?, "CASE:2-1-4-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-1-4-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
    # CASE:2-1-5
    # 正常ケース
    # 受信日時：2007/10/09 10:20:30
    # 時間単位：分
    # 単位数：5
    # 機関数：10
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>nil,
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'5',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>'test',
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-1-5-1")
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 日時リスト検証
      assert(action.date_list[0] == '2007/10/09 10:20', "CASE:2-1-5-2")
      assert(action.date_list[1] == '2007/10/09 10:25', "CASE:2-1-5-2")
      assert(action.date_list[2] == '2007/10/09 10:30', "CASE:2-1-5-2")
      assert(action.date_list[3] == '2007/10/09 10:35', "CASE:2-1-5-2")
      assert(action.date_list[4] == '2007/10/09 10:40', "CASE:2-1-5-2")
      assert(action.date_list[5] == '2007/10/09 10:45', "CASE:2-1-5-2")
      assert(action.date_list[6] == '2007/10/09 10:50', "CASE:2-1-5-2")
      assert(action.date_list[7] == '2007/10/09 10:55', "CASE:2-1-5-2")
      assert(action.date_list[8] == '2007/10/09 11:00', "CASE:2-1-5-2")
      assert(action.date_list[9] == '2007/10/09 11:05', "CASE:2-1-5-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-1-5-3")
      assert(action.item_2.nil?, "CASE:2-1-5-3")
      assert(action.item_3.nil?, "CASE:2-1-5-3")
      assert(action.item_4.nil?, "CASE:2-1-5-3")
      assert(action.item_5.nil?, "CASE:2-1-5-3")
      assert(action.disp_number == '8', "CASE:2-1-5-3")
      assert(action.disp_order == 'DESC', "CASE:2-1-5-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-1-5-3")
      assert(action.time_unit_num == '5', "CASE:2-1-5-3")
      assert(action.time_unit == 'minute', "CASE:2-1-5-3")
      assert(action.aggregation_period == '10', "CASE:2-1-5-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-1-5-3")
      assert(action.function_id.nil?, "CASE:2-1-5-4")
      assert(action.function_trans_no.nil?, "CASE:2-1-5-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-1-5-6")
      assert(action.session_id.nil?, "CASE:2-1-5-6")
      assert(action.client_id.nil?, "CASE:2-1-5-6")
      assert(action.browser_id.nil?, "CASE:2-1-5-6")
      assert(action.browser_version_id.nil?, "CASE:2-1-5-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-1-5-6")
      assert(action.accept_language.nil?, "CASE:2-1-5-6")
      assert(action.referrer.nil?, "CASE:2-1-5-6")
      assert(action.referrer_match == 'F', "CASE:2-1-5-6")
      assert(action.domain_name == 'test', "CASE:2-1-5-6")
      assert(action.domain_name_match == 'F', "CASE:2-1-5-6")
      assert(action.proxy_host.nil?, "CASE:2-1-5-6")
      assert(action.proxy_host_match == 'F', "CASE:2-1-5-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-1-5-6")
      assert(action.remote_host.nil?, "CASE:2-1-5-6")
      assert(action.remote_host_match == 'F', "CASE:2-1-5-6")
      assert(action.ip_address.nil?, "CASE:2-1-5-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-1-5-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-5")
    end
    # CASE:2-1-6
    # 正常ケース
    # 受信日時：2007/10/09 10:20:30
    # 時間単位：秒
    # 単位数：6
    # 機関数：20
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>nil,
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'6',
                        :time_unit=>'second',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>'test',
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-1-6-1")
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 日時リスト検証
      assert(action.date_list[0] == '2007/10/09 10:20:30', "CASE:2-1-6-2")
      assert(action.date_list[1] == '2007/10/09 10:20:36', "CASE:2-1-6-2")
      assert(action.date_list[2] == '2007/10/09 10:20:42', "CASE:2-1-6-2")
      assert(action.date_list[3] == '2007/10/09 10:20:48', "CASE:2-1-6-2")
      assert(action.date_list[4] == '2007/10/09 10:20:54', "CASE:2-1-6-2")
      assert(action.date_list[5] == '2007/10/09 10:21:00', "CASE:2-1-6-2")
      assert(action.date_list[6] == '2007/10/09 10:21:06', "CASE:2-1-6-2")
      assert(action.date_list[7] == '2007/10/09 10:21:12', "CASE:2-1-6-2")
      assert(action.date_list[8] == '2007/10/09 10:21:18', "CASE:2-1-6-2")
      assert(action.date_list[9] == '2007/10/09 10:21:24', "CASE:2-1-6-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-1-6-3")
      assert(action.item_2.nil?, "CASE:2-1-6-3")
      assert(action.item_3.nil?, "CASE:2-1-6-3")
      assert(action.item_4.nil?, "CASE:2-1-6-3")
      assert(action.item_5.nil?, "CASE:2-1-6-3")
      assert(action.disp_number == '8', "CASE:2-1-6-3")
      assert(action.disp_order == 'DESC', "CASE:2-1-6-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-1-6-3")
      assert(action.time_unit_num == '6', "CASE:2-1-6-3")
      assert(action.time_unit == 'second', "CASE:2-1-6-3")
      assert(action.aggregation_period == '10', "CASE:2-1-6-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-1-6-3")
      assert(action.function_id.nil?, "CASE:2-1-6-4")
      assert(action.function_trans_no.nil?, "CASE:2-1-6-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-1-6-6")
      assert(action.session_id.nil?, "CASE:2-1-6-6")
      assert(action.client_id.nil?, "CASE:2-1-6-6")
      assert(action.browser_id.nil?, "CASE:2-1-6-6")
      assert(action.browser_version_id.nil?, "CASE:2-1-6-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-1-6-6")
      assert(action.accept_language.nil?, "CASE:2-1-6-6")
      assert(action.referrer.nil?, "CASE:2-1-6-6")
      assert(action.referrer_match == 'F', "CASE:2-1-6-6")
      assert(action.domain_name == 'test', "CASE:2-1-6-6")
      assert(action.domain_name_match == 'F', "CASE:2-1-6-6")
      assert(action.proxy_host.nil?, "CASE:2-1-6-6")
      assert(action.proxy_host_match == 'F', "CASE:2-1-6-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-1-6-6")
      assert(action.remote_host.nil?, "CASE:2-1-6-6")
      assert(action.remote_host_match == 'F', "CASE:2-1-6-6")
      assert(action.ip_address.nil?, "CASE:2-1-6-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-1-6-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-6")
    end
  end
  
  # 検索結果確認
  test "2-2:TotalizationAction Test:result_list" do
    ###########################################################################
    # テストデータ生成
    ###########################################################################
    create_data
    ###########################################################################
    # 集計処理
    ###########################################################################
    # CASE:2-2-1
    # 正常ケース
    # テスト内容：線分類項目1つ指定
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：なし
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>nil,
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-1-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 480, "CASE:2-2-1-11")
      # 検索結果内容
      ent_cnt = 0
      type_val = 15
      req_count = 16384
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 20)
      action.result_list.each do |ent|
        if ent_cnt == 60 then
          ent_cnt = 0
          type_val -= 1
          req_count /= 2
        end
        datetime = ref_datetime + (ent_cnt * 5).seconds
#        print_log('type_val:' + type_val.to_s)
#        print_log('system_id:' + ent.system_id.to_s)
        assert(ent.system_id == type_val, "CASE:2-2-1-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-1-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-1-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-1-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-1-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-1-11")
        assert(ent.received_second == datetime.sec, "CASE:2-2-1-11")
        assert(ent.request_count == req_count, "CASE:2-2-1-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    # CASE:2-2-2
    # 正常ケース
    # テスト内容：線分類項目全て指定
    # 受信日時：2007/10/09 10:20:30
    # 線分類：リファラー、システムＩＤ、機能ID、機能遷移番号、リモートホスト
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：なし
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'referrer',
                        :item_2=>'system_id',
                        :item_3=>'function_id',
                        :item_4=>'function_transition_no',
                        :item_5=>'remote_host',
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-2-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 480, "CASE:2-2-2-11")
      # 検索結果内容
      ent_cnt = 0
      type_val = 15
      req_count = 16384
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 20)
      action.result_list.each do |ent|
        if ent_cnt == 60 then
          ent_cnt = 0
          type_val -= 1
          req_count /= 2
        end
        datetime = ref_datetime + (ent_cnt * 5).seconds
#        print_log('type_val:' + type_val.to_s)
#        print_log('system_id:' + ent.system_id.to_s)
        assert(ent.referrer == @generator.referrer_list[type_val], "CASE:2-2-2-11")
        assert(ent.system_id == type_val, "CASE:2-2-2-11")
        assert(ent.function_id == type_val, "CASE:2-2-2-11")
        assert(ent.function_transition_no == type_val, "CASE:2-2-2-11")
        assert(ent.remote_host == 'client' + type_val.to_s + '.com', "CASE:2-2-2-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-2-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-2-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-2-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-2-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-2-11")
        assert(ent.received_second == datetime.sec, "CASE:2-2-2-11")
        assert(ent.request_count == req_count, "CASE:2-2-2-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    ###########################################################################
    # 抽出条件チェック
    ###########################################################################
    # CASE:2-2-3
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：システムID
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>'15',
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-3-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 60, "CASE:2-2-3-11")
      # 検索結果内容
      ent_cnt = 0
      type_val = 15
      req_count = 16384
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 20)
      action.result_list.each do |ent|
        datetime = ref_datetime + (ent_cnt * 5).seconds
#        print_log('type_val:' + type_val.to_s)
#        print_log('system_id:' + ent.system_id.to_s)
        assert(ent.system_id == type_val, "CASE:2-2-3-11")
        assert(ent.function_id == type_val, "CASE:2-2-3-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-3-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-3-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-3-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-3-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-3-11")
        assert(ent.received_second == datetime.sec, "CASE:2-2-3-11")
        assert(ent.request_count == req_count, "CASE:2-2-3-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-3-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-3")
    end
    # CASE:2-2-4
    # 異常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：システムID（存在しない値）
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>'16',
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-4-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 0, "CASE:2-2-4-11")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-4-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-4")
    end
    # CASE:2-2-5
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：システムID、機能ID
    begin
#      system_id = System.where(:system_name=>'System Name 3')[0].id
#      function_id = Function.where(:system_id=>system_id)[0].id
#      print_log('system_id:' + system_id.to_s)
#      print_log('function_id:' + function_id.to_s)
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>'3',
                        :function_id=>'3',
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-5-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 60, "CASE:2-2-5-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 4
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 20)
      action.result_list.each do |ent|
        datetime = ref_datetime + (ent_cnt * 5).seconds
        assert(ent.system_id == 3, "CASE:2-2-5-11")
        assert(ent.function_id == 3, "CASE:2-2-5-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-5-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-5-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-5-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-5-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-5-11")
        assert(ent.received_second == datetime.sec, "CASE:2-2-5-11")
        assert(ent.request_count == req_count, "CASE:2-2-5-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-5-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-5")
    end
    # CASE:2-2-6
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：機能遷移番号
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>'3',
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-6-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 60, "CASE:2-2-6-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 4
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 20)
      action.result_list.each do |ent|
        datetime = ref_datetime + (ent_cnt * 5).seconds
        assert(ent.system_id == 3, "CASE:2-2-6-11")
        assert(ent.function_id == 3, "CASE:2-2-6-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-6-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-6-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-6-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-6-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-6-11")
        assert(ent.received_second == datetime.sec, "CASE:2-2-6-11")
        assert(ent.request_count == req_count, "CASE:2-2-6-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-6-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-6")
    end
    # CASE:2-2-7
    # 異常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：機能遷移番号、存在しない値
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>'30',
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-7-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 0, "CASE:2-2-7-11")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-7-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-7")
    end
    # CASE:2-2-8
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：機能遷移番号
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>'3',
                        :function_trans_no_comp=>'LE',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-8-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 30, "CASE:2-2-8-11")
      # 検索結果内容
      ent_cnt = 0
      type_val = 3
      req_count = 48
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        if ent_cnt == 10 then
          ent_cnt = 0
          type_val -= 1
          req_count /= 2
        end
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == type_val, "CASE:2-2-8-11")
        assert(ent.function_id == type_val, "CASE:2-2-8-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-8-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-8-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-8-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-8-11")
#      print_log('minute:' + ent.received_minute.to_s + '==' + datetime.min.to_s)
        assert(ent.received_minute == datetime.min, "CASE:2-2-8-11")
        assert(ent.request_count == req_count, "CASE:2-2-8-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-8-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-8")
    end
    # CASE:2-2-9
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：セッションID
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'LE',
                        :session_id=>"01234567890123456789012345678905",
#                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-9-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
      print_log('Result Size:' + action.result_list.size.to_s)
#      assert(action.result_list.size == 10, "CASE:2-2-9-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 192
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == 5, "CASE:2-2-9-11")
        assert(ent.function_id == 5, "CASE:2-2-9-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-9-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-9-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-9-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-9-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-9-11")
        assert(ent.request_count == req_count, "CASE:2-2-9-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-9-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-9")
    end
    # CASE:2-2-10
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：クライアントID
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'LE',
                        :session_id=>nil,
                        :client_id=>'Client_ID_4',
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-10-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 10, "CASE:2-2-10-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 96
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == 4, "CASE:2-2-10-11")
        assert(ent.function_id == 4, "CASE:2-2-10-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-10-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-10-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-10-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-10-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-10-11")
        assert(ent.request_count == req_count, "CASE:2-2-10-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-10-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-10")
    end
    # CASE:2-2-11
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：ブラウザID
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'LE',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>'6',
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-11-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 10, "CASE:2-2-11-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 384
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == 6, "CASE:2-2-11-11")
        assert(ent.function_id == 6, "CASE:2-2-11-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-11-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-11-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-11-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-11-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-11-11")
        assert(ent.request_count == req_count, "CASE:2-2-11-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-11-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-11")
    end
    # CASE:2-2-12
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：ブラウザID、ブラウザバージョンID
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'LE',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>'4',
                        :browser_version_id=>'4',
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-12-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 10, "CASE:2-2-12-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 96
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == 4, "CASE:2-2-12-11")
        assert(ent.function_id == 4, "CASE:2-2-12-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-12-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-12-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-12-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-12-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-12-11")
        assert(ent.request_count == req_count, "CASE:2-2-12-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-12-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-12")
    end
    # CASE:2-2-13
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：言語
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>'ja_3',
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-13-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 10, "CASE:2-2-13-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 48
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == 3, "CASE:2-2-13-11")
        assert(ent.function_id == 3, "CASE:2-2-13-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-13-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-13-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-13-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-13-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-13-11")
        assert(ent.request_count == req_count, "CASE:2-2-13-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-13-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-13")
    end
    # CASE:2-2-14
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：リファラー
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>'ttp://www.livedoor.com/',
                        :referrer_match=>'B',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-14-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 10, "CASE:2-2-14-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 3072
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == 9, "CASE:2-2-14-11")
        assert(ent.function_id == 9, "CASE:2-2-14-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-14-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-14-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-14-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-14-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-14-11")
        assert(ent.request_count == req_count, "CASE:2-2-14-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-14-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-14")
    end
    # CASE:2-2-15
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：ドメイン名
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>'domain4',
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-15-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 10, "CASE:2-2-15-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 96
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == 4, "CASE:2-2-15-11")
        assert(ent.function_id == 4, "CASE:2-2-15-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-15-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-15-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-15-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-15-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-15-11")
        assert(ent.request_count == req_count, "CASE:2-2-15-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-15-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-15")
    end
    # CASE:2-2-16
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：プロキシホスト
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>'proxy1.com',
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-16-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 10, "CASE:2-2-16-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 12
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == 1, "CASE:2-2-16-11")
        assert(ent.function_id == 1, "CASE:2-2-16-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-16-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-16-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-16-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-16-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-16-11")
        assert(ent.request_count == req_count, "CASE:2-2-16-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-16-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-16")
    end
    # CASE:2-2-17
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：プロキシIP
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>'192.168.100.2',
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-17-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 10, "CASE:2-2-17-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 24
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == 2, "CASE:2-2-17-11")
        assert(ent.function_id == 2, "CASE:2-2-17-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-17-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-17-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-17-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-17-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-17-11")
        assert(ent.request_count == req_count, "CASE:2-2-17-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-17-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-17")
    end
    # CASE:2-2-18
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：クライアントホスト
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>'client5.com',
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-18-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 10, "CASE:2-2-18-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 192
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == 5, "CASE:2-2-18-11")
        assert(ent.function_id == 5, "CASE:2-2-18-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-18-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-18-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-18-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-18-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-18-11")
        assert(ent.request_count == req_count, "CASE:2-2-18-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-18-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-18")
    end
    # CASE:2-2-19
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：クライアントIP
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>'192.168.200.3'
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-19-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 10, "CASE:2-2-19-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 48
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == 3, "CASE:2-2-19-11")
        assert(ent.function_id == 3, "CASE:2-2-19-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-19-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-19-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-19-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-19-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-19-11")
        assert(ent.request_count == req_count, "CASE:2-2-19-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-19-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-19")
    end
    # CASE:2-2-20
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：全て
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>'accept_language',
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>'4',
                        :function_id=>'4',
                        :function_trans_no=>'4',
                        :function_trans_no_comp=>'EQ',
                        :session_id=>'01234567890123456789012345678904',
                        :client_id=>'Client_ID_4',
                        :browser_id=>'4',
                        :browser_version_id=>'4',
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>'ja_4',
                        :referrer=>'http://www.fc2.com/',
                        :referrer_match=>'F',
                        :domain_name=>'domain4.jp',
                        :domain_name_match=>'F',
                        :proxy_host=>'proxy4.com',
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>'192.168.100.4',
                        :remote_host=>'client4.com',
                        :remote_host_match=>'F',
                        :ip_address=>'192.168.200.4'
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-20-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 10, "CASE:2-2-20-11")
      # 検索結果内容
      ent_cnt = 0
      req_count = 96
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 0)
      action.result_list.each do |ent|
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == 4, "CASE:2-2-20-11")
        assert(ent.function_id == 4, "CASE:2-2-20-11")
        assert(ent.accept_language == 'ja_4', "CASE:2-2-20-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-20-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-20-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-20-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-20-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-20-11")
        assert(ent.request_count == req_count, "CASE:2-2-20-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-20-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-20")
    end
    ###########################################################################
    # ソート条件
    ###########################################################################
    # CASE:2-2-21
    # 正常ケース
    # テスト内容：抽出条件チェック
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID
    # 時間単位：分
    # 単位数：1
    # 機関数：10
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'5',
                        :disp_order=>'ASC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'1',
                        :time_unit=>'minute',
                        :aggregation_period=>'10',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-2-21-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 50, "CASE:2-2-21-11")
      # 検索結果内容
      ent_cnt = 0
      type_val = 1
      req_count = 12
      ref_datetime = DateTime.new(2007, 10, 9, 10, 20, 20)
      action.result_list.each do |ent|
        if ent_cnt == 10 then
          ent_cnt = 0
          type_val += 1
          req_count *= 2
        end
        datetime = ref_datetime + ent_cnt.minutes
        assert(ent.system_id == type_val, "CASE:2-2-21-11")
        assert(ent.function_id == type_val, "CASE:2-2-21-11")
        assert(ent.received_year == datetime.year, "CASE:2-2-21-11")
        assert(ent.received_month == datetime.month, "CASE:2-2-21-11")
        assert(ent.received_day == datetime.day, "CASE:2-2-21-11")
        assert(ent.received_hour == datetime.hour, "CASE:2-2-21-11")
        assert(ent.received_minute == datetime.min, "CASE:2-2-21-11")
        assert(ent.request_count == req_count, "CASE:2-2-21-11")
        ent_cnt += 1
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-2-21-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-21")
    end
  end

  # 項目値リスト編集処理
  test "2-3:TotalizationAction Test:to_item_values" do
    ###########################################################################
    # テストデータ生成
    ###########################################################################
    create_data
    ###########################################################################
    # 集計結果項目値リスト生成
    ###########################################################################
    # CASE:2-3-1
    # 正常ケース
    # テスト内容：線分類項目全部
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID、ブラウザID、ブラウザバージョンID、プロキシホスト
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：降順
    # 件数：8件
    # 抽出条件：なし
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>'browser_id',
                        :item_4=>'browser_version_id',
                        :item_5=>'proxy_host',
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-3-1-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
      # 項目値リスト検証
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.item_values.size == 8, "CASE:2-3-1-2")
      # 検索結果内容
      item_values = action.item_values
      headder_list = 'ABCDEFGH'.split('')
      item_values.each_with_index do |values, idx|
        type_no = 15 - idx
#        print_log('values:' + values.to_s)
        assert(values[0] == headder_list[idx], "CASE:2-3-1-3")
        assert(values[1] == ('System Name ' + type_no.to_s + '　SubSystem Name ' + type_no.to_s), "CASE:2-3-1-3")
        assert(values[2] == 'Function Name ' + type_no.to_s, "CASE:2-3-1-3")
        assert(values[3] == 'Browser Name ' + type_no.to_s, "CASE:2-3-1-3")
        assert(values[4] == 'Browser Version ' + type_no.to_s, "CASE:2-3-1-3")
        assert(values[5] == 'proxy' + type_no.to_s + '.com', "CASE:2-3-1-3")
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-3-1-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-1")
    end
    # CASE:2-3-2
    # 正常ケース
    # テスト内容：線分類項目一つ
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：昇順
    # 件数：8件
    # 抽出条件：なし
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'proxy_host',
                        :item_2=>nil,
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'8',
                        :disp_order=>'ASC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-3-2-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
      # 項目値リスト検証
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.item_values.size == 8, "CASE:2-3-2-2")
      # 検索結果内容
      item_values = action.item_values
      headder_list = 'ABCDEFGH'.split('')
      item_values.each_with_index do |values, idx|
        type_no = idx + 1
#        print_log('values:' + values.to_s)
        assert(values[0] == headder_list[idx], "CASE:2-3-2-3")
        assert(values[1] == 'proxy' + type_no.to_s + '.com', "CASE:2-3-2-3")
        assert(values[2].nil?, "CASE:2-3-2-3")
        assert(values[3].nil?, "CASE:2-3-2-3")
        assert(values[4].nil?, "CASE:2-3-2-3")
        assert(values[5].nil?, "CASE:2-3-2-3")
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-3-2-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-2")
    end
    # CASE:2-3-3
    # 正常ケース
    # テスト内容：線分類項目全部、マスタが存在しない
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID、ブラウザID、ブラウザバージョンID、プロキシホスト
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：降順
    # 件数：8件
    # 抽出条件：なし
    begin
      # マスタデータ削除
      @generator.delete_master
      # テスト実行
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>'browser_id',
                        :item_4=>'browser_version_id',
                        :item_5=>'proxy_host',
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-3-3-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
      # 項目値リスト検証
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.item_values.size == 8, "CASE:2-3-3-2")
      # 検索結果内容
      item_values = action.item_values
      headder_list = 'ABCDEFGH'.split('')
      item_values.each_with_index do |values, idx|
        type_no = 15 - idx
#        print_log('values:' + values.to_s)
        assert(values[0] == headder_list[idx], "CASE:2-3-3-3")
        assert(values[1] == '', "CASE:2-3-3-3")
        assert(values[2] == '', "CASE:2-3-3-3")
        assert(values[3] == '', "CASE:2-3-3-3")
        assert(values[4] == '', "CASE:2-3-3-3")
        assert(values[5] == 'proxy' + type_no.to_s + '.com', "CASE:2-3-3-3")
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-3-3-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-3")
    end
  end

  # グラフデータ編集処理
  test "2-4:TotalizationAction Test:to_graph_data" do
    ###########################################################################
    # テストデータ生成
    ###########################################################################
    create_data
    ###########################################################################
    # 集計結果項目値リスト生成
    ###########################################################################
    # CASE:2-4-1
    # 正常ケース
    # テスト内容：間欠無し
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID、ブラウザID、ブラウザバージョンID、プロキシホスト
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：降順
    # 件数：8件
    # 抽出条件：なし
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>'browser_id',
                        :item_4=>'browser_version_id',
                        :item_5=>'proxy_host',
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-4-1-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 480, "CASE:2-4-1-2")
      graph_data = action.graph_data
      # 検索結果内容
      req_count = 49152
      8.times do |i|
        line_data = graph_data[i]
        20.times do |j|
          assert(line_data[j] == req_count, "CASE:2-4-1-3")
        end
        req_count /= 2
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-4-1-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-1")
    end
    # CASE:2-4-2
    # 正常ケース
    # テスト内容：間欠有り
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID、ブラウザID、ブラウザバージョンID、プロキシホスト
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：降順
    # 件数：8件
    # 抽出条件：なし
    begin
      # 線データ削除
      RequestAnalysisResult.where(:system_id=>15).delete_all
      RequestAnalysisResult.where(:system_id=>13).delete_all
      RequestAnalysisResult.where(:system_id=>10).delete_all
      RequestAnalysisResult.where(:system_id=>9).delete_all
      # 時間データ削除
      RequestAnalysisResult.where(:received_second=>5).delete_all
      RequestAnalysisResult.where(:received_second=>15).delete_all
      RequestAnalysisResult.where(:received_second=>20).delete_all
      RequestAnalysisResult.where(:received_second=>55).delete_all
      # データ削除
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>'browser_id',
                        :item_4=>'browser_version_id',
                        :item_5=>'proxy_host',
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-4-2-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 320, "CASE:2-4-2-2")
      graph_data = action.graph_data
      # 検索結果内容
      cnt_list = [8192, 2048, 1024, 128, 64, 32, 16, 8]
      unit_cnt = [2,3,2,1,2,3,2,1,2,3,2,1,2,3,2,1,2,3,2,1]
      8.times do |i|
        line_data = graph_data[i]
#        print_log('line_data:' + line_data.to_s)
        20.times do |j|
          assert(line_data[j] == (cnt_list[i] * unit_cnt[j]), "CASE:2-4-2-3")
        end
        req_count /= 2
      end
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-4-2-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-2")
    end
    # CASE:2-4-3
    # 正常ケース
    # テスト内容：対象データなし
    # 受信日時：2007/10/09 10:20:30
    # 線分類：システムＩＤ、機能ID、ブラウザID、ブラウザバージョンID、プロキシホスト
    # 時間単位：秒
    # 単位数：15
    # 機関数：20
    # 並び順：降順
    # 件数：8件
    # 抽出条件：なし
    begin
      # 線データ削除
      RequestAnalysisResult.delete_all
      # データ削除
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_id',
                        :item_3=>'browser_id',
                        :item_4=>'browser_version_id',
                        :item_5=>'proxy_host',
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'second',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>nil,
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>nil,
                        :referrer=>nil,
                        :referrer_match=>'F',
                        :domain_name=>nil,
                        :domain_name_match=>'F',
                        :proxy_host=>nil,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>nil,
                        :remote_host=>nil,
                        :remote_host_match=>'F',
                        :ip_address=>nil
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-4-3-1")
      # バリデーション
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      # 集計処理実行
      action.totalization
      # 検索結果件数
#      print_log('Result Size:' + action.result_list.size.to_s)
      assert(action.result_list.size == 0, "CASE:2-4-3-2")
      assert(action.graph_data.empty?, "CASE:2-4-3-3")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-4-3-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-3")
    end
  end

  # データ生成処理
  def create_data
    ###########################################################################
    # テストデータ生成処理
    ###########################################################################
    # 基準日時
    datetime = Time.new(2007, 10, 9, 10, 20, 0)
    # マスタデータ生成
    @generator.create_master
    # スケジュールデータ生成
    @generator.create_schedule(datetime)
    # 解析結果データ再生成
    RequestAnalysisResult.delete_all
    ActiveRecord::Base.transaction do
#      save_count = 0
      120.times do |i|
        rcvd_dt = datetime + (i * 5).seconds
#        print_log('rcvd_dt:' + rcvd_dt.to_s)
#        print_log('Counter i:' + i.to_s)
        15.times do |j|
          @generator.result_data(j + 1, rcvd_dt).save
#          save_count += 1
        end
      end
#      print_log('Save Count:' + save_count.to_s)
#      print_log('All Count:' + RequestAnalysisResult.all.count.to_s)
    end
  end

end