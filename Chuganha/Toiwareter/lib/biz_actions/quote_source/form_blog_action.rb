# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（ブログ）アクションクラス
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
    class FormBlogAction < BizActions::QuoteSource::SourceBaseAction
      include DataCache
      # リーダー
      attr_reader :blog_name, :article_title, :posted_by, :job_title_id, :job_title,
                  :posted_date, :quoted_source_url
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'blog'
        #######################################################################
        # 出所情報
        #######################################################################
        # ブログ名
        @blog_name = @params[:blog_name]
        # 記事タイトル
        @article_title = @params[:article_title]
        # 投稿日時
        @posted_date = date_time_param(:posted_date)
        # 投稿者
        @posted_by   = @params[:posted_by]
        # 投稿者肩書きID
        @job_title_id = @params[:contributor_job_title_id]
        # 投稿者肩書き
        @job_title = @params[:contributor_job_title]
        # 引用元URL
        @quoted_source_url = @params[:quoted_source_url]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @blog_name     = source_ent.blog_name
        @article_title = source_ent.article_title
        @posted_date   = source_ent.posted_date
        @posted_by     = source_ent.posted_by
        @job_title_id  = source_ent.job_title_id
        @job_title     = source_ent.job_title
        @quoted_source_url = source_ent.quoted_source_url
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceBlog.new
        source_ent.blog_name = @blog_name
        source_ent.article_title = @article_title
        source_ent.posted_date   = @posted_date
        source_ent.posted_by     = @posted_by
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
        # ブログ名
        if blank?(@blog_name) then
          @error_msg_hash[:blog_name] = error_msg('bbs_name', :blank)
          check_result = false
        elsif overflow?(@blog_name, 60) then
          @error_msg_hash[:blog_name] = error_msg('bbs_name', :too_long, {:count=>60})
          check_result = false
        end
        # 記事タイトル
        if overflow?(@article_title, 80) then
          @error_msg_hash[:article_title] = error_msg('article_title', :too_long, {:count=>80})
          check_result = false
        end
        # 投稿日時
        if blank?(@posted_date) then
          @error_msg_hash[:posted_date] = error_msg('posted_date', :invalid)
          check_result = false
        end
        # 投稿者
        if blank?(@posted_by) then
          @error_msg_hash[:posted_by] = error_msg('posted_by', :blank)
          check_result = false
        elsif overflow?(@posted_by, 60) then
          @error_msg_hash[:posted_by] = error_msg('posted_by', :too_long, {:count=>60})
          check_result = false
        end
        # 投稿者肩書きID
        if !blank?(@job_title_id) && !numeric?(@job_title_id) then
          @error_msg_hash[:contributor_job_title] = error_msg('contributor_job_title', :invalid)
          check_result = false
        end
        # 投稿者肩書き
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
        elsif !valid_uri?(@quoted_source_url) then
          @error_msg_hash[:quoted_source_url] = error_msg('quoted_source_url', :invalid)
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