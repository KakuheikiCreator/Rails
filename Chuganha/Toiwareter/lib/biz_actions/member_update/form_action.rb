# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員更新フォームアクションクラス
# コントローラー：Member::UpdateController
# アクション：form
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/21 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/member_update/base_action'

module BizActions
  module MemberUpdate
    class FormAction < BizActions::MemberUpdate::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
    end
  end
end