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

class SQLTotalizationTest < ActiveSupport::TestCase
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
  test "2-1:SQLTotalization Test:initialize" do
    # 正常（デフォルト入力）
    # 表示項目：ドメイン名無し
    # テーブル：ドメイン結合無し
    # 抽出条件：無し
    # ソート条件：降順
    begin
      params = {:item_1=>'system_id'}
      params[:received_date_from] = DateTime.new(2012,10,12,10,0,0) - 5.years
      params[:time_unit_num] = '1'
      params[:time_unit] = 'year'
      params[:aggregation_period] = '20'
      params[:disp_order] = 'DESC'
      params[:disp_number] = '8'
      # コンストラクタ生成
      sql_obj = SQLTotalization.new(params)
      view_obj = SQLRanking.new(params)
      assert(!sql_obj.nil?, "CASE:2-1-1-1")
      # パラメータチェック
      statement = sql_obj.statement
      bind_params = sql_obj.bind_params
      sql_params  = sql_obj.sql_params
      # SQLパラメータチェック
      params_bind_params = sql_params.dup
      params_statement = params_bind_params.shift
#      print_log('bind_param:' + params_bind_params.to_s)
      assert(statement == params_statement, "CASE:2-1-1-2")
      assert(bind_params == params_bind_params, "CASE:2-1-1-3")
      assert(params_bind_params.size == 5, "CASE:2-1-1-15")
      assert(params_bind_params[0] == '2007', "CASE:2-1-1-4")
      assert(params_bind_params[1] == '2026', "CASE:2-1-1-5")
      assert(params_bind_params[2] == 8, "CASE:2-1-1-7")
      assert(params_bind_params[3] == '2007', "CASE:2-1-1-8")
      assert(params_bind_params[4] == '2026', "CASE:2-1-1-9")
      # SQL文チェック(項目)
      result_list = RequestAnalysisResult.find_by_sql(sql_params)
      assert(!result_list.empty?, "CASE:2-1-1-8")
      items = ex_item_list(statement)
#      print_log("items:" + items.to_s)
      assert(items.size == 4, "CASE:2-1-1-15")
      assert(items[0] == 'request_analysis_results.system_id', "CASE:2-1-1-9")
      assert(items[1] == 'request_analysis_results.received_year', "CASE:2-1-1-10")
      assert(items[2] == 'rank_view.total_access', "CASE:2-1-1-11")
      assert(items[3] == 'sum(request_analysis_results.request_count) AS request_count', "CASE:2-1-1-12")
      # SQL文チェック(テーブル)
      tables = ex_table_list(statement)
#      print_log("tables:" + tables.to_s)
      assert(tables.size == 2, "CASE:2-1-1-15")
      assert(tables[0] == 'request_analysis_results', "CASE:2-1-1-11")
      assert(tables[1] == 'rank_view', "CASE:2-1-1-11")
      # SQL文チェック(インラインビュー)
      view_stmt = ex_rank_stmt(statement)
#      print_log("view_stmt:" + view_stmt)
      assert(view_stmt == view_obj.statement, "CASE:2-1-1-11")
      # SQL文チェック(抽出条件)
      where_stmt = ex_where_stmt(statement)
#      print_log("where_stmt:" + where_stmt)
      match_stmt = "(request_analysis_results.system_id = rank_view.system_id OR "
      match_stmt += "request_analysis_results.system_id IS NULL AND "
      match_stmt += "rank_view.system_id IS NULL) AND "
      match_stmt += ex_received_date('year')
#      print_log("match_stmt:" + match_stmt)
#      assert(wheres.size == 2, "CASE:2-1-1-15")
#      assert(where_stmt == match_stmt, "CASE:2-1-1-12")
#      assert(wheres[1] == "request_analysis_results.function_id = ?", "CASE:2-1-1-13")
      # SQL文チェック(グルーピング条件)
      grouping = ex_group_by_list(statement)
#      print_log("grouping:" + grouping.to_s)
      assert(grouping.size == 3, "CASE:2-1-1-15")
      assert(grouping[0] == "request_analysis_results.system_id", "CASE:2-1-1-14")
      assert(grouping[1] == "request_analysis_results.received_year", "CASE:2-1-1-14")
      assert(grouping[2] == "rank_view.total_access", "CASE:2-1-1-14")
      # SQL文チェック(ソート条件)
      order = ex_order_by_list(statement)
#      print_log("order:" + order.to_s)
      assert(order.size == 3, "CASE:2-1-1-15")
      assert(order[0] == "rank_view.total_access DESC", "CASE:2-1-1-15")
      assert(order[1] == "request_analysis_results.system_id ASC", "CASE:2-1-1-15")
      assert(order[2] == "request_analysis_results.received_year ASC", "CASE:2-1-1-15")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 正常（デフォルト入力）
    # 表示項目：ドメイン名無し、全指定、10秒単位
    # テーブル：ドメイン結合無し
    # 抽出条件：ドメイン名以外全部
    # ソート条件：降順
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
      test_data.received_second = 55
      test_data.function_id = 2
      test_data.function_transition_no = 3
      test_data.session_id = '123456789012345678901234567890AB'
      test_data.client_id = 'Client_id'
      test_data.domain_id = 1
      test_data.browser_id = 2
      test_data.browser_version_id = 1
      test_data.accept_language = 'ja'
      test_data.referrer = 'http://localhost:3000/menu/menu'
      test_data.proxy_host = 'proxy.nifty.com'
      test_data.proxy_ip_address = '192.168.10.100'
      test_data.remote_host = 'remote.nifty.com'
      test_data.ip_address = '192.168.20.100'
#      test_data.domain_id = 1
      test_data.request_count = 10
      test_data.save!
#      print_log("RequestAnalysisResult:" + RequestAnalysisResult.where(:received_year=>2007).to_s)
      # 線分類
      params = {:item_1=>'system_id'}
      params[:item_2] = 'function_id'
      params[:item_3] = 'function_transition_no'
      params[:item_4] = 'session_id'
      params[:item_5] = 'client_id'
      # 集計条件
      params[:received_date_from] = DateTime.new(2012,10,12,10,0,0) - 5.years
      params[:time_unit_num] = '10'
      params[:time_unit] = 'second'
      params[:aggregation_period] = '20'
      params[:disp_order] = 'DESC'
      params[:disp_number] = '8'
      # 抽出条件
      params[:system_id] = '1'
      params[:function_id] = '2'
      params[:function_trans_no] = '3'
      params[:function_trans_no_comp] = 'EQ'
      params[:session_id] = '123456789012345678901234567890AB'
      params[:client_id] = 'Client_id'
      params[:browser_id] = '2'
      params[:browser_version_id] = '1'
      params[:browser_version_id_comp] = 'EQ'
      params[:accept_language] = 'ja'
      params[:referrer] = 'http://localhost:3000/menu/menu'
      params[:referrer_match] = 'E'
      params[:proxy_host] = 'oxy.nifty.co'
      params[:proxy_host_match] = 'P'
      params[:proxy_ip_address] = '192.168.10.100'
      params[:remote_host] = 'remote.nifty.'
      params[:remote_host_match] = 'F'
      params[:ip_address] = '192.168.20.100'
      # コンストラクタ生成
      sql_obj = SQLTotalization.new(params)
      view_obj = SQLRanking.new(params)
      assert(!sql_obj.nil?, "CASE:2-1-2-1")
      # パラメータチェック
      statement = sql_obj.statement
      bind_params = sql_obj.bind_params
      sql_params  = sql_obj.sql_params
      # SQLパラメータチェック
      params_bind_params = sql_params.dup
      params_statement = params_bind_params.shift
