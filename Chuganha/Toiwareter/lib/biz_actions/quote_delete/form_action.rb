# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用削除フォーム表示アクションクラス
# コントローラー：Quote::DeleteController
# アクション：delete
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/24 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_delete/base_action'

module BizActions
  module QuoteDelete
    class FormAction < BizActions::QuoteDelete::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
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