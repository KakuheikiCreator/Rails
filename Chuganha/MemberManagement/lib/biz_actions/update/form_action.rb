# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員情報の更新フォーム表示アクション
# コントローラー：Update::UpdateController
# アクション：form
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/13 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/update/base_action'

module BizActions
  module Update
    class FormAction < BizActions::Update::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
    end
  end
end