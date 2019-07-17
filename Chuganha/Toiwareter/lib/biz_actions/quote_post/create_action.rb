# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿アクションクラス
# コントローラー：Quote::PostController
# アクション：create
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/30 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_post/check_action'
require 'data_cache/member_cache'

module BizActions
  module QuotePost
    class CreateAction < BizActions::QuotePost::CheckAction
      include DataCache
      # リーダー
      attr_reader :quote_id
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 表示フォーム名
        @form_name = 'create'
        @quote_id = nil
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 引用投稿
      def create?
        # トランザクション処理
        ActiveRecord::Base.transaction do
          return false unless valid?
          # 会員情報取得
          member = MemberCache.instance[@session[:member_id]]
          # 引用の登録
          quote_ent = create_quote_ent(member)
          quote_ent.save
          # 出所の登録
          source_ent = @source_obj.edit_ent
          source_ent.source_id = @source_id.to_i
          source_ent.quote_id = quote_ent.id
          source_ent.save
          # コメントの登録
          comment_ent = create_comment_ent(member)
          comment_ent.quote_id = quote_ent.id
          comment_ent.save
          # 引用ID
          @quote_id = quote_ent.id.to_s
          # 権限更新
          @session[:authority_hash] = member.authority_hash
        end
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 引用モデル
      def create_quote_ent(member)
        quote_ent = Quote.new
        quote_ent.quote = @quote
        quote_ent.description = @description
        quote_ent.source_id = @source_id.to_i
        # 発言者情報
        quote_ent.speaker = @speaker
        quote_ent.speaker_job_title_id = @job_title_id
        quote_ent.speaker_job_title = @job_title
        # 最終連番
        quote_ent.last_history_seq_no = 0
        quote_ent.last_comment_seq_no = 1
        # 登録者情報
        quote_ent.registrant_id = member.id
        quote_ent.registered_member_id = member.member_id
        quote_ent.registered_date = DateTime.now
        return quote_ent
      end
      
      # コメントモデル
      def create_comment_ent(member)
        comment_ent = Comment.new
        comment_ent.seq_no = 1
        comment_ent.comment = @comment
        comment_ent.critic_id = member.id
        comment_ent.critic_member_id = member.member_id
        comment_ent.criticism_date = DateTime.now
        return comment_ent
      end
    end
  end
end