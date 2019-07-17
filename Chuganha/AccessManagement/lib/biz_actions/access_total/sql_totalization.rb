# -*- coding: utf-8 -*-
###############################################################################
# 集計SQL生成クラス
# 概要：集計処理のSELECT文とバインド変数を生成する
# コントローラー：AccessTotal::AccessTotalController
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/09/25 Nakanohito
# 更新日:
###############################################################################
require 'common/validation_chk_module'
require 'common/model/db_util_module'

module BizActions
  module AccessTotal
    class SQLTotalization
      include Common::ValidationChkModule
      include Common::Model::DbUtilModule
      # アクセサー定義
      attr_reader :statement, :bind_params, :sql_params
      #########################################################################
      # メソッド定義
      #########################################################################
      # 初期化メソッド
      def initialize(params)
        # 集計条件パラメータ
        @params = params
        # バインド変数配列
        @bind_params = Array.new
        # 表示対象グループ抽出SQL
        @rank_sql = SQLRanking.new(params)
        # 項目リスト生成
        @item_name_list = grouping_items_list
        # ドメイン結合フラグ
        @domain_join_flg = !blank?(@params[:domain_name]) &&
                           !@item_name_list.include?('rank_view.domain_name')
        # 集計期間計算
        @rcvd_period = @rank_sql.rcvd_period
        # SELECT文
        @statement = generate_select
        # SQLパラメータ
        @sql_params = @bind_params.dup.unshift(@statement)
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      #　項目リスト生成
      def grouping_items_list
        # グルーピング項目
        item_name_list = Array.new
        [:item_1, :item_2, :item_3, :item_4, :item_5].each do |item|
          item_name = @params[item]
          break if blank?(item_name)
          table_name = 'request_analysis_results.'
          table_name = 'rank_view.' if item_name == 'domain_name'
          item_name_list.push(table_name + item_name)
        end
        # 受信日時
        time_unit = @params[:time_unit]
        ['year', 'month', 'day', 'hour', 'minute', 'second'].each do |unit|
          item_name_list.push('request_analysis_results.received_' + unit)
          break if unit == time_unit
        end
        # 集計値
        item_name_list.push('rank_view.total_access')
        return item_name_list
      end
      
      # SELECT文生成
      def generate_select
        # SELECT文生成
        sql_array = Array.new
        sql_array.push('SELECT ')
        sql_array.push(part_of_item)
        sql_array.push(' FROM ')
        sql_array.push(part_of_tables)
        sql_array.push(' WHERE ')
        sql_array.push(part_of_where)
        sql_array.push(' GROUP BY ')
        sql_array.push(part_of_grouping)
        sql_array.push(' ORDER BY ')
        sql_array.push(part_of_order)
        return sql_array.join
      end
      
      # 項目リスト生成
      def part_of_item
        item_sql = @item_name_list.dup
        item_sql.push('sum(request_analysis_results.request_count) AS request_count')
        return item_sql.join(',')
      end
      
      # テーブルリスト生成
      def part_of_tables
        @bind_params.concat(@rank_sql.bind_params)
        table_main = 'request_analysis_results'
        if @domain_join_flg then
          table_main.concat(' LEFT OUTER JOIN domains')
          table_main.concat(' ON request_analysis_results.domain_id = domains.id')
        end
        rank_view = '(' + @rank_sql.statement + ') AS rank_view'
        return table_main + ',' + rank_view
      end
      
      # 抽出条件生成
      def part_of_where
        where_sql = Array.new
        join_items = Array.new
        # 結合条件（ランクビュー）
        [:item_1, :item_2, :item_3, :item_4, :item_5].each do |item|
          item_name = @params[item]
          break if blank?(item_name)
          join_items.push(item_name)
          item_name = 'domain_id' if item_name == 'domain_name'
          where_sql.push(full_join('request_analysis_results.' + item_name, 'rank_view.' + item_name))
        end
        # 抽出条件（システムID）
        if add_condition?(:system_id, join_items) then
          where_sql.push('request_analysis_results.system_id = ?')
          @bind_params.push(@params[:system_id].to_i)
        end
        # 抽出条件（受信日時）
        rcvd_time_item = "concat(lpad(ifnull(request_analysis_results.received_year, 'XXXX'), 4, '0')"
        time_unit = @params[:time_unit]
        if time_unit != 'year' then
          ['month', 'day', 'hour', 'minute', 'second'].each do |unit|
            now_item = ',lpad(ifnull(request_analysis_results.received_' + unit + ", 'XX'), 2, '0')"
            rcvd_time_item = rcvd_time_item + now_item
            break if unit == time_unit
          end
        end
        rcvd_time_item = rcvd_time_item + ')'
        where_sql.push('(' + rcvd_time_item + ' BETWEEN ? AND ?)')
        @bind_params.push(@rcvd_period[0])
        @bind_params.push(@rcvd_period[1])
        # 抽出条件（機能ID）
        if add_condition?(:function_id, join_items) then
          where_sql.push('request_analysis_results.function_id = ?')
          @bind_params.push(@params[:function_id].to_i)
        end
        #　抽出条件（機能遷移番号）
        function_trans_no = @params[:function_trans_no]
        if !blank?(function_trans_no) && !join_items.include?('function_transition_no') then
          comp_cond = @params[:function_trans_no_comp]
          where_sql.push(comp_statement('request_analysis_results.function_transition_no', comp_cond))
          @bind_params.push(function_trans_no.to_i)
        end
        #　抽出条件（セッションID）
        if add_condition?(:session_id, join_items) then
          where_sql.push('request_analysis_results.session_id = ?')
          @bind_params.push(@params[:session_id])
        end
        #　抽出条件（クライアントID）
        if add_condition?(:client_id, join_items) then
          where_sql.push('request_analysis_results.client_id = ?')
          @bind_params.push(@params[:client_id])
        end
        #　抽出条件（ブラウザID）
        if add_condition?(:browser_id, join_items) then
          where_sql.push('request_analysis_results.browser_id = ?')
          @bind_params.push(@params[:browser_id].to_i)
        end
        #　抽出条件（ブラウザバージョンID）
        if add_condition?(:browser_version_id, join_items) then
          comp_cond = @params[:browser_version_id_comp]
          where_sql.push(comp_statement('request_analysis_results.browser_version_id', comp_cond))
          @bind_params.push(@params[:browser_version_id].to_i)
        end
        #　抽出条件（言語）
        if add_condition?(:accept_language, join_items) then
          where_sql.push('request_analysis_results.accept_language like ?')
          @bind_params.push(match_param(@params[:accept_language], 'F'))
        end
        #　抽出条件（リファラー）
        if add_condition?(:referrer, join_items) then
          match_cond = @params[:referrer_match]
          where_sql.push(match_statement('request_analysis_results.referrer', match_cond))
          @bind_params.push(match_param(@params[:referrer], match_cond))
        end
        #　抽出条件（プロキシホスト）
        if add_condition?(:proxy_host, join_items) then
          match_cond = @params[:proxy_host_match]
          where_sql.push(match_statement('request_analysis_results.proxy_host', match_cond))
          @bind_params.push(match_param(@params[:proxy_host], match_cond))
        end
        #　抽出条件（プロキシIP）
        if add_condition?(:proxy_ip_address, join_items) then
          where_sql.push('request_analysis_results.proxy_ip_address like ?')
          @bind_params.push(match_param(@params[:proxy_ip_address], 'F'))
        end
        #　抽出条件（クライアントホスト）
        if add_condition?(:remote_host, join_items) then
          match_cond = @params[:remote_host_match]
          where_sql.push(match_statement('request_analysis_results.remote_host', match_cond))
          @bind_params.push(match_param(@params[:remote_host], match_cond))
        end
        #　抽出条件（クライアントIP）
        if add_condition?(:ip_address, join_items) then
          where_sql.push('request_analysis_results.ip_address like ?')
          ip_address = @params[:ip_address]
          @bind_params.push(match_param(ip_address, 'F'))
        end
        #　抽出条件（ドメイン名）
        if @domain_join_flg then
          match_cond = @params[:domain_name_match]
          where_sql.push(match_statement('domains.domain_name', match_cond))
          @bind_params.push(match_param(@params[:domain_name], match_cond))
        end
        return where_sql.join(' AND ')
      end
      
      # GroupBy句生成
      def part_of_grouping
        return @item_name_list.join(',')
      end
      
      # OrderBy句生成
      def part_of_order
        order_list = ['rank_view.total_access ' + @params[:disp_order]]
        @item_name_list.each do |item_name|
          next if item_name == 'rank_view.total_access'
          order_list.push(item_name + ' ASC')
        end
        return order_list.join(',')
      end
      
      # 条件判定
      def add_condition?(item_name, join_items)
        return !blank?(@params[item_name]) && !join_items.include?(item_name.to_s)
      end
    end
  end
end