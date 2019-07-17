# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員検索アクションクラス
# コントローラー：Member::ListController
# アクション：search
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/17 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/member_list/base_action'
require 'biz_actions/member_list/sql_member_list'

module BizActions
  module MemberList
    class SearchAction < BizActions::MemberList::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 会員検索処理
      def search_list?
        ActiveRecord::Base.transaction do
          return false unless valid?
          # 検索処理
          sql_params = @params.dup
          sql_params[:join_date] = @join_date
          sql_params[:ineligibility_date] = @ineligibility_date
          sql_params[:last_login_date] = @last_login_date
          sql_params[:page_num] = @search_page_num
          list_sql = SQLMemberList.new(sql_params)
          list_sql.set_db_variable
          @member_list = Member.find_by_sql(list_sql.sql_params)
          list_sql.clear_db_variable
          # 現在ページ情報更新
          @prev_page_flg = @search_page_num.to_i > 1
          @next_page_flg = @member_list.size > @display_count.to_i
          @page_num = @search_page_num
        end
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # アカウント抽出条件チェック
        check_result = member_item_chk?
        # ソート条件チェック
        check_result = false unless cond_sort_chk?
        # 表示件数チェック
        check_result = false unless cond_limit_chk?
        # ページ判定
        if @search_page_num.to_i < 1 then
          check_result = false
        end
        return check_result
      end
      
      # 項目関連チェック
      def related_items_chk?
        # ソート条件関係チェック
        return cond_sort_rel_chk?
      end
      
      # DB関連チェック
      def db_related_chk?
        # 会員状態存在チェック
        check_result = member_state_db_chk?
        # 権限存在チェック
        check_result = false unless authority_db_chk?
        return check_result
      end
    end
  end
end