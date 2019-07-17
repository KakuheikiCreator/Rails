# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（書籍）アクションクラス
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
    class FormBookAction < BizActions::QuoteSource::SourceBaseAction
      include BizCommon::BizValidationModule
      include DataCache
      # リーダー
      attr_reader :isbn, :book_title, :publisher,
                  :release_date_year, :release_date,
                  :author, :job_title_id, :job_title
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'book'
        #######################################################################
        # 出所情報
        #######################################################################
        # ISBNコード
        @isbn = @params[:isbn]
        # 書籍名
        @book_title = @params[:book_title]
        # 出版社
        @publisher = @params[:publisher]
        # 発売日
        @release_date = date_param(:release_date)
        @release_date_year = nil
        @release_date_year = @release_date.year unless @release_date.nil?
        # 著者
        @author = @params[:author]
        # 著者肩書きID
        @job_title_id = @params[:author_job_title_id]
        # 著者肩書き
        @job_title = @params[:author_job_title]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @isbn         = source_ent.isbn
        @book_title   = source_ent.book_title
        @publisher    = source_ent.publisher
        @release_date = source_ent.release_date
        @release_date_year = @release_date.year unless @release_date.nil?
        @author       = source_ent.author
        @job_title_id = source_ent.job_title_id
        @job_title    = source_ent.job_title
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceBook.new
        source_ent.isbn = @isbn
        source_ent.book_title = @book_title
        source_ent.publisher  = @publisher
        source_ent.release_date  = @release_date
        source_ent.author     = @author
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
        # ISBN
        if !blank?(@isbn) && !isbn?(@isbn) then
          @error_msg_hash[:isbn] = error_msg('isbn', :invalid)
          check_result = false
        end
        # 書籍名
        if blank?(@book_title) then
          @error_msg_hash[:book_title] = error_msg('book_title', :blank)
          check_result = false
        elsif overflow?(@book_title, 60) then
          @error_msg_hash[:book_title] = error_msg('book_title', :too_long, {:count=>60})
          check_result = false
        end
        # 出版社
        if overflow?(@publisher, 60) then
          @error_msg_hash[:publisher] = error_msg('publisher', :too_long, {:count=>60})
          check_result = false
        end
        # 著者
        if blank?(@author) then
          @error_msg_hash[:author] = error_msg('author', :blank)
          check_result = false
        elsif overflow?(@author, 60) then
          @error_msg_hash[:author] = error_msg('author', :too_long, {:count=>60})
          check_result = false
        end
        # 著者肩書きID
        if !blank?(@job_title_id) && !numeric?(@job_title_id) then
          @error_msg_hash[:author_job_title] = error_msg('author_job_title', :invalid)
          check_result = false
        end
        # 著者肩書き
        if overflow?(@job_title, 40) then
          @error_msg_hash[:author_job_title] = error_msg('author_job_title', :too_long, {:count=>40})
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