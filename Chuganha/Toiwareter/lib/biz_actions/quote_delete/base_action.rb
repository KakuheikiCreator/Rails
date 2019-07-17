# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用削除基底アクションクラス
# コントローラー：Quote::DeleteController
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/24 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/generic_code_cache'

module BizActions
  module QuoteDelete
    class BaseAction < BizActions::BusinessAction
      # 結果ステータス
      STATUS_OK = 0
      STATUS_AUTH_ERROR    = 1
      STATUS_QUOTE_ERROR   = 2
      STATUS_DELETE_ERROR  = 3
      # リーダー
      attr_reader :status, :partial_name, :quote_id,
                  :delete_reason_id, :delete_reason_detail,
                  :quote_ent, :source_ent
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 結果ステータス
        @status = nil
        #######################################################################
        # 引用情報
        #######################################################################
        # 引用ID
        @quote_id = @params[:quote_id]
        # 引用
        @quote_ent  = nil
        # 出所
        @source_ent = nil
        # 部分フォーム名
        @partial_name = nil
        # 削除理由ID
        @delete_reason_id = @params[:delete_reason_id]
        # 削除理由詳細
        @delete_reason_detail = @params[:delete_reason_detail]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 受信情報チェック
      def valid?
        # 結果ステータス
        @valid_flg = super()
        @status ||= STATUS_OK
        return @valid_flg
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 対象の単項目チェック
      def target_item_chk?
        check_result = true
        # 引用ID
        if blank?(@quote_id) then
          @status ||= STATUS_QUOTE_ERROR
          check_result = false
        elsif !numeric?(@quote_id) then
          @status ||= STATUS_QUOTE_ERROR
          check_result = false
        end
        return check_result
      end
      
      # 対象のDB関連チェック
      def target_db_related_chk?
        check_result = true
        # 引用
        @quote_ent = Quote.find(@quote_id.to_i)
        if blank?(@quote_ent) then
          @status ||= STATUS_QUOTE_ERROR
          check_result = false
        elsif !valid_auth?(@quote_ent) then
          @status ||= STATUS_AUTH_ERROR
          check_result = false
        else
          # 出所
          @source_ent = @quote_ent.source
          # 部分フォーム名
          @partial_name = get_partial_name(@quote_ent.source_id)
        end
        return check_result
      end
      
      # 権限チェック
      def valid_auth?(quote_ent)
        return true if @session[:authority_hash][:quote_delete]
        return @session[:member_id] == quote_ent.registered_member_id
      end
      
      # 出所フォーム名判定
      def get_partial_name(source_id)
        code_info = DataCache::GenericCodeCache.instance.code_info(:SOURCE_NAME)
        return code_info.code_hash[source_id.to_s]
      end
    end
  end
end