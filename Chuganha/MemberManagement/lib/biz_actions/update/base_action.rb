# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員情報更新基底アクションクラス
# コントローラー：Update::UpdateController
# アクション：form, confirm, update
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/13 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'
require 'biz_actions/business_action'
require 'biz_common/business_config'
require 'data_cache/account_cache'
require 'data_cache/member_state_cache'
require 'data_cache/authority_cache'
require 'data_cache/gender_cache'
require 'data_cache/country_cache'
require 'data_cache/language_cache'
require 'data_cache/timezone_cache'
require 'data_cache/mobile_carrier_cache'

module BizActions
  module Update
    class BaseAction < BizActions::BusinessAction
      include Common::NetUtilModule
      include DataCache
      include BizCommon
      # リーダー
      attr_reader :open_id, :user_id, :member_state, :authority, :nickname,
                  :name_1, :name_2, :name_kana_1, :name_kana_2,
                  :gender, :birthday, :country_name, :lang_name, :timezone_id,
                  :postcode, :email, :mobile_phone_no, :mobile_email,
                  :upd_member_state_cls, :upd_member_state,
                  :upd_authority_cls, :upd_authority, :upd_nickname,
                  :upd_password, :upd_retype_pw,
                  :upd_name_1, :upd_name_2, :upd_name_kana_1, :upd_name_kana_2,
                  :upd_gender_cls, :upd_gender, :upd_birthday,
                  :upd_country_name_cd, :upd_country_name,
                  :upd_lang_name_cd, :upd_lang_name, :upd_timezone_id, :upd_postcode,
                  :upd_email, :upd_mobile_phone_no, :upd_mobile_email_local,
                  :upd_mobile_carrier_id, :upd_mobile_email,
                  :member_state_list, :authority_list, :gender_list, :country_list,
                  :language_list, :timezone_list, :mobile_carrier_list
      
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 項目名ヘッダー
        @msg_headder = ''
        # キャッシュデータ
        account_cache = AccountCache.instance
        member_state_cache = MemberStateCache.instance
        authority_cache = AuthorityCache.instance
        gender_cache  = GenderCache.instance
        country_cache = CountryCache.instance
        language_cache = LanguageCache.instance
        timezone_cache = TimezoneCache.instance
        mobile_carrier_cache = MobileCarrierCache.instance
        # マスタデータ
        @member_state_list   = member_state_cache.member_state_list
        @authority_list  = authority_cache.authority_list
        @gender_list   = gender_cache.gender_list
        @country_list  = country_cache.country_list
        @language_list = language_cache.language_list
        @timezone_list = timezone_cache.timezone_list
        @mobile_carrier_list = mobile_carrier_cache.mobile_carrier_list
        #######################################################################
        # 項目値（更新前）
        #######################################################################
        @user_id     = @session[:user_id]
        @user_id     = @params[:user_id] if admin?
        @open_id     = BusinessConfig.instance[:open_id_header] + @user_id
        account      = account_cache.user_id_rec(@user_id)
        member_state = account.member_state
        authority    = account.authority
        persona      = account.persona[0]
        language     = language_cache[persona.dec_value(:enc_lang_name_cd)]
        @member_state  = member_state.member_state
        @member_state_cls = member_state.member_state_cls
        @authority   = authority.authority
        @authority_cls = authority.authority_cls
        @nickname    = persona.dec_value(:enc_nickname)
        @name_1      = nil
        @name_2      = nil
        @name_kana_1 = nil
        @name_kana_2 = nil
        @gender_cls  = account.dec_value(:enc_gender_cls)
        @gender      = gender_cache[@gender_cls].gender
        @birthday    = Time.parse(account.dec_value(:enc_birth_date))
        @country_name_cd = persona.dec_value(:enc_country_name_cd)
        @country_name  = country_cache[@country_name_cd].country_name
        @lang_name_cd  = persona.dec_value(:enc_lang_name_cd)
        @lang_name   = language.lang_name
        @timezone_id = persona.dec_value(:enc_timezone_id)
        @postcode    = persona.dec_value(:enc_postcode)
        @email       = persona.dec_value(:enc_email)
        @mobile_phone_no = persona.dec_value(:enc_mobile_phone_no)
        @mobile_email  = persona.dec_value(:enc_mobile_email)
        @mobile_email_local = @mobile_email.sub(/@.+?$/, '')
        @mobile_carrier_id = persona.mobile_carrier_id
        # 名前ヨミガナ設定
        if Language::NOTATION_CLS_LF == language.name_notation_cls then
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
        #######################################################################
        # 項目値（更新後）
        #######################################################################
        @upd_member_state_cls = @params[:upd_member_state_cls]
        @upd_authority_cls    = @params[:upd_authority_cls]
        if admin? then
          @upd_member_state_cls ||= @member_state_cls
          @upd_authority_cls    ||= @authority_cls
        else
          # 一般ユーザーによる更新の場合には、仮更新のステータスを設定
          @upd_member_state_cls ||= MemberState::MEMBER_STATE_CLS_UPDATE # DEBUGコード
          @upd_authority_cls    ||= @authority_cls                       # DEBUGコード
        end
        @upd_member_state  = member_state_cache[@upd_member_state_cls].member_state
        @upd_authority     = authority_cache[@upd_authority_cls].authority
        @upd_password    = @params[:upd_password]
        @upd_retype_pw   = @params[:upd_retype_pw]
        @upd_nickname    = @params[:upd_nickname]
        @upd_nickname    ||= @nickname
        @upd_name_1      = @params[:upd_name_1]
        @upd_name_1      ||= @name_1
        @upd_name_2      = @params[:upd_name_2]
        @upd_name_2      ||= @name_2
        @upd_name_kana_1 = @params[:upd_name_kana_1]
        @upd_name_kana_1 ||= @name_kana_1
        @upd_name_kana_2 = @params[:upd_name_kana_2]
        @upd_name_kana_2 ||= @name_kana_2
        @upd_last_name       = nil
        @upd_first_name      = nil
        @upd_yomigana_last   = nil
        @upd_yomigana_first  = nil
        @upd_gender_cls  = @params[:upd_gender]
        @upd_gender_cls  ||= @gender_cls
        @upd_gender      = gender_cache[@upd_gender_cls].gender
        @upd_birthday    = date_time_param(:upd_birth)
        @upd_birthday    ||= @birthday
        @upd_country_name_cd = @params[:upd_country]
        @upd_country_name_cd ||= @country_name_cd
        @upd_country_name  = country_cache[@upd_country_name_cd].country_name
        @upd_lang_name_cd  = @params[:upd_lang_name_cd]
        @upd_lang_name_cd  ||= @lang_name_cd
        @upd_lang_name   = language_cache[@upd_lang_name_cd].lang_name
        @upd_timezone_id = @params[:upd_timezone]
        @upd_timezone_id ||= @timezone_id
        @upd_postcode    = @params[:upd_postcode]
        @upd_postcode    ||= @postcode
        @upd_email       = @params[:upd_email]
        @upd_email       ||= @email
        @upd_mobile_phone_no = @params[:upd_mobile_num]
        @upd_mobile_phone_no ||= @mobile_phone_no
        @upd_mobile_email_local = @params[:upd_mobile_email_local]
        @upd_mobile_email_local ||= @mobile_email_local
        @upd_mobile_carrier_id  = @params[:upd_mobile_email_domain]
        @upd_mobile_carrier_id  ||= @mobile_carrier_id
        @upd_mobile_email    = nil
        # 名前ヨミガナ設定
        unless @upd_lang_name_cd.nil? then
          lang_ent = LanguageCache.instance[@upd_lang_name_cd]
          if Language::NOTATION_CLS_LF == lang_ent.name_notation_cls then
            @upd_last_name      = @params[:upd_name_1]
            @upd_last_name      ||= @name_1
            @upd_first_name     = @params[:upd_name_2]
            @upd_first_name     ||= @name_2
            @upd_yomigana_last  = @params[:upd_name_kana_1]
            @upd_yomigana_last  ||= @name_kana_1
            @upd_yomigana_first = @params[:upd_name_kana_2]
            @upd_yomigana_first ||= @name_kana_2
          else
            @upd_first_name     = @params[:upd_name_1]
            @upd_first_name     ||= @name_1
            @upd_last_name      = @params[:upd_name_2]
            @upd_last_name      ||= @name_2
            @upd_yomigana_first = @params[:upd_name_kana_1]
            @upd_yomigana_first ||= @name_kana_1
            @upd_yomigana_last  = @params[:upd_name_kana_2]
            @upd_yomigana_last  ||= @name_kana_2
          end
        end
        # 携帯メールアドレス
        mbl_ent = mobile_carrier_cache[@upd_mobile_carrier_id]
        @upd_mobile_email = @upd_mobile_email_local.to_s + '@' + mbl_ent.domain.to_s unless mbl_ent.nil?
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 管理者判定
      def admin?
        return Authority::AUTHORITY_CLS_ADMIN == @session[:authority_cls]
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック（更新項目）
      def upd_item_chk?
        check_result = true
        # ユーザーIDチェック
        if blank?(@user_id) then
          @error_msg_hash[:user_id] = error_msg('open_id', :blank)
          check_result = false
        elsif overflow?(@user_id, 32) then
          @error_msg_hash[:user_id] = error_msg('open_id', :too_long, :count=>32)
          check_result = false
        elsif (/^[\w\-]*$/ =~ @user_id).nil? then
          @error_msg_hash[:user_id] = error_msg('open_id', :invalid)
          check_result = false
        end
        # パスワード
        if blank?(@upd_password) then
          @error_msg_hash[:upd_password] = error_msg('password', :blank)
          check_result = false
        elsif !overflow?(@upd_password, 11) then
          @error_msg_hash[:upd_password] = error_msg('password', :too_short, :count=>11)
          check_result = false
        elsif overflow?(@upd_password, 64) then
          @error_msg_hash[:upd_password] = error_msg('password', :too_long, :count=>64)
          check_result = false
        elsif !hankaku?(@upd_password) then
          @error_msg_hash[:upd_password] = error_msg('password', :invalid)
          check_result = false
        end
        # パスワード（再入力）
        if blank?(@upd_retype_pw) then
          @error_msg_hash[:upd_retype_pw] = error_msg('retype_pw', :blank)
          check_result = false
        end
        # 会員状態
        if blank?(@upd_member_state_cls) then
          @error_msg_hash[:upd_member_state_cls] = error_msg('member_state', :blank)
          check_result = false
        elsif !length_is?(@upd_member_state_cls, 3) then
          @error_msg_hash[:upd_member_state_cls] = error_msg('member_state', :wrong_length, :count=>3)
          check_result = false
        end
        # 権限
        if blank?(@upd_authority_cls) then
          @error_msg_hash[:upd_authority_cls] = error_msg('authority', :blank)
          check_result = false
        elsif !length_is?(@upd_authority_cls, 3) then
          @error_msg_hash[:upd_authority_cls] = error_msg('authority', :wrong_length, :count=>3)
          check_result = false
        end
        # ニックネーム
        if blank?(@upd_nickname) then
          @error_msg_hash[:upd_nickname] = error_msg('nickname', :blank)
          check_result = false
        elsif overflow?(@upd_nickname, 20) then
          @error_msg_hash[:upd_nickname] = error_msg('nickname', :too_long, :count=>20)
          check_result = false
        end
        # 名前（名）
        if blank?(@upd_first_name) then
          @error_msg_hash[:upd_name] = error_msg('first_name', :blank)
          check_result = false
        elsif overflow?(@upd_first_name, 20) then
          @error_msg_hash[:upd_name] = error_msg('first_name', :too_long, :count=>20)
          check_result = false
        end
        # 名前（姓）
        if blank?(@upd_last_name) then
          @error_msg_hash[:upd_name] = error_msg('last_name', :blank)
          check_result = false
        elsif overflow?(@upd_last_name, 20) then
          @error_msg_hash[:upd_name] = error_msg('last_name', :too_long, :count=>20)
          check_result = false
        end
        # ヨミガナ（名）
        if blank?(@upd_yomigana_first) then
          @error_msg_hash[:upd_name_kana] = error_msg('yomigana_first', :blank)
          check_result = false
        elsif overflow?(@upd_yomigana_first, 30) then
          @error_msg_hash[:upd_name_kana] = error_msg('yomigana_first', :too_long, :count=>30)
          check_result = false
        elsif !yomigana?(@upd_yomigana_first) then
          @error_msg_hash[:upd_name_kana] = error_msg('yomigana_first', :invalid)
          check_result = false
        end
        # ヨミガナ（姓）
        if blank?(@upd_yomigana_last) then
          @error_msg_hash[:upd_name_kana] = error_msg('yomigana_last', :blank)
          check_result = false
        elsif overflow?(@upd_yomigana_last, 30) then
          @error_msg_hash[:upd_name_kana] = error_msg('yomigana_last', :too_long, :count=>30)
          check_result = false
        elsif !yomigana?(@upd_yomigana_last) then
          @error_msg_hash[:upd_name_kana] = error_msg('yomigana_last', :invalid)
          check_result = false
        end
        # 性別
        if blank?(@upd_gender_cls) then
          @error_msg_hash[:upd_gender] = error_msg('gender', :blank)
          check_result = false
        elsif !alphabetic?(@upd_gender_cls) then
          @error_msg_hash[:upd_gender] = error_msg('gender', :invalid)
          check_result = false
        end
        # 誕生日
        if blank?(@upd_birthday) then
          @error_msg_hash[:upd_birth] = error_msg('birthday', :blank)
          check_result = false
        elsif !past_date?(@upd_birthday.year, @upd_birthday.month, @upd_birthday.day) then
          @error_msg_hash[:upd_birth] = error_msg('birthday', :past_date)
          check_result = false
        end
        # 国名コード
        if blank?(@upd_country_name_cd) then
          @error_msg_hash[:upd_country] = error_msg('country', :blank)
          check_result = false
        elsif !length_is?(@upd_country_name_cd, 2) then
          @error_msg_hash[:upd_country] = error_msg('country', :wrong_length, :count=>3)
          check_result = false
        elsif !alphabetic?(@upd_country_name_cd) then
          @error_msg_hash[:upd_country] = error_msg('country', :invalid)
          check_result = false
        end
        # 言語名コード
        if blank?(@upd_lang_name_cd) then
          @error_msg_hash[:upd_language] = error_msg('language', :blank)
          check_result = false
        elsif !length_is?(@upd_lang_name_cd, 2) then
          @error_msg_hash[:upd_language] = error_msg('language', :wrong_length, :count=>2)
          check_result = false
        elsif !alphabetic?(@upd_lang_name_cd) then
          @error_msg_hash[:upd_language] = error_msg('language', :invalid)
          check_result = false
        end
        # タイムゾーンID
        if blank?(@upd_timezone_id) then
          @error_msg_hash[:upd_timezone] = error_msg('timezone', :blank)
          check_result = false
        elsif overflow?(@upd_timezone_id, 255) then
          @error_msg_hash[:upd_timezone] = error_msg('timezone', :too_long, :count=>255)
          check_result = false
        elsif !hankaku?(@upd_timezone_id) then
          @error_msg_hash[:upd_timezone] = error_msg('timezone', :invalid)
          check_result = false
        end
        # 郵便番号
        if blank?(@upd_postcode) then
          @error_msg_hash[:upd_postcode] = error_msg('postcode', :blank)
          check_result = false
        elsif overflow?(@upd_postcode, 9) then
          @error_msg_hash[:upd_postcode] = error_msg('postcode', :too_long, :count=>9)
          check_result = false
        elsif @upd_country_name_cd == 'JPN' && !length_is?(@upd_postcode, 7) then
          @error_msg_hash[:upd_postcode] = error_msg('postcode', :wrong_length, :count=>7)
          check_result = false
        elsif !numeric?(@upd_postcode) then
          @error_msg_hash[:upd_postcode] = error_msg('postcode', :invalid)
          check_result = false
        end
        # メールアドレス
        if blank?(@upd_email) then
          @error_msg_hash[:upd_email] = error_msg('email', :blank)
          check_result = false
        elsif !valid_email?(@upd_email) then
          @error_msg_hash[:upd_email] = error_msg('email', :invalid)
          check_result = false
        end
        # 携帯電話番号
        if blank?(@upd_mobile_phone_no) then
          @error_msg_hash[:upd_mobile_num] = error_msg('mobile_num', :blank)
          check_result = false
        elsif !mobile_phone_no?(@upd_mobile_phone_no) then
          @error_msg_hash[:upd_mobile_num] = error_msg('mobile_num', :invalid)
          check_result = false
        end
        # 携帯メールアドレス
        if blank?(@upd_mobile_email) || blank?(@upd_mobile_carrier_id) then
          @error_msg_hash[:upd_mobile_email] = error_msg('mobile_email', :blank)
          check_result = false
        elsif !valid_email?(@upd_mobile_email) then
          @error_msg_hash[:upd_mobile_email] = error_msg('mobile_email', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # 項目関連チェック（アカウント情報）
      def account_item_rel_chk?
        # パスワードの再入力チェック
        if @password != @retype_pw then
          @error_msg_hash[:upd_retype_pw] = error_msg('retype_pw', :invalid)
          return false
        end
        return true
      end
      
      # DB関連チェック（アカウント）
      def account_db_chk?
        # ユーザー情報の有無判定
        account = AccountCache.instance.user_id_rec(@user_id)
        if account.nil? then
          @error_msg_hash[:user_id] = error_msg('open_id', :inclusion)
          return false
        end
        return true
      end
      
      # DB関連チェック（ペルソナ）
      def persona_db_chk?
        cache = AccountCache.instance
        # 携帯電話番号の有無判定
        if cache.mobile_phone_no_exist?(@upd_mobile_phone_no) then
          @error_msg_hash[:upd_mobile_num] = error_msg('mobile_num', :exclusion)
          return false
        end
        # 携帯メールの有無判定
        if cache.mobile_email_exist?(@upd_mobile_email) then
          @error_msg_hash[:upd_mobile_email] = error_msg('mobile_email', :exclusion)
          return false
        end
        return true
      end
      
      # DB関連チェック（会員状態）
      def member_state_db_chk?
        # 会員状態チェック
        if !MemberStateCache.instance.exist?(@upd_member_state_cls) then
          @error_msg_hash[:upd_member_state] = error_msg('member_state', :invalid)
          return false
        end
        return true
      end
      
      # DB関連チェック（権限）
      def authority_db_chk?
        # 権限チェック
        if !AuthorityCache.instance.exist?(@upd_authority_cls) then
          @error_msg_hash[:upd_authority_cls] = error_msg('authority_cls', :invalid)
          return false
        end
        return true
      end
      
      # DB関連チェック（性別）
      def gender_db_chk?
        # 性別区分チェック
        if !GenderCache.instance.exist?(@upd_gender_cls) then
          @error_msg_hash[:upd_gender] = error_msg('gender', :invalid)
          return false
        end
        return true
      end
      
      # DB関連チェック（国）
      def country_db_chk?
        # 国コードチェック
        if !CountryCache.instance.exist?(@upd_country_name_cd) then
          @error_msg_hash[:upd_country] = error_msg('country', :invalid)
          return false
        end
        return true
      end
      
      # DB関連チェック（言語）
      def language_db_chk?
        # 言語名コードチェック
        if !LanguageCache.instance.exist?(@upd_lang_name_cd) then
          @error_msg_hash[:upd_language] = error_msg('language', :invalid)
          return false
        end
        return true
      end
     
      # DB関連チェック（タイムゾーン）
      def timezone_db_chk?
        # タイムゾーンIDチェック
        if !TimezoneCache.instance.exist?(@upd_timezone_id) then
          @error_msg_hash[:upd_timezone] = error_msg('timezone', :invalid)
          return false
        end
        return true
      end
     
      # DB関連チェック（携帯キャリア）
      def mobile_carrier_db_chk?
        # 携帯キャリアコードチェック
        if !MobileCarrierCache.instance.exist?(@upd_mobile_carrier_id) then
          @error_msg_hash[:upd_mobile_email] = error_msg('mobile_email', :invalid)
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