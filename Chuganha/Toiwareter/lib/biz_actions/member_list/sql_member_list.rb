# -*- coding: utf-8 -*-
###############################################################################
# 会員情報一覧検索SQL生成クラス
# 概要：会員データを問い合わせるSELECT文とバインド変数を生成する
# コントローラー：Member::ListController
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/17 Nakanohito
# 更新日:
###############################################################################
require 'biz_search/business_sql'

module BizActions
  module MemberList
    class SQLMemberList < BizSearch::BusinessSQL
      #########################################################################
      # メソッド定義
      #########################################################################
      # 初期化メソッド
      def initialize(params)
        super()
        # パラメータ
        @params = params
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
        sql_array.push(' FROM members')
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
        item_sql.push('members.id')
        item_sql.push('members.enc_open_id')
        item_sql.push('members.member_id')
        item_sql.push('members.member_state_id')
        item_sql.push('members.authority_id')
        item_sql.push('members.enc_nickname')
        item_sql.push('members.enc_email')
        item_sql.push('members.join_date')
        item_sql.push('members.ineligibility_date')
        item_sql.push('members.last_login_date')
        item_sql.push('members.quote_cnt')
        item_sql.push('members.quote_failure_cnt')
        item_sql.push('members.quote_correct_cnt')
        item_sql.push('members.quote_correct_failure_cnt')
        item_sql.push('members.comment_cnt')
        item_sql.push('members.comment_failure_cnt')
        item_sql.push('members.comment_report_cnt')
        item_sql.push('members.were_reported_cnt')
        item_sql.push('members.support_report_cnt')
        item_sql.push('members.lock_version')
        item_sql.push('members.created_at')
        item_sql.push('members.updated_at')
        return item_sql.join(',')
      end
      
      # 抽出条件生成
      def part_of_where(sql_array)
        where_sql = Array.new
        # 抽出条件（OpenID）
        open_id = @params[:open_id].to_s
        unless blank?(open_id) then
          open_id_match = @params[:open_id_match].to_s
          where_sql.push(dec_match_statement('members.enc_open_id', open_id_match))
          @bind_params.push(match_param(open_id, open_id_match))
        end
        # 抽出条件（会員ID）
        member_id = @params[:member_id].to_s
        unless blank?(member_id) then
          member_id_match = @params[:member_id_match].to_s
          where_sql.push(match_statement('members.member_id', member_id_match))
          @bind_params.push(match_param(member_id, member_id_match))
        end
        # 抽出条件（会員状態ID）
        member_state_id = @params[:member_state_id]
        unless blank?(member_state_id) then
          where_sql.push('members.member_state_id = ?')
          @bind_params.push(member_state_id.to_i)
        end
        # 抽出条件（権限ID）
        authority_id = @params[:authority_id].to_s
        unless blank?(authority_id) then
          where_sql.push('members.authority_id = ?')
          @bind_params.push(authority_id.to_i)
        end
        # ニックネーム
        nickname = @params[:nickname].to_s
        unless blank?(nickname) then
          nickname_match = @params[:nickname_match].to_s
          where_sql.push(dec_match_statement('members.enc_nickname', nickname_match))
          @bind_params.push(match_param(nickname, nickname_match))
        end
        # メール
        email = @params[:email].to_s
        unless blank?(email) then
          email_match = @params[:email_match].to_s
          where_sql.push(dec_match_statement('members.enc_email', email_match))
          @bind_params.push(match_param(email, email_match))
        end
        # 抽出条件（入会日時）
        join_date = @params[:join_date]
        unless blank?(join_date) then
          join_date_comp = @params[:join_date_comp].to_s
          where_sql.push(comp_statement('members.join_date', join_date_comp))
          @bind_params.push(join_date)
        end
        # 抽出条件（資格停止日時）
        ineligibility_date = @params[:ineligibility_date]
        unless blank?(ineligibility_date) then
          ineligibility_date_comp = @params[:ineligibility_date_comp].to_s
          where_sql.push(comp_statement('members.ineligibility_date', ineligibility_date_comp))
          @bind_params.push(ineligibility_date)
        end
        # 抽出条件（最終ログイン日時）
        last_login_date = @params[:last_login_date]
        unless blank?(last_login_date) then
          last_login_date_comp = @params[:last_login_date_comp].to_s
          where_sql.push(comp_statement('members.last_login_date', last_login_date_comp))
          @bind_params.push(last_login_date)
        end
        # 引用投稿回数
        quote_cnt = @params[:quote_cnt]
        unless blank?(quote_cnt) then
          quote_cnt_comp = @params[:quote_cnt_comp]
          where_sql.push(comp_statement('members.quote_cnt', quote_cnt_comp))
          @bind_params.push(quote_cnt.to_i)
        end
        # 引用過失回数
        quote_failure_cnt = @params[:quote_failure_cnt]
        unless blank?(quote_failure_cnt) then
          quote_failure_cnt_comp = @params[:quote_failure_cnt_comp]
          where_sql.push(comp_statement('members.quote_failure_cnt', quote_failure_cnt_comp))
          @bind_params.push(quote_failure_cnt.to_i)
        end
        # 引用訂正回数
        quote_correct_cnt = @params[:quote_correct_cnt]
        unless blank?(quote_correct_cnt) then
          quote_correct_cnt_comp = @params[:quote_correct_cnt_comp]
          where_sql.push(comp_statement('members.quote_correct_cnt', quote_correct_cnt_comp))
          @bind_params.push(quote_correct_cnt.to_i)
        end
        # 引用訂正過失回数
        quote_correct_failure_cnt = @params[:quote_correct_failure_cnt]
        unless blank?(quote_correct_failure_cnt) then
          quote_correct_failure_cnt_comp = @params[:quote_correct_failure_cnt_comp]
          where_sql.push(comp_statement('members.quote_correct_failure_cnt', quote_correct_failure_cnt_comp))
          @bind_params.push(quote_correct_failure_cnt.to_i)
        end
        # コメント投稿回数
        comment_cnt = @params[:comment_cnt]
        unless blank?(comment_cnt) then
          comment_cnt_comp = @params[:comment_cnt_comp]
          where_sql.push(comp_statement('members.comment_cnt', comment_cnt_comp))
          @bind_params.push(comment_cnt.to_i)
        end
        # コメント過失回数
        comment_failure_cnt = @params[:comment_failure_cnt]
        unless blank?(comment_failure_cnt) then
          comment_failure_cnt_comp = @params[:comment_failure_cnt_comp]
          where_sql.push(comp_statement('members.comment_failure_cnt', comment_failure_cnt_comp))
          @bind_params.push(comment_failure_cnt.to_i)
        end
        # コメント通報回数
        comment_report_cnt = @params[:comment_report_cnt]
        unless blank?(comment_report_cnt) then
          comment_report_cnt_comp = @params[:comment_report_cnt_comp]
          where_sql.push(comp_statement('members.comment_report_cnt', comment_report_cnt_comp))
          @bind_params.push(comment_report_cnt.to_i)
        end
        # コメント被通報回数
        were_reported_cnt = @params[:were_reported_cnt]
        unless blank?(were_reported_cnt) then
          were_reported_cnt_comp = @params[:were_reported_cnt_comp]
          where_sql.push(comp_statement('members.were_reported_cnt', were_reported_cnt_comp))
          @bind_params.push(were_reported_cnt.to_i)
        end
        # コメント通報対応
        support_report_cnt = @params[:support_report_cnt]
        unless blank?(support_report_cnt) then
          support_report_cnt_comp = @params[:support_report_cnt_comp]
          where_sql.push(comp_statement('members.support_report_cnt', support_report_cnt_comp))
          @bind_params.push(support_report_cnt.to_i)
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
        page_num  = @params[:page_num]
        unless numeric?(page_num) then
          @bind_params.push(limit_cnt.to_i + 1)
          return '?'
        end
        offset = (page_num.to_i - 1) * limit_cnt.to_i
        @bind_params.push(offset.to_i)
        @bind_params.push(limit_cnt.to_i + 1)
        return '?, ?'
      end
      
      # 復号化マッチングパラメータ生成
      def order_statement(item_name, order)
        table_name = nil
        if Member.attribute_names.include?(item_name) then
          return 'members.' + item_name + ' ' + order
        end
        # 暗号化項目処理
        return dec_item_statement('members.enc_' + item_name) + ' ' + order
      end
    end
  end
end