# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：個人情報保護方針確認フォーム表示アクション
# コントローラー：Registration::RegistrationController
# アクション：step_2
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/19 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'

module BizActions
  module Registration
    class Step2Action < BizActions::BusinessAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # パラメータチェック
      def agreement?
        if valid? then
          # トークン更新
          @session[:function_state].update_token
          return true
        else
          # セッションリセット
          @controller.reset_session
          return false
        end
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # クリックされたボタン判定
        return !blank?(@params[:agree_terms])
      end
    end
  end
end