# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員リスト基底アクションクラス
# コントローラー：Member::ListController
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/15 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/generic_code_cache'
require 'data_cache/authority_cache'
require 'data_cache/member_state_cache'

module BizActions
  module MemberList
    class BaseAction < BizActions::BusinessAction
      include DataCache
      # リーダー
      attr_reader :member_list, :authority_list, :member_state_list,
                  :authority_id, :member_state_id, :open_id, :open_id_match,
                  :member_id, :member_id_match, :nickname, :nickname_match, :email, :email_match,
                  :join_date, :join_date_comp, :ineligibility_date, :ineligibility_date_comp,
                  :last_login_date, :last_login_date_comp,
                  :quote_cnt, :quote_cnt_comp, :quote_failure_cnt, :quote_failure_cnt_comp,
                  :quote_correct_cnt, :quote_correct_cnt_comp,
                  :quote_correct_failure_cnt, :quote_correct_failure_cnt_comp,
                  :comment_cnt, :comment_cnt_comp,
                  :comment_failure_cnt, :comment_failure_cnt_comp,
                  :comment_report_cnt, :comment_report_cnt_comp,
                  :were_reported_cnt, :were_reported_cnt_comp,
                  :support_report_cnt, :support_report_cnt_comp,
                  :sort_field_1, :sort_field_2, :sort_order_1, :sort_order_2, :display_count,
                  :page_num, :prev_page_flg, :next_page_flg
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        #######################################################################
        # キャッシュデータ
        #######################################################################
        @generic_code_cache = GenericCodeCache.instance
        @authority_list    = AuthorityCache.instance.authority_list
        @member_state_list = MemberStateCache.instance.member_state_list
        
        #######################################################################
        # 検索結果
        #######################################################################
        @member_list = Array.new
        
        #######################################################################
        # 検索条件
        #######################################################################
        @open_id          = @params[:open_id]
        @open_id_match    = @params[:open_id_match]
        @member_id        = @params[:member_id]
        @member_id_match  = @params[:member_id_match]
        @member_state_id  = @params[:member_state_id]
        @authority_id     = @params[:authority_id]
        @nickname         = @params[:nickname]
        @nickname_match   = @params[:nickname_match]
        @email            = @params[:email]
        @email_match      = @params[:email_match]
        # 日付
        @join_date        = date_time_param(:join_date)
        @join_date_comp   = @params[:join_date_comp]
        @ineligibility_date = date_time_param(:ineligibility_date)
        @ineligibility_date_comp  = @params[:ineligibility_date_comp]
        @last_login_date  = date_time_param(:last_login_date)
        @last_login_date_comp   = @params[:last_login_date_comp]
        # 引用回数条件
        @quote_cnt         = @params[:quote_cnt]
        @quote_cnt_comp    = @params[:quote_cnt_comp]
        @quote_failure_cnt  = @params[:quote_failure_cnt]
        @quote_failure_cnt_comp = @params[:quote_failure_cnt_comp]
        @quote_correct_cnt      = @params[:quote_correct_cnt]
        @quote_correct_cnt_comp = @params[:quote_correct_cnt_comp]
        @quote_correct_failure_cnt      = @params[:quote_correct_failure_cnt]
        @quote_correct_failure_cnt_comp = @params[:quote_correct_failure_cnt_comp]
        # コメント回数条件
        @comment_cnt          = @params[:comment_cnt]
        @comment_cnt_comp     = @params[:comment_cnt_comp]
        @comment_failure_cnt  = @params[:comment_failure_cnt]
        @comment_failure_cnt_comp = @params[:comment_failure_cnt_comp]
        @comment_report_cnt   = @params[:comment_report_cnt]
        @comment_report_cnt_comp  = @params[:comment_report_cnt_comp]
        @were_reported_cnt    = @params[:were_reported_cnt]
        @were_reported_cnt_comp   = @params[:were_reported_cnt_comp]
        @support_report_cnt   = @params[:support_report_cnt]
        @support_report_cnt_comp  = @params[:support_report_cnt_comp]
        # ソート条件
        @sort_field_1 = @params[:sort_field_1]
        @sort_field_2 = @params[:sort_field_2]
        @sort_order_1 = @params[:sort_order_1]
        @sort_order_2 = @params[:sort_order_2]
        # リミット件数
        @display_count = @params[:display_count]
        # 改ページ制御
        @page_btn = @params[:page_btn]
        @page_num = @params[:page_num]
        @page_num ||= '1'
        @search_page_num = search_page_number
        @prev_page_flg = false
        @next_page_flg = false
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # ページ番号取得
      def search_page_number
        if @page_btn == 'prev' then
          return (@page_num.to_i - 1).to_s
        elsif @page_btn == 'next' then
          return (@page_num.to_i + 1).to_s
        end
        return @page_num
      end
      
      # 単項目チェック（アカウント抽出条件）
      def member_item_chk?
        check_result = true
        # OpenIDチェック
        unless blank?(@open_id) then
          if overflow?(@open_id, 255) then
            @error_msg_hash[:open_id] = error_msg('open_id', :too_long, :count=>255)
            check_result = false
          end
          unless valid_match?(@open_id_match) then
            @error_msg_hash[:open_id] = error_msg('open_id', :invalid)
            check_result = false
          end
        end
        # 会員IDチェック
        unless blank?(@member_id) then
          if !hankaku?(@member_id) then
            @error_msg_hash[:member_id] = error_msg('member_id', :invalid)
            check_result = false
          elsif overflow?(@member_id, 10) then
            @error_msg_hash[:member_id] = error_msg('member_id', :too_long, :count=>10)
            check_result = false
          end
          unless valid_match?(@member_id_match) then
            @error_msg_hash[:member_id] = error_msg('member_id', :invalid)
            check_result = false
          end
        end
        # 会員状態
        unless blank?(@member_state_id) then
          unless numeric?(@member_state_id) then
            @error_msg_hash[:member_state_id] = error_msg('member_state', :not_a_number)
            check_result = false
          end
        end
        # 権限
        unless blank?(@authority_id) then
          unless numeric?(@authority_id) then
            @error_msg_hash[:authority_id] = error_msg('authority', :not_a_number)
            check_result = false
          end
        end
        # ニックネーム
        unless blank?(@nickname) then
          if overflow?(@nickname, 255) then
            @error_msg_hash[:nickname] = error_msg('nickname', :too_long, :count=>255)
            check_result = false
          end
          unless valid_match?(@nickname_match) then
            @error_msg_hash[:nickname] = error_msg('nickname', :invalid)
            check_result = false
          end
        end
        # メールアドレス
        unless blank?(@email) then
          if !hankaku?(@email) then
            @error_msg_hash[:email] = error_msg('email', :invalid)
            check_result = false
          elsif overflow?(@email, 255) then
            @error_msg_hash[:email] = error_msg('email', :too_long, :count=>255)
            check_result = false
          end
          unless valid_match?(@email_match) then
            @error_msg_hash[:email] = error_msg('email', :invalid)
            check_result = false
          end
        end
        # 入会日時
        unless blank?(@join_date) then
          if !past_date?(@join_date.year, @join_date.month, @join_date.day) then
            @error_msg_hash[:join_date] = error_msg('join_date', :past_date)
            check_result = false
          end
          unless valid_comp?(@join_date_comp) then
            @error_msg_hash[:join_date] = error_msg('join_date', :invalid)
            check_result = false
          end
        end
        # 資格停止日時
        unless blank?(@ineligibility_date) then
          if !past_date?(@ineligibility_date.year, @ineligibility_date.month, @ineligibility_date.day) then
            @error_msg_hash[:ineligibility_date] = error_msg('ineligibility_date', :past_date)
            check_result = false
          end
          unless valid_comp?(@ineligibility_date_comp) then
            @error_msg_hash[:ineligibility_date] = error_msg('ineligibility_date', :invalid)
            check_result = false
          end
        end
        # 最終ログイン日時
        unless blank?(@last_login_date) then
          if !past_date?(@last_login_date.year, @last_login_date.month, @last_login_date.day) then
            @error_msg_hash[:last_login_date] = error_msg('last_login_date', :past_date)
            check_result = false
          end
          unless valid_comp?(@last_login_date_comp) then
            @error_msg_hash[:last_login_date] = error_msg('last_login_date', :invalid)
            check_result = false
          end
        end
        # 引用投稿回数
        unless blank?(@quote_cnt) then
          if !numeric?(@quote_cnt) then
            @error_msg_hash[:quote_cnt] = error_msg('quote_cnt', :not_a_number)
            check_result = false
          elsif @quote_cnt.to_i < 0 then
            @error_msg_hash[:quote_cnt] = error_msg('quote_cnt', :greater_than, :count=>'0')
            check_result = false
          end
          unless valid_comp?(@quote_cnt_comp) then
            @error_msg_hash[:quote_cnt] = error_msg('quote_cnt', :invalid)
            check_result = false
          end
        end
        # 引用過失回数
        unless blank?(@quote_failure_cnt) then
          if !numeric?(@quote_failure_cnt) then
            @error_msg_hash[:quote_failure_cnt] = error_msg('quote_failure_cnt', :not_a_number)
            check_result = false
          elsif @quote_failure_cnt.to_i < 0 then
            @error_msg_hash[:quote_failure_cnt] = error_msg('quote_failure_cnt', :greater_than, :count=>'0')
            check_result = false
          end
          unless valid_comp?(@quote_failure_cnt_comp) then
            @error_msg_hash[:quote_failure_cnt] = error_msg('quote_failure_cnt', :invalid)
            check_result = false
          end
        end
        # 引用訂正回数
        unless blank?(@quote_correct_cnt) then
          if !numeric?(@quote_correct_cnt) then
            @error_msg_hash[:quote_correct_cnt] = error_msg('quote_correct_cnt', :not_a_number)
            check_result = false
          elsif @quote_correct_cnt.to_i < 0 then
            @error_msg_hash[:quote_correct_cnt] = error_msg('quote_correct_cnt', :greater_than, :count=>'0')
            check_result = false
          end
          unless valid_comp?(@quote_correct_cnt_comp) then
            @error_msg_hash[:quote_correct_cnt] = error_msg('quote_correct_cnt', :invalid)
            check_result = false
          end
        end
        # 引用訂正過失回数
        unless blank?(@quote_correct_failure_cnt) then
          if !numeric?(@quote_correct_failure_cnt) then
            @error_msg_hash[:quote_correct_failure_cnt] = error_msg('quote_correct_failure_cnt', :not_a_number)
            check_result = false
          elsif @quote_correct_failure_cnt.to_i < 0 then
            @error_msg_hash[:quote_correct_failure_cnt] = error_msg('quote_correct_failure_cnt', :greater_than, :count=>'0')
            check_result = false
          end
          unless valid_comp?(@quote_correct_failure_cnt_comp) then
            @error_msg_hash[:quote_correct_failure_cnt] = error_msg('quote_correct_failure_cnt', :invalid)
            check_result = false
          end
        end
        # コメント投稿回数
        unless blank?(@comment_cnt) then
          if !numeric?(@comment_cnt) then
            @error_msg_hash[:comment_cnt] = error_msg('comment_cnt', :not_a_number)
            check_result = false
          elsif @comment_cnt.to_i < 0 then
            @error_msg_hash[:comment_cnt] = error_msg('comment_cnt', :greater_than, :count=>'0')
            check_result = false
          end
          unless valid_comp?(@comment_cnt_comp) then
            @error_msg_hash[:comment_cnt] = error_msg('comment_cnt', :invalid)
            check_result = false
          end
        end
        # コメント過失回数
        unless blank?(@comment_failure_cnt) then
          if !numeric?(@comment_failure_cnt) then
            @error_msg_hash[:comment_failure_cnt] = error_msg('comment_failure_cnt', :not_a_number)
            check_result = false
          elsif @comment_failure_cnt.to_i < 0 then
            @error_msg_hash[:comment_failure_cnt] = error_msg('comment_failure_cnt', :greater_than, :count=>'0')
            check_result = false
          end
          unless valid_comp?(@comment_failure_cnt_comp) then
            @error_msg_hash[:comment_failure_cnt] = error_msg('comment_failure_cnt', :invalid)
            check_result = false
          end
        end
        # コメント通報回数
        unless blank?(@comment_report_cnt) then
          if !numeric?(@comment_report_cnt) then
            @error_msg_hash[:comment_report_cnt] = error_msg('comment_report_cnt', :not_a_number)
            check_result = false
          elsif @comment_report_cnt.to_i < 0 then
            @error_msg_hash[:comment_report_cnt] = error_msg('comment_report_cnt', :greater_than, :count=>'0')
            check_result = false
          end
          unless valid_comp?(@comment_report_cnt_comp) then
            @error_msg_hash[:comment_report_cnt] = error_msg('comment_report_cnt', :invalid)
            check_result = false
          end
        end
        # コメント被通報回数
        unless blank?(@were_reported_cnt) then
          if !numeric?(@were_reported_cnt) then
            @error_msg_hash[:were_reported_cnt] = error_msg('were_reported_cnt', :not_a_number)
            check_result = false
          elsif @were_reported_cnt.to_i < 0 then
            @error_msg_hash[:were_reported_cnt] = error_msg('were_reported_cnt', :greater_than, :count=>'0')
            check_result = false
          end
          unless valid_comp?(@were_reported_cnt_comp) then
            @error_msg_hash[:were_reported_cnt] = error_msg('were_reported_cnt', :invalid)
            check_result = false
          end
        end
        # コメント通報対応回数
        unless blank?(@support_report_cnt) then
          if !numeric?(@support_report_cnt) then
            @error_msg_hash[:support_report_cnt] = error_msg('support_report_cnt', :not_a_number)
            check_result = false
          elsif @support_report_cnt.to_i < 0 then
            @error_msg_hash[:support_report_cnt] = error_msg('support_report_cnt', :greater_than, :count=>'0')
            check_result = false
          end
          unless valid_comp?(@support_report_cnt_comp) then
            @error_msg_hash[:support_report_cnt] = error_msg('support_report_cnt', :invalid)
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
      
      # DB関連チェック（会員状態）
      def member_state_db_chk?
        check_result = true
        # 会員状態チェック
        unless blank?(@member_state_id) then
          unless MemberStateCache.instance.id_exist?(@member_state_id) then
            @error_msg_hash[:member_state] = error_msg('member_state', :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # DB関連チェック（権限）
      def authority_db_chk?
        check_result = true
        # 権限チェック
        unless blank?(@authority_id) then
          unless AuthorityCache.instance.id_exist?(@authority_id) then
            @error_msg_hash[:authority] = error_msg('authority', :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # 比較条件チェック
      def valid_comp?(comp_val)
        return @generic_code_cache.code_values(:COMP_COND_CLS).include?(comp_val)
      end
      
      # 比較条件チェック
      def valid_match?(match_val)
        return @generic_code_cache.code_values(:MATCH_COND_CLS).include?(match_val)
      end
      
      # ソート項目チェック
      def valid_sort_field?(item_name)
        return true if blank?(item_name)
        return @generic_code_cache.code_values(:MEMBER_SORT_FIELDS).include?(item_name)
      end
      
      # 並び順チェック
      def valid_order?(order)
        return @generic_code_cache.code_values(:SORT_ORDER_CLS).include?(order)
      end
      
      # リミット件数チェック
      def valid_limit?(limit_cnt)
        return @generic_code_cache.code_values(:COUNT_L).include?(limit_cnt)
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text('list.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end