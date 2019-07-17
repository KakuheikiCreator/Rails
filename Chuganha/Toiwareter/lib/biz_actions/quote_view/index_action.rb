# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム基底アクションクラス
# コントローラー：Quote::PostController
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/23 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'biz_common/business_config'
require 'biz_search/comment_search'
require 'data_cache/generic_code_cache'

module BizActions
  module QuoteView
    class IndexAction < BizActions::BusinessAction
      include BizCommon
      include BizSearch
      # リーダー
      attr_reader :login_flg, :comment_flg, :partial_name, :comment, :comment_err_msg,
                  :quote_ent, :source_ent, :comment_list
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 最大コメント件数
        @max_comment_cnt = BusinessConfig.instance[:max_comments_size].to_i
        # ログイン状態
        @login_flg = login_user?
        # コメント投稿フラグ
        @comment_flg = false
        
        #######################################################################
        # 引用情報
        #######################################################################
        # 引用ID
        @quote_id = @params[:quote_id]
        # 引用
        @quote_ent = nil
        # 出所
        @source_ent = nil
        # 投稿されたコメント
        @comment_list = nil
        # 部分フォーム名
        @partial_name = nil
        # 投稿するコメント
        @comment = @params[:comment]
        # コメントエラーメッセージ
        @comment_err_msg = @params[:comment_err_msg]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 引用検索処理
      def search?
        # バリデーション
        return false unless valid?
        # 出所
        @source_ent = @quote_ent.source
        # コメント
        @comment_list = CommentSearch.instance.quote_comment(@quote_ent.id)
        @comment_flg = @comment_list.size < @max_comment_cnt
        # 部分フォーム名
        @partial_name = get_partial_name(@quote_ent.source_id)
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # 引用ID
        if blank?(@quote_id) then
          check_result = false
        elsif !numeric?(@quote_id.to_s) then
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = true
        # 引用
        @quote_ent = Quote.find(@quote_id.to_i)
        if blank?(@quote_ent) then
          check_result = false
        end
        return check_result
      end
      
      # ログイン済み判定
      def login_user?
        return false if @session[:member_id].nil?
        return true if @request.request_method == 'POST'
        return @request.flash[:redirect_flg] == true
      end
      
      # 出所フォーム名判定
      def get_partial_name(source_id)
        code_info = DataCache::GenericCodeCache.instance.code_info(:SOURCE_NAME)
        return code_info.code_hash[source_id.to_s]
      end
    end
  end
end