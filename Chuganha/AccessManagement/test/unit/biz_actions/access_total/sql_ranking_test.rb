# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：集計対象抽出SQL生成クラス
# コントローラー：AccessTotal::AccessTotalController
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/10/11 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/access_total/sql_ranking'

class SQLRankingTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::AccessTotal
  include Mock
  # 前処理
#  def setup
#    BizNotifyList.instance.data_load
#  end
  # 後処理
#  def teardown
#  end
  # コンストラクタ
  test "2-1:SQLRanking Test:initialize" do
    # 正常（デフォルト入力）
    begin
      params = default_params
      # コンストラクタ生成
      sql_obj = SQLRanking.new(params)
      assert(!sql_obj.nil?, "CASE:2-1-1-1")
      # パラメータチェック
      statement = sql_obj.statement
      bind_params = sql_obj.bind_params
      sql_params  = sql_obj.sql_params
      rcvd_period = sql_obj.rcvd_period
      # SQLパラメータチェック
      params_bind_params = sql_params.dup
      params_statement = params_bind_params.shift
#      print_log('bind_param:' + params_bind_params.to_s)
      assert(statement == params_statement, "CASE:2-1-1-2")
      assert(bind_params == params_bind_params, "CASE:2-1-1-3")
      assert(params_bind_params[0] == '2007', "CASE:2-1-1-4")
      assert(params_bind_params[1] == '2026', "CASE:2-1-1-5")
      assert(params_bind_params[2] == 1, "CASE:2-1-1-6")
      assert(params_bind_params[3] == 8, "CASE:2-1-1-7")
      # 集計機関
#      print_log('rcvd_period:' + rcvd_period.to_s)
      assert(rcvd_period[0] == '2007', "CASE:2-1-1-7")
      assert(rcvd_period[1] == '2026', "CASE:2-1-1-7")
      # SQL文チェック(項目)
      result_list = RequestAnalysisResult.find_by_sql(sql_params)
      assert(!result_list.empty?, "CASE:2-1-1-8")
      items = ex_item_list(statement)
#      print_log("items:" + items.to_s)
      assert(items[0] == 'request_analysis_results.system_id', "CASE:2-1-1-9")
      assert(items[1] == 'sum(request_analysis_results.request_count) AS total_access', "CASE:2-1-1-10")
      # SQL文チェック(テーブル)
      tables = ex_table_list(statement)
#      print_log("tables:" + tables.to_s)
      assert(tables[0] == 'request_analysis_results', "CASE:2-1-1-11")
      # SQL文チェック(抽出条件)
      wheres = ex_where_list(statement)
#      print_log("wheres:" + wheres.to_s)
      assert(wheres[0] == ex_received_date('year'), "CASE:2-1-1-12")
      assert(wheres[1] == "request_analysis_results.function_id = ?", "CASE:2-1-1-13")
      # SQL文チェック(グルーピング条件)
      grouping = ex_group_by_list(statement)
#      print_log("grouping:" + grouping.to_s)
      assert(grouping[0] == "request_analysis_results.system_id", "CASE:2-1-1-14")
      # SQL文チェック(ソート条件)
      order = ex_order_by_list(statement)
#      print_log("order:" + order.to_s)
      assert(order[0] == "total_access DESC", "CASE:2-1-1-15")
      # SQL文チェック(リミット件数条件)
      limit = ex_limit(statement)
#      print_log("limit:" + limit.to_s)
      assert(limit == "LIMIT ?", "CASE:2-1-1-16")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 正常
    # 項目：システムID、機能ID、機能遷移番号、ブラウザID、ドメイン名
    # 期間：3ヶ月単位
    # 全条件項目指定
    begin
      # テストデータ作成
      test_data = RequestAnalysisResult.new
      test_data.system_id = 1
      test_data.request_analysis_schedule_id = 1
      test_data.received_year = 2007
      test_data.received_month = 8
      test_data.function_id = 2
      test_data.function_transition_no = 3
      test_data.session_id = '123456789012345678901234567890AB'
      test_data.client_id = 'Client_id'
      test_data.domain_id = 1
      test_data.browser_id = 1
      test_data.browser_version_id = 2
      test_data.accept_language = 'ja'
      test_data.referrer = 'http://localhost:3000/menu/menu'
      test_data.proxy_host = 'proxy.nifty.com'
      test_data.proxy_ip_address = '192.168.10.100'
      test_data.remote_host = 'remote.nifty.com'
      test_data.ip_address = '192.168.20.100'
      test_data.domain_id = 1
      test_data.request_count = 10
      test_data.save!