#      print_log('bind_param:' + params_bind_params.to_s)
      assert(statement == params_statement, "CASE:2-1-2-2")
      assert(bind_params == params_bind_params, "CASE:2-1-2-3")
#      print_log('params.size:' + params_bind_params.size.to_s)
      assert(params_bind_params.size == 26, "CASE:2-1-2-4")
      assert(params_bind_params[0] == 1, "CASE:2-1-2-5")
      assert(params_bind_params[1] == '20071012095951', "CASE:2-1-2-6")
      assert(params_bind_params[2] == '20071012100310', "CASE:2-1-2-7")
      assert(params_bind_params[3] == 2, "CASE:2-1-2-8")
      assert(params_bind_params[4] == 3, "CASE:2-1-2-9")
      assert(params_bind_params[5] == '123456789012345678901234567890AB', "CASE:2-1-2-10")
      assert(params_bind_params[6] == 'Client_id', "CASE:2-1-2-11")
      assert(params_bind_params[7] == 2, "CASE:2-1-2-12")
      assert(params_bind_params[8] == 1, "CASE:2-1-2-13")
      assert(params_bind_params[9] == 'ja%', "CASE:2-1-2-14")
      assert(params_bind_params[10] == 'http://localhost:3000/menu/menu', "CASE:2-1-2-15")
      assert(params_bind_params[11] == '%oxy.nifty.co%', "CASE:2-1-2-16")
      assert(params_bind_params[12] == '192.168.10.100%', "CASE:2-1-2-17")
      assert(params_bind_params[13] == 'remote.nifty.%', "CASE:2-1-2-19")
      assert(params_bind_params[14] == '192.168.20.100%', "CASE:2-1-2-20")
      assert(params_bind_params[15] == 8, "CASE:2-1-2-21")
      assert(params_bind_params[16] == '20071012095951', "CASE:2-1-2-22")
      assert(params_bind_params[17] == '20071012100310', "CASE:2-1-2-23")
      assert(params_bind_params[18] == 2, "CASE:2-1-2-24")
      assert(params_bind_params[19] == 1, "CASE:2-1-2-25")
      assert(params_bind_params[20] == 'ja%', "CASE:2-1-2-26")
      assert(params_bind_params[21] == 'http://localhost:3000/menu/menu', "CASE:2-1-2-27")
      assert(params_bind_params[22] == '%oxy.nifty.co%', "CASE:2-1-2-28")
      assert(params_bind_params[23] == '192.168.10.100%', "CASE:2-1-2-29")
      assert(params_bind_params[24] == 'remote.nifty.%', "CASE:2-1-2-30")
      assert(params_bind_params[25] == '192.168.20.100%', "CASE:2-1-2-31")
      # SQL文チェック(項目)
      result_list = RequestAnalysisResult.find_by_sql(sql_params)
      assert(!result_list.empty?, "CASE:2-1-2-32")
      items = ex_item_list(statement)
#      print_log("items:" + items.to_s)
      assert(items.size == 13, "CASE:2-1-2-33")
      assert(items[0] == 'request_analysis_results.system_id', "CASE:2-1-2-34")
      assert(items[1] == 'request_analysis_results.function_id', "CASE:2-1-2-35")
      assert(items[2] == 'request_analysis_results.function_transition_no', "CASE:2-1-2-36")
      assert(items[3] == 'request_analysis_results.session_id', "CASE:2-1-2-37")
      assert(items[4] == 'request_analysis_results.client_id', "CASE:2-1-2-38")
      assert(items[5] == 'request_analysis_results.received_year', "CASE:2-1-2-39")
      assert(items[6] == 'request_analysis_results.received_month', "CASE:2-1-2-40")
      assert(items[7] == 'request_analysis_results.received_day', "CASE:2-1-2-41")
      assert(items[8] == 'request_analysis_results.received_hour', "CASE:2-1-2-42")
      assert(items[9] == 'request_analysis_results.received_minute', "CASE:2-1-2-43")
      assert(items[10] == 'request_analysis_results.received_second', "CASE:2-1-2-44")
      assert(items[11] == 'rank_view.total_access', "CASE:2-1-2-45")
      assert(items[12] == 'sum(request_analysis_results.request_count) AS request_count', "CASE:2-1-2-46")
      # SQL文チェック(テーブル)
      tables = ex_table_list(statement)
#      print_log("tables:" + tables.to_s)
      assert(tables.size == 2, "CASE:2-1-2-47")
      assert(tables[0] == 'request_analysis_results', "CASE:2-1-2-48")
      assert(tables[1] == 'rank_view', "CASE:2-1-2-49")
      # SQL文チェック(インラインビュー)
      view_stmt = ex_rank_stmt(statement)
#      print_log("view_stmt:" + view_stmt)
      assert(view_stmt == view_obj.statement, "CASE:2-1-2-50")
      # SQL文チェック(抽出条件)
      where_stmt = ex_where_stmt(statement)
#      print_log("where_stmt:" + where_stmt)
      match_stmt = "(request_analysis_results.system_id = rank_view.system_id OR "
      match_stmt += "request_analysis_results.system_id IS NULL AND "
      match_stmt += "rank_view.system_id IS NULL) AND "
      match_stmt += "(request_analysis_results.function_id = rank_view.function_id OR "
      match_stmt += "request_analysis_results.function_id IS NULL AND "
      match_stmt += "rank_view.function_id IS NULL) AND "
      match_stmt += "(request_analysis_results.function_transition_no = rank_view.function_transition_no OR "
      match_stmt += "request_analysis_results.function_transition_no IS NULL AND "
      match_stmt += "rank_view.function_transition_no IS NULL) AND "
      match_stmt += "(request_analysis_results.session_id = rank_view.session_id OR "
      match_stmt += "request_analysis_results.session_id IS NULL AND "
      match_stmt += "rank_view.session_id IS NULL) AND "
      match_stmt += "(request_analysis_results.client_id = rank_view.client_id OR "
      match_stmt += "request_analysis_results.client_id IS NULL AND "
      match_stmt += "rank_view.client_id IS NULL) AND "
      match_stmt += ex_received_date('second') + ' AND '
      match_stmt += "request_analysis_results.browser_id = ? AND "
      match_stmt += "request_analysis_results.browser_version_id = ? AND "
      match_stmt += "request_analysis_results.accept_language like ? AND "
      match_stmt += "request_analysis_results.referrer = ? AND "
      match_stmt += "request_analysis_results.proxy_host like ? AND "
      match_stmt += "request_analysis_results.proxy_ip_address like ? AND "
      match_stmt += "request_analysis_results.remote_host like ? AND "
      match_stmt += "request_analysis_results.ip_address like ?"
