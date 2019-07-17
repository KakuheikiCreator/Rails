# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：受信したリクエスト情報をラッピングし、検証と解析情報取得設定の検索を行う
# コントローラー：ScheduleList::ScheduleListController
# アクション：list
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/08/02 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/schedule_list/base_action'

module BizActions
  module ScheduleList
    class ListAction < BizActions::ScheduleList::BaseAction
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
      # リスト検索
      def search_list
        unless valid? then
          @schedule_list = default_search
          return @schedule_list
        end
        cond_hash = {:system_id=>@system_id,
                     :from_datetime=>@from_datetime,
                     :to_datetime=>@to_datetime}
        search_result = RequestAnalysisSchedule.find_list(cond_hash)
        search_result = search_result.order(@sort_item + ' ' + @sort_order)
        search_result = search_result.limit(@disp_counts.to_i) if numeric?(@disp_counts)
        @schedule_list = search_result.includes(:system)
        return @schedule_list
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 入力項目の属性チェック
        check_result = items_attr_chk?
        # その他条件チェック
        check_result = false unless cond_attr_chk?
        return check_result
      end
      
      # 項目関連チェック
      def related_items_chk?
        return date_related_chk?
      end
      
      # DB関連チェック
      def db_related_chk?
        # システム存在チェック
        return system_exist_chk?
      end
    end
  end
end