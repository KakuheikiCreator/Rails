# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメント全文検索アクションクラス
# コントローラー：Search::FulltextController
# アクション：comment
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/10 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/search_fulltext/base_action'
require 'biz_search/comment_search'

module BizActions
  module SearchFulltext
    class CommentAction < BizActions::SearchFulltext::BaseAction
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
        @result_list = CommentSearch.instance.full(@comment)
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 引用項目チェック
        check_result = true
        # コメント文
        if blank?(@comment) then
          @error_msg_hash[:comment] = error_msg('comment', :blank)
          check_result = false
        elsif overflow?(@comment, 400) then
          @error_msg_hash[:comment] = error_msg('comment', :too_long, {:count=>400})
          check_result = false
        end
        return check_result
      end
    end
  end
end