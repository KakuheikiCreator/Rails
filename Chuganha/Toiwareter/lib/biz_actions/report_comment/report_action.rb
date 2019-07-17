# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメント通報アクションクラス
# コントローラー：Comment::ReportController
# アクション：report
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/16 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/report_comment/check_action'
require 'data_cache/member_cache'

module BizActions
  module ReportComment
    class ReportAction < BizActions::ReportComment::CheckAction
      include DataCache
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 会員情報取得
        @member_ent = MemberCache.instance[@session[:member_id]]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 通報処理
      def report?
        ActiveRecord::Base.transaction do
          # バリデーションチェック
          return false unless valid?
          # 出所
          @source_ent = @quote_ent.source
          # 部分フォーム名
          @partial_name = get_partial_name(@quote_ent.source_id)
          # 通報データ登録
          create_report.save!
          # 権限更新
          @session[:authority_hash] = @member_ent.authority_hash
        end
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 通報データ生成
      def create_report
        ent = CommentReport.new
        ent.quote_id = @quote_ent.id
        ent.comment_id = @comment_ent.id
        ent.seq_no = @comment_ent.seq_no
        ent.report_reason_id = @report_reason_id.to_i
        ent.report_reason_detail = @report_reason_detail
        ent.whistleblower_id = @member_ent.id
        ent.report_member_id = @member_ent.member_id
        ent.report_date = DateTime.now
        return ent
      end
    end
  end
end