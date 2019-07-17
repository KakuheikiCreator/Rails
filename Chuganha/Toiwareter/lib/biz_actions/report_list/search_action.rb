# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメント通報リストアクションクラス
# コントローラー：Report::ListController
# アクション：search
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/27 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/report_list/base_action'
require 'biz_actions/report_list/sql_report_list'

module BizActions
  module ReportList
    class SearchAction < BizActions::ReportList::BaseAction
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
          sql_params[:report_date] = @report_date
          sql_params[:search_page_num] = @search_page_num
          list_sql = SQLReportList.new(sql_params)
          list_sql.set_db_variable
          @report_list = CommentReport.find_by_sql(list_sql.sql_params)
          list_sql.clear_db_variable
          # 現在ページ情報更新
          refresh_page_info
        end
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 抽出条件チェック
        check_result = report_item_chk?
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
        # マスタ関連チェック
        return master_db_related_chk?
      end
    end
  end
end