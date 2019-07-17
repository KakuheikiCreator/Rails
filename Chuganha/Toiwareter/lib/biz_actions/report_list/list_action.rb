# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：コメント通報リストアクションクラス
# コントローラー：Report::ListController
# アクション：list
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/27 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/report_list/base_action'

module BizActions
  module ReportList
    class ListAction < BizActions::ReportList::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
    end
  end
end