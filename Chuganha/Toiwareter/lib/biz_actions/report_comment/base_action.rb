# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメント通報基底アクションクラス
# コントローラー：Comment::ReportController
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/13 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/generic_code_cache'

module BizActions
  module ReportComment
    class BaseAction < BizActions::BusinessAction
      # 結果ステータス
      STATUS_OK = 0
      STATUS_AUTH_ERROR    = 1
      STATUS_QUOTE_ERROR   = 2
      STATUS_COMMENT_ERROR = 3
      STATUS_REPORT_ERROR  = 4
      # リーダー
      attr_reader :status, :partial_name, :comment_id,
                  :report_reason_id, :report_reason_detail,
                  :quote_ent, :source_ent, :comment_ent
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 結果ステータス
        @status = STATUS_OK
        #######################################################################
        # 引用情報
        #######################################################################
        # コメントID
        @comment_id = @params[:comment_id]
        # 引用
        @quote_ent = nil
        # 出所
        @source_ent = nil
        # コメント
        @comment_ent = nil
        # 部分フォーム名
        @partial_name = nil
        # 通報理由ID
        @report_reason_id = @params[:report_reason_id]
        # 通報理由詳細
        @report_reason_detail = @params[:report_reason_detail]
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 対象の単項目チェック
      def target_item_chk?
        check_result = true
        # 引用ID
        if blank?(@comment_id) then
          @status = STATUS_COMMENT_ERROR
          check_result = false
        elsif !numeric?(@comment_id) then
          @status = STATUS_COMMENT_ERROR
          check_result = false
        end
        return check_result
      end
      
      # 対象のDB関連チェック
      def target_db_related_chk?
        check_result = true
        # コメント
        @comment_ent = Comment.find(@comment_id.to_i)
        if blank?(@comment_ent) then
          @status = STATUS_COMMENT_ERROR
          return false
        elsif !valid_auth?(@comment_ent) then
          @status = STATUS_AUTH_ERROR
          return false
        end
        # 引用
        @quote_ent = @comment_ent.quote
        if blank?(@quote_ent) then
          @status = STATUS_QUOTE_ERROR
          check_result = false
        end
        return check_result
      end
      
      # 権限チェック
      def valid_auth?(comment_ent)
        return true if @session[:authority_hash][:comment_report]
        return @session[:member_id] != comment_ent.critic_member_id
      end
      
      # 出所フォーム名判定
      def get_partial_name(source_id)
        code_info = DataCache::GenericCodeCache.instance.code_info(:SOURCE_NAME)
        return code_info.code_hash[source_id.to_s]
      end
    end
  end
end