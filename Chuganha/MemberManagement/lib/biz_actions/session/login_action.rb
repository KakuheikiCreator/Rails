# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：ログインアクション
# コントローラー：Session::SessionController
# アクション：login
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/10 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'
require 'common/session_util_module'
require 'biz_common/business_config'
require 'biz_actions/business_action'
require 'data_cache/account_cache'

module BizActions
  module Session
    class LoginAction < BizActions::BusinessAction
      include Common::NetUtilModule
      include Common::SessionUtilModule
      include BizCommon
      include DataCache
      # アクセサー定義
      attr_reader :open_id
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # OpenIDリクエスト
        @open_id_request = @controller.session[:last_oidreq]
        # アカウントキャッシュ
        @cache = AccountCache.instance
        # OpenIDヘッダー
        @open_id_header = BusinessConfig.instance[:open_id_header]
        # 入力パラメータ
        @open_id  = params[:open_id]
        @open_id  ||= ''
        @password = params[:password]
        @user_id  = @open_id.dup.sub(Regexp.new('^' + Regexp.escape(@open_id_header)), '')
Rails.logger.debug('open_id :' + @open_id.to_s)
Rails.logger.debug('password:' + @password.to_s)
Rails.logger.debug('user_id :' + @user_id.to_s)
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # パラメータチェック
      def login?
        # トランザクション処理
        ActiveRecord::Base.transaction do
          result_flg = valid?
          if result_flg then
            # 認証成功（ログイン処理）
            account = nil
            if @open_id_request.nil? then
              # 認証結果処理
              account = @cache.auth_result(@user_id, result_flg, Time.now, @request, @open_id_header)
            else
              # 外部サイト認証なので認証履歴はRPに返信する際作成
              account = @cache.user_id_rec(@user_id)
            end
            # セッション更新処理
            function_state_init?(@controller)
            @controller.session[:user_id]  = @user_id
            @controller.session[:authority_cls] = account.dec_value(:enc_authority_cls)
            @controller.session[:nickname] = account.persona[0].dec_value(:enc_nickname)
            @controller.session[:last_oidreq] = @open_id_request
          else
            # 認証結果処理
            if @open_id_request.nil? then
              @cache.auth_result(@user_id, result_flg, Time.now, @request, @open_id_header)
              # 認証失敗（セッションリセット）
              @controller.reset_session
            else
              @cache.auth_result(@user_id, result_flg, Time.now, @request, @open_id_request.trust_root)
              # 認証失敗（セッションリセット）
              @controller.reset_session
              @controller.session[:last_oidreq] = @open_id_request
            end
          end
          return result_flg
        end
      end
      
      # OpenID外部サーバー認証判定
      def ex_site_auth?
        return !@controller.session[:last_oidreq].nil?
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
          @error_msg_hash[:open_id] = validation_msg('open_id', :blank)
          check_result = false
        elsif !valid_uri?(@open_id) then
          @error_msg_hash[:account] = validation_msg('account', :invalid)
          check_result = false
        elsif @open_id.index(@open_id_header) != 0 then
          @error_msg_hash[:account] = validation_msg('account', :invalid)
          check_result = false
        end
        # パスワード
        if blank?(@password) then
          @error_msg_hash[:password] = validation_msg('password', :blank)
          check_result = false
        elsif overflow?(@password, 64) then
          @error_msg_hash[:account] = validation_msg('account', :invalid)
          check_result = false
        elsif !hankaku?(@password) then
          @error_msg_hash[:account] = validation_msg('account', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = true
        # アカウント認証判定
        unless @cache.valid_account?(@user_id, @password) then
          @error_msg_hash[:account] = validation_msg('account', :invalid)
          check_result = false
        end
        return check_result
      end
    end
  end
end