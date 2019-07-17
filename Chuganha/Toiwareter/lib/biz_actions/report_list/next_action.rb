# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメント通報リスト改ページアクションクラス
# コントローラー：Report::ListController
# アクション：next
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/03/02 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/report_list/search_action'

module BizActions
  module ReportList
    class NextAction < BizActions::ReportList::SearchAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @search_page_num = (@page_num.to_i + 1).to_s
      end
    end
  end
end