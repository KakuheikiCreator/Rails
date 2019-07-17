# -*- coding: utf-8 -*-
###############################################################################
# 通報情報一覧検索SQL生成クラス
# 概要：通報データを問い合わせるSELECT文とバインド変数を生成する
# コントローラー：Report::ListController
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/28 Nakanohito
# 更新日:
###############################################################################
require 'biz_search/business_sql'

module BizActions
  module ReportList
    class SQLReportList < BizSearch::BusinessSQL
      #########################################################################
      # メソッド定義
      #########################################################################
      # 初期化メソッド
      def initialize(params)
        super()
        # パラメータ
        @params = params
        #　削除フラグ
        @delete_flg = ('deleted' == @params[:comment_state])
        # SELECT文
        @statement = generate_select
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # SELECT文生成
      def generate_select
        sql_array = Array.new
        sql_array.push('SELECT ')
        sql_array.push(part_of_item)
        # FROM句
        sql_array.push(' FROM ')
        sql_array.push(part_of_tables)
        # WHERE句
        part_of_where(sql_array)
        # ORDER BY句
        part_of_order(sql_array)
        # LIMIT句
        sql_array.push(' LIMIT ')
        sql_array.push(part_of_limit)
        return sql_array.join
      end
      
      # 項目リスト生成
      def part_of_item
        item_sql = Array.new
        item_sql.push('comment_reports.id')
        item_sql.push('comment_reports.quote_id')
        item_sql.push('comment_reports.quote_history_id')
        item_sql.push('comment_reports.comment_id')
        item_sql.push('comment_reports.comment_delete_id')
        item_sql.push('comment_reports.seq_no')
        item_sql.push('comment_reports.report_reason_id')
        item_sql.push('comment_reports.report_reason_detail')
        item_sql.push('comment_reports.whistleblower_id')
        item_sql.push('comment_reports.report_member_id')
        item_sql.push('comment_reports.report_date')
        item_sql.push('comment_reports.lock_version')
        item_sql.push('comment_reports.created_at')
        item_sql.push('comment_reports.updated_at')
        item_sql.push('r_members.enc_nickname as enc_whistleblower_nickname')
        item_sql.push('c_members.member_id as critic_member_id')
        item_sql.push('c_members.comment_failure_cnt as comment_failure_cnt')
        item_sql.push('c_members.were_reported_cnt as comment_were_reported_cnt')
        return item_sql.join(',')
      end
      
      # テーブルリスト生成
      def part_of_tables
        tables_sql = Array.new
        tables_sql.push('comment_reports inner join members as r_members on')
        tables_sql.push(' comment_reports.whistleblower_id = r_members.id')
        if @delete_flg then
          # コメント削除を結合
          tables_sql.push(' inner join comment_deletes on')
          tables_sql.push(' comment_reports.comment_delete_id = comment_deletes.id')
          tables_sql.push(' inner join members as c_members on comment_deletes.critic_id = c_members.id')
        else
          # コメントを結合
          tables_sql.push(' inner join comments on comment_reports.comment_id = comments.id')
          tables_sql.push(' inner join members as c_members on comments.critic_id = c_members.id')
        end
        return tables_sql.join
      end
      
      # 抽出条件生成
      def part_of_where(sql_array)
        where_sql = Array.new
        # 引用ID　または　引用履歴ID
        quote_id = @params[:quote_id].to_s
        unless blank?(quote_id) then
          quote_id_comp = @params[:quote_id_comp]
          if @delete_flg then
            where_sql.push(comp_statement('comment_reports.quote_history_id', quote_id_comp))
          else
            where_sql.push(comp_statement('comment_reports.quote_id', quote_id_comp))
          end
          @bind_params.push(quote_id.to_i)
        end
        # コメントID　または　コメント削除ID
        comment_id = @params[:comment_id].to_s
        unless blank?(comment_id) then
          comment_id_comp = @params[:comment_id_comp]
          if @delete_flg then
            where_sql.push(comp_statement('comment_reports.comment_delete_id', comment_id_comp))
          else
            where_sql.push(comp_statement('comment_reports.comment_id', comment_id_comp))
          end
          @bind_params.push(comment_id.to_i)
        end
        # 通報理由ID
        report_reason_id = @params[:report_reason_id].to_s
        unless blank?(report_reason_id) then
          where_sql.push('comment_reports.report_reason_id = ?')
          @bind_params.push(report_reason_id.to_i)
        end
        # 通報理由詳細
        report_reason_detail = @params[:report_reason_detail].to_s
        unless blank?(report_reason_detail) then
          report_reason_match = @params[:report_reason_match].to_s
          where_sql.push(match_statement('comment_reports.report_reason_detail', report_reason_match))
          @bind_params.push(match_param(report_reason_detail, report_reason_match))
        end
        # 通報会員ID
        report_member_id = @params[:report_member_id].to_s
        unless blank?(report_member_id) then
          report_member_match = @params[:report_member_match].to_s
          where_sql.push(match_statement('comment_reports.report_member_id', report_member_match))
          @bind_params.push(match_param(report_member_id, report_member_match))
        end
        # 通報会員ニックネーム
        report_nickname = @params[:report_nickname].to_s
        unless blank?(report_nickname) then
          report_nickname_match = @params[:report_nickname_match].to_s
          where_sql.push(dec_match_statement('r_member.enc_nickname', report_nickname_match))
          @bind_params.push(match_param(report_nickname, report_nickname_match))
        end
        # 通報日時
        report_date = @params[:report_date]
        unless blank?(report_date) then
          report_date_comp = @params[:report_date_comp].to_s
          where_sql.push(comp_statement('comment_reports.report_date', report_date_comp))
          @bind_params.push(report_date)
        end
        # コメント会員ID
        critic_member_id = @params[:critic_member_id]
        unless blank?(critic_member_id) then
          critic_member_match = @params[:critic_member_match].to_s
          where_sql.push(match_statement('comments.critic_member_id', critic_member_match))
          @bind_params.push(match_param(critic_member_id, critic_member_match))
        end
        # コメント会員ニックネーム
        comment_nickname = @params[:comment_nickname].to_s
        unless blank?(comment_nickname) then
          comment_nickname_match = @params[:comment_nickname_match].to_s
          where_sql.push(dec_match_statement('c_member.enc_nickname', comment_nickname_match))
          @bind_params.push(match_param(comment_nickname, comment_nickname_match))
        end
        return if where_sql.empty?
        sql_array.push(' WHERE ')
        sql_array.push(where_sql.join(' AND '))
      end
      
      # OrderBy句生成
      def part_of_order(sql_array)
        field_1 = @params[:sort_field_1]
        field_2 = @params[:sort_field_2]
        return if blank?(field_1) && blank?(field_2)
        sql_array.push(' ORDER BY ')
        order_sql = Array.new
        order_sql.push(order_statement(field_1, @params[:sort_order_1])) unless blank?(field_1)
        order_sql.push(order_statement(field_2, @params[:sort_order_2])) unless blank?(field_2)
        sql_array.push(order_sql.join(','))
      end
      
      # Limit句生成
      def part_of_limit
        # 次ページ判定の為に＋１件検索
        limit_cnt = @params[:display_count]
        search_page_num  = @params[:search_page_num]
        unless numeric?(search_page_num) then
          @bind_params.push(limit_cnt.to_i + 1)
          return '?'
        end
        offset = (search_page_num.to_i - 1) * limit_cnt.to_i
        @bind_params.push(offset.to_i)
        @bind_params.push(limit_cnt.to_i + 1)
        return '?, ?'
      end
      
      # 復号化マッチングパラメータ生成
      def order_statement(item_name, order)
        table_name = nil
        if CommentReport.attribute_names.include?(item_name) then
          if @delete_flg && 'comment_id' == item_name then
            return 'comment_reports.comment_delete_id ' + order
          end
          return 'comment_reports.' + item_name + ' ' + order
        end
        if 'report_member_nickname' == item_name then
          return dec_item_statement('r_members.enc_nickname') + ' ' + order
        elsif 'comment_member_id' == item_name then
          return 'c_members.members_id ' + order
        end
        # デフォルト：コメント通報ID
        return 'comment_reports.id ASC'
      end
    end
  end
end