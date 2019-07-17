# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：退会アクションクラス
# コントローラー：Withdrawal::WithdrawalController
# アクション：withdrawal
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/31 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/withdrawal/base_action'
require 'data_cache/person_withdrawal_state_cache'

module BizActions
  module Withdrawal
    class WithdrawalAction < BizActions::Withdrawal::BaseAction
      include DataCache
      # リーダー
      attr_reader :withdrawal_reason
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @msg_headder = 'withdrawal'
      end
      
      # 退会処理
      def withdrawal?
        # 退会処理
        ActiveRecord::Base.transaction do
          # アカウントキャッシュリロード
          AccountCache.instance.data_update?
          # バリデーション
          return false unless valid?
          # 退会者データ登録
          person_withdrawal = PersonWithdrawal.new
          person_withdrawal.withdrawal_reason_id = @withdrawal_reason.id
          person_withdrawal.set_enc_value(:enc_withdrawal_reason_dtl, @withdrawal_reason_dtl)
          state = PersonWithdrawalStateCache.instance[PersonWithdrawalState::STATE_CLS_PRE_WITHDRAWAL]
          person_withdrawal.person_withdrawal_state_id = state.id
          person_withdrawal.withdrawal_date = Time.now
          person_withdrawal.set_account_info(@account)
          person_withdrawal.save!
          # アカウント論理削除
          @account.delete_flg = true
          @account.save!
          # データ更新情報更新
          upd_cache = DataUpdatedCache.instance
          upd_cache.next_version(:account)
          upd_cache.next_version(:persona)
          upd_cache.next_version(:person_withdrawal)
          # セッション情報処理
          if !admin? then
            # セッションクリア（管理者以外）
            @controller.reset_session
          elsif @session[:user_id] == @user_id then
            # 管理者が自分の会員処理をした場合にはセッションをクリア
            @controller.reset_session
          end
        end
        return true
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
        # DB関連チェック（アカウント）
        check_result = account_db_chk?
        # DB関連チェック（退会理由）
        check_result = false unless withdrawal_reason_db_chk?
        return check_result
      end
      
      # 退会者
      def person_withdrawal_ent(account)
        ent = PersonWithdrawal.new
        return ent
      end
    end
  end
end