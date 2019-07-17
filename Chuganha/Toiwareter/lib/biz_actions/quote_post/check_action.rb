# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用入力値チェックアクションクラス
# コントローラー：Quote::PostController
# アクション：check
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/30 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_post/base_action'

module BizActions
  module QuotePost
    class CheckAction < BizActions::QuotePost::BaseAction
      include BizCommon
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 表示フォーム名
        @form_name = 'check'
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # バリデーションチェック再定義
      def valid?
        return super() if @source_obj.nil?
        valid_flg_1 = super()
        valid_flg_2 = @source_obj.valid?
        @error_msg_hash.update(@source_obj.error_msg_hash)
        return valid_flg_1 && valid_flg_2
      end
      
      # 類似検索結果リスト
      def similar_list
        return QuoteSearch.instance.similar_search(@quote, @speaker)
      end
      
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 引用項目チェック
        check_result = quote_item_chk?
        return check_result
      end
      
      # 項目関連チェック
      def related_items_chk?
        return true
      end
      
      # DB関連チェック
      def db_related_chk?
        # 引用項目チェック
        check_result = quote_db_related_chk?
        return check_result
      end
    end
  end
end