# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメント通報リスト基底アクションクラス
# コントローラー：Report::ListController
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/27 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/generic_code_cache'
require 'data_cache/report_reason_cache'

module BizActions
  module ReportList
    class BaseAction < BizActions::BusinessAction
      include DataCache
      # リーダー
      attr_reader :report_list,
                  :quote_id, :quote_id_comp, :comment_state, :comment_id, :comment_id_comp,
                  :comment_member_id, :comment_member_match, :comment_nickname, :comment_nickname_match,
                  :report_date, :report_date_comp, :report_reason_id, :report_reason_detail, :report_reason_match,
                  :report_member_id, :report_member_match, :report_nickname, :report_nickname_match,
                  :sort_field_1, :sort_field_2, :sort_order_1, :sort_order_2,
                  :display_count, :page_num, :prev_page_flg, :next_page_flg
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        #######################################################################
        # キャッシュデータ
        #######################################################################
        @generic_cache = GenericCodeCache.instance
        
        #######################################################################
        # 検索結果
        #######################################################################
        @report_list = Array.new
        
        #######################################################################
        # 検索条件
        #######################################################################
        # 引用
        @quote_id        = @params[:quote_id]
        @quote_id_comp   = @params[:quote_id_comp]
        # コメント
        @comment_state   = @params[:comment_state]
        @comment_id      = @params[:comment_id]
        @comment_id_comp = @params[:comment_id_comp]
        @comment_member_id      = @params[:comment_member_id]
        @comment_member_match   = @params[:comment_member_match]
        @comment_nickname       = @params[:comment_nickname]
        @comment_nickname_match = @params[:comment_nickname_match]
        # 通報
        @report_date            = date_time_param(:report_date)
        @report_date_comp       = @params[:report_date_comp]
        @report_reason_id       = @params[:report_reason_id]
        @report_reason_detail   = @params[:report_reason_detail]
        @report_reason_match    = @params[:report_reason_match]
        @report_member_id       = @params[:report_member_id]
        @report_member_match    = @params[:report_member_match]
        @report_nickname        = @params[:report_nickname]
        @report_nickname_match  = @params[:report_nickname_match]
        # ソート条件
        @sort_field_1 = @params[:sort_field_1]
        @sort_field_2 = @params[:sort_field_2]
        @sort_order_1 = @params[:sort_order_1]
        @sort_order_2 = @params[:sort_order_2]
        # リミット件数
        @display_count = @params[:display_count]
        # 改ページ制御
        @page_num = @params[:page_num]
        @page_num ||= '1'
        @search_page_num = @page_num
        @prev_page_flg = false
        @next_page_flg = false
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 現在ページ情報更新
      def refresh_page_info
        @prev_page_flg = @search_page_num.to_i > 1
        @next_page_flg = @report_list.size > @display_count.to_i
        @page_num = @search_page_num
      end
      
      # 単項目チェック（抽出条件）
      def report_item_chk?
        check_result = true
        # 引用ID
        unless blank?(@quote_id) then
          if !numeric?(@quote_id) then
            @error_msg_hash[:quote_id] = error_msg('quote_id', :not_a_number)
            check_result = false
          end
          unless valid_comp?(@quote_id_comp) then
            @error_msg_hash[:quote_id] = error_msg('quote_id', :invalid)
            check_result = false
          end
        end
        # コメント状態
        if blank?(@comment_state) then
          @error_msg_hash[:comment_state] = error_msg('comment_state', :blank)
          return false
        elsif !@generic_cache.code_values(:DELETE_STATE).include?(@comment_state) then
          @error_msg_hash[:comment_state] = error_msg('comment_state', :invalid)
          return false
        end
        # コメントID
        unless blank?(@comment_id) then
          if !numeric?(@comment_id) then
            @error_msg_hash[:comment_id] = error_msg('comment_id', :not_a_number)
            check_result = false
          end
          unless valid_comp?(@comment_id_comp) then
            @error_msg_hash[:comment_id] = error_msg('comment_id', :invalid)
            check_result = false
          end
        end
        # コメント会員IDチェック
        unless blank?(@comment_member_id) then
          if !hankaku?(@comment_member_id) then
            @error_msg_hash[:comment_member_id] = error_msg('comment_member_id', :invalid)
            check_result = false
          elsif overflow?(@comment_member_id, 10) then
            @error_msg_hash[:comment_member_id] = error_msg('comment_member_id', :too_long, :count=>10)
            check_result = false
          end
          unless valid_match?(@comment_member_match) then
            @error_msg_hash[:comment_member_id] = error_msg('comment_member_id', :invalid)
            check_result = false
          end
        end
        # コメント会員ニックネーム
        unless blank?(@comment_nickname) then
          if overflow?(@comment_nickname, 255) then
            @error_msg_hash[:comment_member_nickname] = error_msg('comment_member_nickname', :too_long, :count=>255)
            check_result = false
          end
          unless valid_match?(@comment_nickname_match) then
            @error_msg_hash[:comment_member_nickname] = error_msg('comment_member_nickname', :invalid)
            check_result = false
          end
        end
        # 通報日時
        unless blank?(@report_date) then
          if !past_time?(@report_date) then
            @error_msg_hash[:report_date] = error_msg('report_date', :past_time)
            check_result = false
          end
          unless valid_comp?(@report_date_comp) then
            @error_msg_hash[:report_date] = error_msg('report_date', :invalid)
            check_result = false
          end
        end
        # 通報理由ID
        unless blank?(@report_reason_id) then
          if !numeric?(@report_reason_id) then
            @error_msg_hash[:report_reason] = error_msg('report_reason', :not_a_number)
            check_result = false
          end
        end
        # 通報理由詳細
        unless blank?(@report_reason_detail) then
          if overflow?(@report_reason_detail, 255) then
            @error_msg_hash[:report_reason_detail] = error_msg('report_reason_detail', :too_long, :count=>255)
            check_result = false
          end
          unless valid_match?(@report_reason_match) then
            @error_msg_hash[:report_reason_detail] = error_msg('report_reason_detail', :invalid)
            check_result = false
          end
        end
        # 通報会員IDチェック
        unless blank?(@report_member_id) then
          if !hankaku?(@report_member_id) then
            @error_msg_hash[:report_member_id] = error_msg('report_member_id', :invalid)
            check_result = false
          elsif overflow?(@report_member_id, 10) then
            @error_msg_hash[:report_member_id] = error_msg('report_member_id', :too_long, :count=>10)
            check_result = false
          end
          unless valid_match?(@report_member_match) then
            @error_msg_hash[:report_member_id] = error_msg('report_member_id', :invalid)
            check_result = false
          end
        end
        # 通報会員ニックネーム
        unless blank?(@report_nickname) then
          if overflow?(@report_nickname, 255) then
            @error_msg_hash[:report_nickname] = error_msg('report_nickname', :too_long, :count=>255)
            check_result = false
          end
          unless valid_match?(@report_nickname_match) then
            @error_msg_hash[:report_nickname] = error_msg('report_nickname', :invalid)
            check_result = false
          end
        end
        return check_result
      end

      # 単項目チェック（ソート条件）
      def cond_sort_chk?
        check_result = true
        # ソート項目１
        unless valid_sort_field?(@sort_field_1) then
          @error_msg_hash[:sort_limit_fields] = error_msg('sort_limit_fields', :invalid)
          check_result = false
        end
        # ソート項目２
        unless valid_sort_field?(@sort_field_2) then
          @error_msg_hash[:sort_limit_fields] = error_msg('sort_limit_fields', :invalid)
          check_result = false
        end
        # ソート順序１
        unless valid_order?(@sort_order_1) then
          @error_msg_hash[:sort_limit_fields] = error_msg('sort_limit_fields', :invalid)
          check_result = false
        end
        # ソート順序２
        unless valid_order?(@sort_order_2) then
          @error_msg_hash[:sort_limit_fields] = error_msg('sort_limit_fields', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # 単項目チェック（抽出件数チェック）
      def cond_limit_chk?
        check_result = true
        unless valid_limit?(@display_count) then
          @display_count = '0'
          @error_msg_hash[:sort_limit_fields] = error_msg('sort_limit_fields', :invalid)
          check_result = false
        end
        # ページ番号チェック
        unless blank?(@page_num) then
          if !numeric?(@page_num) then
            @error_msg_hash[:sort_limit_fields] = error_msg('sort_limit_fields', :invalid)
            check_result = false
          elsif @page_num.to_i <= 0 then
            @error_msg_hash[:sort_limit_fields] = error_msg('sort_limit_fields', :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # 項目関連チェック（ソート条件）
      def cond_sort_rel_chk?
        check_result = true
        return check_result if blank?(@sort_field_1) && blank?(@sort_field_2)
        # 項目重複チェック
        if @sort_field_1 == @sort_field_2 then
          @error_msg_hash[:sort_limit_fields] = error_msg('sort_limit_fields', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック（マスタ）
      def master_db_related_chk?
        check_result = true
        # 通報理由
        unless blank?(@report_reason_id) then
          unless ReportReasonCache.instance.exist?(@report_reason_id.to_i) then
            @error_msg_hash[:report_reason_id] = error_msg('report_reason_id', :not_found)
            return false
          end
        end
        return check_result
      end
      
      # 比較条件チェック
      def valid_comp?(comp_val)
        return @generic_cache.code_values(:COMP_COND_CLS).include?(comp_val)
      end
      
      # 比較条件チェック
      def valid_match?(match_val)
        return @generic_cache.code_values(:MATCH_COND_CLS).include?(match_val)
      end
      
      # ソート項目チェック
      def valid_sort_field?(item_name)
        return true if blank?(item_name)
        return @generic_cache.code_values(:REPORT_SORT_FIELDS).include?(item_name)
      end
      
      # 並び順チェック
      def valid_order?(order)
        return @generic_cache.code_values(:SORT_ORDER_CLS).include?(order)
      end
      
      # リミット件数チェック
      def valid_limit?(limit_cnt)
        return @generic_cache.code_values(:COUNT_L).include?(limit_cnt)
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text('list.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end