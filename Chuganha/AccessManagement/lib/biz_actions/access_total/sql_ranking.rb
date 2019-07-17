# -*- coding: utf-8 -*-
###############################################################################
# 集計対象抽出SQL生成クラス
# 概要：集計対象データを問い合わせるSELECT文とバインド変数を生成する
# コントローラー：AccessTotal::AccessTotalController
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/09/28 Nakanohito
# 更新日:
###############################################################################
require 'active_support'
require 'common/validation_chk_module'
require 'common/model/db_util_module'

module BizActions
  module AccessTotal
    class SQLRanking
      include Common::ValidationChkModule
      include Common::Model::DbUtilModule
      # アクセサー定義
      attr_reader :statement, :bind_params, :sql_params, :rcvd_period
      #########################################################################
      # メソッド定義
      #########################################################################
      # 初期化メソッド
      def initialize(params)
        # 集計条件パラメータ
        @params = params
        # バインド変数配列
        @bind_params = Array.new
        # 項目リスト生成
        @item_name_list = grouping_items_list
        # ドメイン結合フラグ
        @domain_join_flg = !blank?(@params[:domain_name]) ||
                           @item_name_list.include?('domains.domain_name')
        # 集計期間計算
        period = calc_period
        @rcvd_period = [period_param(period[0]), period_param(period[1])]
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
          if item_name == 'domain_name' then
            item_name_list.push('request_analysis_results.domain_id')
            table_name = 'domains.'
          end
          item_name_list.push(table_name + item_name)
        end
        return item_name_list
      end
      
      # 集計期間計算
      def calc_period
        # 単位期間算出
        ref_date = @params[:received_date_from]
        diff_num = @params[:time_unit_num].to_i - 1
        period_num = @params[:time_unit_num].to_i * (@params[:aggregation_period].to_i - 1)
        to_date = nil
        case @params[:time_unit]
        when 'year' then
          from_date = ref_date - diff_num.years
          to_date   = ref_date + period_num.years
        when 'month' then
          from_date = ref_date - diff_num.months
          to_date   = ref_date + period_num.months
        when 'day' then
          from_date = ref_date - diff_num.days
          to_date   = ref_date + period_num.days
        when 'hour' then
          from_date = ref_date - diff_num.hours
          to_date   = ref_date + period_num.hours
        when 'minute' then
          from_date = ref_date - diff_num.minutes
          to_date   = ref_date + period_num.minutes
        else
          from_date = ref_date - diff_num.seconds
          to_date   = ref_date + period_num.seconds
        end        
        return [from_date, to_date]
      end
      
      # 日付文字列への変換
      def period_param(datetime)
        time_unit = @params[:time_unit]
        item_list = [datetime.year.to_s.rjust(4, '0')]
        return item_list.join if time_unit == 'year'
        item_list.push(datetime.month.to_s.rjust(2, '0'))
        return item_list.join if time_unit == 'month'
        item_list.push(datetime.day.to_s.rjust(2, '0'))
        return item_list.join if time_unit == 'day'
        item_list.push(datetime.hour.to_s.rjust(2, '0'))
        return item_list.join if time_unit == 'hour'
        item_list.push(datetime.min.to_s.rjust(2, '0'))
        return item_list.join if time_unit == 'minute'
        item_list.push(datetime.sec.to_s.rjust(2, '0'))
        return item_list.join
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
        sql_array.push(' LIMIT ?')
        @bind_params.push(@params[:disp_number].to_i)
        return sql_array.join
      end
      
      # 項目リスト生成
      def part_of_item
        item_sql = @item_name_list.dup
        item_sql.push('sum(request_analysis_results.request_count) AS total_access')
        return item_sql.join(',')
      end
      
      # テーブルリスト生成
      def part_of_tables
        tables_sql = ['request_analysis_results']
        if @domain_join_flg then
          tables_sql.push(' LEFT OUTER JOIN ')
          tables_sql.push('domains')
          tables_sql.push(' ON ')
          tables_sql.push('request_analysis_results.domain_id = domains.id')
        end
        return tables_sql.join
      end
      
      # 抽出条件生成
      def part_of_where
        where_sql = Array.new
        # 抽出条件（システムID）
        system_id = @params[:system_id]
        unless blank?(system_id) then
          where_sql.push('request_analysis_results.system_id = ?')
          @bind_params.push(system_id.to_i)
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
        rcvd_time_item = rcvd_time_item + ")"
        where_sql.push('(' + rcvd_time_item + ' BETWEEN ? AND ?)')
        @bind_params.push(@rcvd_period[0])
        @bind_params.push(@rcvd_period[1])
        # 抽出条件（機能ID）
        function_id = @params[:function_id]
        unless blank?(function_id) then
          where_sql.push('request_analysis_results.function_id = ?')
          @bind_params.push(function_id.to_i)
        end
        #　抽出条件（機能遷移番号）
        function_transition_no = @params[:function_trans_no]
        unless blank?(function_transition_no) then
          comp_cond = @params[:function_trans_no_comp]
          where_sql.push(comp_statement('request_analysis_results.function_transition_no', comp_cond))
          @bind_params.push(function_transition_no.to_i)
        end
        #　抽出条件（セッションID）
        session_id = @params[:session_id]
        unless blank?(session_id) then
          where_sql.push('request_analysis_results.session_id = ?')
          @bind_params.push(session_id)
        end
        #　抽出条件（クライアントID）
        client_id = @params[:client_id]
        unless blank?(client_id) then
          where_sql.push('request_analysis_results.client_id = ?')
          @bind_params.push(client_id)
        end
        #　抽出条件（ブラウザID）
        browser_id = @params[:browser_id]
        unless blank?(browser_id) then
          where_sql.push('request_analysis_results.browser_id = ?')
          @bind_params.push(browser_id.to_i)
        end
        #　抽出条件（ブラウザバージョンID）
        browser_version_id = @params[:browser_version_id]
        unless blank?(browser_version_id) then
          comp_cond = @params[:browser_version_id_comp]
          where_sql.push(comp_statement('request_analysis_results.browser_version_id', comp_cond))
          @bind_params.push(browser_version_id.to_i)
        end
        #　抽出条件（言語）
        accept_language = @params[:accept_language]
        unless blank?(accept_language) then
          where_sql.push('request_analysis_results.accept_language like ?')
          @bind_params.push(match_param(accept_language, 'F'))
        end
        #　抽出条件（リファラー）
        referrer = @params[:referrer]
        unless blank?(referrer) then
          match_cond = @params[:referrer_match]
          where_sql.push(match_statement('request_analysis_results.referrer', match_cond))
          @bind_params.push(match_param(referrer, match_cond))
        end
        #　抽出条件（プロキシホスト）
        proxy_host = @params[:proxy_host]
        unless blank?(proxy_host) then
          match_cond = @params[:proxy_host_match]
          where_sql.push(match_statement('request_analysis_results.proxy_host', match_cond))
          @bind_params.push(match_param(proxy_host, match_cond))
        end
        #　抽出条件（プロキシIP）
        proxy_ip_address = @params[:proxy_ip_address]
        unless blank?(proxy_ip_address) then
          where_sql.push('request_analysis_results.proxy_ip_address like ?')
          @bind_params.push(match_param(proxy_ip_address, 'F'))
        end
        #　抽出条件（クライアントホスト）
        remote_host = @params[:remote_host]
        unless blank?(remote_host) then
          match_cond = @params[:remote_host_match]
          where_sql.push(match_statement('request_analysis_results.remote_host', match_cond))
          @bind_params.push(match_param(remote_host, match_cond))
        end
        #　抽出条件（クライアントIP）
        ip_address = @params[:ip_address]
        unless blank?(ip_address) then
          where_sql.push('request_analysis_results.ip_address like ?')
          @bind_params.push(match_param(ip_address, 'F'))
        end
        #　抽出条件（ドメイン名）
        domain_name = @params[:domain_name]
        unless blank?(domain_name) then
          match_cond = @params[:domain_name_match]
          where_sql.push(match_statement('domains.domain_name', match_cond))
          @bind_params.push(match_param(domain_name, match_cond))
        end
        return where_sql.join(' AND ')
      end
      
      # GroupBy句生成
      def part_of_grouping
        return @item_name_list.join(',')
      end
      
      # OrderBy句生成
      def part_of_order
        return 'total_access ' + @params[:disp_order]
      end
    end
  end
end