# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：AccessTotal::AccessTotalController
# アクション：
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/10/15 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/access_total/totalization_action'

class BaseActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::AccessTotal
  include Mock
  # 前処理
  def setup
    Time.zone = 3/8
  end
  # 後処理
#  def teardown
#  end
  # 単項目チェック（線分類）
  test "2-1:BaseAction Test:line_cond_chk?" do
    ###########################################################################
    # 線分類項目チェック
    ###########################################################################
    # CASE:2-1-1
    # 正常ケース
    # 線分類項目１のみ指定
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
                        :time_unit=>'minute',
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
      assert(!action.nil?, "CASE:2-1-1-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-1-1-2")
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
      assert(action.time_unit_num == '15', "CASE:2-1-1-3")
      assert(action.time_unit == 'minute', "CASE:2-1-1-3")
      assert(action.aggregation_period == '20', "CASE:2-1-1-3")
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
      assert(action.domain_name.nil?, "CASE:2-1-1-6")
      assert(action.domain_name_match == 'F', "CASE:2-1-1-6")
      assert(action.proxy_host.nil?, "CASE:2-1-1-6")
      assert(action.proxy_host_match == 'F', "CASE:2-1-1-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-1-1-6")
      assert(action.remote_host.nil?, "CASE:2-1-1-6")
      assert(action.remote_host_match == 'F', "CASE:2-1-1-6")
      assert(action.ip_address.nil?, "CASE:2-1-1-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-1-1-6")
      assert(action.item_values.empty?, "CASE:2-1-1-6")
      assert(action.graph_data.empty?, "CASE:2-1-1-6")
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
    # 線分類項目１~５まで指定
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'browser_id',
                        :item_2=>'function_id',
                        :item_3=>'domain_name',
                        :item_4=>'remote_host',
                        :item_5=>'client_id',
                        :disp_number=>'5',
                        :disp_order=>'ASC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'minute',
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
      assert(!action.nil?, "CASE:2-1-2-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-1-2-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'browser_id', "CASE:2-1-2-3")
      assert(action.item_2 == 'function_id', "CASE:2-1-2-3")
      assert(action.item_3 == 'domain_name', "CASE:2-1-2-3")
      assert(action.item_4 == 'remote_host', "CASE:2-1-2-3")
      assert(action.item_5 == 'client_id', "CASE:2-1-2-3")
      assert(action.disp_number == '5', "CASE:2-1-2-3")
      assert(action.disp_order == 'ASC', "CASE:2-1-2-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-1-2-3")
      assert(action.time_unit_num == '15', "CASE:2-1-2-3")
      assert(action.time_unit == 'minute', "CASE:2-1-2-3")
      assert(action.aggregation_period == '20', "CASE:2-1-2-3")
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
      assert(action.domain_name.nil?, "CASE:2-1-2-6")
      assert(action.domain_name_match == 'F', "CASE:2-1-2-6")
      assert(action.proxy_host.nil?, "CASE:2-1-2-6")
      assert(action.proxy_host_match == 'F', "CASE:2-1-2-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-1-2-6")
      assert(action.remote_host.nil?, "CASE:2-1-2-6")
      assert(action.remote_host_match == 'F', "CASE:2-1-2-6")
      assert(action.ip_address.nil?, "CASE:2-1-2-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-1-2-6")
      assert(action.item_values.empty?, "CASE:2-1-2-6")
      assert(action.graph_data.empty?, "CASE:2-1-2-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-1-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # CASE:2-1-3
    # 異常ケース
    # 線分類項目全て未指定
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>nil,
                        :item_2=>nil,
                        :item_3=>nil,
                        :item_4=>nil,
                        :item_5=>nil,
                        :disp_number=>'5',
                        :disp_order=>'ASC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'minute',
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
      assert(!action.nil?, "CASE:2-1-3-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-1-3-2")
      # アクセサ（線分類）
      assert(action.item_1.nil?, "CASE:2-1-3-3")
      assert(action.item_2.nil?, "CASE:2-1-3-3")
      assert(action.item_3.nil?, "CASE:2-1-3-3")
      assert(action.item_4.nil?, "CASE:2-1-3-3")
      assert(action.item_5.nil?, "CASE:2-1-3-3")
      assert(action.disp_number == '5', "CASE:2-1-3-3")
      assert(action.disp_order == 'ASC', "CASE:2-1-3-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-1-3-3")
      assert(action.time_unit_num == '15', "CASE:2-1-3-3")
      assert(action.time_unit == 'minute', "CASE:2-1-3-3")
      assert(action.aggregation_period == '20', "CASE:2-1-3-3")
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
      assert(action.domain_name.nil?, "CASE:2-1-3-6")
      assert(action.domain_name_match == 'F', "CASE:2-1-3-6")
      assert(action.proxy_host.nil?, "CASE:2-1-3-6")
      assert(action.proxy_host_match == 'F', "CASE:2-1-3-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-1-3-6")
      assert(action.remote_host.nil?, "CASE:2-1-3-6")
      assert(action.remote_host_match == 'F', "CASE:2-1-3-6")
      assert(action.ip_address.nil?, "CASE:2-1-3-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-1-3-6")
      assert(action.item_values.empty?, "CASE:2-1-3-6")
      assert(action.graph_data.empty?, "CASE:2-1-3-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      error_msg_hash = action.error_msg_hash
      assert(error_msg_hash.size == 1, "CASE:2-1-3-11")
      assert(error_msg_hash[:item_1] == '第１項目 は不正な値です。', "CASE:2-1-3-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # CASE:2-1-4
    # 異常ケース
    # 線分類項目全て未指定、全てエラー値
    # 表示順序、表示件数もエラー
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'none_1',
                        :item_2=>'none_2',
                        :item_3=>'none_3',
                        :item_4=>'none_4',
                        :item_5=>'none_5',
                        :disp_number=>'6',
                        :disp_order=>'ASDC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'minute',
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
      assert(!action.nil?, "CASE:2-1-4-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-1-4-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'none_1', "CASE:2-1-4-3")
      assert(action.item_2 == 'none_2', "CASE:2-1-4-3")
      assert(action.item_3 == 'none_3', "CASE:2-1-4-3")
      assert(action.item_4 == 'none_4', "CASE:2-1-4-3")
      assert(action.item_5 == 'none_5', "CASE:2-1-4-3")
      assert(action.disp_number == '6', "CASE:2-1-4-3")
      assert(action.disp_order == 'ASDC', "CASE:2-1-4-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-1-4-3")
      assert(action.time_unit_num == '15', "CASE:2-1-4-3")
      assert(action.time_unit == 'minute', "CASE:2-1-4-3")
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
      assert(action.domain_name.nil?, "CASE:2-1-4-6")
      assert(action.domain_name_match == 'F', "CASE:2-1-4-6")
      assert(action.proxy_host.nil?, "CASE:2-1-4-6")
      assert(action.proxy_host_match == 'F', "CASE:2-1-4-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-1-4-6")
      assert(action.remote_host.nil?, "CASE:2-1-4-6")
      assert(action.remote_host_match == 'F', "CASE:2-1-4-6")
      assert(action.ip_address.nil?, "CASE:2-1-4-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-1-4-6")
      assert(action.item_values.empty?, "CASE:2-1-4-6")
      assert(action.graph_data.empty?, "CASE:2-1-4-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      error_msg_hash = action.error_msg_hash
      assert(error_msg_hash.size == 6, "CASE:2-1-4-11")
      assert(error_msg_hash[:item_1] == '第１項目 は不正な値です。', "CASE:2-1-4-11")
      assert(error_msg_hash[:item_2] == '第２項目 は不正な値です。', "CASE:2-1-4-11")
      assert(error_msg_hash[:item_3] == '第３項目 は不正な値です。', "CASE:2-1-4-11")
      assert(error_msg_hash[:item_4] == '第４項目 は不正な値です。', "CASE:2-1-4-11")
      assert(error_msg_hash[:item_5] == '第５項目 は不正な値です。', "CASE:2-1-4-11")
      assert(error_msg_hash[:disp_cond] == '表示対象 は不正な値です。', "CASE:2-1-4-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
    # CASE:2-1-5
    # 異常ケース
    # 線分類項目全て未指定、全てエラー値
    # 表示順序エラー
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'none_1',
                        :item_2=>'none_2',
                        :item_3=>'none_3',
                        :item_4=>'none_4',
                        :item_5=>'none_5',
                        :disp_number=>'8',
                        :disp_order=>'ERROR',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'minute',
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
      assert(!action.nil?, "CASE:2-1-5-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-1-5-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'none_1', "CASE:2-1-5-3")
      assert(action.item_2 == 'none_2', "CASE:2-1-5-3")
      assert(action.item_3 == 'none_3', "CASE:2-1-5-3")
      assert(action.item_4 == 'none_4', "CASE:2-1-5-3")
      assert(action.item_5 == 'none_5', "CASE:2-1-5-3")
      assert(action.disp_number == '8', "CASE:2-1-5-3")
      assert(action.disp_order == 'ERROR', "CASE:2-1-5-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-1-5-3")
      assert(action.time_unit_num == '15', "CASE:2-1-5-3")
      assert(action.time_unit == 'minute', "CASE:2-1-5-3")
      assert(action.aggregation_period == '20', "CASE:2-1-5-3")
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
      assert(action.domain_name.nil?, "CASE:2-1-5-6")
      assert(action.domain_name_match == 'F', "CASE:2-1-5-6")
      assert(action.proxy_host.nil?, "CASE:2-1-5-6")
      assert(action.proxy_host_match == 'F', "CASE:2-1-5-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-1-5-6")
      assert(action.remote_host.nil?, "CASE:2-1-5-6")
      assert(action.remote_host_match == 'F', "CASE:2-1-5-6")
      assert(action.ip_address.nil?, "CASE:2-1-5-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-1-5-6")
      assert(action.item_values.empty?, "CASE:2-1-5-6")
      assert(action.graph_data.empty?, "CASE:2-1-5-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      error_msg_hash = action.error_msg_hash
      assert(error_msg_hash.size == 6, "CASE:2-1-5-11")
      assert(error_msg_hash[:item_1] == '第１項目 は不正な値です。', "CASE:2-1-5-11")
      assert(error_msg_hash[:item_2] == '第２項目 は不正な値です。', "CASE:2-1-5-11")
      assert(error_msg_hash[:item_3] == '第３項目 は不正な値です。', "CASE:2-1-5-11")
      assert(error_msg_hash[:item_4] == '第４項目 は不正な値です。', "CASE:2-1-5-11")
      assert(error_msg_hash[:item_5] == '第５項目 は不正な値です。', "CASE:2-1-5-11")
      assert(error_msg_hash[:disp_cond] == '表示対象 は不正な値です。', "CASE:2-1-5-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-5")
    end
    # CASE:2-1-6
    # 異常ケース
    # 線分類項目全て未指定、全てエラー値
    # 表示件数エラー
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'none_1',
                        :item_2=>'none_2',
                        :item_3=>'none_3',
                        :item_4=>'none_4',
                        :item_5=>'none_5',
                        :disp_number=>'10',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'minute',
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
      assert(!action.nil?, "CASE:2-1-6-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-1-6-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'none_1', "CASE:2-1-6-3")
      assert(action.item_2 == 'none_2', "CASE:2-1-6-3")
      assert(action.item_3 == 'none_3', "CASE:2-1-6-3")
      assert(action.item_4 == 'none_4', "CASE:2-1-6-3")
      assert(action.item_5 == 'none_5', "CASE:2-1-6-3")
      assert(action.disp_number == '10', "CASE:2-1-6-3")
      assert(action.disp_order == 'DESC', "CASE:2-1-6-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-1-6-3")
      assert(action.time_unit_num == '15', "CASE:2-1-6-3")
      assert(action.time_unit == 'minute', "CASE:2-1-6-3")
      assert(action.aggregation_period == '20', "CASE:2-1-6-3")
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
      assert(action.domain_name.nil?, "CASE:2-1-6-6")
      assert(action.domain_name_match == 'F', "CASE:2-1-6-6")
      assert(action.proxy_host.nil?, "CASE:2-1-6-6")
      assert(action.proxy_host_match == 'F', "CASE:2-1-6-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-1-6-6")
      assert(action.remote_host.nil?, "CASE:2-1-6-6")
      assert(action.remote_host_match == 'F', "CASE:2-1-6-6")
      assert(action.ip_address.nil?, "CASE:2-1-6-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-1-6-6")
      assert(action.item_values.empty?, "CASE:2-1-6-6")
      assert(action.graph_data.empty?, "CASE:2-1-6-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      error_msg_hash = action.error_msg_hash
      assert(error_msg_hash.size == 6, "CASE:2-1-6-11")
      assert(error_msg_hash[:item_1] == '第１項目 は不正な値です。', "CASE:2-1-6-11")
      assert(error_msg_hash[:item_2] == '第２項目 は不正な値です。', "CASE:2-1-6-11")
      assert(error_msg_hash[:item_3] == '第３項目 は不正な値です。', "CASE:2-1-6-11")
      assert(error_msg_hash[:item_4] == '第４項目 は不正な値です。', "CASE:2-1-6-11")
      assert(error_msg_hash[:item_5] == '第５項目 は不正な値です。', "CASE:2-1-6-11")
      assert(error_msg_hash[:disp_cond] == '表示対象 は不正な値です。', "CASE:2-1-6-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-6")
    end
  end
  
  # 単項目チェック（横軸）
  test "2-2:BaseAction Test:horizontal_axis_chk?" do
    ###########################################################################
    # 横軸項目チェック
    ###########################################################################
    # CASE:2-2-1
    # 正常ケース
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
                        :time_unit=>'minute',
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
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-2-1-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-2-1-3")
      assert(action.item_2.nil?, "CASE:2-2-1-3")
      assert(action.item_3.nil?, "CASE:2-2-1-3")
      assert(action.item_4.nil?, "CASE:2-2-1-3")
      assert(action.item_5.nil?, "CASE:2-2-1-3")
      assert(action.disp_number == '8', "CASE:2-2-1-3")
      assert(action.disp_order == 'DESC', "CASE:2-2-1-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-2-1-3")
      assert(action.time_unit_num == '15', "CASE:2-2-1-3")
      assert(action.time_unit == 'minute', "CASE:2-2-1-3")
      assert(action.aggregation_period == '20', "CASE:2-2-1-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-2-1-3")
      assert(action.function_id.nil?, "CASE:2-2-1-4")
      assert(action.function_trans_no.nil?, "CASE:2-2-1-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-2-1-6")
      assert(action.session_id.nil?, "CASE:2-2-1-6")
      assert(action.client_id.nil?, "CASE:2-2-1-6")
      assert(action.browser_id.nil?, "CASE:2-2-1-6")
      assert(action.browser_version_id.nil?, "CASE:2-2-1-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-2-1-6")
      assert(action.accept_language.nil?, "CASE:2-2-1-6")
      assert(action.referrer.nil?, "CASE:2-2-1-6")
      assert(action.referrer_match == 'F', "CASE:2-2-1-6")
      assert(action.domain_name.nil?, "CASE:2-2-1-6")
      assert(action.domain_name_match == 'F', "CASE:2-2-1-6")
      assert(action.proxy_host.nil?, "CASE:2-2-1-6")
      assert(action.proxy_host_match == 'F', "CASE:2-2-1-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-2-1-6")
      assert(action.remote_host.nil?, "CASE:2-2-1-6")
      assert(action.remote_host_match == 'F', "CASE:2-2-1-6")
      assert(action.ip_address.nil?, "CASE:2-2-1-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-2-1-6")
      assert(action.item_values.empty?, "CASE:2-2-1-6")
      assert(action.graph_data.empty?, "CASE:2-2-1-6")
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
    # 異常ケース
    # 横軸値指定なし
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
                        :received_date_from=>nil,
                        :time_unit_num=>nil,
                        :time_unit=>nil,
                        :aggregation_period=>nil,
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
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-2-2-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-2-2-3")
      assert(action.item_2.nil?, "CASE:2-2-2-3")
      assert(action.item_3.nil?, "CASE:2-2-2-3")
      assert(action.item_4.nil?, "CASE:2-2-2-3")
      assert(action.item_5.nil?, "CASE:2-2-2-3")
      assert(action.disp_number == '8', "CASE:2-2-2-3")
      assert(action.disp_order == 'DESC', "CASE:2-2-2-3")
      # アクセサ（横軸）
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(!action.received_date_from.nil?, "CASE:2-2-2-3")
      now = DateTime.now
      assert(action.received_date_from.year == now.year, "CASE:2-2-2-3")
      assert(action.received_date_from.month == now.month, "CASE:2-2-2-3")
      assert(action.received_date_from.day == now.day, "CASE:2-2-2-3")
      assert(action.received_date_from.hour == now.hour, "CASE:2-2-2-3")
      assert(action.received_date_from.minute == now.minute, "CASE:2-2-2-3")
      assert(action.received_date_from.second == 0, "CASE:2-2-2-3")
      assert(action.received_date_from.offset == now.offset, "CASE:2-2-2-3")
      assert(action.time_unit_num == '1', "CASE:2-2-2-3")
      assert(action.time_unit.nil?, "CASE:2-2-2-3")
      assert(action.aggregation_period.nil?, "CASE:2-2-2-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-2-2-3")
      assert(action.function_id.nil?, "CASE:2-2-2-4")
      assert(action.function_trans_no.nil?, "CASE:2-2-2-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-2-2-6")
      assert(action.session_id.nil?, "CASE:2-2-2-6")
      assert(action.client_id.nil?, "CASE:2-2-2-6")
      assert(action.browser_id.nil?, "CASE:2-2-2-6")
      assert(action.browser_version_id.nil?, "CASE:2-2-2-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-2-2-6")
      assert(action.accept_language.nil?, "CASE:2-2-2-6")
      assert(action.referrer.nil?, "CASE:2-2-2-6")
      assert(action.referrer_match == 'F', "CASE:2-2-2-6")
      assert(action.domain_name.nil?, "CASE:2-2-2-6")
      assert(action.domain_name_match == 'F', "CASE:2-2-2-6")
      assert(action.proxy_host.nil?, "CASE:2-2-2-6")
      assert(action.proxy_host_match == 'F', "CASE:2-2-2-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-2-2-6")
      assert(action.remote_host.nil?, "CASE:2-2-2-6")
      assert(action.remote_host_match == 'F', "CASE:2-2-2-6")
      assert(action.ip_address.nil?, "CASE:2-2-2-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-2-2-6")
      assert(action.item_values.empty?, "CASE:2-2-2-6")
      assert(action.graph_data.empty?, "CASE:2-2-2-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      error_msg_hash = action.error_msg_hash
      assert(error_msg_hash.size == 2, "CASE:2-2-2-11")
#      assert(error_msg_hash[:received_date_from] == '受信日時 は不正な値です。', "CASE:2-2-2-11")
      assert(error_msg_hash[:time_unit_cond] == '集計単位 は不正な値です。', "CASE:2-2-2-11")
      assert(error_msg_hash[:aggregation_period] == '集計期間 は不正な値です。', "CASE:2-2-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    # CASE:2-2-3
    # 異常ケース
    # 横軸値、集計単位数以外異常値
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
                        :received_date_from=>'2007/10/09 00:00:00',
                        :time_unit_num=>'100',
                        :time_unit=>'nano',
                        :aggregation_period=>'100',
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
      assert(!action.nil?, "CASE:2-2-3-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-2-3-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-2-3-3")
      assert(action.item_2.nil?, "CASE:2-2-3-3")
      assert(action.item_3.nil?, "CASE:2-2-3-3")
      assert(action.item_4.nil?, "CASE:2-2-3-3")
      assert(action.item_5.nil?, "CASE:2-2-3-3")
      assert(action.disp_number == '8', "CASE:2-2-3-3")
      assert(action.disp_order == 'DESC', "CASE:2-2-3-3")
      # アクセサ（横軸）
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(!action.received_date_from.nil?, "CASE:2-2-3-3")
      assert(action.time_unit_num == '100', "CASE:2-2-3-3")
      assert(action.time_unit == 'nano', "CASE:2-2-3-3")
      assert(action.aggregation_period == '100', "CASE:2-2-3-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-2-3-3")
      assert(action.function_id.nil?, "CASE:2-2-3-4")
      assert(action.function_trans_no.nil?, "CASE:2-2-3-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-2-3-6")
      assert(action.session_id.nil?, "CASE:2-2-3-6")
      assert(action.client_id.nil?, "CASE:2-2-3-6")
      assert(action.browser_id.nil?, "CASE:2-2-3-6")
      assert(action.browser_version_id.nil?, "CASE:2-2-3-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-2-3-6")
      assert(action.accept_language.nil?, "CASE:2-2-3-6")
      assert(action.referrer.nil?, "CASE:2-2-3-6")
      assert(action.referrer_match == 'F', "CASE:2-2-3-6")
      assert(action.domain_name.nil?, "CASE:2-2-3-6")
      assert(action.domain_name_match == 'F', "CASE:2-2-3-6")
      assert(action.proxy_host.nil?, "CASE:2-2-3-6")
      assert(action.proxy_host_match == 'F', "CASE:2-2-3-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-2-3-6")
      assert(action.remote_host.nil?, "CASE:2-2-3-6")
      assert(action.remote_host_match == 'F', "CASE:2-2-3-6")
      assert(action.ip_address.nil?, "CASE:2-2-3-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-2-3-6")
      assert(action.item_values.empty?, "CASE:2-2-3-6")
      assert(action.graph_data.empty?, "CASE:2-2-3-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      error_msg_hash = action.error_msg_hash
      assert(error_msg_hash.size == 2, "CASE:2-2-3-11")
#      assert(error_msg_hash[:received_date_from] == '受信日時 は不正な値です。', "CASE:2-2-3-11")
      assert(error_msg_hash[:time_unit_cond] == '集計単位 は不正な値です。', "CASE:2-2-3-11")
      assert(error_msg_hash[:aggregation_period] == '集計期間 は不正な値です。', "CASE:2-2-3-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-3")
    end
    # CASE:2-2-4
    # 異常ケース
    # 横軸値、集計単位以外異常値
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
                        :received_date_from=>'2007/10/09 00:00:00',
                        :time_unit_num=>'百',
                        :time_unit=>'year',
                        :aggregation_period=>'21',
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
      assert(!action.nil?, "CASE:2-2-4-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-2-4-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-2-4-3")
      assert(action.item_2.nil?, "CASE:2-2-4-3")
      assert(action.item_3.nil?, "CASE:2-2-4-3")
      assert(action.item_4.nil?, "CASE:2-2-4-3")
      assert(action.item_5.nil?, "CASE:2-2-4-3")
      assert(action.disp_number == '8', "CASE:2-2-4-3")
      assert(action.disp_order == 'DESC', "CASE:2-2-4-3")
      # アクセサ（横軸）
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(!action.received_date_from.nil?, "CASE:2-2-4-3")
      assert(action.time_unit_num == '百', "CASE:2-2-4-3")
      assert(action.time_unit == 'year', "CASE:2-2-4-3")
      assert(action.aggregation_period == '21', "CASE:2-2-4-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-2-4-3")
      assert(action.function_id.nil?, "CASE:2-2-4-4")
      assert(action.function_trans_no.nil?, "CASE:2-2-4-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-2-4-6")
      assert(action.session_id.nil?, "CASE:2-2-4-6")
      assert(action.client_id.nil?, "CASE:2-2-4-6")
      assert(action.browser_id.nil?, "CASE:2-2-4-6")
      assert(action.browser_version_id.nil?, "CASE:2-2-4-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-2-4-6")
      assert(action.accept_language.nil?, "CASE:2-2-4-6")
      assert(action.referrer.nil?, "CASE:2-2-4-6")
      assert(action.referrer_match == 'F', "CASE:2-2-4-6")
      assert(action.domain_name.nil?, "CASE:2-2-4-6")
      assert(action.domain_name_match == 'F', "CASE:2-2-4-6")
      assert(action.proxy_host.nil?, "CASE:2-2-4-6")
      assert(action.proxy_host_match == 'F', "CASE:2-2-4-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-2-4-6")
      assert(action.remote_host.nil?, "CASE:2-2-4-6")
      assert(action.remote_host_match == 'F', "CASE:2-2-4-6")
      assert(action.ip_address.nil?, "CASE:2-2-4-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-2-4-6")
      assert(action.item_values.empty?, "CASE:2-2-4-6")
      assert(action.graph_data.empty?, "CASE:2-2-4-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      error_msg_hash = action.error_msg_hash
      assert(error_msg_hash.size == 2, "CASE:2-2-4-11")
#      assert(error_msg_hash[:received_date_from] == '受信日時 は不正な値です。', "CASE:2-2-4-11")
      assert(error_msg_hash[:time_unit_cond] == '集計単位 は不正な値です。', "CASE:2-2-4-11")
      assert(error_msg_hash[:aggregation_period] == '集計期間 は不正な値です。', "CASE:2-2-4-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-4")
    end
    # CASE:2-2-5
    # 異常ケース
    # 横軸値、集計単位数０
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
                        :received_date_from=>'2007/10/09 00:00:00',
                        :time_unit_num=>'0',
                        :time_unit=>'year',
                        :aggregation_period=>'21',
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
      assert(!action.nil?, "CASE:2-2-5-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-2-5-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-2-5-3")
      assert(action.item_2.nil?, "CASE:2-2-5-3")
      assert(action.item_3.nil?, "CASE:2-2-5-3")
      assert(action.item_4.nil?, "CASE:2-2-5-3")
      assert(action.item_5.nil?, "CASE:2-2-5-3")
      assert(action.disp_number == '8', "CASE:2-2-5-3")
      assert(action.disp_order == 'DESC', "CASE:2-2-5-3")
      # アクセサ（横軸）
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(!action.received_date_from.nil?, "CASE:2-2-5-3")
      assert(action.time_unit_num == '0', "CASE:2-2-5-3")
      assert(action.time_unit == 'year', "CASE:2-2-5-3")
      assert(action.aggregation_period == '21', "CASE:2-2-5-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-2-5-3")
      assert(action.function_id.nil?, "CASE:2-2-5-4")
      assert(action.function_trans_no.nil?, "CASE:2-2-5-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-2-5-6")
      assert(action.session_id.nil?, "CASE:2-2-5-6")
      assert(action.client_id.nil?, "CASE:2-2-5-6")
      assert(action.browser_id.nil?, "CASE:2-2-5-6")
      assert(action.browser_version_id.nil?, "CASE:2-2-5-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-2-5-6")
      assert(action.accept_language.nil?, "CASE:2-2-5-6")
      assert(action.referrer.nil?, "CASE:2-2-5-6")
      assert(action.referrer_match == 'F', "CASE:2-2-5-6")
      assert(action.domain_name.nil?, "CASE:2-2-5-6")
      assert(action.domain_name_match == 'F', "CASE:2-2-5-6")
      assert(action.proxy_host.nil?, "CASE:2-2-5-6")
      assert(action.proxy_host_match == 'F', "CASE:2-2-5-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-2-5-6")
      assert(action.remote_host.nil?, "CASE:2-2-5-6")
      assert(action.remote_host_match == 'F', "CASE:2-2-5-6")
      assert(action.ip_address.nil?, "CASE:2-2-5-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-2-5-6")
      assert(action.item_values.empty?, "CASE:2-2-5-6")
      assert(action.graph_data.empty?, "CASE:2-2-5-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      error_msg_hash = action.error_msg_hash
      assert(error_msg_hash.size == 2, "CASE:2-2-5-11")
#      assert(error_msg_hash[:received_date_from] == '受信日時 は不正な値です。', "CASE:2-2-5-11")
      assert(error_msg_hash[:time_unit_cond] == '集計単位 は不正な値です。', "CASE:2-2-5-11")
      assert(error_msg_hash[:aggregation_period] == '集計期間 は不正な値です。', "CASE:2-2-5-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-5")
    end
  end
  
  # 単項目チェック（抽出条件）
  test "2-3:BaseAction Test:extraction_cond_chk?" do
    ###########################################################################
    # 抽出条件項目チェック
    ###########################################################################
    # CASE:2-3-1
    # 正常ケース
    # 抽出条件：値指定なし
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
                        :time_unit=>'minute',
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
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-3-1-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-3-1-3")
      assert(action.item_2.nil?, "CASE:2-3-1-3")
      assert(action.item_3.nil?, "CASE:2-3-1-3")
      assert(action.item_4.nil?, "CASE:2-3-1-3")
      assert(action.item_5.nil?, "CASE:2-3-1-3")
      assert(action.disp_number == '8', "CASE:2-3-1-3")
      assert(action.disp_order == 'DESC', "CASE:2-3-1-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-3-1-3")
      assert(action.time_unit_num == '15', "CASE:2-3-1-3")
      assert(action.time_unit == 'minute', "CASE:2-3-1-3")
      assert(action.aggregation_period == '20', "CASE:2-3-1-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-3-1-3")
      assert(action.function_id.nil?, "CASE:2-3-1-4")
      assert(action.function_trans_no.nil?, "CASE:2-3-1-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-3-1-6")
      assert(action.session_id.nil?, "CASE:2-3-1-6")
      assert(action.client_id.nil?, "CASE:2-3-1-6")
      assert(action.browser_id.nil?, "CASE:2-3-1-6")
      assert(action.browser_version_id.nil?, "CASE:2-3-1-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-3-1-6")
      assert(action.accept_language.nil?, "CASE:2-3-1-6")
      assert(action.referrer.nil?, "CASE:2-3-1-6")
      assert(action.referrer_match == 'F', "CASE:2-3-1-6")
      assert(action.domain_name.nil?, "CASE:2-3-1-6")
      assert(action.domain_name_match == 'F', "CASE:2-3-1-6")
      assert(action.proxy_host.nil?, "CASE:2-3-1-6")
      assert(action.proxy_host_match == 'F', "CASE:2-3-1-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-3-1-6")
      assert(action.remote_host.nil?, "CASE:2-3-1-6")
      assert(action.remote_host_match == 'F', "CASE:2-3-1-6")
      assert(action.ip_address.nil?, "CASE:2-3-1-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-3-1-6")
      assert(action.item_values.empty?, "CASE:2-3-1-6")
      assert(action.graph_data.empty?, "CASE:2-3-1-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-3-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-1")
    end
    # CASE:2-3-2
    # 正常ケース
    # 抽出条件：全ての値を指定
    begin
      session_id = generate_str(CHAR_SET_ALPHANUMERIC, 32)
      client_id = generate_str(CHAR_SET_ALPHANUMERIC, 255)
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>'1',
                        :function_id=>'2',
                        :function_trans_no=>'3',
                        :function_trans_no_comp=>'EQ',
                        :session_id=>session_id,
                        :client_id=>client_id,
                        :browser_id=>'1',
                        :browser_version_id=>'2',
                        :browser_version_id_comp=>'NE',
                        :accept_language=>'ja',
                        :referrer=>'http://www.yahoo.co.jp',
                        :referrer_match=>'E',
                        :domain_name=>'test.jp',
                        :domain_name_match=>'F',
                        :proxy_host=>'proxy.nifty.com',
                        :proxy_host_match=>'P',
                        :proxy_ip_address=>'192',
                        :remote_host=>'client.nifty.com',
                        :remote_host_match=>'B',
                        :ip_address=>'192.168.100.200'
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-3-2-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-3-2-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-3-2-3")
      assert(action.item_2.nil?, "CASE:2-3-2-3")
      assert(action.item_3.nil?, "CASE:2-3-2-3")
      assert(action.item_4.nil?, "CASE:2-3-2-3")
      assert(action.item_5.nil?, "CASE:2-3-2-3")
      assert(action.disp_number == '8', "CASE:2-3-2-3")
      assert(action.disp_order == 'DESC', "CASE:2-3-2-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-3-2-3")
      assert(action.time_unit_num == '15', "CASE:2-3-2-3")
      assert(action.time_unit == 'minute', "CASE:2-3-2-3")
      assert(action.aggregation_period == '20', "CASE:2-3-2-3")
      # アクセサ（抽出条件）
      assert(action.system_id == '1', "CASE:2-3-2-3")
      assert(action.function_id == '2', "CASE:2-3-2-4")
      assert(action.function_trans_no == '3', "CASE:2-3-2-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-3-2-6")
      assert(action.session_id == session_id, "CASE:2-3-2-6")
      assert(action.client_id == client_id, "CASE:2-3-2-6")
      assert(action.browser_id == '1', "CASE:2-3-2-6")
      assert(action.browser_version_id == '2', "CASE:2-3-2-6")
      assert(action.browser_version_id_comp == 'NE', "CASE:2-3-2-6")
      assert(action.accept_language == 'ja', "CASE:2-3-2-6")
      assert(action.referrer == 'http://www.yahoo.co.jp', "CASE:2-3-2-6")
      assert(action.referrer_match == 'E', "CASE:2-3-2-6")
      assert(action.domain_name == 'test.jp', "CASE:2-3-2-6")
      assert(action.domain_name_match == 'F', "CASE:2-3-2-6")
      assert(action.proxy_host == 'proxy.nifty.com', "CASE:2-3-2-6")
      assert(action.proxy_host_match == 'P', "CASE:2-3-2-6")
      assert(action.proxy_ip_address == '192', "CASE:2-3-2-6")
      assert(action.remote_host == 'client.nifty.com', "CASE:2-3-2-6")
      assert(action.remote_host_match == 'B', "CASE:2-3-2-6")
      assert(action.ip_address == '192.168.100.200', "CASE:2-3-2-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-3-2-6")
      assert(action.item_values.empty?, "CASE:2-3-2-6")
      assert(action.graph_data.empty?, "CASE:2-3-2-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-3-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-2")
    end
    # CASE:2-3-3
    # 異常ケース
    # 抽出条件：全ての値を指定、全てエラー値（桁数エラー優先）
    begin
      err_session_id = generate_str(CHAR_SET_HANKAKU, 256)
      err_client_id = generate_str(CHAR_SET_HANKAKU, 256)
      err_lang = generate_str(CHAR_SET_HANKAKU, 256)
      err_referrer = generate_str(CHAR_SET_HANKAKU, 256)
      err_domain_name = generate_str(CHAR_SET_HANKAKU, 256)
      err_proxy_host = generate_str(CHAR_SET_HANKAKU, 256)
      err_remote_host = generate_str(CHAR_SET_HANKAKU, 256)
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>'１',
                        :function_id=>'２',
                        :function_trans_no=>'３',
                        :function_trans_no_comp=>'=',
                        :session_id=>err_session_id,
                        :client_id=>err_client_id,
                        :browser_id=>'１',
                        :browser_version_id=>'２',
                        :browser_version_id_comp=>'=',
                        :accept_language=>err_lang,
                        :referrer=>err_referrer,
                        :referrer_match=>'=',
                        :domain_name=>err_domain_name,
                        :domain_name_match=>'=',
                        :proxy_host=>err_proxy_host,
                        :proxy_host_match=>'=',
                        :proxy_ip_address=>'256.168.100.100',
                        :remote_host=>err_remote_host,
                        :remote_host_match=>'=',
                        :ip_address=>'192.168.100.256'
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-3-3-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-3-3-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-3-3-3")
      assert(action.item_2.nil?, "CASE:2-3-3-3")
      assert(action.item_3.nil?, "CASE:2-3-3-3")
      assert(action.item_4.nil?, "CASE:2-3-3-3")
      assert(action.item_5.nil?, "CASE:2-3-3-3")
      assert(action.disp_number == '8', "CASE:2-3-3-3")
      assert(action.disp_order == 'DESC', "CASE:2-3-3-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-3-3-3")
      assert(action.time_unit_num == '15', "CASE:2-3-3-3")
      assert(action.time_unit == 'minute', "CASE:2-3-3-3")
      assert(action.aggregation_period == '20', "CASE:2-3-3-3")
      # アクセサ（抽出条件）
      assert(action.system_id == '１', "CASE:2-3-3-3")
      assert(action.function_id == '２', "CASE:2-3-3-4")
      assert(action.function_trans_no == '３', "CASE:2-3-3-5")
      assert(action.function_trans_no_comp == '=', "CASE:2-3-3-6")
      assert(action.session_id == err_session_id, "CASE:2-3-3-6")
      assert(action.client_id == err_client_id, "CASE:2-3-3-6")
      assert(action.browser_id == '１', "CASE:2-3-3-6")
      assert(action.browser_version_id == '２', "CASE:2-3-3-6")
      assert(action.browser_version_id_comp == '=', "CASE:2-3-3-6")
      assert(action.accept_language == err_lang, "CASE:2-3-3-6")
      assert(action.referrer == err_referrer, "CASE:2-3-3-6")
      assert(action.referrer_match == '=', "CASE:2-3-3-6")
      assert(action.domain_name == err_domain_name, "CASE:2-3-3-6")
      assert(action.domain_name_match == '=', "CASE:2-3-3-6")
      assert(action.proxy_host == err_proxy_host, "CASE:2-3-3-6")
      assert(action.proxy_host_match == '=', "CASE:2-3-3-6")
      assert(action.proxy_ip_address == '256.168.100.100', "CASE:2-3-3-6")
      assert(action.remote_host == err_remote_host, "CASE:2-3-3-6")
      assert(action.remote_host_match == '=', "CASE:2-3-3-6")
      assert(action.ip_address == '192.168.100.256', "CASE:2-3-3-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-3-3-6")
      assert(action.item_values.empty?, "CASE:2-3-3-6")
      assert(action.graph_data.empty?, "CASE:2-3-3-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 14, "CASE:2-3-3-11")
      assert(error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:function_id] == '機能名 は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:function_trans_no_cond] == '機能遷移番号 は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:session_id] == 'セッションID は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:client_id] == 'クライアントID は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:browser_id] == 'ブラウザ名 は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:browser_version_cond] == 'ブラウザバージョン は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:accept_language] == '言語 は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:domain_name_cond] == 'ドメイン名 は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:referrer_cond] == 'リファラー は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:proxy_host_cond] == 'プロキシホスト は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:proxy_ip_address] == 'プロキシIP は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:remote_host_cond] == 'クライアントホスト は不正な値です。', "CASE:2-3-3-11")
      assert(error_msg_hash[:ip_address] == 'クライアントIP は不正な値です。', "CASE:2-3-3-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-3")
    end
    # CASE:2-3-4
    # 異常ケース
    # 抽出条件：半角項目と比較条件に値を指定、全てエラー値（属性エラー優先）
    begin
      err_lang = '日本語でござる'
      err_referrer = 'えっちなサイトから来たでごわす'
      err_domain_name = 'ドメイン名は秘密なり'
      err_proxy_host = 'プロキシサーバーなんて使っておりまへんよ'
      err_remote_host = 'リモートホストはひ・み・つ'
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>'1',
                        :function_id=>'2',
                        :function_trans_no=>'3',
                        :function_trans_no_comp=>'=',
                        :session_id=>'123456789012345678901234567890AB',
                        :client_id=>'Client ID',
                        :browser_id=>'1',
                        :browser_version_id=>'2',
                        :browser_version_id_comp=>'=',
                        :accept_language=>err_lang,
                        :referrer=>err_referrer,
                        :referrer_match=>'F',
                        :domain_name=>err_domain_name,
                        :domain_name_match=>'F',
                        :proxy_host=>err_proxy_host,
                        :proxy_host_match=>'F',
                        :proxy_ip_address=>'192.168.100.0',
                        :remote_host=>err_remote_host,
                        :remote_host_match=>'F',
                        :ip_address=>'192.168.200.0'
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-3-4-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-3-4-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-3-4-3")
      assert(action.item_2.nil?, "CASE:2-3-4-3")
      assert(action.item_3.nil?, "CASE:2-3-4-3")
      assert(action.item_4.nil?, "CASE:2-3-4-3")
      assert(action.item_5.nil?, "CASE:2-3-4-3")
      assert(action.disp_number == '8', "CASE:2-3-4-3")
      assert(action.disp_order == 'DESC', "CASE:2-3-4-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-3-4-3")
      assert(action.time_unit_num == '15', "CASE:2-3-4-3")
      assert(action.time_unit == 'minute', "CASE:2-3-4-3")
      assert(action.aggregation_period == '20', "CASE:2-3-4-3")
      # アクセサ（抽出条件）
      assert(action.system_id == '1', "CASE:2-3-4-3")
      assert(action.function_id == '2', "CASE:2-3-4-4")
      assert(action.function_trans_no == '3', "CASE:2-3-4-5")
      assert(action.function_trans_no_comp == '=', "CASE:2-3-4-6")
      assert(action.session_id == '123456789012345678901234567890AB', "CASE:2-3-4-6")
      assert(action.client_id == 'Client ID', "CASE:2-3-4-6")
      assert(action.browser_id == '1', "CASE:2-3-4-6")
      assert(action.browser_version_id == '2', "CASE:2-3-4-6")
      assert(action.browser_version_id_comp == '=', "CASE:2-3-4-6")
      assert(action.accept_language == err_lang, "CASE:2-3-4-6")
      assert(action.referrer == err_referrer, "CASE:2-3-4-6")
      assert(action.referrer_match == 'F', "CASE:2-3-4-6")
      assert(action.domain_name == err_domain_name, "CASE:2-3-4-6")
      assert(action.domain_name_match == 'F', "CASE:2-3-4-6")
      assert(action.proxy_host == err_proxy_host, "CASE:2-3-4-6")
      assert(action.proxy_host_match == 'F', "CASE:2-3-4-6")
      assert(action.proxy_ip_address == '192.168.100.0', "CASE:2-3-4-6")
      assert(action.remote_host == err_remote_host, "CASE:2-3-4-6")
      assert(action.remote_host_match == 'F', "CASE:2-3-4-6")
      assert(action.ip_address == '192.168.200.0', "CASE:2-3-4-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-3-4-6")
      assert(action.item_values.empty?, "CASE:2-3-4-6")
      assert(action.graph_data.empty?, "CASE:2-3-4-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 7, "CASE:2-3-4-11")
      assert(error_msg_hash[:function_trans_no_cond] == '比較条件区分 は不正な値です。', "CASE:2-3-4-11")
      assert(error_msg_hash[:browser_version_cond] == '比較条件区分 は不正な値です。', "CASE:2-3-4-11")
      assert(error_msg_hash[:accept_language] == '言語 は不正な値です。', "CASE:2-3-4-11")
      assert(error_msg_hash[:domain_name_cond] == 'ドメイン名 は不正な値です。', "CASE:2-3-4-11")
      assert(error_msg_hash[:referrer_cond] == 'リファラー は不正な値です。', "CASE:2-3-4-11")
      assert(error_msg_hash[:proxy_host_cond] == 'プロキシホスト は不正な値です。', "CASE:2-3-4-11")
      assert(error_msg_hash[:remote_host_cond] == 'クライアントホスト は不正な値です。', "CASE:2-3-4-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-4")
    end
    # CASE:2-3-5
    # 異常ケース
    # 抽出条件：比較条件に値を指定、全てエラー値
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>'1',
                        :function_id=>'2',
                        :function_trans_no=>'3',
                        :function_trans_no_comp=>'EQ',
                        :session_id=>'123456789012345678901234567890AB',
                        :client_id=>'Client ID',
                        :browser_id=>'1',
                        :browser_version_id=>'2',
                        :browser_version_id_comp=>'EQ',
                        :accept_language=>'ja',
                        :referrer=>'http://www.yahoo.co.jp',
                        :referrer_match=>'FULL',
                        :domain_name=>'domain.com',
                        :domain_name_match=>'FULL',
                        :proxy_host=>'proxy.com',
                        :proxy_host_match=>'FULL',
                        :proxy_ip_address=>'192.168.100.0',
                        :remote_host=>'remote.com',
                        :remote_host_match=>'FULL',
                        :ip_address=>'192.168.200.0'
                        }
             }
      controller = MockController.new(params)
      action = TotalizationAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-3-5-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-3-5-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-3-5-3")
      assert(action.item_2.nil?, "CASE:2-3-5-3")
      assert(action.item_3.nil?, "CASE:2-3-5-3")
      assert(action.item_4.nil?, "CASE:2-3-5-3")
      assert(action.item_5.nil?, "CASE:2-3-5-3")
      assert(action.disp_number == '8', "CASE:2-3-5-3")
      assert(action.disp_order == 'DESC', "CASE:2-3-5-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-3-5-3")
      assert(action.time_unit_num == '15', "CASE:2-3-5-3")
      assert(action.time_unit == 'minute', "CASE:2-3-5-3")
      assert(action.aggregation_period == '20', "CASE:2-3-5-3")
      # アクセサ（抽出条件）
      assert(action.system_id == '1', "CASE:2-3-5-3")
      assert(action.function_id == '2', "CASE:2-3-5-4")
      assert(action.function_trans_no == '3', "CASE:2-3-5-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-3-5-6")
      assert(action.session_id == '123456789012345678901234567890AB', "CASE:2-3-5-6")
      assert(action.client_id == 'Client ID', "CASE:2-3-5-6")
      assert(action.browser_id == '1', "CASE:2-3-5-6")
      assert(action.browser_version_id == '2', "CASE:2-3-5-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-3-5-6")
      assert(action.accept_language == 'ja', "CASE:2-3-5-6")
      assert(action.referrer == 'http://www.yahoo.co.jp', "CASE:2-3-5-6")
      assert(action.referrer_match == 'FULL', "CASE:2-3-5-6")
      assert(action.domain_name == 'domain.com', "CASE:2-3-5-6")
      assert(action.domain_name_match == 'FULL', "CASE:2-3-5-6")
      assert(action.proxy_host == 'proxy.com', "CASE:2-3-5-6")
      assert(action.proxy_host_match == 'FULL', "CASE:2-3-5-6")
      assert(action.proxy_ip_address == '192.168.100.0', "CASE:2-3-5-6")
      assert(action.remote_host == 'remote.com', "CASE:2-3-5-6")
      assert(action.remote_host_match == 'FULL', "CASE:2-3-5-6")
      assert(action.ip_address == '192.168.200.0', "CASE:2-3-5-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-3-5-6")
      assert(action.item_values.empty?, "CASE:2-3-5-6")
      assert(action.graph_data.empty?, "CASE:2-3-5-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 4, "CASE:2-3-5-11")
      assert(error_msg_hash[:domain_name_cond] == '一致条件区分 は不正な値です。', "CASE:2-3-5-11")
      assert(error_msg_hash[:referrer_cond] == '一致条件区分 は不正な値です。', "CASE:2-3-5-11")
      assert(error_msg_hash[:proxy_host_cond] == '一致条件区分 は不正な値です。', "CASE:2-3-5-11")
      assert(error_msg_hash[:remote_host_cond] == '一致条件区分 は不正な値です。', "CASE:2-3-5-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-5")
    end
  end
  
  # 項目関連チェック（線分類）
  test "2-4:BaseAction Test:line_class_rel_chk?" do
    ###########################################################################
    # 線分類関連チェック
    ###########################################################################
    # CASE:2-4-1
    # 正常ケース
    # 線分類関連チェック：重複、間欠なし
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
                        :time_unit=>'minute',
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
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-4-1-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-4-1-3")
      assert(action.item_2.nil?, "CASE:2-4-1-3")
      assert(action.item_3.nil?, "CASE:2-4-1-3")
      assert(action.item_4.nil?, "CASE:2-4-1-3")
      assert(action.item_5.nil?, "CASE:2-4-1-3")
      assert(action.disp_number == '8', "CASE:2-4-1-3")
      assert(action.disp_order == 'DESC', "CASE:2-4-1-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-4-1-3")
      assert(action.time_unit_num == '15', "CASE:2-4-1-3")
      assert(action.time_unit == 'minute', "CASE:2-4-1-3")
      assert(action.aggregation_period == '20', "CASE:2-4-1-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-4-1-3")
      assert(action.function_id.nil?, "CASE:2-4-1-4")
      assert(action.function_trans_no.nil?, "CASE:2-4-1-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-4-1-6")
      assert(action.session_id.nil?, "CASE:2-4-1-6")
      assert(action.client_id.nil?, "CASE:2-4-1-6")
      assert(action.browser_id.nil?, "CASE:2-4-1-6")
      assert(action.browser_version_id.nil?, "CASE:2-4-1-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-4-1-6")
      assert(action.accept_language.nil?, "CASE:2-4-1-6")
      assert(action.referrer.nil?, "CASE:2-4-1-6")
      assert(action.referrer_match == 'F', "CASE:2-4-1-6")
      assert(action.domain_name.nil?, "CASE:2-4-1-6")
      assert(action.domain_name_match == 'F', "CASE:2-4-1-6")
      assert(action.proxy_host.nil?, "CASE:2-4-1-6")
      assert(action.proxy_host_match == 'F', "CASE:2-4-1-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-4-1-6")
      assert(action.remote_host.nil?, "CASE:2-4-1-6")
      assert(action.remote_host_match == 'F', "CASE:2-4-1-6")
      assert(action.ip_address.nil?, "CASE:2-4-1-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-4-1-6")
      assert(action.item_values.empty?, "CASE:2-4-1-6")
      assert(action.graph_data.empty?, "CASE:2-4-1-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-4-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-1")
    end
    # CASE:2-4-2
    # 正常ケース
    # 線分類：全て指定
    # 線分類関連チェック：重複、間欠なし
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_transition_no',
                        :item_3=>'accept_language',
                        :item_4=>'browser_id',
                        :item_5=>'domain_name',
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'minute',
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
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-4-2-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-4-2-3")
      assert(action.item_2 == 'function_transition_no', "CASE:2-4-2-3")
      assert(action.item_3 == 'accept_language', "CASE:2-4-2-3")
      assert(action.item_4 == 'browser_id', "CASE:2-4-2-3")
      assert(action.item_5 == 'domain_name', "CASE:2-4-2-3")
      assert(action.disp_number == '8', "CASE:2-4-2-3")
      assert(action.disp_order == 'DESC', "CASE:2-4-2-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-4-2-3")
      assert(action.time_unit_num == '15', "CASE:2-4-2-3")
      assert(action.time_unit == 'minute', "CASE:2-4-2-3")
      assert(action.aggregation_period == '20', "CASE:2-4-2-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-4-2-3")
      assert(action.function_id.nil?, "CASE:2-4-2-4")
      assert(action.function_trans_no.nil?, "CASE:2-4-2-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-4-2-6")
      assert(action.session_id.nil?, "CASE:2-4-2-6")
      assert(action.client_id.nil?, "CASE:2-4-2-6")
      assert(action.browser_id.nil?, "CASE:2-4-2-6")
      assert(action.browser_version_id.nil?, "CASE:2-4-2-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-4-2-6")
      assert(action.accept_language.nil?, "CASE:2-4-2-6")
      assert(action.referrer.nil?, "CASE:2-4-2-6")
      assert(action.referrer_match == 'F', "CASE:2-4-2-6")
      assert(action.domain_name.nil?, "CASE:2-4-2-6")
      assert(action.domain_name_match == 'F', "CASE:2-4-2-6")
      assert(action.proxy_host.nil?, "CASE:2-4-2-6")
      assert(action.proxy_host_match == 'F', "CASE:2-4-2-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-4-2-6")
      assert(action.remote_host.nil?, "CASE:2-4-2-6")
      assert(action.remote_host_match == 'F', "CASE:2-4-2-6")
      assert(action.ip_address.nil?, "CASE:2-4-2-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-4-2-6")
      assert(action.item_values.empty?, "CASE:2-4-2-6")
      assert(action.graph_data.empty?, "CASE:2-4-2-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-4-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-2")
    end
    # CASE:2-4-3
    # 異常ケース
    # 線分類：全て指定
    # 線分類関連チェック：重複あり先頭、間欠なし
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'system_id',
                        :item_3=>'accept_language',
                        :item_4=>'browser_id',
                        :item_5=>'domain_name',
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'minute',
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
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-4-3-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-4-3-3")
      assert(action.item_2 == 'system_id', "CASE:2-4-3-3")
      assert(action.item_3 == 'accept_language', "CASE:2-4-3-3")
      assert(action.item_4 == 'browser_id', "CASE:2-4-3-3")
      assert(action.item_5 == 'domain_name', "CASE:2-4-3-3")
      assert(action.disp_number == '8', "CASE:2-4-3-3")
      assert(action.disp_order == 'DESC', "CASE:2-4-3-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-4-3-3")
      assert(action.time_unit_num == '15', "CASE:2-4-3-3")
      assert(action.time_unit == 'minute', "CASE:2-4-3-3")
      assert(action.aggregation_period == '20', "CASE:2-4-3-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-4-3-3")
      assert(action.function_id.nil?, "CASE:2-4-3-4")
      assert(action.function_trans_no.nil?, "CASE:2-4-3-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-4-3-6")
      assert(action.session_id.nil?, "CASE:2-4-3-6")
      assert(action.client_id.nil?, "CASE:2-4-3-6")
      assert(action.browser_id.nil?, "CASE:2-4-3-6")
      assert(action.browser_version_id.nil?, "CASE:2-4-3-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-4-3-6")
      assert(action.accept_language.nil?, "CASE:2-4-3-6")
      assert(action.referrer.nil?, "CASE:2-4-3-6")
      assert(action.referrer_match == 'F', "CASE:2-4-3-6")
      assert(action.domain_name.nil?, "CASE:2-4-3-6")
      assert(action.domain_name_match == 'F', "CASE:2-4-3-6")
      assert(action.proxy_host.nil?, "CASE:2-4-3-6")
      assert(action.proxy_host_match == 'F', "CASE:2-4-3-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-4-3-6")
      assert(action.remote_host.nil?, "CASE:2-4-3-6")
      assert(action.remote_host_match == 'F', "CASE:2-4-3-6")
      assert(action.ip_address.nil?, "CASE:2-4-3-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-4-3-6")
      assert(action.item_values.empty?, "CASE:2-4-3-6")
      assert(action.graph_data.empty?, "CASE:2-4-3-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 1, "CASE:2-4-3-11")
      assert(error_msg_hash[:item_2] == '第２項目 は不正な値です。', "CASE:2-4-3-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-3")
    end
    # CASE:2-4-4
    # 正常ケース
    # 線分類：全て指定
    # 線分類関連チェック：重複あり末尾、間欠なし
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'function_transition_no',
                        :item_3=>'accept_language',
                        :item_4=>'browser_id',
                        :item_5=>'browser_id',
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'minute',
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
      assert(!action.nil?, "CASE:2-4-4-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-4-4-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-4-4-3")
      assert(action.item_2 == 'function_transition_no', "CASE:2-4-4-3")
      assert(action.item_3 == 'accept_language', "CASE:2-4-4-3")
      assert(action.item_4 == 'browser_id', "CASE:2-4-4-3")
      assert(action.item_5 == 'browser_id', "CASE:2-4-4-3")
      assert(action.disp_number == '8', "CASE:2-4-4-3")
      assert(action.disp_order == 'DESC', "CASE:2-4-4-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-4-4-3")
      assert(action.time_unit_num == '15', "CASE:2-4-4-3")
      assert(action.time_unit == 'minute', "CASE:2-4-4-3")
      assert(action.aggregation_period == '20', "CASE:2-4-4-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-4-4-3")
      assert(action.function_id.nil?, "CASE:2-4-4-4")
      assert(action.function_trans_no.nil?, "CASE:2-4-4-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-4-4-6")
      assert(action.session_id.nil?, "CASE:2-4-4-6")
      assert(action.client_id.nil?, "CASE:2-4-4-6")
      assert(action.browser_id.nil?, "CASE:2-4-4-6")
      assert(action.browser_version_id.nil?, "CASE:2-4-4-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-4-4-6")
      assert(action.accept_language.nil?, "CASE:2-4-4-6")
      assert(action.referrer.nil?, "CASE:2-4-4-6")
      assert(action.referrer_match == 'F', "CASE:2-4-4-6")
      assert(action.domain_name.nil?, "CASE:2-4-4-6")
      assert(action.domain_name_match == 'F', "CASE:2-4-4-6")
      assert(action.proxy_host.nil?, "CASE:2-4-4-6")
      assert(action.proxy_host_match == 'F', "CASE:2-4-4-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-4-4-6")
      assert(action.remote_host.nil?, "CASE:2-4-4-6")
      assert(action.remote_host_match == 'F', "CASE:2-4-4-6")
      assert(action.ip_address.nil?, "CASE:2-4-4-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-4-4-6")
      assert(action.item_values.empty?, "CASE:2-4-4-6")
      assert(action.graph_data.empty?, "CASE:2-4-4-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 1, "CASE:2-4-4-11")
      assert(error_msg_hash[:item_5] == '第５項目 は不正な値です。', "CASE:2-4-4-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-4")
    end
    # CASE:2-4-5
    # 正常ケース
    # 線分類：全て指定
    # 線分類関連チェック：重複なし、間欠あり先頭
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>nil,
                        :item_3=>'accept_language',
                        :item_4=>'browser_id',
                        :item_5=>'ip_address',
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'minute',
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
      assert(!action.nil?, "CASE:2-4-5-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-4-5-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-4-5-3")
      assert(action.item_2.nil?, "CASE:2-4-5-3")
      assert(action.item_3 == 'accept_language', "CASE:2-4-5-3")
      assert(action.item_4 == 'browser_id', "CASE:2-4-5-3")
      assert(action.item_5 == 'ip_address', "CASE:2-4-5-3")
      assert(action.disp_number == '8', "CASE:2-4-5-3")
      assert(action.disp_order == 'DESC', "CASE:2-4-5-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-4-5-3")
      assert(action.time_unit_num == '15', "CASE:2-4-5-3")
      assert(action.time_unit == 'minute', "CASE:2-4-5-3")
      assert(action.aggregation_period == '20', "CASE:2-4-5-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-4-5-3")
      assert(action.function_id.nil?, "CASE:2-4-5-4")
      assert(action.function_trans_no.nil?, "CASE:2-4-5-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-4-5-6")
      assert(action.session_id.nil?, "CASE:2-4-5-6")
      assert(action.client_id.nil?, "CASE:2-4-5-6")
      assert(action.browser_id.nil?, "CASE:2-4-5-6")
      assert(action.browser_version_id.nil?, "CASE:2-4-5-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-4-5-6")
      assert(action.accept_language.nil?, "CASE:2-4-5-6")
      assert(action.referrer.nil?, "CASE:2-4-5-6")
      assert(action.referrer_match == 'F', "CASE:2-4-5-6")
      assert(action.domain_name.nil?, "CASE:2-4-5-6")
      assert(action.domain_name_match == 'F', "CASE:2-4-5-6")
      assert(action.proxy_host.nil?, "CASE:2-4-5-6")
      assert(action.proxy_host_match == 'F', "CASE:2-4-5-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-4-5-6")
      assert(action.remote_host.nil?, "CASE:2-4-5-6")
      assert(action.remote_host_match == 'F', "CASE:2-4-5-6")
      assert(action.ip_address.nil?, "CASE:2-4-5-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-4-5-6")
      assert(action.item_values.empty?, "CASE:2-4-5-6")
      assert(action.graph_data.empty?, "CASE:2-4-5-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 1, "CASE:2-4-5-11")
      assert(error_msg_hash[:item_3] == '第３項目 は第２項目との整合性に問題があります。', "CASE:2-4-5-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-5")
    end
    # CASE:2-4-6
    # 正常ケース
    # 線分類：全て指定
    # 線分類関連チェック：重複なし、間欠あり末尾
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'browser_id',
                        :item_3=>'accept_language',
                        :item_4=>nil,
                        :item_5=>'ip_address',
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'minute',
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
      assert(!action.nil?, "CASE:2-4-6-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-4-6-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-4-6-3")
      assert(action.item_2 == 'browser_id', "CASE:2-4-6-3")
      assert(action.item_3 == 'accept_language', "CASE:2-4-6-3")
      assert(action.item_4.nil?, "CASE:2-4-6-3")
      assert(action.item_5 == 'ip_address', "CASE:2-4-6-3")
      assert(action.disp_number == '8', "CASE:2-4-6-3")
      assert(action.disp_order == 'DESC', "CASE:2-4-6-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-4-6-3")
      assert(action.time_unit_num == '15', "CASE:2-4-6-3")
      assert(action.time_unit == 'minute', "CASE:2-4-6-3")
      assert(action.aggregation_period == '20', "CASE:2-4-6-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-4-6-3")
      assert(action.function_id.nil?, "CASE:2-4-6-4")
      assert(action.function_trans_no.nil?, "CASE:2-4-6-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-4-6-6")
      assert(action.session_id.nil?, "CASE:2-4-6-6")
      assert(action.client_id.nil?, "CASE:2-4-6-6")
      assert(action.browser_id.nil?, "CASE:2-4-6-6")
      assert(action.browser_version_id.nil?, "CASE:2-4-6-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-4-6-6")
      assert(action.accept_language.nil?, "CASE:2-4-6-6")
      assert(action.referrer.nil?, "CASE:2-4-6-6")
      assert(action.referrer_match == 'F', "CASE:2-4-6-6")
      assert(action.domain_name.nil?, "CASE:2-4-6-6")
      assert(action.domain_name_match == 'F', "CASE:2-4-6-6")
      assert(action.proxy_host.nil?, "CASE:2-4-6-6")
      assert(action.proxy_host_match == 'F', "CASE:2-4-6-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-4-6-6")
      assert(action.remote_host.nil?, "CASE:2-4-6-6")
      assert(action.remote_host_match == 'F', "CASE:2-4-6-6")
      assert(action.ip_address.nil?, "CASE:2-4-6-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-4-6-6")
      assert(action.item_values.empty?, "CASE:2-4-6-6")
      assert(action.graph_data.empty?, "CASE:2-4-6-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 1, "CASE:2-4-6-11")
      assert(error_msg_hash[:item_5] == '第５項目 は第４項目との整合性に問題があります。', "CASE:2-4-6-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-6")
    end
    # CASE:2-4-7
    # 正常ケース
    # 線分類：全て指定
    # 線分類関連チェック：重複あり、間欠あり
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:item_1=>'system_id',
                        :item_2=>'browser_id',
                        :item_3=>'browser_id',
                        :item_4=>nil,
                        :item_5=>'ip_address',
                        :disp_number=>'8',
                        :disp_order=>'DESC',
              # 横軸
                        :received_date_from=>{:year=>'2007', :month=>'10', :day=>'09',
                                              :hour=>'10', :minute=>'20', :second=>'30'},
                        :time_unit_num=>'15',
                        :time_unit=>'minute',
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
      assert(!action.nil?, "CASE:2-4-7-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-4-7-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-4-7-3")
      assert(action.item_2 == 'browser_id', "CASE:2-4-7-3")
      assert(action.item_3 == 'browser_id', "CASE:2-4-7-3")
      assert(action.item_4.nil?, "CASE:2-4-7-3")
      assert(action.item_5 == 'ip_address', "CASE:2-4-7-3")
      assert(action.disp_number == '8', "CASE:2-4-7-3")
      assert(action.disp_order == 'DESC', "CASE:2-4-7-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-4-7-3")
      assert(action.time_unit_num == '15', "CASE:2-4-7-3")
      assert(action.time_unit == 'minute', "CASE:2-4-7-3")
      assert(action.aggregation_period == '20', "CASE:2-4-7-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-4-7-3")
      assert(action.function_id.nil?, "CASE:2-4-7-4")
      assert(action.function_trans_no.nil?, "CASE:2-4-7-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-4-7-6")
      assert(action.session_id.nil?, "CASE:2-4-7-6")
      assert(action.client_id.nil?, "CASE:2-4-7-6")
      assert(action.browser_id.nil?, "CASE:2-4-7-6")
      assert(action.browser_version_id.nil?, "CASE:2-4-7-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-4-7-6")
      assert(action.accept_language.nil?, "CASE:2-4-7-6")
      assert(action.referrer.nil?, "CASE:2-4-7-6")
      assert(action.referrer_match == 'F', "CASE:2-4-7-6")
      assert(action.domain_name.nil?, "CASE:2-4-7-6")
      assert(action.domain_name_match == 'F', "CASE:2-4-7-6")
      assert(action.proxy_host.nil?, "CASE:2-4-7-6")
      assert(action.proxy_host_match == 'F', "CASE:2-4-7-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-4-7-6")
      assert(action.remote_host.nil?, "CASE:2-4-7-6")
      assert(action.remote_host_match == 'F', "CASE:2-4-7-6")
      assert(action.ip_address.nil?, "CASE:2-4-7-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-4-7-6")
      assert(action.item_values.empty?, "CASE:2-4-7-6")
      assert(action.graph_data.empty?, "CASE:2-4-7-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 2, "CASE:2-4-7-11")
      assert(error_msg_hash[:item_3] == '第３項目 は不正な値です。', "CASE:2-4-7-11")
      assert(error_msg_hash[:item_5] == '第５項目 は第４項目との整合性に問題があります。', "CASE:2-4-7-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-7")
    end
  end
  
  # 項目関連チェック（ 抽出条件）
  test "2-5:BaseAction Test:extraction_cond_rel_chk?" do
    ###########################################################################
    # 線分類関連チェック
    ###########################################################################
    # CASE:2-5-1
    # 正常ケース
    # 抽出条件：システムID、機能ID、ブラウザID、ブラウザバージョンID
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>'1',
                        :function_id=>'1',
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>'1',
                        :browser_version_id=>'1',
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
      assert(!action.nil?, "CASE:2-5-1-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-5-1-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-5-1-3")
      assert(action.item_2.nil?, "CASE:2-5-1-3")
      assert(action.item_3.nil?, "CASE:2-5-1-3")
      assert(action.item_4.nil?, "CASE:2-5-1-3")
      assert(action.item_5.nil?, "CASE:2-5-1-3")
      assert(action.disp_number == '8', "CASE:2-5-1-3")
      assert(action.disp_order == 'DESC', "CASE:2-5-1-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-5-1-3")
      assert(action.time_unit_num == '15', "CASE:2-5-1-3")
      assert(action.time_unit == 'minute', "CASE:2-5-1-3")
      assert(action.aggregation_period == '20', "CASE:2-5-1-3")
      # アクセサ（抽出条件）
      assert(action.system_id == '1', "CASE:2-5-1-3")
      assert(action.function_id == '1', "CASE:2-5-1-4")
      assert(action.function_trans_no.nil?, "CASE:2-5-1-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-5-1-6")
      assert(action.session_id.nil?, "CASE:2-5-1-6")
      assert(action.client_id.nil?, "CASE:2-5-1-6")
      assert(action.browser_id == '1', "CASE:2-5-1-6")
      assert(action.browser_version_id == '1', "CASE:2-5-1-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-5-1-6")
      assert(action.accept_language.nil?, "CASE:2-5-1-6")
      assert(action.referrer.nil?, "CASE:2-5-1-6")
      assert(action.referrer_match == 'F', "CASE:2-5-1-6")
      assert(action.domain_name.nil?, "CASE:2-5-1-6")
      assert(action.domain_name_match == 'F', "CASE:2-5-1-6")
      assert(action.proxy_host.nil?, "CASE:2-5-1-6")
      assert(action.proxy_host_match == 'F', "CASE:2-5-1-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-5-1-6")
      assert(action.remote_host.nil?, "CASE:2-5-1-6")
      assert(action.remote_host_match == 'F', "CASE:2-5-1-6")
      assert(action.ip_address.nil?, "CASE:2-5-1-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-5-1-6")
      assert(action.item_values.empty?, "CASE:2-5-1-6")
      assert(action.graph_data.empty?, "CASE:2-5-1-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-5-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-5-1")
    end
    # CASE:2-5-2
    # 異常ケース
    # 抽出条件：機能ID、ブラウザバージョンID
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>'1',
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>nil,
                        :browser_version_id=>'1',
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
      assert(!action.nil?, "CASE:2-5-2-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-5-2-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-5-2-3")
      assert(action.item_2.nil?, "CASE:2-5-2-3")
      assert(action.item_3.nil?, "CASE:2-5-2-3")
      assert(action.item_4.nil?, "CASE:2-5-2-3")
      assert(action.item_5.nil?, "CASE:2-5-2-3")
      assert(action.disp_number == '8', "CASE:2-5-2-3")
      assert(action.disp_order == 'DESC', "CASE:2-5-2-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-5-2-3")
      assert(action.time_unit_num == '15', "CASE:2-5-2-3")
      assert(action.time_unit == 'minute', "CASE:2-5-2-3")
      assert(action.aggregation_period == '20', "CASE:2-5-2-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-5-2-3")
      assert(action.function_id == '1', "CASE:2-5-2-4")
      assert(action.function_trans_no.nil?, "CASE:2-5-2-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-5-2-6")
      assert(action.session_id.nil?, "CASE:2-5-2-6")
      assert(action.client_id.nil?, "CASE:2-5-2-6")
      assert(action.browser_id.nil?, "CASE:2-5-2-6")
      assert(action.browser_version_id == '1', "CASE:2-5-2-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-5-2-6")
      assert(action.accept_language.nil?, "CASE:2-5-2-6")
      assert(action.referrer.nil?, "CASE:2-5-2-6")
      assert(action.referrer_match == 'F', "CASE:2-5-2-6")
      assert(action.domain_name.nil?, "CASE:2-5-2-6")
      assert(action.domain_name_match == 'F', "CASE:2-5-2-6")
      assert(action.proxy_host.nil?, "CASE:2-5-2-6")
      assert(action.proxy_host_match == 'F', "CASE:2-5-2-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-5-2-6")
      assert(action.remote_host.nil?, "CASE:2-5-2-6")
      assert(action.remote_host_match == 'F', "CASE:2-5-2-6")
      assert(action.ip_address.nil?, "CASE:2-5-2-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-5-2-6")
      assert(action.item_values.empty?, "CASE:2-5-2-6")
      assert(action.graph_data.empty?, "CASE:2-5-2-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 2, "CASE:2-5-2-11")
      assert(error_msg_hash[:system_id] == 'システム名 を入力してください。', "CASE:2-4-2-11")
      assert(error_msg_hash[:browser_id] == 'ブラウザ名 を入力してください。', "CASE:2-4-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-5-2")
    end
  end
  
  # DB関連チェック（ システム）
  test "2-6:BaseAction Test:system_exist_chk?" do
    ###########################################################################
    # DB関連チェック
    ###########################################################################
    # CASE:2-6-1
    # 正常ケース
    # 抽出条件：システムID
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>'1',
                        :function_id=>'1',
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>'1',
                        :browser_version_id=>'1',
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
      assert(!action.nil?, "CASE:2-6-1-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-6-1-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-6-1-3")
      assert(action.item_2.nil?, "CASE:2-6-1-3")
      assert(action.item_3.nil?, "CASE:2-6-1-3")
      assert(action.item_4.nil?, "CASE:2-6-1-3")
      assert(action.item_5.nil?, "CASE:2-6-1-3")
      assert(action.disp_number == '8', "CASE:2-6-1-3")
      assert(action.disp_order == 'DESC', "CASE:2-6-1-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-6-1-3")
      assert(action.time_unit_num == '15', "CASE:2-6-1-3")
      assert(action.time_unit == 'minute', "CASE:2-6-1-3")
      assert(action.aggregation_period == '20', "CASE:2-6-1-3")
      # アクセサ（抽出条件）
      assert(action.system_id == '1', "CASE:2-6-1-3")
      assert(action.function_id == '1', "CASE:2-6-1-4")
      assert(action.function_trans_no.nil?, "CASE:2-6-1-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-6-1-6")
      assert(action.session_id.nil?, "CASE:2-6-1-6")
      assert(action.client_id.nil?, "CASE:2-6-1-6")
      assert(action.browser_id == '1', "CASE:2-6-1-6")
      assert(action.browser_version_id == '1', "CASE:2-6-1-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-6-1-6")
      assert(action.accept_language.nil?, "CASE:2-6-1-6")
      assert(action.referrer.nil?, "CASE:2-6-1-6")
      assert(action.referrer_match == 'F', "CASE:2-6-1-6")
      assert(action.domain_name.nil?, "CASE:2-6-1-6")
      assert(action.domain_name_match == 'F', "CASE:2-6-1-6")
      assert(action.proxy_host.nil?, "CASE:2-6-1-6")
      assert(action.proxy_host_match == 'F', "CASE:2-6-1-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-6-1-6")
      assert(action.remote_host.nil?, "CASE:2-6-1-6")
      assert(action.remote_host_match == 'F', "CASE:2-6-1-6")
      assert(action.ip_address.nil?, "CASE:2-6-1-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-6-1-6")
      assert(action.item_values.empty?, "CASE:2-6-1-6")
      assert(action.graph_data.empty?, "CASE:2-6-1-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-6-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-6-1")
    end
    # CASE:2-6-2
    # 異常ケース
    # 抽出条件：システムID
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>'1000',
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>'1',
                        :browser_version_id=>'1',
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
      assert(!action.nil?, "CASE:2-6-2-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-6-2-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-6-2-3")
      assert(action.item_2.nil?, "CASE:2-6-2-3")
      assert(action.item_3.nil?, "CASE:2-6-2-3")
      assert(action.item_4.nil?, "CASE:2-6-2-3")
      assert(action.item_5.nil?, "CASE:2-6-2-3")
      assert(action.disp_number == '8', "CASE:2-6-2-3")
      assert(action.disp_order == 'DESC', "CASE:2-6-2-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-6-2-3")
      assert(action.time_unit_num == '15', "CASE:2-6-2-3")
      assert(action.time_unit == 'minute', "CASE:2-6-2-3")
      assert(action.aggregation_period == '20', "CASE:2-6-2-3")
      # アクセサ（抽出条件）
      assert(action.system_id == '1000', "CASE:2-6-2-3")
      assert(action.function_id.nil?, "CASE:2-6-2-4")
      assert(action.function_trans_no.nil?, "CASE:2-6-2-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-6-2-6")
      assert(action.session_id.nil?, "CASE:2-6-2-6")
      assert(action.client_id.nil?, "CASE:2-6-2-6")
      assert(action.browser_id == '1', "CASE:2-6-2-6")
      assert(action.browser_version_id == '1', "CASE:2-6-2-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-6-2-6")
      assert(action.accept_language.nil?, "CASE:2-6-2-6")
      assert(action.referrer.nil?, "CASE:2-6-2-6")
      assert(action.referrer_match == 'F', "CASE:2-6-2-6")
      assert(action.domain_name.nil?, "CASE:2-6-2-6")
      assert(action.domain_name_match == 'F', "CASE:2-6-2-6")
      assert(action.proxy_host.nil?, "CASE:2-6-2-6")
      assert(action.proxy_host_match == 'F', "CASE:2-6-2-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-6-2-6")
      assert(action.remote_host.nil?, "CASE:2-6-2-6")
      assert(action.remote_host_match == 'F', "CASE:2-6-2-6")
      assert(action.ip_address.nil?, "CASE:2-6-2-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-6-2-6")
      assert(action.item_values.empty?, "CASE:2-6-2-6")
      assert(action.graph_data.empty?, "CASE:2-6-2-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 1, "CASE:2-6-2-11")
      assert(error_msg_hash[:system_id] == 'システム名 が見つかりません。', "CASE:2-6-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-6-2")
    end
  end
  
  # DB関連チェック（機能）
  test "2-7:BaseAction Test:function_exist_chk?" do
    ###########################################################################
    # DB関連チェック
    ###########################################################################
    # CASE:2-7-1
    # 正常ケース
    # 抽出条件：システムID、機能ID
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>'1',
                        :function_id=>'1',
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>'1',
                        :browser_version_id=>'1',
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
      assert(!action.nil?, "CASE:2-7-1-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-7-1-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-7-1-3")
      assert(action.item_2.nil?, "CASE:2-7-1-3")
      assert(action.item_3.nil?, "CASE:2-7-1-3")
      assert(action.item_4.nil?, "CASE:2-7-1-3")
      assert(action.item_5.nil?, "CASE:2-7-1-3")
      assert(action.disp_number == '8', "CASE:2-7-1-3")
      assert(action.disp_order == 'DESC', "CASE:2-7-1-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-7-1-3")
      assert(action.time_unit_num == '15', "CASE:2-7-1-3")
      assert(action.time_unit == 'minute', "CASE:2-7-1-3")
      assert(action.aggregation_period == '20', "CASE:2-7-1-3")
      # アクセサ（抽出条件）
      assert(action.system_id == '1', "CASE:2-7-1-3")
      assert(action.function_id == '1', "CASE:2-7-1-4")
      assert(action.function_trans_no.nil?, "CASE:2-7-1-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-7-1-6")
      assert(action.session_id.nil?, "CASE:2-7-1-6")
      assert(action.client_id.nil?, "CASE:2-7-1-6")
      assert(action.browser_id == '1', "CASE:2-7-1-6")
      assert(action.browser_version_id == '1', "CASE:2-7-1-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-7-1-6")
      assert(action.accept_language.nil?, "CASE:2-7-1-6")
      assert(action.referrer.nil?, "CASE:2-7-1-6")
      assert(action.referrer_match == 'F', "CASE:2-7-1-6")
      assert(action.domain_name.nil?, "CASE:2-7-1-6")
      assert(action.domain_name_match == 'F', "CASE:2-7-1-6")
      assert(action.proxy_host.nil?, "CASE:2-7-1-6")
      assert(action.proxy_host_match == 'F', "CASE:2-7-1-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-7-1-6")
      assert(action.remote_host.nil?, "CASE:2-7-1-6")
      assert(action.remote_host_match == 'F', "CASE:2-7-1-6")
      assert(action.ip_address.nil?, "CASE:2-7-1-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-7-1-6")
      assert(action.item_values.empty?, "CASE:2-7-1-6")
      assert(action.graph_data.empty?, "CASE:2-7-1-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-7-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-1")
    end
    # CASE:2-7-2
    # 異常ケース
    # 抽出条件：システムID、機能ID
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>'1',
                        :function_id=>'1000',
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>'1',
                        :browser_version_id=>'1',
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
      assert(!action.nil?, "CASE:2-7-2-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-7-2-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-7-2-3")
      assert(action.item_2.nil?, "CASE:2-7-2-3")
      assert(action.item_3.nil?, "CASE:2-7-2-3")
      assert(action.item_4.nil?, "CASE:2-7-2-3")
      assert(action.item_5.nil?, "CASE:2-7-2-3")
      assert(action.disp_number == '8', "CASE:2-7-2-3")
      assert(action.disp_order == 'DESC', "CASE:2-7-2-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-7-2-3")
      assert(action.time_unit_num == '15', "CASE:2-7-2-3")
      assert(action.time_unit == 'minute', "CASE:2-7-2-3")
      assert(action.aggregation_period == '20', "CASE:2-7-2-3")
      # アクセサ（抽出条件）
      assert(action.system_id == '1', "CASE:2-7-2-3")
      assert(action.function_id == '1000', "CASE:2-7-2-4")
      assert(action.function_trans_no.nil?, "CASE:2-7-2-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-7-2-6")
      assert(action.session_id.nil?, "CASE:2-7-2-6")
      assert(action.client_id.nil?, "CASE:2-7-2-6")
      assert(action.browser_id == '1', "CASE:2-7-2-6")
      assert(action.browser_version_id == '1', "CASE:2-7-2-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-7-2-6")
      assert(action.accept_language.nil?, "CASE:2-7-2-6")
      assert(action.referrer.nil?, "CASE:2-7-2-6")
      assert(action.referrer_match == 'F', "CASE:2-7-2-6")
      assert(action.domain_name.nil?, "CASE:2-7-2-6")
      assert(action.domain_name_match == 'F', "CASE:2-7-2-6")
      assert(action.proxy_host.nil?, "CASE:2-7-2-6")
      assert(action.proxy_host_match == 'F', "CASE:2-7-2-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-7-2-6")
      assert(action.remote_host.nil?, "CASE:2-7-2-6")
      assert(action.remote_host_match == 'F', "CASE:2-7-2-6")
      assert(action.ip_address.nil?, "CASE:2-7-2-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-7-2-6")
      assert(action.item_values.empty?, "CASE:2-7-2-6")
      assert(action.graph_data.empty?, "CASE:2-7-2-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 1, "CASE:2-7-2-11")
      assert(error_msg_hash[:function_id] == '機能名 が見つかりません。', "CASE:2-7-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-2")
    end
  end
  
  # DB関連チェック（ ブラウザ）
  test "2-8:BaseAction Test:browser_exist_chk?" do
    ###########################################################################
    # DB関連チェック
    ###########################################################################
    # CASE:2-8-1
    # 正常ケース
    # 抽出条件：ブラウザID
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>'1',
                        :browser_version_id=>'1',
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
      assert(!action.nil?, "CASE:2-8-1-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-8-1-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-8-1-3")
      assert(action.item_2.nil?, "CASE:2-8-1-3")
      assert(action.item_3.nil?, "CASE:2-8-1-3")
      assert(action.item_4.nil?, "CASE:2-8-1-3")
      assert(action.item_5.nil?, "CASE:2-8-1-3")
      assert(action.disp_number == '8', "CASE:2-8-1-3")
      assert(action.disp_order == 'DESC', "CASE:2-8-1-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-8-1-3")
      assert(action.time_unit_num == '15', "CASE:2-8-1-3")
      assert(action.time_unit == 'minute', "CASE:2-8-1-3")
      assert(action.aggregation_period == '20', "CASE:2-8-1-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-8-1-3")
      assert(action.function_id.nil?, "CASE:2-8-1-4")
      assert(action.function_trans_no.nil?, "CASE:2-8-1-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-8-1-6")
      assert(action.session_id.nil?, "CASE:2-8-1-6")
      assert(action.client_id.nil?, "CASE:2-8-1-6")
      assert(action.browser_id == '1', "CASE:2-8-1-6")
      assert(action.browser_version_id == '1', "CASE:2-8-1-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-8-1-6")
      assert(action.accept_language.nil?, "CASE:2-8-1-6")
      assert(action.referrer.nil?, "CASE:2-8-1-6")
      assert(action.referrer_match == 'F', "CASE:2-8-1-6")
      assert(action.domain_name.nil?, "CASE:2-8-1-6")
      assert(action.domain_name_match == 'F', "CASE:2-8-1-6")
      assert(action.proxy_host.nil?, "CASE:2-8-1-6")
      assert(action.proxy_host_match == 'F', "CASE:2-8-1-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-8-1-6")
      assert(action.remote_host.nil?, "CASE:2-8-1-6")
      assert(action.remote_host_match == 'F', "CASE:2-8-1-6")
      assert(action.ip_address.nil?, "CASE:2-8-1-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-8-1-6")
      assert(action.item_values.empty?, "CASE:2-8-1-6")
      assert(action.graph_data.empty?, "CASE:2-8-1-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-8-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-1")
    end
    # CASE:2-8-2
    # 異常ケース
    # 抽出条件：ブラウザID
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>'1000',
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
      assert(!action.nil?, "CASE:2-8-2-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-8-2-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-8-2-3")
      assert(action.item_2.nil?, "CASE:2-8-2-3")
      assert(action.item_3.nil?, "CASE:2-8-2-3")
      assert(action.item_4.nil?, "CASE:2-8-2-3")
      assert(action.item_5.nil?, "CASE:2-8-2-3")
      assert(action.disp_number == '8', "CASE:2-8-2-3")
      assert(action.disp_order == 'DESC', "CASE:2-8-2-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-8-2-3")
      assert(action.time_unit_num == '15', "CASE:2-8-2-3")
      assert(action.time_unit == 'minute', "CASE:2-8-2-3")
      assert(action.aggregation_period == '20', "CASE:2-8-2-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-8-2-3")
      assert(action.function_id.nil?, "CASE:2-8-2-4")
      assert(action.function_trans_no.nil?, "CASE:2-8-2-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-8-2-6")
      assert(action.session_id.nil?, "CASE:2-8-2-6")
      assert(action.client_id.nil?, "CASE:2-8-2-6")
      assert(action.browser_id == '1000', "CASE:2-8-2-6")
      assert(action.browser_version_id.nil?, "CASE:2-8-2-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-8-2-6")
      assert(action.accept_language.nil?, "CASE:2-8-2-6")
      assert(action.referrer.nil?, "CASE:2-8-2-6")
      assert(action.referrer_match == 'F', "CASE:2-8-2-6")
      assert(action.domain_name.nil?, "CASE:2-8-2-6")
      assert(action.domain_name_match == 'F', "CASE:2-8-2-6")
      assert(action.proxy_host.nil?, "CASE:2-8-2-6")
      assert(action.proxy_host_match == 'F', "CASE:2-8-2-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-8-2-6")
      assert(action.remote_host.nil?, "CASE:2-8-2-6")
      assert(action.remote_host_match == 'F', "CASE:2-8-2-6")
      assert(action.ip_address.nil?, "CASE:2-8-2-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-8-2-6")
      assert(action.item_values.empty?, "CASE:2-8-2-6")
      assert(action.graph_data.empty?, "CASE:2-8-2-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 1, "CASE:2-8-2-11")
      assert(error_msg_hash[:browser_id] == 'ブラウザ名 が見つかりません。', "CASE:2-8-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-2")
    end
  end
  
  # DB関連チェック（ブラウザバージョン）
  test "2-9:BaseAction Test:browser_version_exist_chk?" do
    ###########################################################################
    # DB関連チェック
    ###########################################################################
    # CASE:2-9-1
    # 正常ケース
    # 抽出条件：ブラウザバージョンID
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>'1',
                        :browser_version_id=>'1',
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
      assert(!action.nil?, "CASE:2-9-1-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-9-1-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-9-1-3")
      assert(action.item_2.nil?, "CASE:2-9-1-3")
      assert(action.item_3.nil?, "CASE:2-9-1-3")
      assert(action.item_4.nil?, "CASE:2-9-1-3")
      assert(action.item_5.nil?, "CASE:2-9-1-3")
      assert(action.disp_number == '8', "CASE:2-9-1-3")
      assert(action.disp_order == 'DESC', "CASE:2-9-1-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-9-1-3")
      assert(action.time_unit_num == '15', "CASE:2-9-1-3")
      assert(action.time_unit == 'minute', "CASE:2-9-1-3")
      assert(action.aggregation_period == '20', "CASE:2-9-1-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-9-1-3")
      assert(action.function_id.nil?, "CASE:2-9-1-4")
      assert(action.function_trans_no.nil?, "CASE:2-9-1-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-9-1-6")
      assert(action.session_id.nil?, "CASE:2-9-1-6")
      assert(action.client_id.nil?, "CASE:2-9-1-6")
      assert(action.browser_id == '1', "CASE:2-9-1-6")
      assert(action.browser_version_id == '1', "CASE:2-9-1-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-9-1-6")
      assert(action.accept_language.nil?, "CASE:2-9-1-6")
      assert(action.referrer.nil?, "CASE:2-9-1-6")
      assert(action.referrer_match == 'F', "CASE:2-9-1-6")
      assert(action.domain_name.nil?, "CASE:2-9-1-6")
      assert(action.domain_name_match == 'F', "CASE:2-9-1-6")
      assert(action.proxy_host.nil?, "CASE:2-9-1-6")
      assert(action.proxy_host_match == 'F', "CASE:2-9-1-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-9-1-6")
      assert(action.remote_host.nil?, "CASE:2-9-1-6")
      assert(action.remote_host_match == 'F', "CASE:2-9-1-6")
      assert(action.ip_address.nil?, "CASE:2-9-1-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-9-1-6")
      assert(action.item_values.empty?, "CASE:2-9-1-6")
      assert(action.graph_data.empty?, "CASE:2-9-1-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-9-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-9-1")
    end
    # CASE:2-9-2
    # 異常ケース
    # 抽出条件：ブラウザバージョンID
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
                        :time_unit=>'minute',
                        :aggregation_period=>'20',
              # 抽出条件
                        :system_id=>nil,
                        :function_id=>nil,
                        :function_trans_no=>nil,
                        :function_trans_no_comp=>'EQ',
                        :session_id=>nil,
                        :client_id=>nil,
                        :browser_id=>'1',
                        :browser_version_id=>'1000',
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
      assert(!action.nil?, "CASE:2-9-2-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-9-2-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-9-2-3")
      assert(action.item_2.nil?, "CASE:2-9-2-3")
      assert(action.item_3.nil?, "CASE:2-9-2-3")
      assert(action.item_4.nil?, "CASE:2-9-2-3")
      assert(action.item_5.nil?, "CASE:2-9-2-3")
      assert(action.disp_number == '8', "CASE:2-9-2-3")
      assert(action.disp_order == 'DESC', "CASE:2-9-2-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-9-2-3")
      assert(action.time_unit_num == '15', "CASE:2-9-2-3")
      assert(action.time_unit == 'minute', "CASE:2-9-2-3")
      assert(action.aggregation_period == '20', "CASE:2-9-2-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-9-2-3")
      assert(action.function_id.nil?, "CASE:2-9-2-4")
      assert(action.function_trans_no.nil?, "CASE:2-9-2-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-9-2-6")
      assert(action.session_id.nil?, "CASE:2-9-2-6")
      assert(action.client_id.nil?, "CASE:2-9-2-6")
      assert(action.browser_id == '1', "CASE:2-9-2-6")
      assert(action.browser_version_id == '1000', "CASE:2-9-2-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-9-2-6")
      assert(action.accept_language.nil?, "CASE:2-9-2-6")
      assert(action.referrer.nil?, "CASE:2-9-2-6")
      assert(action.referrer_match == 'F', "CASE:2-9-2-6")
      assert(action.domain_name.nil?, "CASE:2-9-2-6")
      assert(action.domain_name_match == 'F', "CASE:2-9-2-6")
      assert(action.proxy_host.nil?, "CASE:2-9-2-6")
      assert(action.proxy_host_match == 'F', "CASE:2-9-2-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-9-2-6")
      assert(action.remote_host.nil?, "CASE:2-9-2-6")
      assert(action.remote_host_match == 'F', "CASE:2-9-2-6")
      assert(action.ip_address.nil?, "CASE:2-9-2-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-9-2-6")
      assert(action.item_values.empty?, "CASE:2-9-2-6")
      assert(action.graph_data.empty?, "CASE:2-9-2-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 1, "CASE:2-9-2-11")
      assert(error_msg_hash[:browser_version_id] == 'ブラウザバージョン が見つかりません。', "CASE:2-9-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-9-2")
    end
  end
  
  # DB関連チェック（ ドメイン）
  test "2-10:BaseAction Test:domain_exist_chk?" do
    ###########################################################################
    # DB関連チェック
    ###########################################################################
    # CASE:2-10-1
    # 正常ケース
    # 抽出条件：ドメイン名、一致条件
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
                        :time_unit=>'minute',
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
      assert(!action.nil?, "CASE:2-10-1-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(action.valid?, "CASE:2-10-1-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-10-1-3")
      assert(action.item_2.nil?, "CASE:2-10-1-3")
      assert(action.item_3.nil?, "CASE:2-10-1-3")
      assert(action.item_4.nil?, "CASE:2-10-1-3")
      assert(action.item_5.nil?, "CASE:2-10-1-3")
      assert(action.disp_number == '8', "CASE:2-10-1-3")
      assert(action.disp_order == 'DESC', "CASE:2-10-1-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-10-1-3")
      assert(action.time_unit_num == '15', "CASE:2-10-1-3")
      assert(action.time_unit == 'minute', "CASE:2-10-1-3")
      assert(action.aggregation_period == '20', "CASE:2-10-1-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-10-1-3")
      assert(action.function_id.nil?, "CASE:2-10-1-4")
      assert(action.function_trans_no.nil?, "CASE:2-10-1-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-10-1-6")
      assert(action.session_id.nil?, "CASE:2-10-1-6")
      assert(action.client_id.nil?, "CASE:2-10-1-6")
      assert(action.browser_id.nil?, "CASE:2-10-1-6")
      assert(action.browser_version_id.nil?, "CASE:2-10-1-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-10-1-6")
      assert(action.accept_language.nil?, "CASE:2-10-1-6")
      assert(action.referrer.nil?, "CASE:2-10-1-6")
      assert(action.referrer_match == 'F', "CASE:2-10-1-6")
      assert(action.domain_name == 'test', "CASE:2-10-1-6")
      assert(action.domain_name_match == 'F', "CASE:2-10-1-6")
      assert(action.proxy_host.nil?, "CASE:2-10-1-6")
      assert(action.proxy_host_match == 'F', "CASE:2-10-1-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-10-1-6")
      assert(action.remote_host.nil?, "CASE:2-10-1-6")
      assert(action.remote_host_match == 'F', "CASE:2-10-1-6")
      assert(action.ip_address.nil?, "CASE:2-10-1-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-10-1-6")
      assert(action.item_values.empty?, "CASE:2-10-1-6")
      assert(action.graph_data.empty?, "CASE:2-10-1-6")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-10-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-10-1")
    end
    # CASE:2-10-2
    # 異常ケース
    # 抽出条件：ドメイン名
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
                        :time_unit=>'minute',
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
                        :domain_name_match=>'B',
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
      assert(!action.nil?, "CASE:2-10-2-1")
      # パラメータチェック
#      action.valid?
#      print_log('error msg:' + action.error_msg_hash.to_s)
      assert(!action.valid?, "CASE:2-10-2-2")
      # アクセサ（線分類）
      assert(action.item_1 == 'system_id', "CASE:2-10-2-3")
      assert(action.item_2.nil?, "CASE:2-10-2-3")
      assert(action.item_3.nil?, "CASE:2-10-2-3")
      assert(action.item_4.nil?, "CASE:2-10-2-3")
      assert(action.item_5.nil?, "CASE:2-10-2-3")
      assert(action.disp_number == '8', "CASE:2-10-2-3")
      assert(action.disp_order == 'DESC', "CASE:2-10-2-3")
      # アクセサ（横軸）
      datetime = Time.new(2007, 10, 9, 10, 20, 30)
#      print_log('date_from:' + action.received_date_from.to_s + ':' + datetime.to_s)
      assert(action.received_date_from == datetime, "CASE:2-10-2-3")
      assert(action.time_unit_num == '15', "CASE:2-10-2-3")
      assert(action.time_unit == 'minute', "CASE:2-10-2-3")
      assert(action.aggregation_period == '20', "CASE:2-10-2-3")
      # アクセサ（抽出条件）
      assert(action.system_id.nil?, "CASE:2-10-2-3")
      assert(action.function_id.nil?, "CASE:2-10-2-4")
      assert(action.function_trans_no.nil?, "CASE:2-10-2-5")
      assert(action.function_trans_no_comp == 'EQ', "CASE:2-10-2-6")
      assert(action.session_id.nil?, "CASE:2-10-2-6")
      assert(action.client_id.nil?, "CASE:2-10-2-6")
      assert(action.browser_id.nil?, "CASE:2-10-2-6")
      assert(action.browser_version_id.nil?, "CASE:2-10-2-6")
      assert(action.browser_version_id_comp == 'EQ', "CASE:2-10-2-6")
      assert(action.accept_language.nil?, "CASE:2-10-2-6")
      assert(action.referrer.nil?, "CASE:2-10-2-6")
      assert(action.referrer_match == 'F', "CASE:2-10-2-6")
      assert(action.domain_name == 'test', "CASE:2-10-2-6")
      assert(action.domain_name_match == 'B', "CASE:2-10-2-6")
      assert(action.proxy_host.nil?, "CASE:2-10-2-6")
      assert(action.proxy_host_match == 'F', "CASE:2-10-2-6")
      assert(action.proxy_ip_address.nil?, "CASE:2-10-2-6")
      assert(action.remote_host.nil?, "CASE:2-10-2-6")
      assert(action.remote_host_match == 'F', "CASE:2-10-2-6")
      assert(action.ip_address.nil?, "CASE:2-10-2-6")
      # 集計結果
      assert(action.date_list.empty?, "CASE:2-10-2-6")
      assert(action.item_values.empty?, "CASE:2-10-2-6")
      assert(action.graph_data.empty?, "CASE:2-10-2-6")
      # エラーメッセージ
      error_msg_hash = action.error_msg_hash
#      print_log('error hash:' + error_msg_hash.to_s)
      assert(error_msg_hash.size == 1, "CASE:2-10-2-11")
      assert(error_msg_hash[:domain_name_cond] == 'ドメイン名 が見つかりません。', "CASE:2-10-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-10-2")
    end
  end
end