#      print_log("RequestAnalysisResult:" + RequestAnalysisResult.where(:received_year=>2007).to_s)
      # パラメータ生成
      params = default_params
      params[:item_2] = 'function_id'
      params[:item_3] = 'function_transition_no'
      params[:item_4] = 'browser_id'
      params[:item_5] = 'domain_name'
      params[:time_unit_num] = '3'
      params[:time_unit] = 'month'
      params[:system_id] = '1'
      params[:function_id] = '2'
      params[:function_trans_no] = '3'
      params[:function_trans_no_comp] = 'EQ'
      params[:session_id]  = '123456789012345678901234567890AB'
      params[:client_id] = 'Client_id'
      params[:browser_id] = '1'
      params[:browser_version_id] = '2'
      params[:browser_version_id_comp] = 'LE'
      params[:accept_language] = 'ja'
      params[:referrer] = 'http://localhost:3000/menu/menu'
      params[:referrer_match] = 'E'
      params[:proxy_host] = 'proxy.nifty'
      params[:proxy_host_match] = 'F'
      params[:proxy_ip_address] = '192.168.10.100'
      params[:remote_host] = 'mote.nifty.'
      params[:remote_host_match] = 'P'
      params[:ip_address] = '192.168.20.100'
      params[:domain_name] = 'e.jp'
      params[:domain_name_match] = 'B'
      # コンストラクタ生成
      sql_obj = SQLRanking.new(params)
      assert(!sql_obj.nil?, "CASE:2-1-2-1")
      # パラメータチェック
      statement = sql_obj.statement
      bind_params = sql_obj.bind_params
      sql_params  = sql_obj.sql_params
      rcvd_period = sql_obj.rcvd_period
      # SQLパラメータチェック
      params_bind_params = sql_params.dup
      params_statement = params_bind_params.shift
      assert(statement == params_statement, "CASE:2-1-2-2")
      assert(bind_params == params_bind_params, "CASE:2-1-2-3")
#      print_log('bind_params:' + params_bind_params.to_s)
      assert(params_bind_params[0] == 1, "CASE:2-1-2-4") # システムID
      assert(params_bind_params[1] == '200708', "CASE:2-1-2-5")
      assert(params_bind_params[2] == '201207', "CASE:2-1-2-6")
      assert(params_bind_params[3] == 2, "CASE:2-1-2-7") # 機能ID
      assert(params_bind_params[4] == 3, "CASE:2-1-2-8") # 機能遷移番号
      assert(params_bind_params[5] == '123456789012345678901234567890AB', "CASE:2-1-2-9") # ログインID
      assert(params_bind_params[6] == 'Client_id', "CASE:2-1-2-10") # クライアントID
      assert(params_bind_params[7] == 1, "CASE:2-1-2-11") # ブラウザID
      assert(params_bind_params[8] == 2, "CASE:2-1-2-12") # ブラウザバージョンID
      assert(params_bind_params[9] == 'ja%', "CASE:2-1-2-13") # 言語
      assert(params_bind_params[10] == 'http://localhost:3000/menu/menu', "CASE:2-1-2-14") # リファラー
      assert(params_bind_params[11] == 'proxy.nifty%', "CASE:2-1-2-15") # プロキシホスト
      assert(params_bind_params[12] == '192.168.10.100%', "CASE:2-1-2-16") # プロキシIP
      assert(params_bind_params[13] == '%mote.nifty.%', "CASE:2-1-2-17") # クライアントホスト
      assert(params_bind_params[14] == '192.168.20.100%', "CASE:2-1-2-18") # クライアントIP
      assert(params_bind_params[15] == '%e.jp', "CASE:2-1-2-19") # ドメイン名
      assert(params_bind_params[16] == 8, "CASE:2-1-2-20") # リミット件数
      # 集計機関
#      print_log('rcvd_period:' + rcvd_period.to_s)
      assert(rcvd_period[0] == '200708', "CASE:2-1-2-7")
      assert(rcvd_period[1] == '201207', "CASE:2-1-2-7")
      # SQL文チェック(項目)
      result_list = RequestAnalysisResult.find_by_sql(sql_params)
      assert(!result_list.empty?, "CASE:2-1-2-21")
      assert(result_list.size == 1, "CASE:2-1-2-22")
      items = ex_item_list(statement)
#      print_log("items:" + items.to_s)
      assert(items[0] == 'request_analysis_results.system_id', "CASE:2-1-2-23")
      assert(items[1] == 'request_analysis_results.function_id', "CASE:2-1-2-24")
      assert(items[2] == 'request_analysis_results.function_transition_no', "CASE:2-1-2-25")
      assert(items[3] == 'request_analysis_results.browser_id', "CASE:2-1-2-26")
      assert(items[4] == 'request_analysis_results.domain_id', "CASE:2-1-2-27")
      assert(items[5] == 'domains.domain_name', "CASE:2-1-2-28")
      assert(items[6] == 'sum(request_analysis_results.request_count) AS total_access', "CASE:2-1-2-29")
      # SQL文チェック(テーブル)
      tables = ex_table_list(statement)
