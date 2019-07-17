# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（動画）アクションクラス
# コントローラー：Quote::
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_source/source_base_action'

module BizActions
  module QuoteSource
    class FormMovieAction < BizActions::QuoteSource::SourceBaseAction
      # リーダー
      attr_reader :title, :production, :sold_by, :release_date_year, :release_date
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'movie'
        #######################################################################
        # 出所情報
        #######################################################################
        # 作品名
        @title = @params[:title]
        # 制作
        @production = @params[:production]
        # 販売元
        @sold_by = @params[:sold_by]
        # 発売日
        @release_date = date_param(:release_date)
        @release_date_year = nil
        @release_date_year = @release_date.year unless @release_date.nil?
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @title        = source_ent.title
        @production   = source_ent.production
        @sold_by      = source_ent.sold_by
        @release_date = source_ent.release_date
        @release_date_year = @release_date.year unless @release_date.nil?
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceMovie.new
        source_ent.title   = @title
        source_ent.production = @production
        source_ent.sold_by = @sold_by
        source_ent.release_date  = @release_date
        return source_ent
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # 作品名
        if blank?(@title) then
          @error_msg_hash[:title] = error_msg('title', :blank)
          check_result = false
        elsif overflow?(@title, 60) then
          @error_msg_hash[:title] = error_msg('title', :too_long, {:count=>60})
          check_result = false
        end
        # 制作
        if blank?(@production) then
          @error_msg_hash[:production] = error_msg('production', :blank)
          check_result = false
        elsif overflow?(@production, 60) then
          @error_msg_hash[:production] = error_msg('production', :too_long, {:count=>60})
          check_result = false
        end
        # 販売元
        if overflow?(@sold_by, 60) then
          @error_msg_hash[:sold_by] = error_msg('sold_by', :too_long, {:count=>60})
          check_result = false
        end
        return check_result
      end
    end
  end
end