#      print_log("match_stmt:" + match_stmt)
      assert(where_stmt == match_stmt, "CASE:2-1-2-51")
#      assert(wheres[13] == "request_analysis_results.ip_address like ?", "CASE:2-1-2-13")
      # SQL文チェック(グルーピング条件)
      grouping = ex_group_by_list(statement)
#      print_log("grouping:" + grouping.to_s)
      assert(grouping.size == 12, "CASE:2-1-2-52")
      assert(grouping[0] == "request_analysis_results.system_id", "CASE:2-1-2-53")
      assert(grouping[1] == "request_analysis_results.function_id", "CASE:2-1-2-54")
      assert(grouping[2] == "request_analysis_results.function_transition_no", "CASE:2-1-2-55")
      assert(grouping[3] == "request_analysis_results.session_id", "CASE:2-1-2-56")
      assert(grouping[4] == "request_analysis_results.client_id", "CASE:2-1-2-57")
      assert(grouping[5] == "request_analysis_results.received_year", "CASE:2-1-2-58")
      assert(grouping[6] == "request_analysis_results.received_month", "CASE:2-1-2-59")
      assert(grouping[7] == "request_analysis_results.received_day", "CASE:2-1-2-60")
      assert(grouping[8] == "request_analysis_results.received_hour", "CASE:2-1-2-61")
      assert(grouping[9] == "request_analysis_results.received_minute", "CASE:2-1-2-62")
      assert(grouping[10] == "request_analysis_results.received_second", "CASE:2-1-2-63")
      assert(grouping[11] == "rank_view.total_access", "CASE:2-1-2-64")
      # SQL文チェック(ソート条件)
      order = ex_order_by_list(statement)
#      print_log("order:" + order.to_s)
      assert(order.size == 12, "CASE:2-1-2-65")
      assert(order[0] == "rank_view.total_access DESC", "CASE:2-1-2-66")
      assert(order[1] == "request_analysis_results.system_id ASC", "CASE:2-1-2-67")
      assert(order[2] == "request_analysis_results.function_id ASC", "CASE:2-1-2-68")
      assert(order[3] == "request_analysis_results.function_transition_no ASC", "CASE:2-1-2-69")
      assert(order[4] == "request_analysis_results.session_id ASC", "CASE:2-1-2-70")
      assert(order[5] == "request_analysis_results.client_id ASC", "CASE:2-1-2-71")
      assert(order[6] == "request_analysis_results.received_year ASC", "CASE:2-1-2-72")
      assert(order[7] == "request_analysis_results.received_month ASC", "CASE:2-1-2-73")
      assert(order[8] == "request_analysis_results.received_day ASC", "CASE:2-1-2-74")
      assert(order[9] == "request_analysis_results.received_hour ASC", "CASE:2-1-2-75")
      assert(order[10] == "request_analysis_results.received_minute ASC", "CASE:2-1-2-76")
      assert(order[11] == "request_analysis_results.received_second ASC", "CASE:2-1-2-77")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # 正常（デフォルト入力）
    # 表示項目：ドメイン名有り、10秒単位
    # テーブル：ドメイン結合
    # 抽出条件：全条件指定
    # ソート条件：降順
    begin
      # テストデータ作成
      test_data = RequestAnalysisResult.new
      test_data.system_id = 1
      test_data.request_analysis_schedule_id = 1
      test_data.received_year = 2008
      test_data.received_month = 10
      test_data.received_day = 12
      test_data.received_hour = 9
      test_data.received_minute = 59
      test_data.received_second = 55
      test_data.function_id = 2
      test_data.function_transition_no = 3
      test_data.session_id = '123456789012345678901234567890AB'
      test_data.client_id = 'Client_id'
      test_data.domain_id = 1
      test_data.browser_id = 2
      test_data.browser_version_id = 1
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
      # 線分類
      params = {:item_1=>'browser_id'}
      params[:item_2] = 'browser_version_id'
      params[:item_3] = 'accept_language'
      params[:item_4] = 'domain_name'
      # 集計条件
      params[:received_date_from] = DateTime.new(2012,10,12,10,0,0) - 4.years
      params[:time_unit_num] = '10'
      params[:time_unit] = 'second'
      params[:aggregation_period] = '20'
      params[:disp_order] = 'DESC'
      params[:disp_number] = '8'
      # 抽出条件
      params[:system_id] = '1'
      params[:function_id] = '2'
      params[:function_trans_no] = '3'
      params[:function_trans_no_comp] = 'EQ'
      params[:session_id] = '123456789012345678901234567890AB'
      params[:client_id] = 'Client_id'
      params[:browser_id] = '2'
      params[:browser_version_id] = '1'
      params[:browser_version_id_comp] = 'EQ'
      params[:accept_language] = 'ja'
      params[:referrer] = 'http://localhost:3000/menu/menu'
      params[:referrer_match] = 'E'
      params[:proxy_host] = 'oxy.nifty.co'
      params[:proxy_host_match] = 'P'
      params[:proxy_ip_address] = '192.168.10.100'
      params[:remote_host] = 'remote.nifty.'
      params[:remote_host_match] = 'F'
      params[:ip_address] = '192.168.20.100'
      params[:domain_name] = 'ne.jp'
      params[:domain_name_match] = 'F'
      # コンストラクタ生成
      sql_obj = SQLTotalization.new(params)
      view_obj = SQLRanking.new(params)
      assert(!sql_obj.nil?, "CASE:2-1-3-1")
      # パラメータチェック
      statement = sql_obj.statement
      bind_params = sql_obj.bind_params
      sql_params  = sql_obj.sql_params
      # SQLパラメータチェック
      params_bind_params = sql_params.dup
      params_statement = params_bind_params.shift
#      print_log('bind_param:' + params_bind_params.to_s)
      assert(statement == params_statement, "CASE:2-1-3-2")
      assert(bind_params == params_bind_params, "CASE:2-1-3-3")
