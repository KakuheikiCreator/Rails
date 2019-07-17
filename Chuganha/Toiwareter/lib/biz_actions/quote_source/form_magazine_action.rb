# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（雑誌）アクションクラス
# コントローラー：Quote::
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_source/source_base_action'
require 'biz_common/biz_validation_module'
require 'data_cache/job_title_cache'

module BizActions
  module QuoteSource
    class FormMagazineAction < BizActions::QuoteSource::SourceBaseAction
      include BizCommon::BizValidationModule
      include DataCache
      # リーダー
      attr_reader :magazine_cd, :magazine_name, :article_title,
                  :publisher, :release_date_year, :release_date,
                  :reporter, :job_title_id, :job_title
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'magazine'
        #######################################################################
        # 出所情報
        #######################################################################
        # 雑誌コード
        @magazine_cd = @params[:magazine_cd]
        # 雑誌名
        @magazine_name = @params[:magazine_name]
        # 記事タイトル
        @article_title = @params[:article_title]
        # 出版社
        @publisher = @params[:publisher]
        # 発売日
        @release_date = date_param(:release_date)
        @release_date_year = nil
        @release_date_year = @release_date.year unless @release_date.nil?
        # 記者
        @reporter = @params[:reporter]
        # 記者肩書きID
        @job_title_id = @params[:reporter_job_title_id]
        # 記者肩書き
        @job_title = @params[:reporter_job_title]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @magazine_cd   = source_ent.magazine_cd
        @magazine_name = source_ent.magazine_name
        @article_title = source_ent.article_title
        @publisher     = source_ent.publisher
        @release_date  = source_ent.release_date
        @release_date_year = @release_date.year
        @reporter      = source_ent.reporter
        @job_title_id  = source_ent.job_title_id
        @job_title     = source_ent.job_title
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceMagazine.new
        source_ent.magazine_cd   = @magazine_cd
        source_ent.magazine_name = @magazine_name
        source_ent.article_title = @article_title
        source_ent.publisher     = @publisher
        source_ent.release_date  = @release_date
        source_ent.reporter      = @reporter
        source_ent.job_title_id  = @job_title_id
        source_ent.job_title     = @job_title
        return source_ent
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # 雑誌コード
        if !blank?(@magazine_cd) && !magazine_cd?(@magazine_cd) then
          @error_msg_hash[:magazine_cd] = error_msg('magazine_cd', :invalid)
          check_result = false
        end
        # 雑誌名
        if blank?(@magazine_name) then
          @error_msg_hash[:magazine_name] = error_msg('magazine_name', :blank)
          check_result = false
        elsif overflow?(@book_title, 60) then
          @error_msg_hash[:magazine_name] = error_msg('magazine_name', :too_long, {:count=>60})
          check_result = false
        end
        # 記事タイトル
        if overflow?(@article_title, 80) then
          @error_msg_hash[:article_title] = error_msg('article_title', :too_long, {:count=>80})
          check_result = false
        end
        # 出版社
        if overflow?(@publisher, 60) then
          @error_msg_hash[:publisher] = error_msg('publisher', :too_long, {:count=>60})
          check_result = false
        end
        # 発売日
        if blank?(@release_date) then
          @error_msg_hash[:release_date] = error_msg('release_date', :invalid)
          check_result = false
        end
        # 記者
        if overflow?(@reporter, 60) then
          @error_msg_hash[:reporter] = error_msg('reporter', :too_long, {:count=>60})
          check_result = false
        end
        # 記者肩書きID
        if !blank?(@job_title_id) && !numeric?(@job_title_id) then
          @error_msg_hash[:reporter_job_title] = error_msg('reporter_job_title', :invalid)
          check_result = false
        end
        # 記者肩書き
        if overflow?(@job_title, 40) then
          @error_msg_hash[:reporter_job_title] = error_msg('reporter_job_title', :too_long, {:count=>40})
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = true
        # 肩書き
        if !blank?(@job_title_id) && !JobTitleCache.instance.exist?(@job_title_id.to_i) then
          @error_msg_hash[:reporter_job_title] = error_msg('reporter_job_title', :invalid)
          check_result = false
        end
        return check_result
      end
    end
  end
end