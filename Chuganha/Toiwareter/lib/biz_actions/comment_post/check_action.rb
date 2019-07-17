# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメントチェックアクションクラス
# コントローラー：Comment::PostController
# アクション：check
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/11 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'biz_common/business_config'
require 'biz_search/quote_search'
require 'data_cache/generic_code_cache'
require 'data_cache/member_cache'
require 'data_cache/ng_word_cache'

module BizActions
  module CommentPost
    class CheckAction < BizActions::BusinessAction
      include BizCommon
      include DataCache
      # 結果ステータス
      STATUS_OK = 0
      STATUS_QUOTE_ERROR = 1
      STATUS_COMMENT_ERROR = 2
      # リーダー
      attr_reader :result_status, :quote_id, :comment, :partial_name,
                  :member_ent, :quote_ent, :source_ent
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 結果ステータス
        @result_status = STATUS_OK
        #######################################################################
        # 投稿者情報
        #######################################################################
        # 会員情報取得
        @member_ent = MemberCache.instance[@session[:member_id]]
        
        #######################################################################
        # 引用情報
        #######################################################################
        # 引用ID
        @quote_id = @params[:quote_id]
        # 引用
        @quote_ent = nil
        # 出所
        @source_ent = nil
        # 部分フォーム名
        @partial_name = nil
        
        #######################################################################
        # コメント情報
        #######################################################################
        # 最大コメント件数
        @max_comment_cnt = BusinessConfig.instance[:max_comments_size].to_i
        # コメント
        @comment = NgWordCache.instance.replacement(@params[:comment])
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # コメントチェック処理
      def check?
        # バリデーション
        return false unless valid?
        # 出所
        @source_ent = @quote_ent.source
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
          @result_status = STATUS_QUOTE_ERROR
          check_result = false
        elsif !numeric?(@quote_id) then
          @result_status = STATUS_QUOTE_ERROR
          check_result = false
        end
        # コメント
        if blank?(@comment) then
          @error_msg_hash[:comment] = error_msg('comment', :blank)
          @result_status = STATUS_COMMENT_ERROR
          check_result = false
        elsif overflow?(@comment, 4000) then
          @error_msg_hash[:comment] = error_msg('comment', :too_long, {:count=>4000})
          @result_status = STATUS_COMMENT_ERROR
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
          @result_status = STATUS_QUOTE_ERROR
          return false
        elsif @quote_ent.last_comment_seq_no >= @max_comment_cnt then
          @result_status = STATUS_QUOTE_ERROR
          check_result = false
        end
        return check_result
      end
       
      # 出所フォーム名判定
      def get_partial_name(source_id)
        code_info = DataCache::GenericCodeCache.instance.code_info(:SOURCE_NAME)
        return code_info.code_hash[source_id.to_s]
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text('check.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end