#      print_log('params.size:' + params_bind_params.size.to_s)
      assert(params_bind_params.size == 29, "CASE:2-1-3-4")
      assert(params_bind_params[0] == 1, "CASE:2-1-3-5")
      assert(params_bind_params[1] == '20081012095951', "CASE:2-1-3-6")
      assert(params_bind_params[2] == '20081012100310', "CASE:2-1-3-7")
      assert(params_bind_params[3] == 2, "CASE:2-1-3-8")
      assert(params_bind_params[4] == 3, "CASE:2-1-3-9")
      assert(params_bind_params[5] == '123456789012345678901234567890AB', "CASE:2-1-3-10")
      assert(params_bind_params[6] == 'Client_id', "CASE:2-1-3-11")
      assert(params_bind_params[7] == 2, "CASE:2-1-3-12")
      assert(params_bind_params[8] == 1, "CASE:2-1-3-13")
      assert(params_bind_params[9] == 'ja%', "CASE:2-1-3-14")
      assert(params_bind_params[10] == 'http://localhost:3000/menu/menu', "CASE:2-1-3-15")
      assert(params_bind_params[11] == '%oxy.nifty.co%', "CASE:2-1-3-16")
      assert(params_bind_params[12] == '192.168.10.100%', "CASE:2-1-3-17")
      assert(params_bind_params[13] == 'remote.nifty.%', "CASE:2-1-3-19")
      assert(params_bind_params[14] == '192.168.20.100%', "CASE:2-1-3-20")
      assert(params_bind_params[15] == 'ne.jp%', "CASE:2-1-3-20")
      assert(params_bind_params[16] == 8, "CASE:2-1-3-21")
      assert(params_bind_params[17] == 1, "CASE:2-1-3-5")
      assert(params_bind_params[18] == '20081012095951', "CASE:2-1-3-22")
      assert(params_bind_params[19] == '20081012100310', "CASE:2-1-3-23")
      assert(params_bind_params[20] == 2, "CASE:2-1-3-8")
      assert(params_bind_params[21] == 3, "CASE:2-1-3-9")
      assert(params_bind_params[22] == '123456789012345678901234567890AB', "CASE:2-1-3-10")
      assert(params_bind_params[23] == 'Client_id', "CASE:2-1-3-11")
      assert(params_bind_params[24] == 'http://localhost:3000/menu/menu', "CASE:2-1-3-15")
      assert(params_bind_params[25] == '%oxy.nifty.co%', "CASE:2-1-3-28")
      assert(params_bind_params[26] == '192.168.10.100%', "CASE:2-1-3-29")
      assert(params_bind_params[27] == 'remote.nifty.%', "CASE:2-1-3-30")
      assert(params_bind_params[28] == '192.168.20.100%', "CASE:2-1-3-31")
      # SQL文チェック(項目)
      result_list = RequestAnalysisResult.find_by_sql(sql_params)
      assert(!result_list.empty?, "CASE:2-1-3-32")
      items = ex_item_list(statement)
#      print_log("items:" + items.to_s)
      assert(items.size == 12, "CASE:2-1-3-33")
      assert(items[0] == 'request_analysis_results.browser_id', "CASE:2-1-3-34")
      assert(items[1] == 'request_analysis_results.browser_version_id', "CASE:2-1-3-35")
      assert(items[2] == 'request_analysis_results.accept_language', "CASE:2-1-3-36")
      assert(items[3] == 'rank_view.domain_name', "CASE:2-1-3-37")
      assert(items[4] == 'request_analysis_results.received_year', "CASE:2-1-3-39")
      assert(items[5] == 'request_analysis_results.received_month', "CASE:2-1-3-40")
      assert(items[6] == 'request_analysis_results.received_day', "CASE:2-1-3-41")
      assert(items[7] == 'request_analysis_results.received_hour', "CASE:2-1-3-42")
      assert(items[8] == 'request_analysis_results.received_minute', "CASE:2-1-3-43")
      assert(items[9] == 'request_analysis_results.received_second', "CASE:2-1-3-44")
      assert(items[10] == 'rank_view.total_access', "CASE:2-1-3-45")
      assert(items[11] == 'sum(request_analysis_results.request_count) AS request_count', "CASE:2-1-3-46")
      # SQL文チェック(テーブル)
      tables = ex_table_list(statement)
#      print_log("tables:" + tables.to_s)
      assert(tables.size == 2, "CASE:2-1-3-47")
      assert(tables[0] == 'request_analysis_results', "CASE:2-1-3-48")
      assert(tables[1] == 'rank_view', "CASE:2-1-3-49")
      # SQL文チェック(インラインビュー)
      view_stmt = ex_rank_stmt(statement)
#      print_log("view_stmt:" + view_stmt)
      assert(view_stmt == view_obj.statement, "CASE:2-1-3-50")
      # SQL文チェック(抽出条件)
      where_stmt = ex_where_stmt(statement)
#      print_log("where_stmt:" + where_stmt)
      match_stmt = "(request_analysis_results.browser_id = rank_view.browser_id OR "
      match_stmt += "request_analysis_results.browser_id IS NULL AND "
      match_stmt += "rank_view.browser_id IS NULL) AND "
      match_stmt += "(request_analysis_results.browser_version_id = rank_view.browser_version_id OR "
      match_stmt += "request_analysis_results.browser_version_id IS NULL AND "
      match_stmt += "rank_view.browser_version_id IS NULL) AND "
      match_stmt += "(request_analysis_results.accept_language = rank_view.accept_language OR "
      match_stmt += "request_analysis_results.accept_language IS NULL AND "
      match_stmt += "rank_view.accept_language IS NULL) AND "
      match_stmt += "(request_analysis_results.domain_id = rank_view.domain_id OR "
      match_stmt += "request_analysis_results.domain_id IS NULL AND "
      match_stmt += "rank_view.domain_id IS NULL) AND "
      match_stmt += "request_analysis_results.system_id = ? AND "
      match_stmt += ex_received_date('second') + ' AND '
      match_stmt += "request_analysis_results.function_id = ? AND "
      match_stmt += "request_analysis_results.function_transition_no = ? AND "
      match_stmt += "request_analysis_results.session_id = ? AND "
      match_stmt += "request_analysis_results.client_id = ? AND "
      match_stmt += "request_analysis_results.referrer = ? AND "
      match_stmt += "request_analysis_results.proxy_host like ? AND "
      match_stmt += "request_analysis_results.proxy_ip_address like ? AND "
      match_stmt += "request_analysis_results.remote_host like ? AND "
      match_stmt += "request_analysis_results.ip_address like ?"
#      print_log("match_stmt:" + match_stmt)
      assert(where_stmt == match_stmt, "CASE:2-1-3-51")
#      assert(wheres[13] == "request_analysis_results.ip_address like ?", "CASE:2-1-3-13")
      # SQL文チェック(グルーピング条件)
      grouping = ex_group_by_list(statement)
#      print_log("grouping:" + grouping.to_s)
      assert(grouping.size == 11, "CASE:2-1-3-52")
      assert(grouping[0] == "request_analysis_results.browser_id", "CASE:2-1-3-53")
      assert(grouping[1] == "request_analysis_results.browser_version_id", "CASE:2-1-3-54")
      assert(grouping[2] == "request_analysis_results.accept_language", "CASE:2-1-3-55")
      assert(grouping[3] == "rank_view.domain_name", "CASE:2-1-3-56")
      assert(grouping[4] == "request_analysis_results.received_year", "CASE:2-1-3-58")
      assert(grouping[5] == "request_analysis_results.received_month", "CASE:2-1-3-59")
      assert(grouping[6] == "request_analysis_results.received_day", "CASE:2-1-3-60")
      assert(grouping[7] == "request_analysis_results.received_hour", "CASE:2-1-3-61")
      assert(grouping[8] == "request_analysis_results.received_minute", "CASE:2-1-3-62")
      assert(grouping[9] == "request_analysis_results.received_second", "CASE:2-1-3-63")
      assert(grouping[10] == "rank_view.total_access", "CASE:2-1-3-64")
      # SQL文チェック(ソート条件)
      order = ex_order_by_list(statement)
