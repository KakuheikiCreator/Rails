# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：OpenIDのProviderにログイン認証依頼をする
# コントローラー：OpenID::OPController
# アクション：index
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/16 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/open_id/base_action'

module BizActions
  module OpenId
    class IndexAction < BizActions::OpenId::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # OpenID認証開始処理
      def index_action
@logger.debug('index_action user_id:' + @session[:user_id].to_s)
        # リクエストのデコード
        oidreq = nil
        begin
          # ログインセッションが無い場合にはリクエストをデコード
          oidreq = @op_server.decode_request(@params)
        rescue ProtocolError => ex
          # 不正なOpenIDリクエスト の場合にはエラーメッセージだけ返信
          @logger.error("Error:" + ex.message)
          @controller.render(:text=>e.to_s, :status=>500)
          return
        end
        # OpenIDのリクエストが取得出来ない
        if oidreq.nil? then
          @controller.render(:text => "This is an OpenID server endpoint.")
          return
        end
        # IDチェックのリクエスト以外か判定
        unless CheckIDRequest === oidreq then
          # associateモード (RPからのリクエスト)
          # check_authenticationモード(RPからのリクエスト)
          render_response(@op_server.handle_request(oidreq))
          return
        end
        #======================================================================
        # ユーザー認証リクエスト処理
        #======================================================================
        # 即時認証リクエスト判定（対応しない）
        if oidreq.immediate then
          render_response(oidreq.answer(false))
          return
        end
        # 受信したユーザーID情報の取得
        identity = oidreq.identity
        # ID選択の場合には現在セッションのOpenIDを設定
        identity = url_for_user if oidreq.id_select
@logger.debug('id_select:' + oidreq.id_select.to_s)
@logger.debug('identity:' + identity.to_s)
@logger.debug('user_id:' + @session[:user_id].to_s)
        # 認証セッション判定
        unless is_authorized?(identity) then
          # 未認証（ログイン画面表示）
          redirect_login_page(oidreq)
          return
        end
        # 認証済みRP判定
        unless approved?(oidreq.trust_root) then
          # RPの信用確認ページを表示
          @session[:last_oidreq] = oidreq
          @controller.confirmation_form
        end
        # 認証結果処理
        account = auth_result(oidreq, true)
        # 認証OKのレスポンスを生成
        oidresp = oidreq.answer(true, url_for_server, identity)
        # ユーザーの属性情報の付加
        sregreq = @op_server.ex_sreg_request(oidreq)
        @op_server.add_sreg(oidresp, sregreq, get_sreg_data(account, sregreq))
        # レスポンス
        render_response(oidresp)
      end
    end
  end
end