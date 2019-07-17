# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム表示アクションクラス
# コントローラー：Quote::PostController
# アクション：form
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/23 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_post/base_action'

module BizActions
  module QuotePost
    class FormAction < BizActions::QuotePost::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 表示フォーム名
        @form_name = 'form'
      end
    end
  end
end