# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員ホーム表示アクションクラス
# コントローラー：Member::HomeController
# アクション：index
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/12 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/member_cache'

module BizActions
  module MemberHome
    class IndexAction < BizActions::BusinessAction
      include DataCache
      # リーダー
      attr_reader :member_id, :member
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # MemberID
        @member_id = @function_state[:member_id]
        if user_admin? then
          @member_id ||= @params[:member_id]
          @member_id ||= @session[:member_id]
        else
          @member_id = @session[:member_id]
        end
        @function_state[:member_id] = @member_id
        # プロパティ
        @member = MemberCache.instance[@member_id]
      end
  
      # 管理者判定
      def user_admin?
        return Authority::AUTHORITY_CLS_ADMIN == @session[:authority_cls]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # セッションユーザー判定
      def session_user?
        return @session[:member_id] == @member_id
      end
    end
  end
end