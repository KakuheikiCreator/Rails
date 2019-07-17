# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：退会処理アクションの基底クラス
# コントローラー：Withdrawal::WithdrawalController
# アクション：
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/31 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/withdrawal_reason_cache'

module BizActions
  module Withdrawal
    class BaseAction < BizActions::BusinessAction
      include DataCache
      # リーダー
      attr_reader :withdrawal_reason_list, :withdrawal_reason_cls, :withdrawal_reason_dtl
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @msg_headder = nil
        # キャッシュデータ
        @withdrawal_reason_list = WithdrawalReasonCache.instance.withdrawal_reason_list
        # 入力項目
        @user_id   = @session[:user_id]
        if admin? then
          @user_id = @params[:user_id]
          @user_id ||= @function_state[:user_id]
          @user_id ||= @session[:user_id]
        end
        @function_state[:user_id] = @user_id
        @withdrawal_reason_cls = @params[:withdrawal_reason_cls]
        @withdrawal_reason_dtl = @params[:withdrawal_reason_dtl]
        # 関連データ
        @account = nil
        @withdrawal_reason = nil
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 管理者判定
      def admin?
        return Authority::AUTHORITY_CLS_ADMIN == @session[:authority_cls]
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 退会理由チェック
      def check_reason?
        check_result = true
        # 退会理由区分チェック
        if blank?(@withdrawal_reason_cls) then
          @error_msg_hash[:withdrawal_reason_cls] = error_msg('reason', :blank)
          check_result = false
        elsif !length_is?(@withdrawal_reason_cls, 3) then
          @error_msg_hash[:withdrawal_reason_cls] = error_msg('reason', :wrong_length, :count=>3)
          check_result = false
        end
        # 退会理由詳細
        unless blank?(@withdrawal_reason_dtl) then
          if overflow?(@withdrawal_reason_dtl, 2000) then
            @error_msg_hash[:withdrawal_reason_dtl] = error_msg('detail', :too_long, :count=>2000)
            check_result = false
          end
        end
        return check_result
      end
      
      # DB関連チェック（アカウント）
      def account_db_chk?
        # ユーザー情報の有無判定
        @account = AccountCache.instance.user_id_rec(@user_id)
        if @account.nil? then
          @error_msg_hash[:user_id] = error_msg('user_id', :inclusion)
          return false
        end
        return true
      end
      
      # DB関連チェック（退会理由）
      def withdrawal_reason_db_chk?
        # 言語名コードチェック
        @withdrawal_reason = WithdrawalReasonCache.instance[@withdrawal_reason_cls]
        if @withdrawal_reason.nil? then
          @error_msg_hash[:withdrawal_reason_cls] = error_msg('reason', :invalid)
          return false
        end
        return true
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text(@msg_headder + '.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end