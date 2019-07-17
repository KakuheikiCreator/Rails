# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員情報の一覧フォーム表示アクション
# コントローラー：List::ListController
# アクション：form
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/18 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/list/base_action'
require 'biz_actions/list/sql_member_list'

module BizActions
  module List
    class FormAction < BizActions::List::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @msg_headder = 'list'
      end
    end
  end
end