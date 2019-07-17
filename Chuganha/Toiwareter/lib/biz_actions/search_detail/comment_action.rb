# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメント全文検索アクションクラス
# コントローラー：Quote::DetailController
# アクション：comment
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/10 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/search_detail/base_action'
require 'biz_search/comment_search'

module BizActions
  module SearchDetail
    class CommentAction < BizActions::SearchDetail::BaseAction
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
        member_id = to_member_id(@critic_member)
        @result_list = CommentSearch.instance.detail(@comment, member_id,
                                     @criticism_date, @criticism_date_comp)
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
        unless blank?(@comment) then
          if overflow?(@comment, 255) then
            @error_msg_hash[:comment] = error_msg('comment', :too_long, {:count=>255})
            check_result = false
          end
        end
        # 批評者
        unless blank?(@critic_member) then
          if overflow?(@critic_member, 255) then
            @error_msg_hash[:critic_member] = error_msg('critic_member', :too_long, {:count=>255})
            check_result = false
          end
        end
        # 批評日時
        unless blank?(@criticism_date) then
          if !past_time?(@criticism_date) then
            @error_msg_hash[:criticism_date] = error_msg('criticism_date', :past_date)
            check_result = false
          end
          unless valid_comp?(@criticism_date_comp) then
            @error_msg_hash[:criticism_date] = error_msg('criticism_date', :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # 項目関連チェック
      def related_items_chk?
        check_result = true
        # 抽出条件未入力チェック
        if blank?(@comment) && blank?(@critic_member) && blank?(@criticism_date) then
          @error_msg_hash[:comment]        = error_msg('result_cond', :empty)
          @error_msg_hash[:critic_member]  = error_msg('result_cond', :empty)
          @error_msg_hash[:criticism_date] = error_msg('result_cond', :empty)
          check_result = false
        end
        return check_result
      end
    end
  end
end