#      print_log("order:" + order.to_s)
      assert(order.size == 11, "CASE:2-1-3-65")
      assert(order[0] == "rank_view.total_access DESC", "CASE:2-1-3-66")
      assert(order[1] == "request_analysis_results.browser_id ASC", "CASE:2-1-3-53")
      assert(order[2] == "request_analysis_results.browser_version_id ASC", "CASE:2-1-3-54")
      assert(order[3] == "request_analysis_results.accept_language ASC", "CASE:2-1-3-55")
      assert(order[4] == "rank_view.domain_name ASC", "CASE:2-1-3-56")
      assert(order[5] == "request_analysis_results.received_year ASC", "CASE:2-1-3-72")
      assert(order[6] == "request_analysis_results.received_month ASC", "CASE:2-1-3-73")
      assert(order[7] == "request_analysis_results.received_day ASC", "CASE:2-1-3-74")
      assert(order[8] == "request_analysis_results.received_hour ASC", "CASE:2-1-3-75")
      assert(order[9] == "request_analysis_results.received_minute ASC", "CASE:2-1-3-76")
      assert(order[10] == "request_analysis_results.received_second ASC", "CASE:2-1-3-77")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # 正常（デフォルト入力）
    # 表示項目：ドメイン名有り、10秒単位
    # テーブル：ドメイン結合
    # 抽出条件：ドメイン以外指定
    # ソート条件：降順
    begin
      # テストデータ作成
      test_data = RequestAnalysisResult.new
      test_data.system_id = 1
      test_data.request_analysis_schedule_id = 1
      test_data.received_year = 2009
      test_data.received_month = 10
      test_data.received_day = 12
      test_data.received_hour = 9
      test_data.received_minute = 59
      test_data.received_second = 55
      test_data.function_id = 2
      test_data.function_transition_no = 3
      test_data.session_id = '123456789012345678901234567890AB'
      test_data.client_id = 'Client_id'
      test_data.domain_id = 1
      test_data.browser_id = 2
      test_data.browser_version_id = 1
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
      # 線分類
      params = {:item_1=>'browser_id'}
      params[:item_2] = 'browser_version_id'
      params[:item_3] = 'accept_language'
      params[:item_4] = 'domain_name'
      # 集計条件
      params[:received_date_from] = DateTime.new(2012,10,12,10,0,0) - 3.years
      params[:time_unit_num] = '10'
      params[:time_unit] = 'second'
      params[:aggregation_period] = '20'
      params[:disp_order] = 'DESC'
      params[:disp_number] = '8'
      # 抽出条件
      params[:system_id] = '1'
      params[:function_id] = '2'
      params[:function_trans_no] = '3'
      params[:function_trans_no_comp] = 'EQ'
      params[:session_id] = '123456789012345678901234567890AB'
      params[:client_id] = 'Client_id'
      params[:browser_id] = '2'
      params[:browser_version_id] = '1'
      params[:browser_version_id_comp] = 'EQ'
      params[:accept_language] = 'ja'
      params[:referrer] = 'http://localhost:3000/menu/menu'
      params[:referrer_match] = 'E'
      params[:proxy_host] = 'oxy.nifty.co'
      params[:proxy_host_match] = 'P'
      params[:proxy_ip_address] = '192.168.10.100'
      params[:remote_host] = 'remote.nifty.'
      params[:remote_host_match] = 'F'
      params[:ip_address] = '192.168.20.100'
#      params[:domain_name] = 'ne.jp'
#      params[:domain_name_match] = 'F'
      # コンストラクタ生成
      sql_obj = SQLTotalization.new(params)
      view_obj = SQLRanking.new(params)
      assert(!sql_obj.nil?, "CASE:2-1-4-1")
      # パラメータチェック
      statement = sql_obj.statement
      bind_params = sql_obj.bind_params
      sql_params  = sql_obj.sql_params
      # SQLパラメータチェック
      params_bind_params = sql_params.dup
      params_statement = params_bind_params.shift
#      print_log('bind_param:' + params_bind_params.to_s)
      assert(statement == params_statement, "CASE:2-1-4-2")
      assert(bind_params == params_bind_params, "CASE:2-1-4-3")
#      print_log('params.size:' + params_bind_params.size.to_s)
      assert(params_bind_params.size == 28, "CASE:2-1-4-4")
      assert(params_bind_params[0] == 1, "CASE:2-1-4-5")
      assert(params_bind_params[1] == '20091012095951', "CASE:2-1-4-6")
      assert(params_bind_params[2] == '20091012100310', "CASE:2-1-4-7")
      assert(params_bind_params[3] == 2, "CASE:2-1-4-8")
      assert(params_bind_params[4] == 3, "CASE:2-1-4-9")
      assert(params_bind_params[5] == '123456789012345678901234567890AB', "CASE:2-1-4-10")
      assert(params_bind_params[6] == 'Client_id', "CASE:2-1-4-11")
      assert(params_bind_params[7] == 2, "CASE:2-1-4-12")
      assert(params_bind_params[8] == 1, "CASE:2-1-4-13")
      assert(params_bind_params[9] == 'ja%', "CASE:2-1-4-14")
      assert(params_bind_params[10] == 'http://localhost:3000/menu/menu', "CASE:2-1-4-15")
      assert(params_bind_params[11] == '%oxy.nifty.co%', "CASE:2-1-4-16")
      assert(params_bind_params[12] == '192.168.10.100%', "CASE:2-1-4-17")
      assert(params_bind_params[13] == 'remote.nifty.%', "CASE:2-1-4-19")
      assert(params_bind_params[14] == '192.168.20.100%', "CASE:2-1-4-20")
      assert(params_bind_params[15] == 8, "CASE:2-1-4-21")
      assert(params_bind_params[16] == 1, "CASE:2-1-4-5")
      assert(params_bind_params[17] == '20091012095951', "CASE:2-1-4-22")
      assert(params_bind_params[18] == '20091012100310', "CASE:2-1-4-23")
      assert(params_bind_params[19] == 2, "CASE:2-1-4-8")
      assert(params_bind_params[20] == 3, "CASE:2-1-4-9")
      assert(params_bind_params[21] == '123456789012345678901234567890AB', "CASE:2-1-4-10")
      assert(params_bind_params[22] == 'Client_id', "CASE:2-1-4-11")
      assert(params_bind_params[23] == 'http://localhost:3000/menu/menu', "CASE:2-1-4-15")
      assert(params_bind_params[24] == '%oxy.nifty.co%', "CASE:2-1-4-28")
      assert(params_bind_params[25] == '192.168.10.100%', "CASE:2-1-4-29")
      assert(params_bind_params[26] == 'remote.nifty.%', "CASE:2-1-4-30")
      assert(params_bind_params[27] == '192.168.20.100%', "CASE:2-1-4-31")
      # SQL文チェック(項目)
      result_list = RequestAnalysisResult.find_by_sql(sql_params)
      assert(!result_list.empty?, "CASE:2-1-4-32")
      items = ex_item_list(statement)
