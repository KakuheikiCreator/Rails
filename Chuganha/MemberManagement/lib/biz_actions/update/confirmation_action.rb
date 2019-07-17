# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員情報の更新フォーム確認アクション
# コントローラー：Update::UpdateController
# アクション：confirmation
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/14 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/update/base_action'

module BizActions
  module Update
    class ConfirmationAction < BizActions::Update::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 項目名ヘッダー
        @msg_headder = 'confirmation'
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 更新項目チェック
        return upd_item_chk?
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
        # DB関連チェック（会員状態）
        check_result = false unless member_state_db_chk?
        # DB関連チェック（権限）
        check_result = false unless authority_db_chk?
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