#      print_log("tables:" + tables.to_s)
      assert(tables[0] == 'request_analysis_results LEFT OUTER JOIN domains ON request_analysis_results.domain_id = domains.id', "CASE:2-1-2-30")
      # SQL文チェック(抽出条件)
      wheres = ex_where_list(statement)
#      print_log("wheres:" + wheres.to_s)
      assert(wheres[0] == "request_analysis_results.system_id = ?", "CASE:2-1-2-32")
      assert(wheres[1] == ex_received_date('month'), "CASE:2-1-2-33")
      assert(wheres[2] == "request_analysis_results.function_id = ?", "CASE:2-1-2-34")
      assert(wheres[3] == "request_analysis_results.function_transition_no = ?", "CASE:2-1-2-35")
      assert(wheres[4] == "request_analysis_results.session_id = ?", "CASE:2-1-2-36")
      assert(wheres[5] == "request_analysis_results.client_id = ?", "CASE:2-1-2-37")
      assert(wheres[6] == "request_analysis_results.browser_id = ?", "CASE:2-1-2-38")
      assert(wheres[7] == "request_analysis_results.browser_version_id <= ?", "CASE:2-1-2-39")
      assert(wheres[8] == "request_analysis_results.accept_language like ?", "CASE:2-1-2-40")
      assert(wheres[9] == "request_analysis_results.referrer = ?", "CASE:2-1-2-41")
      assert(wheres[10] == "request_analysis_results.proxy_host like ?", "CASE:2-1-2-42")
      assert(wheres[11] == "request_analysis_results.proxy_ip_address like ?", "CASE:2-1-2-43")
      assert(wheres[12] == "request_analysis_results.remote_host like ?", "CASE:2-1-2-44")
      assert(wheres[13] == "request_analysis_results.ip_address like ?", "CASE:2-1-2-45")
      assert(wheres[14] == "domains.domain_name like ?", "CASE:2-1-2-46")
      # SQL文チェック(グルーピング条件)
      grouping = ex_group_by_list(statement)
#      print_log("grouping:" + grouping.to_s)
      assert(grouping[0] == "request_analysis_results.system_id", "CASE:2-1-2-47")
      assert(grouping[1] == 'request_analysis_results.function_id', "CASE:2-1-2-48")
      assert(grouping[2] == 'request_analysis_results.function_transition_no', "CASE:2-1-2-49")
      assert(grouping[3] == 'request_analysis_results.browser_id', "CASE:2-1-2-50")
      assert(grouping[4] == 'request_analysis_results.domain_id', "CASE:2-1-2-50")
      assert(grouping[5] == 'domains.domain_name', "CASE:2-1-2-51")
      # SQL文チェック(ソート条件)
      order = ex_order_by_list(statement)
#      print_log("order:" + order.to_s)
      assert(order[0] == "total_access DESC", "CASE:2-1-2-52")
      # SQL文チェック(リミット件数条件)
      limit = ex_limit(statement)
#      print_log("limit:" + limit.to_s)
      assert(limit == "LIMIT ?", "CASE:2-1-2-53")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # 正常
    # 項目：システムID、機能ID、機能遷移番号、ブラウザID、リモートホスト
    # 期間：10日単位
    # 抽出条件：ドメイン有り
    begin
      # テストデータ作成
      test_data = RequestAnalysisResult.new
      test_data.system_id = 1
      test_data.request_analysis_schedule_id = 1
      test_data.received_year = 2008
      test_data.received_month = 4
      test_data.received_day = 19
      test_data.function_id = 3
      test_data.function_transition_no = 3
      test_data.session_id = '123456789012345678901234567890AB'
      test_data.client_id = 'Client_id'
      test_data.domain_id = 1
      test_data.browser_id = 1
      test_data.browser_version_id = 2
      test_data.accept_language = 'ja'
      test_data.referrer = 'http://localhost:3000/menu/menu'
      test_data.proxy_host = 'proxy.nifty.com'
      test_data.proxy_ip_address = '192.168.10.100'
      test_data.remote_host = 'remote.nifty.com'
      test_data.ip_address = '192.168.20.100'
      test_data.domain_id = 1
      test_data.request_count = 10
      test_data.save!
