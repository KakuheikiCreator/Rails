# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：受信したリクエスト情報をラッピングし、検証等のビジネスロジックを実装する
# コントローラー：Login::LoginController
# アクション：login
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/01 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/account_cache'

module BizActions
  module Login
    class LoginAction < BizActions::BusinessAction
      include DataCache
      # アクセサー定義
      attr_reader :login_id
      #########################################################################
      # 定数定義
      #########################################################################
      MSG_INVALID_ACCOUNT = 'messages.invalid_account'
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @login_id = @params[:login_id]
        @password = @params[:password]
      end
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        if @login_id.nil? then
          @error_msg_hash[:err_msg] = view_text(MSG_INVALID_ACCOUNT)
          check_result = false
        end
        return check_result
      end
      # DB関連チェック
      def db_related_chk?
        check_result = true
        unless AccountCache.instance.valid_account?(@login_id, @password) then
          @error_msg_hash[:err_msg] = view_text(MSG_INVALID_ACCOUNT)
          check_result = false
        end
        return check_result
      end
    end
  end
end