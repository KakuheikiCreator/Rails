# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（その他サイト）アクションクラス
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
    class FormOtherSiteAction < BizActions::QuoteSource::SourceBaseAction
      include DataCache
      # リーダー
      attr_reader :site_name, :page_name, :posted_date,
        :posts_by, :job_title_id, :job_title, :quoted_source_url
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'other_site'
        #######################################################################
        # 出所情報
        #######################################################################
        # サイト名
        @site_name   = @params[:site_name]
        # ページ名
        @page_name   = @params[:page_name]
        # 掲載日時
        @posted_date  = date_time_param(:posted_date)
        # 掲載者
        @posts_by     = @params[:posts_by]
        # 掲載者肩書きID
        @job_title_id = @params[:contributor_job_title_id]
        # 掲載者肩書き
        @job_title    = @params[:contributor_job_title]
        # 引用元URL
        @quoted_source_url = @params[:quoted_source_url]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @site_name    = source_ent.site_name
        @page_name    = source_ent.page_name
        @posted_date  = source_ent.posted_date
        @posts_by     = source_ent.posts_by
        @job_title_id = source_ent.job_title_id
        @job_title    = source_ent.job_title
        @quoted_source_url = source_ent.quoted_source_url
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceOtherSite.new
        source_ent.site_name     = @site_name
        source_ent.page_name     = @page_name
        source_ent.posted_date   = @posted_date
        source_ent.posts_by      = @posts_by
        source_ent.job_title_id  = @job_title_id
        source_ent.job_title     = @job_title
        source_ent.quoted_source_url = @quoted_source_url
        return source_ent
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # サイト名
        if blank?(@site_name) then
          @error_msg_hash[:site_name] = error_msg('site_name', :blank)
          check_result = false
        elsif overflow?(@site_name, 60) then
          @error_msg_hash[:site_name] = error_msg('site_name', :too_long, {:count=>60})
          check_result = false
        end
        # ページ名
        if overflow?(@page_name, 60) then
          @error_msg_hash[:page_name] = error_msg('page_name', :too_long, {:count=>60})
          check_result = false
        end
        # 掲載者
        if overflow?(@author, 60) then
          @error_msg_hash[:posts_by] = error_msg('posts_by', :too_long, {:count=>60})
          check_result = false
        end
        # 掲載者肩書きID
        if !blank?(@job_title_id) && !numeric?(@job_title_id) then
          @error_msg_hash[:contributor_job_title] = error_msg('contributor_job_title', :invalid)
          check_result = false
        end
        # 掲載者肩書き
        if overflow?(@job_title, 40) then
          @error_msg_hash[:contributor_job_title] = error_msg('contributor_job_title', :too_long, {:count=>40})
          check_result = false
        end
        # 引用元URL
        if blank?(@quoted_source_url) then
          @error_msg_hash[:quoted_source_url] = error_msg('quoted_source_url', :blank)
          check_result = false
        elsif overflow?(@quoted_source_url, 255) then
          @error_msg_hash[:quoted_source_url] = error_msg('quoted_source_url', :too_long, {:count=>255})
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = true
        # 肩書き
        if !blank?(@job_title_id) && !JobTitleCache.instance.exist?(@job_title_id.to_i) then
          @error_msg_hash[:contributor_job_title] = error_msg('contributor_job_title', :invalid)
          check_result = false
        end
        return check_result
      end
    end
  end
end