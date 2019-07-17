# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：携帯からの認証の基底アクション
# コントローラー：Registration::RegistrationController
# アクション：step_7, miss
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/09 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/mobile_action'
require 'data_cache/account_cache'
require 'data_cache/person_withdrawal_cache'

module BizActions
  module Registration
    class AuthBaseAction < BizActions::MobileAction
      include DataCache
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # アカウントキャッシュ
        @account_cache = AccountCache.instance
        # 退会者キャッシュ
        @person_withdrawal_cache = PersonWithdrawalCache.instance
        # パラメータ
        @guid = @params[:guid]
        @user_id = @params[:id]
        @temp_password = @params[:cd]
        @account = nil
        @logger.debug('AuthBaseAction guid:' + @guid.to_s)
        @logger.debug('AuthBaseAction user_id:' + @user_id.to_s)
        @logger.debug('AuthBaseAction temp_password:' + @temp_password.to_s)
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # ユーザーIDチェック
        if blank?(@user_id) then
          check_result = false
        elsif overflow?(@user_id, 32) then
          check_result = false
        elsif (/^[\w\-]*$/ =~ @user_id).nil? then
          check_result = false
        end
        # 一時パスワード
        if blank?(@temp_password) then
          check_result = false
        end
        # 携帯リモートホストチェック
        if blank?(@mobile_host) then
          check_result = false
        end
        # 個体識別番号チェック
        if blank?(@mobile_id_no) != @mobile_id_blank_flg then
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        unless @mobile_id_blank_flg then
@logger.debug('AuthBaseAction db_related_chk? 1')
          # 携帯個体識別番号チェック
          return false if @account_cache.mobile_id_no_exist?(@mobile_id_no)
@logger.debug('AuthBaseAction db_related_chk? 2')
          # 携帯個体識別番号チェック （退会者）
          return false if @person_withdrawal_cache.mobile_id_exist?(@mobile_id_no)
        end
@logger.debug('AuthBaseAction db_related_chk? 3')
        # 対象となる仮登録データの有無チェック
        @account = @account_cache.provisional_account(@user_id, @temp_password, @mobile_carrier_cd)
        return !@account.nil?
      end
    end
  end
end