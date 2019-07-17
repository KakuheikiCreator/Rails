# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：退会情報確認アクションクラス
# コントローラー：Withdrawal::WithdrawalController
# アクション：confirmation
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/31 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/withdrawal/base_action'

module BizActions
  module Withdrawal
    class ConfirmationAction < BizActions::Withdrawal::BaseAction
      include DataCache
      # リーダー
      attr_reader :withdrawal_reason_str
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @msg_headder = 'confirmation'
        @withdrawal_reason = nil
        reason_data = WithdrawalReasonCache.instance[@withdrawal_reason_cls]
        @withdrawal_reason_str = reason_data.withdrawal_reason unless reason_data.nil?
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 退会理由項目チェック
        return check_reason?
      end
      
      # DB関連チェック
      def db_related_chk?
        # DB関連チェック（退会理由）
        return withdrawal_reason_db_chk?
      end
    end
  end
end