# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（その他）アクションクラス
# コントローラー：Quote::PostController
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/27 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_source/source_base_action'

module BizActions
  module QuoteSource
    class FormOtherAction < BizActions::QuoteSource::SourceBaseAction
      # リーダー
      attr_reader :media_name
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'other'
        #######################################################################
        # 出所情報
        #######################################################################
        # メディア名
        @media_name = @params[:media_name]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @media_name = source_ent.media_name
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceOther.new
        source_ent.media_name = @media_name
        return source_ent
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # メディア名
        if blank?(@media_name) then
          @error_msg_hash[:media_name] = error_msg('media_name', :blank)
          check_result = false
        elsif overflow?(@media_name, 60) then
          @error_msg_hash[:media_name] = error_msg('media_name', :too_long, {:count=>60})
          check_result = false
        end
        return check_result
      end
    end
  end
end