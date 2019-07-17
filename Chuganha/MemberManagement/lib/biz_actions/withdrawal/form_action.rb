# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：退会フォームアクションクラス
# コントローラー：Withdrawal::WithdrawalController
# アクション：form
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/31 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/withdrawal/base_action'

module BizActions
  module Withdrawal
    class FormAction < BizActions::Withdrawal::BaseAction
      include DataCache
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
    end
  end
end