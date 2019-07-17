# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：RPを認証するのか確認を行う
# コントローラー：OpenID::OPController
# アクション：confirmation
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2013/01/03 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/open_id/base_action'

module BizActions
  module OpenId
    class ConfirmationAction < BizActions::OpenId::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @oidreq = @session[:last_oidreq]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # RP認証判定
      def confirmation
        # パラメータエラー
        unless valid? then
          @controller.render(:text=>'Internal Server Error', :status=>500)
          return
        end
        # セッションのOpenIDリクエストクリア
        @session[:last_oidreq] = nil
        # RPの信頼判定
        agree_val = view_text('confirmation_form.item_names.agree_btn')
        if agree_val != @params[:commit] then
          # RPを信頼しないのでキャンセルURLへリダイレクト
          @controller.redirect_to(@oidreq.cancel_url)
          return
        end
        # 認証結果処理
        account = auth_result(@oidreq, true)
        # 認証レスポンスの生成
        identity = @oidreq.identity
        identity = url_for_user if @oidreq.id_select
        oidresp = @oidreq.answer(true, url_for_server, identity)
        # ユーザーの属性情報の付加
        sregreq = @op_server.ex_sreg_request(@oidreq)
        @op_server.add_sreg(oidresp, sregreq, get_sreg_data(account, sregreq))
@logger.debug('user_id:' + @session[:user_id].to_s)
        # 返信
        render_response(oidresp)
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # ログインセッションチェック
        if blank?(@session[:user_id]) then
          check_result = false
        end
        # OpenIDリクエスト存在チェック
        if @oidreq.nil? then
          check_result = false
        end
        return check_result
      end
    end
  end
end