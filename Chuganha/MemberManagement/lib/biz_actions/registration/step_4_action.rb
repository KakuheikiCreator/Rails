# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：入力された会員情報の確認画面表示アクション
# コントローラー：Registration::RegistrationController
# アクション：step_4
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/28 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/registration/base_action'

module BizActions
  module Registration
    class Step4Action < BizActions::Registration::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @msg_headder = 'step_3'
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 確認画面表示判定
      def confirmation_display?
        if valid? then
          # トークン更新
          @session[:function_state].update_token
          return true
        else
          return false
        end
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 入力された会員情報の単項目チェック
        return account_item_chk?
      end
      
      # 項目関連チェック
      def related_items_chk?
        # 会員情報の項目関連チェック
        return account_item_rel_chk?
      end
      
      # DB関連チェック
      def db_related_chk?
        # DB関連チェック（アカウント）
        check_result = account_db_chk?
        # DB関連チェック（ペルソナ）
#        check_result = false unless persona_db_chk?
        # DB関連チェック（退会者）
#        check_result = false unless person_withdrawal_db_chk?
        # DB関連チェック（性別）
        check_result = false unless gender_db_chk?
        # DB関連チェック（国）
        check_result = false unless country_db_chk?
        # DB関連チェック（言語）
        check_result = false unless language_db_chk?
        # DB関連チェック（タイムゾーン）
        check_result = false unless timezone_db_chk?
        # DB関連チェック（携帯キャリア）
        check_result = false unless mobile_carrier_db_chk?
        return check_result
      end
    end
  end
end