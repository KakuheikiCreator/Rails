# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメント削除アクションクラス
# コントローラー：Comment::DeleteController
# アクション：delete
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/18 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/delete_comment/check_action'
require 'biz_common/biz_history_operate'
require 'data_cache/member_cache'

module BizActions
  module DeleteComment
    class DeleteAction < BizActions::DeleteComment::CheckAction
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
          if @quote_ent.comment.size <= 1 then
            @status = STATUS_QUOTE_DELETE
            return_flg = operate.create_history?(@quote_ent)
            @quote_ent.destroy
          else
            return_flg = operate.delete_comment?(comment_ent)
          end
          # 権限更新
          @session[:authority_hash] = member_ent.authority_hash
        end
        return return_flg
      end
    end
  end
end