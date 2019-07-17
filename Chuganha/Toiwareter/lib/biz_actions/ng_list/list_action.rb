# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：NGワードリストアクションクラス
# コントローラー：NGList::NGListController
# アクション：list
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/14 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/ng_list/base_action'

module BizActions
  module NgList
    class ListAction < BizActions::NgList::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
    end
  end
end