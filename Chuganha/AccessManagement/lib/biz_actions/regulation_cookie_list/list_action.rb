# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：受信したリクエスト情報をラッピングし、検証と規制クッキー情報の検索を行う
# コントローラー：RegulationCookie::RegulationCookieController
# アクション：list
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/03/23 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/regulation_cookie_list/base_action'

module BizActions
  module RegulationCookieList
    class ListAction < BizActions::RegulationCookieList::BaseAction
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
          @reg_cookie_list = default_search
          return @reg_cookie_list
        end
        search_result = RegulationCookie.search_list(@reg_cookie)
        search_result = search_result.order(@sort_item + ' ' + @sort_order)
        search_result = search_result.limit(@disp_counts.to_i) if numeric?(@disp_counts)
        @reg_cookie_list = search_result
        return @reg_cookie_list
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
      # DB関連チェック
      def db_related_chk?
        # システム存在チェック
        return system_exist_chk?
      end
    end
  end
end