#      print_log("items:" + items.to_s)
      assert(items.size == 12, "CASE:2-1-4-33")
      assert(items[0] == 'request_analysis_results.browser_id', "CASE:2-1-4-34")
      assert(items[1] == 'request_analysis_results.browser_version_id', "CASE:2-1-4-35")
      assert(items[2] == 'request_analysis_results.accept_language', "CASE:2-1-4-36")
      assert(items[3] == 'rank_view.domain_name', "CASE:2-1-4-37")
      assert(items[4] == 'request_analysis_results.received_year', "CASE:2-1-4-39")
      assert(items[5] == 'request_analysis_results.received_month', "CASE:2-1-4-40")
      assert(items[6] == 'request_analysis_results.received_day', "CASE:2-1-4-41")
      assert(items[7] == 'request_analysis_results.received_hour', "CASE:2-1-4-42")
      assert(items[8] == 'request_analysis_results.received_minute', "CASE:2-1-4-43")
      assert(items[9] == 'request_analysis_results.received_second', "CASE:2-1-4-44")
      assert(items[10] == 'rank_view.total_access', "CASE:2-1-4-45")
      assert(items[11] == 'sum(request_analysis_results.request_count) AS request_count', "CASE:2-1-4-46")
      # SQL文チェック(テーブル)
      tables = ex_table_list(statement)
#      print_log("tables:" + tables.to_s)
      assert(tables.size == 2, "CASE:2-1-4-47")
      assert(tables[0] == 'request_analysis_results', "CASE:2-1-4-48")
      assert(tables[1] == 'rank_view', "CASE:2-1-4-49")
      # SQL文チェック(インラインビュー)
      view_stmt = ex_rank_stmt(statement)
#      print_log("view_stmt:" + view_stmt)
      assert(view_stmt == view_obj.statement, "CASE:2-1-4-50")
      # SQL文チェック(抽出条件)
      where_stmt = ex_where_stmt(statement)
#      print_log("where_stmt:" + where_stmt)
      match_stmt = "(request_analysis_results.browser_id = rank_view.browser_id OR "
      match_stmt += "request_analysis_results.browser_id IS NULL AND "
      match_stmt += "rank_view.browser_id IS NULL) AND "
      match_stmt += "(request_analysis_results.browser_version_id = rank_view.browser_version_id OR "
      match_stmt += "request_analysis_results.browser_version_id IS NULL AND "
      match_stmt += "rank_view.browser_version_id IS NULL) AND "
      match_stmt += "(request_analysis_results.accept_language = rank_view.accept_language OR "
      match_stmt += "request_analysis_results.accept_language IS NULL AND "
      match_stmt += "rank_view.accept_language IS NULL) AND "
      match_stmt += "(request_analysis_results.domain_id = rank_view.domain_id OR "
      match_stmt += "request_analysis_results.domain_id IS NULL AND "
      match_stmt += "rank_view.domain_id IS NULL) AND "
      match_stmt += "request_analysis_results.system_id = ? AND "
      match_stmt += ex_received_date('second') + ' AND '
      match_stmt += "request_analysis_results.function_id = ? AND "
      match_stmt += "request_analysis_results.function_transition_no = ? AND "
      match_stmt += "request_analysis_results.session_id = ? AND "
      match_stmt += "request_analysis_results.client_id = ? AND "
      match_stmt += "request_analysis_results.referrer = ? AND "
      match_stmt += "request_analysis_results.proxy_host like ? AND "
      match_stmt += "request_analysis_results.proxy_ip_address like ? AND "
      match_stmt += "request_analysis_results.remote_host like ? AND "
      match_stmt += "request_analysis_results.ip_address like ?"
#      print_log("match_stmt:" + match_stmt)
      assert(where_stmt == match_stmt, "CASE:2-1-4-51")
#      assert(wheres[13] == "request_analysis_results.ip_address like ?", "CASE:2-1-4-13")
      # SQL文チェック(グルーピング条件)
      grouping = ex_group_by_list(statement)
#      print_log("grouping:" + grouping.to_s)
      assert(grouping.size == 11, "CASE:2-1-4-52")
      assert(grouping[0] == "request_analysis_results.browser_id", "CASE:2-1-4-53")
      assert(grouping[1] == "request_analysis_results.browser_version_id", "CASE:2-1-4-54")
      assert(grouping[2] == "request_analysis_results.accept_language", "CASE:2-1-4-55")
      assert(grouping[3] == "rank_view.domain_name", "CASE:2-1-4-56")
      assert(grouping[4] == "request_analysis_results.received_year", "CASE:2-1-4-58")
      assert(grouping[5] == "request_analysis_results.received_month", "CASE:2-1-4-59")
      assert(grouping[6] == "request_analysis_results.received_day", "CASE:2-1-4-60")
      assert(grouping[7] == "request_analysis_results.received_hour", "CASE:2-1-4-61")
      assert(grouping[8] == "request_analysis_results.received_minute", "CASE:2-1-4-62")
      assert(grouping[9] == "request_analysis_results.received_second", "CASE:2-1-4-63")
      assert(grouping[10] == "rank_view.total_access", "CASE:2-1-4-64")
      # SQL文チェック(ソート条件)
      order = ex_order_by_list(statement)
#      print_log("order:" + order.to_s)
      assert(order.size == 11, "CASE:2-1-4-65")
      assert(order[0] == "rank_view.total_access DESC", "CASE:2-1-4-66")
      assert(order[1] == "request_analysis_results.browser_id ASC", "CASE:2-1-4-53")
      assert(order[2] == "request_analysis_results.browser_version_id ASC", "CASE:2-1-4-54")
      assert(order[3] == "request_analysis_results.accept_language ASC", "CASE:2-1-4-55")
      assert(order[4] == "rank_view.domain_name ASC", "CASE:2-1-4-56")
      assert(order[5] == "request_analysis_results.received_year ASC", "CASE:2-1-4-72")
      assert(order[6] == "request_analysis_results.received_month ASC", "CASE:2-1-4-73")
      assert(order[7] == "request_analysis_results.received_day ASC", "CASE:2-1-4-74")
      assert(order[8] == "request_analysis_results.received_hour ASC", "CASE:2-1-4-75")
      assert(order[9] == "request_analysis_results.received_minute ASC", "CASE:2-1-4-76")
      assert(order[10] == "request_analysis_results.received_second ASC", "CASE:2-1-4-77")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
    # 正常（デフォルト入力）
    # 表示項目：ドメイン名無し、10秒単位
    # テーブル：ドメイン結合
    # 抽出条件：全条件指定
    # ソート条件：降順
    begin
      # テストデータ作成
      test_data = RequestAnalysisResult.new
      test_data.system_id = 1
      test_data.request_analysis_schedule_id = 1
      test_data.received_year = 2010
      test_data.received_month = 10
      test_data.received_day = 12
      test_data.received_hour = 9
      test_data.received_minute = 59
      test_data.received_second = 55
      test_data.function_id = 2
      test_data.function_transition_no = 3
      test_data.session_id = '123456789012345678901234567890AB'
      test_data.client_id = 'Client_id'
      test_data.domain_id = 1
      test_data.browser_id = 2
      test_data.browser_version_id = 1
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
      # 線分類
      params = {:item_1=>'browser_id'}
      params[:item_2] = 'browser_version_id'
      params[:item_3] = 'accept_language'
      params[:item_4] = 'ip_address'
      # 集計条件
      params[:received_date_from] = DateTime.new(2012,10,12,10,0,0) - 2.years
      params[:time_unit_num] = '10'
      params[:time_unit] = 'second'
      params[:aggregation_period] = '20'
      params[:disp_order] = 'DESC'
      params[:disp_number] = '8'
      # 抽出条件
      params[:system_id] = '1'
      params[:function_id] = '2'
      params[:function_trans_no] = '3'
      params[:function_trans_no_comp] = 'EQ'
      params[:session_id] = '123456789012345678901234567890AB'
      params[:client_id] = 'Client_id'
      params[:browser_id] = '2'
      params[:browser_version_id] = '1'
      params[:browser_version_id_comp] = 'EQ'
      params[:accept_language] = 'ja'
      params[:referrer] = 'http://localhost:3000/menu/menu'
      params[:referrer_match] = 'E'
      params[:proxy_host] = 'oxy.nifty.co'
      params[:proxy_host_match] = 'P'
      params[:proxy_ip_address] = '192.168.10.100'
      params[:remote_host] = 'remote.nifty.'
      params[:remote_host_match] = 'F'
      params[:ip_address] = '192.168.20.100'
      params[:domain_name] = 'ne.jp'
      params[:domain_name_match] = 'F'
      # コンストラクタ生成
      sql_obj = SQLTotalization.new(params)
      view_obj = SQLRanking.new(params)
      assert(!sql_obj.nil?, "CASE:2-1-5-1")
      # パラメータチェック
      statement = sql_obj.statement
      bind_params = sql_obj.bind_params
      sql_params  = sql_obj.sql_params
      # SQLパラメータチェック
      params_bind_params = sql_params.dup
      params_statement = params_bind_params.shift
