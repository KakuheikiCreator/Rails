# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員リストアクションクラス
# コントローラー：Member::ListController
# アクション：list
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/14 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/member_list/base_action'

module BizActions
  module MemberList
    class ListAction < BizActions::MemberList::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
    end
  end
end