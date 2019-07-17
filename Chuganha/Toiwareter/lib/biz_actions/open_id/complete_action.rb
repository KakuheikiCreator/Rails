# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：OpenIDのProviderからのリダイレクト内容判定をする
# コントローラー：OpenID::RPController
# アクション：complete
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/11/15 Nakanohito
# 更新日:
###############################################################################
require 'common/session_util_module'
require 'authentication/auth_consumer'
require 'biz_actions/business_action'
require 'data_cache/member_cache'

module BizActions
  module OpenId
    class CompleteAction < BizActions::BusinessAction
      include Common
      include Authentication
      include DataCache
      # アクセサー定義
      attr_reader :open_id, :result_ptn
      #########################################################################
      # 定数定義
      #########################################################################
      PTN_SUCCESS  = 0 # 認証成功
      PTN_SUCCESS_NEW  = 1 # 認証成功（新規会員）
      PTN_FAILURE  = 2 # 認証失敗
      PTN_CANCEL   = 3 # 認証キャンセル
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @open_id = nil
        @result_ptn = PTN_FAILURE
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # OpenID認証結果判定
      def complete
        # パラメータからパス情報を取り除く
        parameters = @params.reject do |key, value| @request.path_parameters.has_key?(key.to_sym) end
        # OpenIDレスポンス抽出
        current_url = @controller.url_for(:action=>'complete', :only_path=>false)
        consumer = AuthConsumer.new(@session)
        oidresp = consumer.complete(parameters, current_url)
        @open_id = oidresp.display_identifier
        if blank?(@open_id) then
          # 認証失敗
          @result_ptn = PTN_FAILURE
          @error_msg_hash[:login_form] = view_text('index.sentences.err_msg_2')
          return
        end
        # 認証ステータス判定
        case oidresp.status
        when OpenID::Consumer::SUCCESS then
          # OpenID認証成功
          member_ent = MemberCache.instance.open_id_rec(@open_id)
          if member_ent.nil? then
            # 新規会員
            @result_ptn = PTN_SUCCESS_NEW
            # セッション初期化
            SessionUtilModule.function_state_init?(@controller)
            # SREGパラメータ取得
            sreg_data = consumer.sreg_response(oidresp).data
            @controller.flash[:open_id]  = @open_id
            @controller.flash[:nickname] = sreg_data['nickname']
            @controller.flash[:email]    = sreg_data['email']
          elsif !member_ent.valid_member? then
            # 無効な会員
            @result_ptn = PTN_FAILURE
            @error_msg_hash[:login_form] = view_text('index.sentences.err_msg_2')
          else
            # 有効な会員
            @result_ptn = PTN_SUCCESS
            # SREGパラメータ取得
            sreg_data = consumer.sreg_response(oidresp).data
            # 会員情報更新
            member_update(member_ent, sreg_data)
            # セッション初期化
            SessionUtilModule.function_state_init?(@controller)
            @controller.session[:member_id] = member_ent.member_id
            @controller.session[:authority_cls] = member_ent.authority.authority_cls
            @controller.session[:nickname]  = member_ent.nickname
            @controller.session[:authority_hash] = member_ent.authority_hash
          end
        when OpenID::Consumer::FAILURE then
          # 認証失敗
          @result_ptn = PTN_FAILURE
          @error_msg_hash[:login_form] = view_text('index.sentences.err_msg_2')
        when OpenID::Consumer::CANCEL then
          # 認証処理がOP側でキャンセルされた
          @result_ptn = PTN_CANCEL
          @error_msg_hash[:login_form] = view_text('index.sentences.err_msg_3')
        when OpenID::Consumer::SETUP_NEEDED then
          # 即時認証失敗
          @result_ptn = PTN_FAILURE
          @error_msg_hash[:login_form] = view_text('index.sentences.err_msg_2')
        end
      end
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # Login処理
      def member_update(member_ent,sreg_data)
        # 会員情報更新
        ActiveRecord::Base.transaction do
          member_ent.set_enc_value(:email, sreg_data['email'])
          member_ent.last_login_date = Time.now
          member_ent.login_cnt += 1
          member_ent.save!
        end
        # キャッシュデータ更新
        MemberCache.instance.refresh_data(member_ent)
      end
    end
  end
end