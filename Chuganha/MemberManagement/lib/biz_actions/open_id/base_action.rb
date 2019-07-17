# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：OpenIDのOPアクションの基底暮らす
# コントローラー：OpenID::OPController
# アクション：
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2013/01/01 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/account_cache'
require "openid"
require "openid/consumer/discovery"
require 'openid/extensions/sreg'
require 'openid/store/filesystem'
require 'authentication/op_server'

module BizActions
  module OpenId
    class BaseAction < BizActions::BusinessAction
      include DataCache
      include OpenID
      include OpenID::Server
      include Authentication
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @op_server = OPServer.instance
      end
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 承認済みRP判定
      def approved?(trust_root)
        return false if @session[:approvals].nil?
        return @session[:approvals].include?(trust_root)
      end
      
      # ユーザー認証処理
      def is_authorized?(open_id)
        return !@session[:user_id].nil?
#        return !@session[:user_id].nil? && open_id == url_for_user
      end
      
      # OpenIDサーバーURL
      def url_for_server
        return @controller.url_for(:controller=>'open_id/op', :only_path=>false)
      end
      
      # OpenID会員ページ
      def url_for_user
        return @controller.url_for(:controller=>'open_id/op', :action=>'user_page', :user_id=>@session[:user_id], :only_path=>false)
      end
      
      # SREGのユーザー属性データ生成
      def get_sreg_data(account, sregreq)
        persona = account.persona[0]
        user_data_hash = {
          'nickname'=>@session[:nickname],
          'fullname'=>account.fullname,
          'email'=>persona.dec_value(:enc_email),
          'dob'=>Time.parse(account.dec_value(:enc_birth_date)).strftime("%Y-%m-%d"),
          'gender'=>account.dec_value(:enc_gender_cls),
          'postcode'=>persona.dec_value(:enc_postcode),
          'country'=>persona.dec_value(:enc_country_name_cd),
          'language'=>persona.dec_value(:enc_lang_name_cd),
          'timezone'=>persona.dec_value(:enc_timezone_id)
        }
        sreg_data_hash = Hash.new
        sregreq.all_requested_fields.each do |field|
          sreg_data_hash[field] = user_data_hash[field.to_s]
        end
        return sreg_data_hash
      end
      
      # ログインページにリダイレクト
      def redirect_login_page(oidreq)
        @session[:last_oidreq] = oidreq
        @controller.redirect_to("/session/index.html")
      end
            
      # OpenIDレスポンス処理
      def render_response(oidresp)
        # 署名の要否判定
        @op_server.resp_sign?(oidresp)
        # レスポンス生成
        web_response = @op_server.encode_response(oidresp)
        case web_response.code
        when HTTP_OK then
          @controller.render(:text=>web_response.body, :status=>200)
        when HTTP_REDIRECT then
          @controller.redirect_to(web_response.headers['location'])
        else
          @controller.render(:text=>web_response.body, :status=>400)
        end
      end
      
      # 認証結果登録処理
      def auth_result(oidreq, result_flg)
        trust_root = oidreq.trust_root
        if result_flg then
          # 認証したRPのURLをセッションに保存
          @session[:approvals] ||= Array.new
          @session[:approvals].push(trust_root) unless approved?(trust_root)
        end
        # アカウントデータ返信
        cache = AccountCache.instance
        return cache.auth_result(@session[:user_id], result_flg, Time.now, @request, trust_root)
      end
    end
  end
end