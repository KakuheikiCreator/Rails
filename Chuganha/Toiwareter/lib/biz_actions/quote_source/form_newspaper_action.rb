# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（新聞）アクションクラス
# コントローラー：Quote::
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_source/source_base_action'
require 'data_cache/generic_code_cache'
require 'data_cache/job_title_cache'
require 'data_cache/newspaper_cache'

module BizActions
  module QuoteSource
    class FormNewspaperAction < BizActions::QuoteSource::SourceBaseAction
      include DataCache
      # リーダー
      attr_reader :newspaper_list,
        :newspaper_id, :newspaper_detail, :posted_date_year, :posted_date,
        :newspaper_cls, :headline, :reporter, :job_title_id, :job_title
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'newspaper'
        #######################################################################
        # 出所情報
        #######################################################################
        # 新聞ID
        @newspaper_id = @params[:newspaper_id]
        # 新聞詳細名
        @newspaper_detail = @params[:newspaper_detail]
        # 掲載日
        @posted_date = date_param(:posted_date)
        @posted_date_year = nil
        @posted_date_year = @posted_date.year unless @posted_date.nil?
        # 新聞分類
        @newspaper_cls = @params[:newspaper_cls]
        # 記事見出し
        @headline = @params[:headline]
        # 記者
        @reporter = @params[:reporter]
        # 記者肩書きID
        @job_title_id  = @params[:reporter_job_title_id]
        # 記者肩書き
        @job_title     = @params[:reporter_job_title]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @newspaper_id     = source_ent.newspaper_id
        @newspaper_detail = source_ent.newspaper_detail
        @posted_date      = source_ent.posted_date
        @posted_date_year = @posted_date.year
        @newspaper_cls    = source_ent.newspaper_cls
        @headline         = source_ent.headline
        @reporter         = source_ent.reporter
        @job_title_id     = source_ent.job_title_id
        @job_title        = source_ent.job_title
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceNewspaper.new
        source_ent.newspaper_id     = @newspaper_id
        source_ent.newspaper_detail = @newspaper_detail
        source_ent.posted_date      = @posted_date
        source_ent.newspaper_cls    = @newspaper_cls
        source_ent.headline         = @headline
        source_ent.reporter         = @reporter
        source_ent.job_title_id     = @job_title_id
        source_ent.job_title        = @job_title
        return source_ent
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # 新聞ID
        if blank?(@newspaper_id) then
          @error_msg_hash[:newspaper] = error_msg('newspaper', :blank)
          check_result = false
        elsif !numeric?(@newspaper_id) then
          @error_msg_hash[:newspaper] = error_msg('newspaper', :invalid)
          check_result = false
        end
        # 新聞詳細名
        if overflow?(@newspaper_detail, 60) then
          @error_msg_hash[:newspaper] = error_msg('newspaper', :too_long, {:count=>60})
          check_result = false
        end
        # 掲載日
        if blank?(@posted_date) then
          @error_msg_hash[:edition] = error_msg('posted_date', :invalid)
          check_result = false
        end
        # 新聞分類
        if blank?(@newspaper_cls) then
          @error_msg_hash[:edition] = error_msg('newspaper_cls', :invalid)
          check_result = false
        else
          values = GenericCodeCache.instance.code_values(:NEWSPAPER_CLS)
          unless values.include?(@newspaper_cls) then
            @error_msg_hash[:edition] = error_msg('newspaper_cls', :invalid)
            check_result = false
          end
        end
        # 記事見出し
        if blank?(@headline) then
          @error_msg_hash[:headline] = error_msg('headline', :blank)
          check_result = false
        elsif overflow?(@headline, 80) then
          @error_msg_hash[:headline] = error_msg('headline', :too_long, {:count=>80})
          check_result = false
        end
        # 記者
        if overflow?(@reporter, 60) then
          @error_msg_hash[:reporter] = error_msg('reporter', :too_long, {:count=>60})
          check_result = false
        end
        # 記者肩書きID
        if !blank?(@job_title_id) && !numeric?(@job_title_id) then
          @error_msg_hash[:reporter_job_title] = error_msg('job_title', :invalid)
          check_result = false
        end
        # 記者肩書き
        if overflow?(@job_title, 40) then
          @error_msg_hash[:reporter_job_title] = error_msg('job_title', :too_long, {:count=>40})
          check_result = false
        end
        return check_result
      end
      
      # 項目関連チェック
      def related_items_chk?
        check_result = true
        if Newspaper::ID_OTHER.to_s == @newspaper_id && blank?(@newspaper_detail) then
          @error_msg_hash[:newspaper] = error_msg('newspaper', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = true
        # 新聞
        unless NewspaperCache.instance.exist?(@newspaper_id.to_i) then
          @error_msg_hash[:newspaper] = error_msg('newspaper', :not_found)
          check_result = false
        end
        # 肩書き
        if !blank?(@job_title_id) && !JobTitleCache.instance.exist?(@job_title_id.to_i) then
          @error_msg_hash[:reporter_job_title] = error_msg('job_title', :invalid)
          check_result = false
        end
        return check_result
      rescue StandardError => ex
        return false
      end
    end
  end
end