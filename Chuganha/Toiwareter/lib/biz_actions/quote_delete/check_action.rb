# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用削除チェックアクションクラス
# コントローラー：Quote::DeleteController
# アクション：check
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/24 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_delete/base_action'
require 'data_cache/report_reason_cache'

module BizActions
  module QuoteDelete
    class CheckAction < BizActions::QuoteDelete::BaseAction
      include DataCache
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = target_item_chk?
        # 削除理由ID
        if blank?(@delete_reason_id) then
          @error_msg_hash[:delete_reason_id] = error_msg('delete_reason_id', :blank)
          @status ||= STATUS_DELETE_ERROR
          check_result = false
        elsif !numeric?(@delete_reason_id) then
          @error_msg_hash[:delete_reason_id] = error_msg('delete_reason_id', :invalid)
          @status ||= STATUS_DELETE_ERROR
          check_result = false
        end
        # 削除理由詳細
        if blank?(@delete_reason_detail) then
          @error_msg_hash[:delete_reason_detail] = error_msg('detailed_reason', :blank)
          @status ||= STATUS_DELETE_ERROR
          check_result = false
        elsif overflow?(@delete_reason_detail, 2000) then
          @error_msg_hash[:delete_reason_detail] = error_msg('detailed_reason', :too_long, {:count=>2000})
          @status ||= STATUS_DELETE_ERROR
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = target_db_related_chk?
        # 削除理由IDの存在チェック
        unless DeleteReasonCache.instance.exist?(@delete_reason_id.to_i) then
          @error_msg_hash[:delete_reason_id] = error_msg('delete_reason_id', :invalid)
          @status ||= STATUS_DELETE_ERROR
          check_result = false
        end
        return check_result
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text('check.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end