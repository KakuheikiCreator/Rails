# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員規約確認フォーム表示アクション
# コントローラー：Registration::RegistrationController
# アクション：step_1
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/16 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'common/session_util_module'

module BizActions
  module Registration
    class Step1Action < BizActions::BusinessAction
      include Common::SessionUtilModule
      
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
      # ログインセッションチェック
      def login?
        if valid? then
          # 未ログイン状態なのでセッションを初期化
          function_state_init?(@controller)
          return false
        end
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # ログイン済みチェック
        return blank?(@session[:user_id])
      end
    end
  end
end