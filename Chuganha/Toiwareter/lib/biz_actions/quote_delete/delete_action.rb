# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用削除アクションクラス
# コントローラー：Comment::DeleteController
# アクション：delete
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/24 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_delete/check_action'
require 'biz_common/biz_history_operate'
require 'data_cache/member_cache'

module BizActions
  module QuoteDelete
    class DeleteAction < BizActions::QuoteDelete::CheckAction
      include BizCommon
      include DataCache
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
      # 削除処理
      def delete?
        return_flg = false
        ActiveRecord::Base.transaction do
          # バリデーションチェック
          return return_flg unless valid?
          # 削除処理
          member_ent = MemberCache.instance[@session[:member_id]]
          operate = BizHistoryOperate.new(member_ent, @delete_reason_id, @delete_reason_detail)
          return_flg = operate.create_history?(@quote_ent)
          @quote_ent.destroy
          # 権限更新
          @session[:authority_hash] = member_ent.authority_hash
        end
        return return_flg
      end
    end
  end
end