#      print_log("RequestAnalysisResult:" + RequestAnalysisResult.where(:received_year=>2007).to_s)
      # パラメータ生成
      params = default_params
      params[:item_2] = 'function_id'
      params[:item_3] = 'function_transition_no'
      params[:item_4] = 'browser_id'
      params[:item_5] = 'remote_host'
      params[:time_unit_num] = '10'
      params[:time_unit] = 'day'
      params[:disp_number] = '5'
      params[:disp_order] = 'ASC'
      params[:function_id] = nil
      params[:function_trans_no] = '5'
      params[:function_trans_no_comp] = 'NE'
      params[:browser_version_id] = '3'
      params[:browser_version_id_comp] = 'LT'
      params[:domain_name] = 'e.jp'
      params[:domain_name_match] = 'B'
      # コンストラクタ生成
      sql_obj = SQLRanking.new(params)
      assert(!sql_obj.nil?, "CASE:2-1-3-1")
      # パラメータチェック
      statement = sql_obj.statement
      bind_params = sql_obj.bind_params
      sql_params  = sql_obj.sql_params
      rcvd_period = sql_obj.rcvd_period
      # SQLパラメータチェック
      params_bind_params = sql_params.dup
      params_statement = params_bind_params.shift
#      print_log("params:" + params_bind_params.to_s)
      assert(statement == params_statement, "CASE:2-1-3-2")
      assert(bind_params == params_bind_params, "CASE:2-1-3-3")
      assert(params_bind_params[0] == '20071003', "CASE:2-1-3-4")
      assert(params_bind_params[1] == '20080419', "CASE:2-1-3-5")
      assert(params_bind_params[2] == 5, "CASE:2-1-3-6") # 機能遷移番号
      assert(params_bind_params[3] == 3, "CASE:2-1-3-7") # ブラウザバージョンID
      assert(params_bind_params[4] == '%e.jp', "CASE:2-1-3-8") # ドメイン名
      assert(params_bind_params[5] == 5, "CASE:2-1-3-9") # リミット件数
      # 集計機関
#      print_log('rcvd_period:' + rcvd_period.to_s)
      assert(rcvd_period[0] == '20071003', "CASE:2-1-3-7")
      assert(rcvd_period[1] == '20080419', "CASE:2-1-3-7")
      # SQL文チェック(項目)
      result_list = RequestAnalysisResult.find_by_sql(sql_params)
      assert(!result_list.empty?, "CASE:2-1-3-10")
      assert(result_list.size == 1, "CASE:2-1-3-11")
      items = ex_item_list(statement)
#      print_log("items:" + items.to_s)
      assert(items[0] == 'request_analysis_results.system_id', "CASE:2-1-3-12")
      assert(items[1] == 'request_analysis_results.function_id', "CASE:2-1-3-13")
      assert(items[2] == 'request_analysis_results.function_transition_no', "CASE:2-1-3-14")
      assert(items[3] == 'request_analysis_results.browser_id', "CASE:2-1-3-15")
      assert(items[4] == 'request_analysis_results.remote_host', "CASE:2-1-3-16")
      assert(items[5] == 'sum(request_analysis_results.request_count) AS total_access', "CASE:2-1-3-17")
      # SQL文チェック(テーブル)
      tables = ex_table_list(statement)
#      print_log("tables:" + tables.to_s)
      assert(tables[0] == 'request_analysis_results LEFT OUTER JOIN domains ON request_analysis_results.domain_id = domains.id', "CASE:2-1-3-18")
      # SQL文チェック(抽出条件)
      wheres = ex_where_list(statement)
#      print_log("wheres:" + wheres.to_s)
      assert(wheres[0] == ex_received_date('day'), "CASE:2-1-3-16")
      assert(wheres[1] == "request_analysis_results.function_transition_no <> ?", "CASE:2-1-3-17")
      assert(wheres[2] == "request_analysis_results.browser_version_id < ?", "CASE:2-1-3-17")
      assert(wheres[3] == "domains.domain_name like ?", "CASE:2-1-3-17")
      # SQL文チェック(グルーピング条件)
      grouping = ex_group_by_list(statement)
#      print_log("grouping:" + grouping.to_s)
      assert(grouping[0] == "request_analysis_results.system_id", "CASE:2-1-3-13")
      assert(grouping[1] == 'request_analysis_results.function_id', "CASE:2-1-3-10")
      assert(grouping[2] == 'request_analysis_results.function_transition_no', "CASE:2-1-3-11")
      assert(grouping[3] == 'request_analysis_results.browser_id', "CASE:2-1-3-12")
      assert(grouping[4] == 'request_analysis_results.remote_host', "CASE:2-1-3-13")
      # SQL文チェック(ソート条件)
      order = ex_order_by_list(statement)
