# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメント通報チェックアクションクラス
# コントローラー：Comment::ReportController
# アクション：check
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/14 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/report_comment/base_action'
require 'data_cache/report_reason_cache'

module BizActions
  module ReportComment
    class CheckAction < BizActions::ReportComment::BaseAction
      include DataCache
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # チェック処理
      def check?
        # バリデーションチェック
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
        check_result = target_item_chk?
        # 通報理由ID
        if blank?(@report_reason_id) then
          @error_msg_hash[:report_reason_id] = error_msg('report_reason_id', :blank)
          @status = STATUS_REPORT_ERROR
          check_result = false
        elsif !numeric?(@report_reason_id) then
          @error_msg_hash[:report_reason_id] = error_msg('report_reason_id', :invalid)
          @status = STATUS_REPORT_ERROR
          check_result = false
        end
        # 通報理由詳細
        if blank?(@report_reason_detail) then
          @error_msg_hash[:report_reason_detail] = error_msg('report_reason_detail', :blank)
          @status = STATUS_REPORT_ERROR
          check_result = false
        elsif overflow?(@report_reason_detail, 4000) then
          @error_msg_hash[:report_reason_detail] = error_msg('report_reason_detail', :too_long, {:count=>4000})
          @status = STATUS_REPORT_ERROR
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = target_db_related_chk?
        # 通報理由IDの存在チェック
        unless ReportReasonCache.instance.exist?(@report_reason_id.to_i) then
          @error_msg_hash[:report_reason_id] = error_msg('report_reason_id', :invalid)
          @status = STATUS_REPORT_ERROR
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