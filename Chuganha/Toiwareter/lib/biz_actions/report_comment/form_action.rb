# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメント通報フォーム表示アクションクラス
# コントローラー：Comment::ReportController
# アクション：form
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/13 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/report_comment/base_action'

module BizActions
  module ReportComment
    class FormAction < BizActions::ReportComment::BaseAction
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
      # 検索処理判定
      def search?
        # バリデーション
        return false unless valid?
        # 出所
        @source_ent = @quote_ent.source
        # 部分フォーム名
        @partial_name = get_partial_name(@quote_ent.source_id)
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        return target_item_chk?
      end
      
      # DB関連チェック
      def db_related_chk?
        return target_db_related_chk?
      end
   end
  end
end