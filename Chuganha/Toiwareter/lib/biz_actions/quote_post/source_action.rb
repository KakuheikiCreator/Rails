# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：出所部分フォーム表示アクションクラス
# コントローラー：Quote::PostController
# アクション：source
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_post/base_action'

module BizActions
  module QuotePost
    class SourceAction < BizActions::QuotePost::BaseAction
      # リーダー
      attr_reader :job_title_list, :source_obj
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
        check_result = true
        # 出所ID
        if blank?(@source_id) then
          check_result = true
        elsif !numeric?(@source_id) then
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        # 出所ID存在チェック
        return SourceCache.instance.exist?(@source_id.to_i)
      end
    end
  end
end