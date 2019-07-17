# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：基底アクションクラス
# コントローラー：Registration::RegistrationController
# アクション：step_4, step_5
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/25 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'
require 'biz_common/business_config'
require 'biz_actions/business_action'
require 'data_cache/account_cache'
require 'data_cache/person_withdrawal_cache'
require 'data_cache/gender_cache'
require 'data_cache/country_cache'
require 'data_cache/language_cache'
require 'data_cache/timezone_cache'
require 'data_cache/mobile_carrier_cache'

module BizActions
  module Registration
    class BaseAction < BizActions::BusinessAction
      include Common::NetUtilModule
      include DataCache
      include BizCommon
      # リーダー
      attr_reader :open_id_header, :gender_list, :country_list,
                  :language_list, :timezone_list, :mobile_carrier_list,
                  :accept_terms_flg, :accept_policy_flg,
                  :user_id, :password, :retype_pw, :nickname,
                  :name_1, :name_2, :name_kana_1, :name_kana_2,
                  :first_name, :last_name, :yomigana_first, :yomigana_last,
                  :gender_cls, :birth_day, :country_name_cd, :lang_name_cd,
                  :timezone_id, :postcode, :email, :mobile_phone_no,
                  :mobile_email_local, :mobile_carrier_id, :mobile_email
      
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 項目名ヘッダー
        @msg_headder = ''
        # OpenIDヘッダーURL
        @open_id_header = BusinessConfig.instance[:open_id_header]
        # マスタデータ
        @gender_list   = GenderCache.instance.gender_list
        @country_list  = CountryCache.instance.country_list
        @language_list = LanguageCache.instance.language_list
        @timezone_list = TimezoneCache.instance.timezone_list
        @mobile_carrier_list = MobileCarrierCache.instance.mobile_carrier_list
        # パラメータ
        @accept_terms_flg    = @params[:accept_terms_flg]
        @accept_policy_flg   = @params[:accept_policy_flg]
        @user_id     = @params[:identifier]
        @password    = @params[:password]
        @retype_pw   = @params[:retype_pw]
        @nickname    = @params[:nickname]
        @name_1      = @params[:name_1]
        @name_2      = @params[:name_2]
        @name_kana_1 = @params[:name_kana_1]
        @name_kana_2 = @params[:name_kana_2]
        @first_name     = nil
        @last_name      = nil
        @yomigana_first = nil
        @yomigana_last  = nil
        @gender_cls  = @params[:gender]
        @birth_day   = date_time_param(:birth)
        @country_name_cd   = @params[:country]
        @lang_name_cd      = @params[:language]
        @timezone_id = @params[:timezone]
        @postcode    = @params[:postcode]
        @email       = @params[:email]
        @mobile_phone_no   = @params[:mobile_num]
        @mobile_email_local  = @params[:mobile_email_local]
        @mobile_carrier_id = @params[:mobile_email_domain]
        @mobile_email      = nil
        # 名前ヨミガナ設定
        unless @lang_name_cd.nil? then
          lang_ent = LanguageCache.instance[@lang_name_cd]
          if Language::NOTATION_CLS_LF == lang_ent.name_notation_cls then
            @last_name      = @name_1
            @first_name     = @name_2
            @yomigana_last  = @name_kana_1
            @yomigana_first = @name_kana_2
          else
            @first_name     = @name_1
            @last_name      = @name_2
            @yomigana_first = @name_kana_1
            @yomigana_last  = @name_kana_2
          end
        end
        # 携帯メールアドレス
        mbl_local  = @mobile_email_local
        mbl_ent = MobileCarrierCache.instance[@mobile_carrier_id]
        @mobile_email = mbl_local.to_s + '@' + mbl_ent.domain.to_s unless mbl_ent.nil?
        # エラーメッセージハッシュ更新
        err_hash = flash[:err_hash]
        @error_msg_hash = err_hash if Hash === err_hash
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック（アカウント情報）
      def account_item_chk?
        check_result = true
        # 会員規約承諾フラグ
        if blank?(@accept_terms_flg) then
          @error_msg_hash[:accept_terms_flg] = error_msg('accept_terms_flg', :blank)
          check_result = false
        elsif @accept_terms_flg != 'true' then
          @error_msg_hash[:accept_terms_flg] = error_msg('accept_terms_flg', :invalid)
          check_result = false
        end
        # 個人情報保護方針承諾フラグ
        if blank?(@accept_policy_flg) then
          @error_msg_hash[:accept_policy_flg] = error_msg('accept_policy_flg', :blank)
          check_result = false
        elsif @accept_policy_flg != 'true' then
          @error_msg_hash[:accept_policy_flg] = error_msg('accept_policy_flg', :invalid)
          check_result = false
        end
        # ユーザーIDチェック
        if blank?(@user_id) then
          @error_msg_hash[:identifier] = error_msg('open_id', :blank)
          check_result = false
        elsif overflow?(@user_id, 32) then
          @error_msg_hash[:identifier] = error_msg('open_id', :too_long, :count=>32)
          check_result = false
        elsif (/^[\w\-]*$/ =~ @user_id).nil? then
          @error_msg_hash[:identifier] = error_msg('open_id', :invalid)
          check_result = false
        end
        # パスワード
        if blank?(@password) then
          @error_msg_hash[:password] = error_msg('password', :blank)
          check_result = false
        elsif !overflow?(@password, 11) then
          @error_msg_hash[:password] = error_msg('password', :too_short, :count=>11)
          check_result = false
        elsif overflow?(@password, 64) then
          @error_msg_hash[:password] = error_msg('password', :too_long, :count=>64)
          check_result = false
        elsif !hankaku?(@password) then
          @error_msg_hash[:password] = error_msg('password', :invalid)
          check_result = false
        end
        # パスワード（再入力）
        if blank?(@retype_pw) then
          @error_msg_hash[:retype_pw] = error_msg('retype_pw', :blank)
          check_result = false
        end
        # ニックネーム
        if blank?(@nickname) then
          @error_msg_hash[:nickname] = error_msg('nickname', :blank)
          check_result = false
        elsif overflow?(@nickname, 20) then
          @error_msg_hash[:nickname] = error_msg('nickname', :too_long, :count=>20)
          check_result = false
        end
        # 名前（名）
        if blank?(@first_name) then
          @error_msg_hash[:name] = error_msg('first_name', :blank)
          check_result = false
        elsif overflow?(@first_name, 20) then
          @error_msg_hash[:name] = error_msg('first_name', :too_long, :count=>20)
          check_result = false
        end
        # 名前（姓）
        if blank?(@last_name) then
          @error_msg_hash[:name] = error_msg('last_name', :blank)
          check_result = false
        elsif overflow?(@last_name, 20) then
          @error_msg_hash[:name] = error_msg('last_name', :too_long, :count=>20)
          check_result = false
        end
        # ヨミガナ（名）
        if blank?(@yomigana_first) then
          @error_msg_hash[:name_kana] = error_msg('yomigana_first', :blank)
          check_result = false
        elsif overflow?(@yomigana_first, 30) then
          @error_msg_hash[:name_kana] = error_msg('yomigana_first', :too_long, :count=>30)
          check_result = false
        elsif !yomigana?(@yomigana_first) then
          @error_msg_hash[:name_kana] = error_msg('yomigana_first', :invalid)
          check_result = false
        end
        # ヨミガナ（姓）
        if blank?(@yomigana_last) then
          @error_msg_hash[:name_kana] = error_msg('yomigana_last', :blank)
          check_result = false
        elsif overflow?(@yomigana_last, 30) then
          @error_msg_hash[:name_kana] = error_msg('yomigana_last', :too_long, :count=>30)
          check_result = false
        elsif !yomigana?(@yomigana_last) then
          @error_msg_hash[:name_kana] = error_msg('yomigana_last', :invalid)
          check_result = false
        end
        # 性別
        if blank?(@gender_cls) then
          @error_msg_hash[:gender] = error_msg('gender', :blank)
          check_result = false
        elsif !alphabetic?(@gender_cls) then
          @error_msg_hash[:gender] = error_msg('gender', :invalid)
          check_result = false
        end
        # 誕生日
        if blank?(@birth_day) then
          @error_msg_hash[:birth] = error_msg('birthday', :blank)
          check_result = false
        elsif !past_date?(@birth_day.year, @birth_day.month, @birth_day.day) then
          @error_msg_hash[:birth] = error_msg('birthday', :past_date)
          check_result = false
        end
        # 国名コード
        if blank?(@country_name_cd) then
          @error_msg_hash[:country] = error_msg('country', :blank)
          check_result = false
        elsif !length_is?(@country_name_cd, 2) then
          @error_msg_hash[:country] = error_msg('country', :wrong_length, :count=>3)
          check_result = false
        elsif !alphabetic?(@country_name_cd) then
          @error_msg_hash[:country] = error_msg('country', :invalid)
          check_result = false
        end
        # 言語名コード
        if blank?(@lang_name_cd) then
          @error_msg_hash[:language] = error_msg('language', :blank)
          check_result = false
        elsif !length_is?(@lang_name_cd, 2) then
          @error_msg_hash[:language] = error_msg('language', :wrong_length, :count=>2)
          check_result = false
        elsif !alphabetic?(@lang_name_cd) then
          @error_msg_hash[:language] = error_msg('language', :invalid)
          check_result = false
        end
        # タイムゾーンID
        if blank?(@timezone_id) then
          @error_msg_hash[:timezone] = error_msg('timezone', :blank)
          check_result = false
        elsif overflow?(@timezone_id, 255) then
          @error_msg_hash[:timezone] = error_msg('timezone', :too_long, :count=>255)
          check_result = false
        elsif !hankaku?(@timezone_id) then
          @error_msg_hash[:timezone] = error_msg('timezone', :invalid)
          check_result = false
        end
        # 郵便番号
        if blank?(@postcode) then
          @error_msg_hash[:postcode] = error_msg('postcode', :blank)
          check_result = false
        elsif overflow?(@postcode, 9) then
          @error_msg_hash[:postcode] = error_msg('postcode', :too_long, :count=>9)
          check_result = false
        elsif @country_name_cd == 'JPN' && !length_is?(@postcode, 7) then
          @error_msg_hash[:postcode] = error_msg('postcode', :wrong_length, :count=>7)
          check_result = false
        elsif !numeric?(@postcode) then
          @error_msg_hash[:postcode] = error_msg('postcode', :invalid)
          check_result = false
        end
        # メールアドレス
        if blank?(@email) then
          @error_msg_hash[:email] = error_msg('email', :blank)
          check_result = false
        elsif !valid_email?(@email) then
          @error_msg_hash[:email] = error_msg('email', :invalid)
          check_result = false
        end
        # 携帯電話番号
        if blank?(@mobile_phone_no) then
          @error_msg_hash[:mobile_num] = error_msg('mobile_num', :blank)
          check_result = false
        elsif !mobile_phone_no?(@mobile_phone_no) then
          @error_msg_hash[:mobile_num] = error_msg('mobile_num', :invalid)
          check_result = false
        end
        # 携帯メールアドレス
        if blank?(@mobile_email) || blank?(@mobile_carrier_id) then
          @error_msg_hash[:mobile_email] = error_msg('mobile_email', :blank)
          check_result = false
        elsif !valid_email?(@mobile_email) then
          @error_msg_hash[:mobile_email] = error_msg('mobile_email', :invalid)
          check_result = false
        end
        return check_result
      end

      # 項目関連チェック（アカウント情報）
      def account_item_rel_chk?
        # パスワードの再入力チェック
        if @password != @retype_pw then
          @error_msg_hash[:retype_pw] = error_msg('retype_pw', :invalid)
          return false
        end
        return true
      end
      
      # DB関連チェック（アカウント）
      def account_db_chk?
        # ユーザー情報の有無判定
        if AccountCache.instance.exist?(@user_id) then
          @error_msg_hash[:identifier] = error_msg('open_id', :exclusion)
          return false
        end
        return true
      end
      
      # DB関連チェック（ペルソナ）
      def persona_db_chk?
        cache = AccountCache.instance
        # 携帯電話番号の有無判定
        if cache.mobile_phone_no_exist?(@mobile_phone_no) then
          @error_msg_hash[:mobile_num] = error_msg('mobile_num', :exclusion)
          return false
        end
        # 携帯メールの有無判定
        if cache.mobile_email_exist?(@mobile_email) then
          @error_msg_hash[:mobile_email] = error_msg('mobile_email', :exclusion)
          return false
        end
        return true
      end
      
      # DB関連チェック（退会者）
      def person_withdrawal_db_chk?
        cache = PersonWithdrawalCache.instance
        # 携帯電話番号の有無判定
        if cache.mobile_phone_no_exist?(@mobile_phone_no) then
          @error_msg_hash[:mobile_num] = error_msg('mobile_num', :exclusion)
          return false
        end
        # 携帯メールの有無判定
        if cache.mobile_email_exist?(@mobile_email) then
          @error_msg_hash[:mobile_email] = error_msg('mobile_email', :exclusion)
          return false
        end
        return true
      end
      
      # DB関連チェック（性別）
      def gender_db_chk?
        # 性別区分チェック
        if !GenderCache.instance.exist?(@gender_cls) then
          @error_msg_hash[:gender] = error_msg('gender', :invalid)
          return false
        end
        return true
      end
      
      # DB関連チェック（国）
      def country_db_chk?
        # 国コードチェック
        if !CountryCache.instance.exist?(@country_name_cd) then
          @error_msg_hash[:country] = error_msg('country', :invalid)
          return false
        end
        return true
      end
      
      # DB関連チェック（言語）
      def language_db_chk?
        # 言語名コードチェック
        if !LanguageCache.instance.exist?(@lang_name_cd) then
          @error_msg_hash[:language] = error_msg('language', :invalid)
          return false
        end
        return true
      end
     
      # DB関連チェック（タイムゾーン）
      def timezone_db_chk?
        # タイムゾーンIDチェック
        if !TimezoneCache.instance.exist?(@timezone_id) then
          @error_msg_hash[:timezone] = error_msg('timezone', :invalid)
          return false
        end
        return true
      end
     
      # DB関連チェック（携帯キャリア）
      def mobile_carrier_db_chk?
        # 携帯キャリアコードチェック
        if !MobileCarrierCache.instance.exist?(@mobile_carrier_id) then
          @error_msg_hash[:mobile_email] = error_msg('mobile_email', :invalid)
          return false
        end
        return true
      end
      
      #########################################################################
      # protected
      #########################################################################
      protected
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text(@msg_headder + '.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end