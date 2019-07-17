# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用更新アクションクラス
# コントローラー：Quote::UpdateController
# アクション：update
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_update/check_action'
require 'biz_common/biz_history_operate'
require 'data_cache/member_cache'

module BizActions
  module QuoteUpdate
    class UpdateAction < BizActions::QuoteUpdate::CheckAction
      include BizCommon
      include DataCache
      # リーダー
      attr_reader :quote_id
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # メッセージフォーム名
        @form_name = 'check'
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 引用更新
      def update?
        # トランザクション処理
        ActiveRecord::Base.transaction do
          return false unless valid?
          # 履歴生成処理
          operate = BizHistoryOperate.new
          operate.create_history?(@quote_ent)
          # 会員情報取得
          member = MemberCache.instance[@session[:member_id]]
          # 引用の更新
          edit_quote_ent(member, @quote_ent).save!
          # 出所の更新
          @source_obj.edit_ent(@quote_ent.source).save!
          # 権限更新
          @session[:authority_hash] = member.authority_hash
        end
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 引用モデル編集
      def edit_quote_ent(member, quote_ent)
        # 引用文
        quote_ent.quote = @quote
        # 発言者
        quote_ent.speaker = @speaker
        # 発言者肩書きID
        quote_ent.speaker_job_title_id = @job_title_id.to_i
        # 発言者肩書き
        quote_ent.speaker_job_title = @job_title
        # 引用文説明
        quote_ent.description = @description
        # 更新者ID
        quote_ent.update_id = member.id
        # 更新会員ID
        quote_ent.update_member_id = member.member_id
        # 更新日時
        quote_ent.update_date = DateTime.now
        return quote_ent
      end
    end
  end
end