#      print_log('bind_param:' + params_bind_params.to_s)
      assert(statement == params_statement, "CASE:2-1-5-2")
      assert(bind_params == params_bind_params, "CASE:2-1-5-3")
#      print_log('params.size:' + params_bind_params.size.to_s)
      assert(params_bind_params.size == 29, "CASE:2-1-5-4")
      assert(params_bind_params[0] == 1, "CASE:2-1-5-5")
      assert(params_bind_params[1] == '20101012095951', "CASE:2-1-5-6")
      assert(params_bind_params[2] == '20101012100310', "CASE:2-1-5-7")
      assert(params_bind_params[3] == 2, "CASE:2-1-5-8")
      assert(params_bind_params[4] == 3, "CASE:2-1-5-9")
      assert(params_bind_params[5] == '123456789012345678901234567890AB', "CASE:2-1-5-10")
      assert(params_bind_params[6] == 'Client_id', "CASE:2-1-5-11")
      assert(params_bind_params[7] == 2, "CASE:2-1-5-12")
      assert(params_bind_params[8] == 1, "CASE:2-1-5-13")
      assert(params_bind_params[9] == 'ja%', "CASE:2-1-5-14")
      assert(params_bind_params[10] == 'http://localhost:3000/menu/menu', "CASE:2-1-5-15")
      assert(params_bind_params[11] == '%oxy.nifty.co%', "CASE:2-1-5-16")
      assert(params_bind_params[12] == '192.168.10.100%', "CASE:2-1-5-17")
      assert(params_bind_params[13] == 'remote.nifty.%', "CASE:2-1-5-19")
      assert(params_bind_params[14] == '192.168.20.100%', "CASE:2-1-5-20")
      assert(params_bind_params[15] == 'ne.jp%', "CASE:2-1-5-20")
      assert(params_bind_params[16] == 8, "CASE:2-1-5-21")
      assert(params_bind_params[17] == 1, "CASE:2-1-5-5")
      assert(params_bind_params[18] == '20101012095951', "CASE:2-1-5-22")
      assert(params_bind_params[19] == '20101012100310', "CASE:2-1-5-23")
      assert(params_bind_params[20] == 2, "CASE:2-1-5-8")
      assert(params_bind_params[21] == 3, "CASE:2-1-5-9")
      assert(params_bind_params[22] == '123456789012345678901234567890AB', "CASE:2-1-5-10")
      assert(params_bind_params[23] == 'Client_id', "CASE:2-1-5-11")
      assert(params_bind_params[24] == 'http://localhost:3000/menu/menu', "CASE:2-1-5-15")
      assert(params_bind_params[25] == '%oxy.nifty.co%', "CASE:2-1-5-28")
      assert(params_bind_params[26] == '192.168.10.100%', "CASE:2-1-5-29")
      assert(params_bind_params[27] == 'remote.nifty.%', "CASE:2-1-5-30")
      assert(params_bind_params[28] == 'ne.jp%', "CASE:2-1-5-20")
      # SQL文チェック(項目)
      result_list = RequestAnalysisResult.find_by_sql(sql_params)
      assert(!result_list.empty?, "CASE:2-1-5-32")
      items = ex_item_list(statement)
#      print_log("items:" + items.to_s)
      assert(items.size == 12, "CASE:2-1-5-33")
      assert(items[0] == 'request_analysis_results.browser_id', "CASE:2-1-5-34")
      assert(items[1] == 'request_analysis_results.browser_version_id', "CASE:2-1-5-35")
      assert(items[2] == 'request_analysis_results.accept_language', "CASE:2-1-5-36")
      assert(items[3] == 'request_analysis_results.ip_address', "CASE:2-1-5-37")
      assert(items[4] == 'request_analysis_results.received_year', "CASE:2-1-5-39")
      assert(items[5] == 'request_analysis_results.received_month', "CASE:2-1-5-40")
      assert(items[6] == 'request_analysis_results.received_day', "CASE:2-1-5-41")
      assert(items[7] == 'request_analysis_results.received_hour', "CASE:2-1-5-42")
      assert(items[8] == 'request_analysis_results.received_minute', "CASE:2-1-5-43")
      assert(items[9] == 'request_analysis_results.received_second', "CASE:2-1-5-44")
      assert(items[10] == 'rank_view.total_access', "CASE:2-1-5-45")
      assert(items[11] == 'sum(request_analysis_results.request_count) AS request_count', "CASE:2-1-5-46")
      # SQL文チェック(テーブル)
      tables = ex_table_list(statement)
#      print_log("tables:" + tables.to_s)
      assert(tables.size == 2, "CASE:2-1-5-47")
      assert(tables[0] == 'request_analysis_results LEFT OUTER JOIN domains ON request_analysis_results.domain_id = domains.id', "CASE:2-1-5-48")
      assert(tables[1] == 'rank_view', "CASE:2-1-5-49")
      # SQL文チェック(インラインビュー)
      view_stmt = ex_rank_stmt(statement)
#      print_log("view_stmt:" + view_stmt)
      assert(view_stmt == view_obj.statement, "CASE:2-1-5-50")
      # SQL文チェック(抽出条件)
      where_stmt = ex_where_stmt(statement)
