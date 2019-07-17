# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：ユーザーIDの存在チェックを行う
# コントローラー：Registration::RegistrationController
# アクション：chk_id
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/24 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/account_cache'

module BizActions
  module Registration
    class CheckIDAction < BizActions::BusinessAction
      include DataCache
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @user_id = @params[:check_user_id]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      def check_result
        return '<span class="check_ok">Check OK !</span>' if valid?
        return '<span class="check_err">Check Error !</span>'
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 必須チェック
        check_result = true
        # ユーザーIDチェック
        if blank?(@user_id) then
          check_result = false
        elsif overflow?(@user_id, 32) then
          check_result = false
        elsif (/^[A-Za-z0-9\-_]*$/ =~ @user_id).nil? then
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        # アカウント存在チェック
        return !AccountCache.instance.exist?(@user_id)
      end
    end
  end
end