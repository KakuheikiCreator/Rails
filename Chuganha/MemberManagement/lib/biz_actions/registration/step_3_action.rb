# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員情報の入力フォーム表示アクション
# コントローラー：Registration::RegistrationController
# アクション：step_3
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/19 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/registration/base_action'

module BizActions
  module Registration
    class Step3Action < BizActions::Registration::BaseAction
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
#          @session[:function_state].update_token
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
        check_result = !blank?(@params[:agree_policy])
        # 会員規約同意の有無を確認
        check_result = false if @params[:accept_terms_flg] != 'true'
        return check_result
      end
    end
  end
end