#      print_log("where_stmt:" + where_stmt)
      match_stmt = "(request_analysis_results.browser_id = rank_view.browser_id OR "
      match_stmt += "request_analysis_results.browser_id IS NULL AND "
      match_stmt += "rank_view.browser_id IS NULL) AND "
      match_stmt += "(request_analysis_results.browser_version_id = rank_view.browser_version_id OR "
      match_stmt += "request_analysis_results.browser_version_id IS NULL AND "
      match_stmt += "rank_view.browser_version_id IS NULL) AND "
      match_stmt += "(request_analysis_results.accept_language = rank_view.accept_language OR "
      match_stmt += "request_analysis_results.accept_language IS NULL AND "
      match_stmt += "rank_view.accept_language IS NULL) AND "
      match_stmt += "(request_analysis_results.ip_address = rank_view.ip_address OR "
      match_stmt += "request_analysis_results.ip_address IS NULL AND "
      match_stmt += "rank_view.ip_address IS NULL) AND "
      match_stmt += "request_analysis_results.system_id = ? AND "
      match_stmt += ex_received_date('second') + ' AND '
      match_stmt += "request_analysis_results.function_id = ? AND "
      match_stmt += "request_analysis_results.function_transition_no = ? AND "
      match_stmt += "request_analysis_results.session_id = ? AND "
      match_stmt += "request_analysis_results.client_id = ? AND "
      match_stmt += "request_analysis_results.referrer = ? AND "
      match_stmt += "request_analysis_results.proxy_host like ? AND "
      match_stmt += "request_analysis_results.proxy_ip_address like ? AND "
      match_stmt += "request_analysis_results.remote_host like ? AND "
#      match_stmt += "request_analysis_results.ip_address like ?"
      match_stmt += "domains.domain_name like ?"
#      print_log("match_stmt:" + match_stmt)
      assert(where_stmt == match_stmt, "CASE:2-1-5-51")
#      assert(wheres[13] == "request_analysis_results.ip_address like ?", "CASE:2-1-5-13")
      # SQL文チェック(グルーピング条件)
      grouping = ex_group_by_list(statement)
#      print_log("grouping:" + grouping.to_s)
      assert(grouping.size == 11, "CASE:2-1-5-52")
      assert(grouping[0] == "request_analysis_results.browser_id", "CASE:2-1-5-53")
      assert(grouping[1] == "request_analysis_results.browser_version_id", "CASE:2-1-5-54")
      assert(grouping[2] == "request_analysis_results.accept_language", "CASE:2-1-5-55")
      assert(grouping[3] == "request_analysis_results.ip_address", "CASE:2-1-5-56")
      assert(grouping[4] == "request_analysis_results.received_year", "CASE:2-1-5-58")
      assert(grouping[5] == "request_analysis_results.received_month", "CASE:2-1-5-59")
      assert(grouping[6] == "request_analysis_results.received_day", "CASE:2-1-5-60")
      assert(grouping[7] == "request_analysis_results.received_hour", "CASE:2-1-5-61")
      assert(grouping[8] == "request_analysis_results.received_minute", "CASE:2-1-5-62")
      assert(grouping[9] == "request_analysis_results.received_second", "CASE:2-1-5-63")
      assert(grouping[10] == "rank_view.total_access", "CASE:2-1-5-64")
      # SQL文チェック(ソート条件)
      order = ex_order_by_list(statement)
#      print_log("order:" + order.to_s)
      assert(order.size == 11, "CASE:2-1-5-65")
      assert(order[0] == "rank_view.total_access DESC", "CASE:2-1-5-66")
      assert(order[1] == "request_analysis_results.browser_id ASC", "CASE:2-1-5-53")
      assert(order[2] == "request_analysis_results.browser_version_id ASC", "CASE:2-1-5-54")
      assert(order[3] == "request_analysis_results.accept_language ASC", "CASE:2-1-5-55")
      assert(order[4] == "request_analysis_results.ip_address ASC", "CASE:2-1-5-56")
      assert(order[5] == "request_analysis_results.received_year ASC", "CASE:2-1-5-72")
      assert(order[6] == "request_analysis_results.received_month ASC", "CASE:2-1-5-73")
      assert(order[7] == "request_analysis_results.received_day ASC", "CASE:2-1-5-74")
      assert(order[8] == "request_analysis_results.received_hour ASC", "CASE:2-1-5-75")
      assert(order[9] == "request_analysis_results.received_minute ASC", "CASE:2-1-5-76")
      assert(order[10] == "request_analysis_results.received_second ASC", "CASE:2-1-5-77")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-5")
    end
    # 異常（パラメータ）
    # 表示項目：ドメイン名無し、10秒単位
    # テーブル：ドメイン結合
    # 抽出条件：なし
    # ソート条件：降順
    sql_obj = nil
    begin
      # 線分類
      params = {:item_1=>'browser_id'}
      params[:item_2] = 'browser_version_id'
      params[:item_3] = 'accept_language'
      params[:item_4] = 'ip_address'
      # 集計条件
      params[:received_date_from] = DateTime.new(2012,10,12,10,0,0) - 2.years
      params[:time_unit_num] = []
      params[:time_unit] = 'second'
      params[:aggregation_period] = 'HIJ'
      params[:disp_order] = 'DESC'
      params[:disp_number] = '8'
      # コンストラクタ生成
      sql_obj = SQLTotalization.new(params)
      print_log('statement:' + sql_obj.statement)
      print_log('bind_params:' + sql_obj.bind_params.to_s)
      flunk("CASE:2-1-6")
    rescue => ex
      assert(sql_obj.nil?, "CASE:2-1-6-1")
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
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
    head = statement.scan(/SELECT .*? FROM/)[0]
    return head.sub("SELECT ", "").sub(" FROM", "").split(',')
  end
  
  # テーブルリスト抽出
  def ex_table_list(statement)
    from = statement.scan(/FROM .*\) AS rank_view WHERE/)[0]
    return from.sub(/\(.*\) AS /, "").sub("FROM ", "").sub(" WHERE", "").split(',')
  end
  
  # インラインビュー抽出
  def ex_rank_stmt(statement)
    from = statement.scan(/FROM .*\) AS rank_view WHERE/)[0]
    return from.sub(/FROM .*?\(/, "").sub(/\) AS rank_view WHERE/, "")
  end
  
  # 条件リスト抽出
  def ex_where_stmt(statement)
    where = statement.scan(/ rank_view WHERE .*? GROUP/)[0]
    return where.sub(/ rank_view WHERE /, "").sub(" GROUP", "")
  end
  
  # グルーピング条件抽出
  def ex_group_by_list(statement)
    group = statement.scan(/ rank_view WHERE .*? ORDER BY/)[0]
    return group.sub(/ rank_view .*? GROUP BY /, "").sub(" ORDER BY", "").split(',')
  end
  
  # ソート条件抽出
  def ex_order_by_list(statement)
    order = statement.scan(/ rank_view WHERE .*/)[0]
    return order.sub(/ rank_view .*? ORDER BY /, "").split(',')
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
    rcvd_time_item = rcvd_time_item + ')'
    return '(' + rcvd_time_item + ' BETWEEN ? AND ?)'
  end
end