# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用更新フォーム表示アクションクラス
# コントローラー：Quote::UpdateController
# アクション：form
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_update/base_action'

module BizActions
  module QuoteUpdate
    class FormAction < BizActions::QuoteUpdate::BaseAction
      include BizActions::QuoteSource
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # メッセージフォーム名
        @form_name = 'form'
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 引用検索処理
      def search?
        # バリデーション
        return false unless valid?
        return true unless @quote.nil?
        #######################################################################
        # 引用情報
        #######################################################################
        # 引用文
        @quote   = @quote_ent.quote
        # 発言者
        @speaker = @quote_ent.speaker
        # 発言者肩書きID
        @job_title_id = @quote_ent.speaker_job_title_id.to_s
        # 発言者肩書き
        @job_title    = @quote_ent.speaker_job_title
        # 引用文説明
        @description  = @quote_ent.description
        #######################################################################
        # 出所情報
        #######################################################################
        # 初期値設定
        @source_obj.set_ent_values(@quote_ent.source)
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