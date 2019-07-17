# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（ニュースサイト）アクションクラス
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
    class FormNewsSiteAction < BizActions::QuoteSource::SourceBaseAction
      include DataCache
      # リーダー
      attr_reader :bbs_list,
        :site_name, :article_title, :posted_date,
        :reporter, :job_title_id, :job_title, :quoted_source_url
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'news_site'
        #######################################################################
        # 出所情報
        #######################################################################
        # サイト名
        @site_name   = @params[:site_name]
        # 記事タイトル
        @article_title = @params[:article_title]
        # 掲載日時
        @posted_date   = date_time_param(:posted_date)
        # 記者
        @reporter      = @params[:reporter]
        # 記者肩書きID
        @job_title_id  = @params[:reporter_job_title_id]
        # 記者肩書き
        @job_title     = @params[:reporter_job_title]
        # 引用元URL
        @quoted_source_url = @params[:quoted_source_url]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @site_name     = source_ent.site_name
        @article_title = source_ent.article_title
        @posted_date   = source_ent.posted_date
        @reporter      = source_ent.reporter
        @job_title_id  = source_ent.job_title_id
        @job_title     = source_ent.job_title
        @quoted_source_url = source_ent.quoted_source_url
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceNewsSite.new
        source_ent.site_name     = @site_name
        source_ent.article_title = @article_title
        source_ent.posted_date   = @posted_date
        source_ent.reporter      = @reporter
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
        # 記事タイトル
        if blank?(@article_title) then
          @error_msg_hash[:article_title] = error_msg('article_title', :blank)
          check_result = false
        elsif overflow?(@article_title, 60) then
          @error_msg_hash[:article_title] = error_msg('article_title', :too_long, {:count=>60})
          check_result = false
        end
        # 掲載日時
        if blank?(@posted_date) then
          @error_msg_hash[:posted_date] = error_msg('posted_date', :invalid)
          check_result = false
        end
        # 記者
        if overflow?(@publisher, 60) then
          @error_msg_hash[:reporter] = error_msg('reporter', :too_long, {:count=>60})
          check_result = false
        end
        # 著者肩書きID
        if !blank?(@job_title_id) && !numeric?(@job_title_id) then
          @error_msg_hash[:reporter_job_title] = error_msg('reporter_job_title', :invalid)
          check_result = false
        end
        # 著者肩書き
        if overflow?(@job_title, 40) then
          @error_msg_hash[:reporter_job_title] = error_msg('reporter_job_title', :too_long, {:count=>40})
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
          @error_msg_hash[:author_job_title] = error_msg('author_job_title', :invalid)
          check_result = false
        end
        return check_result
      end
    end
  end
end