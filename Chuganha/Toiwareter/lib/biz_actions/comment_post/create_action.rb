# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメント投稿アクションクラス
# コントローラー：Comment::PostController
# アクション：create
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/11 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/comment_post/check_action'
require 'biz_search/quote_search'

module BizActions
  module CommentPost
    class CreateAction < BizActions::CommentPost::CheckAction
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
      # コメント投稿処理
      def create?
        ActiveRecord::Base.transaction do
          # バリデーション
          return false unless valid?
          # 引用更新
          @quote_ent.last_comment_seq_no += 1
          @quote_ent.save!
          # コメント登録
          create_comment_ent.save!
          # 権限更新
          @session[:authority_hash] = @member_ent.authority_hash
        end
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # コメントモデル生成
      def create_comment_ent
        comment_ent = Comment.new
        comment_ent.quote_id = @quote_ent.id
        comment_ent.seq_no = @quote_ent.last_comment_seq_no
        comment_ent.comment = @comment
        comment_ent.critic_id = @member_ent.id
        comment_ent.critic_member_id = @member_ent.member_id
        comment_ent.criticism_date = DateTime.now
        return comment_ent
      end
    end
  end
end