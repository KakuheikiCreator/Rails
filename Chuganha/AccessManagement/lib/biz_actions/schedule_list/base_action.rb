# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションの基底クラス
# 概要：受信したリクエスト情報をラッピングし、検証と解析情報取得設定の検索を行う
# コントローラー：ScheduleList::ScheduleListController
# アクション：list,create,delete,update,notify
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/08/02 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'
require 'data_cache/generic_code_cache'
require 'biz_actions/business_action'

module BizActions
  module ScheduleList
    class BaseAction < BizActions::BusinessAction
      include Common::NetUtilModule
      include DataCache
      # アクセサー定義
      attr_reader :system_id, :from_datetime, :to_datetime,
                  :sort_item, :sort_order, :disp_counts, :schedule_list
      #########################################################################
      # 定数定義
      #########################################################################
      DEFAULT_SORT_ITEM        = 'gets_start_date'
      DEFAULT_SORT_ORDER       = 'ASC'
      DEFAULT_DISP_COUNTS      = '500'
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 登録・抽出条件
        @system_id = params[:system_id]
        @from_datetime = date_time_param(:from_datetime)
        @to_datetime   = date_time_param(:to_datetime)
        # ソート条件等
        @sort_item   = params[:sort_item]
        @sort_item   ||= DEFAULT_SORT_ITEM
        @sort_order  = params[:sort_order]
        @sort_order  ||= DEFAULT_SORT_ORDER
        @disp_counts = params[:disp_counts]
        @disp_counts ||= DEFAULT_DISP_COUNTS
        # 検索結果
        @schedule_list = nil
        # 汎用コードキャッシュ
        @generic_code_cache = GenericCodeCache.instance
      end
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目属性チェック（input_form）
      def items_attr_chk?
        check_result = true
        # システムID
        unless blank?(@system_id) then
          unless numeric?(@system_id.to_s) then
            @error_msg_hash[:system_id] = validation_msg(:system_name, :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # 項目関連チェック（input_form）
      def date_related_chk?
        check_result = true
        # 取得開始日時の関連チェック
        if !@from_datetime.nil? && !@to_datetime.nil? then
          if @from_datetime >= @to_datetime then
            @error_msg_hash[:gets_start_date] = validation_msg(:gets_start_date, :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # その他条件チェック（input_form）
      def cond_attr_chk?
        check_result = true
        # ソート条件チェック
        if blank?(@sort_item) then
          @error_msg_hash[:sort_cond] = validation_msg(:ordering, :blank)
          check_result = false
        else
          column_names = RequestAnalysisSchedule.column_names
          sort_order_info = @generic_code_cache.code_info(:SORT_ORDER_CLS)
          unless column_names.include?(@sort_item) &&
                 sort_order_info.values.include?(@sort_order) then
            @error_msg_hash[:sort_cond] = validation_msg(:ordering, :invalid)
            check_result = false
          end
        end
        # 表示件数チェック
        if blank?(@disp_counts) then
          @error_msg_hash[:disp_counts] = validation_msg(:number_to_display, :blank)
          check_result = false
        else
          count_info = @generic_code_cache.code_info(:COUNT_L)
          unless count_info.values.include?(@disp_counts) then
            @error_msg_hash[:disp_counts] = validation_msg(:number_to_display, :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # システム項目存在チェック
      def system_exist_chk?
        check_result = true
        if !blank?(@system_id) && System.where(:id=>@system_id.to_i).empty? then
          @error_msg_hash[:system_id] = validation_msg(:system_name, :invalid)
          check_result = false
        end
        return check_result
      end
      
      # デフォルト検索
      def default_search
        return RequestAnalysisSchedule.order('system_id ASC').order('gets_start_date ASC').limit(500).includes(:system)
      end
    end
  end
end