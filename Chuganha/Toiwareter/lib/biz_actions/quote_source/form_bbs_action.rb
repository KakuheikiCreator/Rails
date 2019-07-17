# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（電子掲示板）アクションクラス
# コントローラー：Quote::
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_source/source_base_action'
require 'common/net_util_module'
require 'data_cache/bbs_cache'

module BizActions
  module QuoteSource
    class FormBbsAction < BizActions::QuoteSource::SourceBaseAction
      include DataCache
      # リーダー
      attr_reader :bbs_id, :bbs_detail_name, :thread_title,
                  :posted_by, :posted_date, :quoted_source_url
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'bbs'
        #######################################################################
        # 出所情報
        #######################################################################
        # 電子掲示板ID
        @bbs_id = @params[:bbs_id]
        # 電子掲示板名
        @bbs_detail_name = @params[:bbs_detail_name]
        # スレッドタイトル
        @thread_title    = @params[:thread_title]
        # 投稿者
        @posted_by   = @params[:posted_by]
        # 投稿日時
        @posted_date = date_time_param(:posted_date)
        # 引用元URL
        @quoted_source_url = @params[:quoted_source_url]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @bbs_id          = source_ent.bbs_id
        @bbs_detail_name = source_ent.bbs_detail_name
        @thread_title    = source_ent.thread_title
        @posted_date     = source_ent.posted_date
        @posted_by       = source_ent.posted_by
        @quoted_source_url = source_ent.quoted_source_url
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceBbs.new
        source_ent.bbs_id = @bbs_id
        source_ent.bbs_detail_name   = @bbs_detail_name
        source_ent.thread_title = @thread_title
        source_ent.posted_date  = @posted_date
        source_ent.posted_by    = @posted_by
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
        # BBSID
        if blank?(@bbs_id) then
          @error_msg_hash[:bbs_name] = error_msg('bbs_name', :blank)
          check_result = false
        elsif !numeric?(@bbs_id) then
          @error_msg_hash[:bbs_name] = error_msg('bbs_name', :invalid)
          check_result = false
        end
        # BBS名
        if overflow?(@bbs_detail_name, 60) then
          @error_msg_hash[:bbs_name] = error_msg('bbs_name', :too_long, {:count=>60})
          check_result = false
        end
        # スレッドタイトル
        if overflow?(@thread_title, 80) then
          @error_msg_hash[:thread_title] = error_msg('thread_title', :invalid)
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
      
      # 項目関連チェック
      def related_items_chk?
        check_result = true
        # BBSIDとBBS名の関連チェック
        if Bbs::ID_OTHER.to_s == @bbs_id && blank?(@bbs_detail_name) then
          @error_msg_hash[:bbs_name] = error_msg('bbs_name', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = true
        # 電子掲示板
        unless BbsCache.instance.exist?(@bbs_id.to_i) then
          @error_msg_hash[:bbs_name] = error_msg('bbs_name', :not_found)
          check_result = false
        end
        return check_result
      end
    end
  end
end