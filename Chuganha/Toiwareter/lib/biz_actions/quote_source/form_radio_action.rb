# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（ラジオ）アクションクラス
# コントローラー：Quote::
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_source/source_base_action'
require 'data_cache/job_title_cache'

module BizActions
  module QuoteSource
    class FormRadioAction < BizActions::QuoteSource::SourceBaseAction
      include DataCache
      # リーダー
      attr_reader :program_name, :production, :radio_station,
                  :broadcast_date_year, :broadcast_date
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'radio'
        #######################################################################
        # 出所情報
        #######################################################################
        # 番組名
        @program_name = @params[:program_name]
        # 放送日時
        @broadcast_date = date_time_param(:broadcast_date)
        @broadcast_date_year = nil
        @broadcast_date_year = @broadcast_date.year unless @broadcast_date.nil?
        # 制作局
        @production = @params[:production]
        # 放送局
        @radio_station = @params[:radio_station]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @program_name   = source_ent.program_name
        @broadcast_date = source_ent.broadcast_date
        @broadcast_date_year = @broadcast_date.year unless @broadcast_date.nil?
        @production     = source_ent.production
        @radio_station  = source_ent.radio_station
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceRadio.new
        source_ent.program_name   = @program_name
        source_ent.broadcast_date = @broadcast_date
        source_ent.production     = @production
        source_ent.radio_station  = @radio_station
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
        elsif overflow?(@book_title, 60) then
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
          @error_msg_hash[:production] = error_msg('production', :too_long, {:count=>60})
          check_result = false
        end
        # 放送局
        if blank?(@radio_station) then
          @error_msg_hash[:radio_station] = error_msg('radio_station', :blank)
          check_result = false
        elsif overflow?(@radio_station, 60) then
          @error_msg_hash[:radio_station] = error_msg('radio_station', :too_long, {:count=>60})
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = true
        # 肩書き
        if !blank?(@job_title_id) && !JobTitleCache.instance.exist?(@job_title_id.to_i) then
          @error_msg_hash[:author_job_title] = error_msg('author_job_title', :invalid)
          check_result = false
        end
        return check_result
      end
    end
  end
end