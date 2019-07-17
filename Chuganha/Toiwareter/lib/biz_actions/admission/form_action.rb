# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：新規会員登録フォーム表示アクションクラス
# コントローラー：Admission::AdmissionController
# アクション：form
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/08 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'

module BizActions
  module Admission
    class FormAction < BizActions::BusinessAction
      # リーダー
      attr_reader :open_id, :nickname, :email
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # OpenID
        @open_id = @controller.flash[:open_id]
        @nickname = @controller.flash[:nickname]
        @email = @controller.flash[:email]
        @function_state[:open_id]  = @open_id
        @function_state[:nickname] = @nickname
        @function_state[:email]    = @email
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # OpenID
        if blank?(@open_id) then
          @error_msg_hash[:open_id] = error_msg('open_id', :blank)
          check_result = false
        end
        return check_result
      end
    end
  end
end