#      print_log("order:" + order.to_s)
      assert(order[0] == "total_access ASC", "CASE:2-1-3-14")
      # SQL文チェック(リミット件数条件)
      limit = ex_limit(statement)
#      print_log("limit:" + limit.to_s)
      assert(limit == "LIMIT ?", "CASE:2-1-3-15")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # 正常
    # 項目：システムID、機能ID、機能遷移番号、ブラウザID、ドメイン
    # 期間：3時間単位
    # 抽出条件：ドメイン有り
    begin
      # テストデータ作成
      test_data = RequestAnalysisResult.new
      test_data.system_id = 1
      test_data.request_analysis_schedule_id = 1
      test_data.received_year = 2007
      test_data.received_month = 10
      test_data.received_day = 13
      test_data.received_hour = 11
      test_data.request_count = 5
      test_data.save!
      # パラメータ生成
      params = default_params
      params[:item_1] = 'system_id'
      params[:item_2] = 'function_id'
      params[:item_3] = 'function_transition_no'
      params[:item_4] = 'referrer'
      params[:item_5] = 'domain_name'
      params[:time_unit_num] = '3'
      params[:time_unit] = 'hour'
      params[:disp_number] = '8'
      params[:disp_order] = 'DESC'
      params[:function_id] = nil
      # コンストラクタ生成
      sql_obj = SQLRanking.new(params)
      assert(!sql_obj.nil?, "CASE:2-1-4-1")
      # パラメータチェック
      statement = sql_obj.statement
      bind_params = sql_obj.bind_params
      sql_params  = sql_obj.sql_params
      rcvd_period = sql_obj.rcvd_period
      # SQLパラメータチェック
      params_bind_params = sql_params.dup
      params_statement = params_bind_params.shift
#      print_log("params:" + params_bind_params.to_s)
      assert(statement == params_statement, "CASE:2-1-4-2")
      assert(bind_params == params_bind_params, "CASE:2-1-4-3")
      assert(params_bind_params[0] == '2007101208', "CASE:2-1-4-4")
      assert(params_bind_params[1] == '2007101419', "CASE:2-1-4-5")
      assert(params_bind_params[2] == 8, "CASE:2-1-4-7") # リミット件数
      # 集計機関
#      print_log('rcvd_period:' + rcvd_period.to_s)
      assert(rcvd_period[0] == '2007101208', "CASE:2-1-4-7")
      assert(rcvd_period[1] == '2007101419', "CASE:2-1-4-7")
      # SQL文チェック(項目)
      result_list = RequestAnalysisResult.find_by_sql(sql_params)
      assert(!result_list.empty?, "CASE:2-1-4-8")
      assert(result_list.size == 1, "CASE:2-1-4-8")
      items = ex_item_list(statement)
#      print_log("items:" + items.to_s)
      assert(items[0] == 'request_analysis_results.system_id', "CASE:2-1-4-9")
      assert(items[1] == 'request_analysis_results.function_id', "CASE:2-1-4-10")
      assert(items[2] == 'request_analysis_results.function_transition_no', "CASE:2-1-4-11")
      assert(items[3] == 'request_analysis_results.referrer', "CASE:2-1-4-12")
      assert(items[4] == 'request_analysis_results.domain_id', "CASE:2-1-4-13")
      assert(items[5] == 'domains.domain_name', "CASE:2-1-4-14")
      assert(items[6] == 'sum(request_analysis_results.request_count) AS total_access', "CASE:2-1-4-15")
      # SQL文チェック(テーブル)
      tables = ex_table_list(statement)
#      print_log("tables:" + tables.to_s)
      assert(tables[0] == 'request_analysis_results LEFT OUTER JOIN domains ON request_analysis_results.domain_id = domains.id', "CASE:2-1-4-16")
      # SQL文チェック(抽出条件)
      wheres = ex_where_list(statement)
#      print_log("wheres:" + wheres.to_s)
      assert(wheres[0] == ex_received_date('hour'), "CASE:2-1-4-16")
      # SQL文チェック(グルーピング条件)
      grouping = ex_group_by_list(statement)
#      print_log("grouping:" + grouping.to_s)
      assert(grouping[0] == "request_analysis_results.system_id", "CASE:2-1-4-13")
      assert(grouping[1] == 'request_analysis_results.function_id', "CASE:2-1-4-10")
      assert(grouping[2] == 'request_analysis_results.function_transition_no', "CASE:2-1-4-11")
      assert(grouping[3] == 'request_analysis_results.referrer', "CASE:2-1-4-11")
      assert(grouping[4] == 'request_analysis_results.domain_id', "CASE:2-1-4-11")
      assert(grouping[5] == 'domains.domain_name', "CASE:2-1-4-13")
      # SQL文チェック(ソート条件)
      order = ex_order_by_list(statement)
