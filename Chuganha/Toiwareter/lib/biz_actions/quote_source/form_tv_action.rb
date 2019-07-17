# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（テレビ）アクションクラス
# コントローラー：Quote::
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_source/source_base_action'

module BizActions
  module QuoteSource
    class FormTvAction < BizActions::QuoteSource::SourceBaseAction
      # リーダー
      attr_reader :program_name, :production, :tv_station,
                  :broadcast_date_year, :broadcast_date
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'tv'
        #######################################################################
        # 出所情報
        #######################################################################
        # 番組名
        @program_name = @params[:program_name]
        # 放送日時
        @broadcast_date_year = @params[:broadcast_date_year]
        @broadcast_date = date_time_param(:broadcast_date)
        # 制作局
        @production = @params[:production]
        # 放送局
        @tv_station = @params[:tv_station]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @program_name   = source_ent.program_name
        @broadcast_date = source_ent.broadcast_date
        @production     = source_ent.production
        @tv_station     = source_ent.tv_station
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceTv.new
        source_ent.program_name   = @program_name
        source_ent.broadcast_date = @broadcast_date
        source_ent.production     = @production
        source_ent.tv_station     = @tv_station
        return source_ent
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # 番組名
        if blank?(@program_name) then
          @error_msg_hash[:program_name] = error_msg('program_name', :blank)
          check_result = false
        elsif overflow?(@program_name, 60) then
          @error_msg_hash[:program_name] = error_msg('program_name', :too_long, {:count=>60})
          check_result = false
        end
        # 放送日時
        if blank?(@broadcast_date) then
          @error_msg_hash[:broadcast_date] = error_msg('broadcast_date', :invalid)
          check_result = false
        end
        # 制作局
        if overflow?(@production, 60) then
          @error_msg_hash[:publisher] = error_msg('production', :too_long, {:count=>60})
          check_result = false
        end
        # 放送局
        if blank?(@tv_station) then
          @error_msg_hash[:tv_station] = error_msg('tv_station', :blank)
          check_result = false
        elsif overflow?(@tv_station, 60) then
          @error_msg_hash[:tv_station] = error_msg('tv_station', :too_long, {:count=>60})
          check_result = false
        end
        return check_result
      end
    end
  end
end