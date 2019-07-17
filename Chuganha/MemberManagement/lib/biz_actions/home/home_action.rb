# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員ホームアクションクラス
# コントローラー：Home::HomeController
# アクション：home
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/11 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'biz_common/business_config'
require 'data_cache/account_cache'
require 'data_cache/gender_cache'
require 'data_cache/country_cache'
require 'data_cache/language_cache'

module BizActions
  module Home
    class HomeAction < BizActions::BusinessAction
      include DataCache
      include BizCommon
      # リーダー
      attr_reader :open_id_header, :user_id, :join_date, :nickname,
                  :name_1, :name_2, :name_kana_1, :name_kana_2,
                  :gender, :birthday, :country_name, :lang_name,
                  :timezone_id, :postcode, :email, :mobile_phone_no, :mobile_email,
                  :mobile_id_no, :mobile_host, :last_auth_date, :auth_histories
      
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # OpenIDヘッダーURL
        @open_id_header = BusinessConfig.instance[:open_id_header]
        # キャッシュデータ
        account_cache = AccountCache.instance
        gender_cache  = GenderCache.instance
        country_cache = CountryCache.instance
        language_cache = LanguageCache.instance
        # 項目値
Rails.logger.debug('session:' + @session.to_s)
        @user_id     = @session[:user_id]
        if admin? then
          @user_id   = @params[:user_id]
          @user_id   ||= @function_state[:user_id]
          @user_id   ||= @session[:user_id]
        end
        @function_state[:user_id] = @user_id
        account      = account_cache.user_id_rec(@user_id)
        persona      = account.persona[0]
        language     = language_cache[persona.dec_value(:enc_lang_name_cd)]
        @join_date   = account.join_date.strftime("%Y/%m/%d %H:%M:%S")
        @nickname    = persona.dec_value(:enc_nickname)
        @name_1      = nil
        @name_2      = nil
        @name_kana_1 = nil
        @name_kana_2 = nil
        @gender      = gender_cache[account.dec_value(:enc_gender_cls)].gender
        @birthday    = Time.parse(account.dec_value(:enc_birth_date)).strftime("%Y/%m/%d")
        @country_name  = country_cache[persona.dec_value(:enc_country_name_cd)].country_name
        @lang_name   = language.lang_name
        @timezone_id = persona.dec_value(:enc_timezone_id)
        @postcode    = persona.dec_value(:enc_postcode)
        @email       = persona.dec_value(:enc_email)
        @mobile_phone_no = persona.dec_value(:enc_mobile_phone_no)
        @mobile_email  = persona.dec_value(:enc_mobile_email)
        @mobile_id_no  = persona.dec_value(:enc_mobile_id_no)
        @mobile_host   = persona.dec_value(:enc_mobile_host)
        # 名前ヨミガナ設定
        if language.name_notation_cls == Language::NOTATION_CLS_LF then
          @name_1      = account.dec_value(:enc_last_name)
          @name_2      = account.dec_value(:enc_first_name)
          @name_kana_1 = account.dec_value(:enc_yomigana_last)
          @name_kana_2 = account.dec_value(:enc_yomigana_first)
        else
          @name_1      = account.dec_value(:enc_first_name)
          @name_2      = account.dec_value(:enc_last_name)
          @name_kana_1 = account.dec_value(:enc_yomigana_first)
          @name_kana_2 = account.dec_value(:enc_yomigana_last)
        end
        # 認証履歴
        @auth_histories = account.authentication_history.reorder('seq_no DESC')
        # 最終認証日時
        @last_auth_date = nil
        last_auth_history = @auth_histories.first
        return if last_auth_history.nil?
        @last_auth_date = last_auth_history.authentication_date.strftime("%Y/%m/%d %H:%M:%S")
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 管理者判定
      def admin?
        return Authority::AUTHORITY_CLS_ADMIN == @session[:authority_cls]
      end
    end
  end
end