# -*- coding: utf-8 -*-
###############################################################################
# 履歴データ生成処理
# 概要：引用またはコメントの履歴生成処理
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/20 Nakanohito
# 更新日:
###############################################################################

module BizCommon
  class BizHistoryOperate
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize(exec_member=nil, reason_id=nil, reason_detail=nil)
      # 実行会員情報
      @exec_member = exec_member
      # 削除理由ID
      @delete_reason_id = reason_id.to_i
      # 削除理由詳細
      @delete_reason_detail = reason_detail
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # 引用履歴生成
    def create_history?(quote_ent)
      return false if quote_ent.nil?
      # 引用履歴
      quote_ent.last_history_seq_no += 1
      history_ent = quote_ent.new_history
      history_ent.seq_no = quote_ent.last_history_seq_no
      delete_flg = can_delete?
      if delete_flg then
        history_ent.delete_reason_id     = @delete_reason_id
        history_ent.delete_reason_detail = @delete_reason_detail
        history_ent.deleted_id           = @exec_member.id
        history_ent.delete_member_id     = @exec_member.member_id
      end
      history_ent.save!
      # 出所履歴
      source_history_ent = quote_ent.source.new_history
      source_history_ent.quote_history_id = history_ent.id
      source_history_ent.save!
      # コメント関係
      return history_ent unless delete_flg
      quote_ent.comment.each do |comment_ent|
        # コメント削除生成
        create_comment_delete(comment_ent, history_ent)
        # コメント削除
        comment_ent.destroy
      end
      # 既存コメント削除データ更新
      update_comment_delete(quote_ent, history_ent)
      return true
    end
    
    # コメント削除処理
    def delete_comment?(comment_ent)
      return false if comment_ent.nil?
      return false unless can_delete?
      return false if comment_ent.quote.comment.size <= 1
      create_comment_delete(comment_ent)
      comment_ent.destroy
      return true
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # 削除条件チェック
    def can_delete?
      return false if @exec_member.nil?
      return false if @delete_reason_id.nil?
      return !@delete_reason_detail.nil?
    end
    
    # コメント削除生成
    def create_comment_delete(comment_ent, history_ent=nil)
      # コメント削除生成
      delete_ent = comment_ent.new_comment_delete
      unless history_ent.nil? then
        delete_ent.quote_id           = nil
        delete_ent.quote_history_id   = history_ent.id
      end
      delete_ent.delete_reason_id     = @delete_reason_id
      delete_ent.delete_reason_detail = @delete_reason_detail
      delete_ent.deleted_id           = @exec_member.id
      delete_ent.delete_member_id     = @exec_member.member_id
      delete_ent.save!
      # コメント通報データの付け替え
      comment_ent.comment_report.each do |report_ent|
        unless history_ent.nil? then
          report_ent.quote_id         = nil
          report_ent.quote_history_id = history_ent.id
        end
        report_ent.comment_id         = nil
        report_ent.comment_delete_id  = delete_ent.id
        report_ent.save!
      end
    end
    
    # 既存コメント削除データ更新
    def update_comment_delete(quote_ent, history_ent)
      # 引用履歴に付け替える
      quote_ent.comment_delete.each do |delete_ent|
        delete_ent.quote_id = nil
        delete_ent.quote_history_id = history_ent.id
        delete_ent.save!
      end
    end
  end
end