#      print_log("order:" + order.to_s)
      assert(order[0] == "total_access DESC", "CASE:2-1-4-14")
      # SQL文チェック(リミット件数条件)
      limit = ex_limit(statement)
#      print_log("limit:" + limit.to_s)
      assert(limit == "LIMIT ?", "CASE:2-1-4-15")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
    # 正常
    # 項目：システムID、機能ID、機能遷移番号、ブラウザID、ドメイン
    # 期間：30分単位
    # 抽出条件：ドメイン有り
    begin
      # テストデータ作成
      test_data = RequestAnalysisResult.new
      test_data.system_id = 1
      test_data.request_analysis_schedule_id = 1
      test_data.received_year = 2007
      test_data.received_month = 10
      test_data.received_day = 12
      test_data.received_hour = 9
      test_data.received_minute = 31
      test_data.request_count = 5
      test_data.save!
      # パラメータ生成
      params = default_params
      params[:item_1] = 'system_id'
      params[:item_2] = 'function_id'
      params[:item_3] = 'function_transition_no'
      params[:item_4] = 'referrer'
      params[:item_5] = 'domain_name'
      params[:time_unit_num] = '30'
      params[:time_unit] = 'minute'
      params[:disp_number] = '8'
      params[:disp_order] = 'DESC'
      params[:function_id] = nil
      # コンストラクタ生成
      sql_obj = SQLRanking.new(params)
      assert(!sql_obj.nil?, "CASE:2-1-5-1")
      # パラメータチェック
      statement = sql_obj.statement
      bind_params = sql_obj.bind_params
      sql_params  = sql_obj.sql_params
      rcvd_period = sql_obj.rcvd_period
      # SQLパラメータチェック
      params_bind_params = sql_params.dup
      params_statement = params_bind_params.shift
#      print_log("params:" + params_bind_params.to_s)
      assert(statement == params_statement, "CASE:2-1-5-2")
      assert(bind_params == params_bind_params, "CASE:2-1-5-3")
      assert(params_bind_params[0] == '200710120931', "CASE:2-1-5-4")
      assert(params_bind_params[1] == '200710121930', "CASE:2-1-5-5")
      assert(params_bind_params[2] == 8, "CASE:2-1-5-7") # リミット件数
      # 集計機関
#      print_log('rcvd_period:' + rcvd_period.to_s)
      assert(rcvd_period[0] == '200710120931', "CASE:2-1-5-7")
      assert(rcvd_period[1] == '200710121930', "CASE:2-1-5-7")
      # SQL文チェック(項目)
      result_list = RequestAnalysisResult.find_by_sql(sql_params)
      assert(!result_list.empty?, "CASE:2-1-5-8")
      assert(result_list.size == 1, "CASE:2-1-5-8")
      items = ex_item_list(statement)
#      print_log("items:" + items.to_s)
      assert(items[0] == 'request_analysis_results.system_id', "CASE:2-1-5-9")
      assert(items[1] == 'request_analysis_results.function_id', "CASE:2-1-5-10")
      assert(items[2] == 'request_analysis_results.function_transition_no', "CASE:2-1-5-11")
      assert(items[3] == 'request_analysis_results.referrer', "CASE:2-1-5-12")
      assert(items[4] == 'request_analysis_results.domain_id', "CASE:2-1-5-13")
      assert(items[5] == 'domains.domain_name', "CASE:2-1-5-14")
      assert(items[6] == 'sum(request_analysis_results.request_count) AS total_access', "CASE:2-1-5-15")
      # SQL文チェック(テーブル)
      tables = ex_table_list(statement)
#      print_log("tables:" + tables.to_s)
      assert(tables[0] == 'request_analysis_results LEFT OUTER JOIN domains ON request_analysis_results.domain_id = domains.id', "CASE:2-1-5-16")
      # SQL文チェック(抽出条件)
      wheres = ex_where_list(statement)
#      print_log("wheres:" + wheres.to_s)
      assert(wheres[0] == ex_received_date('minute'), "CASE:2-1-5-16")
      # SQL文チェック(グルーピング条件)
      grouping = ex_group_by_list(statement)
#      print_log("grouping:" + grouping.to_s)
      assert(grouping[0] == "request_analysis_results.system_id", "CASE:2-1-5-13")
      assert(grouping[1] == 'request_analysis_results.function_id', "CASE:2-1-5-10")
      assert(grouping[2] == 'request_analysis_results.function_transition_no', "CASE:2-1-5-11")
      assert(grouping[3] == 'request_analysis_results.referrer', "CASE:2-1-5-11")
      assert(grouping[4] == 'request_analysis_results.domain_id', "CASE:2-1-5-11")
      assert(grouping[5] == 'domains.domain_name', "CASE:2-1-5-13")
      # SQL文チェック(ソート条件)
      order = ex_order_by_list(statement)
