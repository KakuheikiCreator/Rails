# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用全文検索アクションクラス
# コントローラー：Search::FulltextController
# アクション：quote
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/10 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/search_fulltext/base_action'
require 'biz_search/quote_search'

module BizActions
  module SearchFulltext
    class QuoteAction < BizActions::SearchFulltext::BaseAction
      include BizSearch
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
      # 検索処理
      def search?
        return false unless valid?
        @result_list = QuoteSearch.instance.full(@quote)
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 引用項目チェック
        check_result = true
        # 引用文
        if blank?(@quote) then
          @error_msg_hash[:quote] = error_msg('quote', :blank)
          check_result = false
        elsif overflow?(@quote, 400) then
          @error_msg_hash[:quote] = error_msg('quote', :too_long, {:count=>400})
          check_result = false
        end
        return check_result
      end
    end
  end
end