#      print_log("order:" + order.to_s)
      assert(order[0] == "total_access DESC", "CASE:2-1-5-14")
      # SQL文チェック(リミット件数条件)
      limit = ex_limit(statement)
#      print_log("limit:" + limit.to_s)
      assert(limit == "LIMIT ?", "CASE:2-1-5-15")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-5")
    end
    # 正常
    # 項目：システムID、機能ID、機能遷移番号、ブラウザID、ドメイン
    # 期間：30秒単位
    # 抽出条件：ドメイン有り
    begin
      # テストデータ作成
      test_data = RequestAnalysisResult.new
      test_data.system_id = 1
      test_data.request_analysis_schedule_id = 1
      test_data.received_year = 2007
      test_data.received_month = 10
      test_data.received_day = 12
      test_data.received_hour = 9
      test_data.received_minute = 59
      test_data.received_second = 59
      test_data.request_count = 5
      test_data.save!
      # パラメータ生成
      params = default_params
      params[:item_1] = 'system_id'
      params[:item_2] = 'function_id'
      params[:item_3] = 'function_transition_no'
      params[:item_4] = 'referrer'
      params[:item_5] = 'domain_name'
      params[:time_unit_num] = '30'
      params[:time_unit] = 'second'
      params[:disp_number] = '8'
      params[:disp_order] = 'DESC'
      params[:function_id] = nil
      # コンストラクタ生成
      sql_obj = SQLRanking.new(params)
      assert(!sql_obj.nil?, "CASE:2-1-6-1")
      # パラメータチェック
      statement = sql_obj.statement
      bind_params = sql_obj.bind_params
      sql_params  = sql_obj.sql_params
      rcvd_period = sql_obj.rcvd_period
      # SQLパラメータチェック
      params_bind_params = sql_params.dup
      params_statement = params_bind_params.shift
#      print_log("params:" + params_bind_params.to_s)
      assert(statement == params_statement, "CASE:2-1-6-2")
      assert(bind_params == params_bind_params, "CASE:2-1-6-3")
      assert(params_bind_params[0] == '20071012095931', "CASE:2-1-6-4")
      assert(params_bind_params[1] == '20071012100930', "CASE:2-1-6-5")
      assert(params_bind_params[2] == 8, "CASE:2-1-6-7") # リミット件数
      # 集計機関
#      print_log('rcvd_period:' + rcvd_period.to_s)
      assert(rcvd_period[0] == '20071012095931', "CASE:2-1-6-7")
      assert(rcvd_period[1] == '20071012100930', "CASE:2-1-6-7")
      # SQL文チェック(項目)
      result_list = RequestAnalysisResult.find_by_sql(sql_params)
      assert(!result_list.empty?, "CASE:2-1-6-8")
      assert(result_list.size == 1, "CASE:2-1-6-8")
      items = ex_item_list(statement)
#      print_log("items:" + items.to_s)
      assert(items[0] == 'request_analysis_results.system_id', "CASE:2-1-6-9")
      assert(items[1] == 'request_analysis_results.function_id', "CASE:2-1-6-10")
      assert(items[2] == 'request_analysis_results.function_transition_no', "CASE:2-1-6-11")
      assert(items[3] == 'request_analysis_results.referrer', "CASE:2-1-6-12")
      assert(items[4] == 'request_analysis_results.domain_id', "CASE:2-1-6-13")
      assert(items[5] == 'domains.domain_name', "CASE:2-1-6-14")
      assert(items[6] == 'sum(request_analysis_results.request_count) AS total_access', "CASE:2-1-6-15")
      # SQL文チェック(テーブル)
      tables = ex_table_list(statement)
#      print_log("tables:" + tables.to_s)
      assert(tables[0] == 'request_analysis_results LEFT OUTER JOIN domains ON request_analysis_results.domain_id = domains.id', "CASE:2-1-6-16")
      # SQL文チェック(抽出条件)
      wheres = ex_where_list(statement)
#      print_log("wheres:" + wheres.to_s)
      assert(wheres[0] == ex_received_date('second'), "CASE:2-1-6-16")
      # SQL文チェック(グルーピング条件)
      grouping = ex_group_by_list(statement)
#      print_log("grouping:" + grouping.to_s)
      assert(grouping[0] == "request_analysis_results.system_id", "CASE:2-1-6-13")
      assert(grouping[1] == 'request_analysis_results.function_id', "CASE:2-1-6-10")
      assert(grouping[2] == 'request_analysis_results.function_transition_no', "CASE:2-1-6-11")
      assert(grouping[3] == 'request_analysis_results.referrer', "CASE:2-1-6-11")
      assert(grouping[4] == 'request_analysis_results.domain_id', "CASE:2-1-6-11")
      assert(grouping[5] == 'domains.domain_name', "CASE:2-1-6-13")
      # SQL文チェック(ソート条件)
      order = ex_order_by_list(statement)
#      print_log("order:" + order.to_s)
      assert(order[0] == "total_access DESC", "CASE:2-1-6-14")
      # SQL文チェック(リミット件数条件)
      limit = ex_limit(statement)
#      print_log("limit:" + limit.to_s)
      assert(limit == "LIMIT ?", "CASE:2-1-6-15")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-6")
    end
    # 異常
    # 項目：システムID、機能ID、機能遷移番号、ブラウザID、ドメイン
    # 期間：3時間単位
    # 抽出条件：ドメイン有り
    sql_obj = nil
    begin
      # パラメータ生成
      params = default_params
      params[:item_1] = 'system_id'
      params[:item_2] = 'function_id'
      params[:item_3] = 'function_transition_no'
      params[:item_4] = 'referrer'
      params[:item_5] = 'domain_name'
      params[:time_unit_num] = 'さんじゅう'
      params[:time_unit] = 'second'
      params[:disp_number] = '8'
      params[:disp_order] = 'DESC'
      params[:function_id] = nil
      # コンストラクタ生成
      sql_obj = SQLRanking.new(params)
      assert(sql_obj.nil?, "CASE:2-1-7-1")
      flunk("CASE:2-1-7")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      assert(sql_obj.nil?, "CASE:2-1-7-1")
    end
  end

  #############################################################################
  # 共通メソッド
  #############################################################################
  # 永続化処理
  def default_params
    params = Hash.new
    params[:item_1] = 'system_id'
    params[:received_date_from] = DateTime.new(2012,10,12,10,0,0) - 5.years
    params[:time_unit_num] = '1'
    params[:time_unit] = 'year'
    params[:aggregation_period] = '20'
    params[:disp_order] = 'DESC'
    params[:disp_number] = '8'
    params[:function_id] = '1'
    return params
  end
  
  # 項目リスト抽出
  def ex_item_list(statement)
    head = statement.scan(/SELECT .* FROM/)[0]
    return head.sub("SELECT ", "").sub(" FROM", "").split(',')
  end
  
  # テーブルリスト抽出
  def ex_table_list(statement)
    from = statement.scan(/FROM .* WHERE/)[0]
    return from.sub("FROM ", "").sub(" WHERE", "").split(',')
  end
  
  # 条件リスト抽出
  def ex_where_list(statement)
    where = statement.scan(/WHERE .* GROUP/)[0]
    cond_list = Array.new
    bef_cond = nil
    where.sub("WHERE ", "").sub(" GROUP", "").split(/ AND /).each do |cond|
      if cond.include?(' BETWEEN ') then
        bef_cond = cond
      elsif bef_cond.nil? then
        cond_list.push(cond)
      else
        cond_list.push(bef_cond + ' AND ' + cond)
        bef_cond = nil
      end
    end
    return cond_list
  end
  
  # グルーピング条件抽出
  def ex_group_by_list(statement)
    group = statement.scan(/GROUP BY .* ORDER BY/)[0]
    return group.sub("GROUP BY ", "").sub(" ORDER BY", "").split(',')
  end
  
  # ソート条件抽出
  def ex_order_by_list(statement)
    order = statement.scan(/ORDER BY .* LIMIT/)[0]
    return order.sub("ORDER BY ", "").sub(" LIMIT", "").split(',')
  end
  
  # リミット条件抽出
  def ex_limit(statement)
    return statement.scan(/LIMIT .*$/)[0]
  end
  
  # 受信日時の生成ロジック
  def ex_received_date(time_unit)
    rcvd_time_item = "concat(lpad(ifnull(request_analysis_results.received_year, 'XXXX'), 4, '0')"
    if time_unit != 'year' then
      ['month', 'day', 'hour', 'minute', 'second'].each do |unit|
        now_item = ',lpad(ifnull(request_analysis_results.received_' + unit + ", 'XX'), 2, '0')"
        rcvd_time_item = rcvd_time_item + now_item
        break if unit == time_unit
      end
    end
    rcvd_time_item = rcvd_time_item + ")"
    return '(' + rcvd_time_item + ' BETWEEN ? AND ?)'
  end
end