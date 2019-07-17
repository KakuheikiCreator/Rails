# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員情報一覧基底アクションクラス
# コントローラー：List::ListController
# アクション：list
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/18 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'
require 'biz_actions/business_action'
require 'biz_common/business_config'
require 'data_cache/member_state_cache'
require 'data_cache/authority_cache'
require 'data_cache/gender_cache'
require 'data_cache/country_cache'
require 'data_cache/language_cache'
require 'data_cache/timezone_cache'
require 'data_cache/mobile_carrier_cache'

module BizActions
  module List
    class BaseAction < BizActions::BusinessAction
      include Common::NetUtilModule
      include DataCache
      include BizCommon
      # リーダー
      attr_reader :cond_user_id, :cond_user_id_match, :cond_member_state_cls, :cond_authority_cls,
                  :cond_join_date, :cond_join_date_comp,:cond_nickname, :cond_nickname_match,
                  :cond_last_name, :cond_first_name, :cond_name_match,
                  :cond_yomigana_last, :cond_yomigana_first, :cond_yomigana_match,
                  :cond_gender_cls, :cond_birthday, :cond_birthday_comp, :cond_country_name_cd,
                  :cond_lang_name_cd, :cond_timezone_id, :cond_postcode, :cond_postcode_match,
                  :cond_email, :cond_email_match, :cond_mobile_phone_no, :cond_mbl_num_match,
                  :cond_mobile_carrier_cd, :cond_mobile_email, :cond_mbl_email_match,
                  :cond_mobile_id_no, :cond_mbl_id_match, :cond_last_auth_date, :cond_last_auth_comp,
                  :sort_field_1, :sort_field_2, :sort_field_3,
                  :sort_order_1, :sort_order_2, :sort_order_3,
                  :cond_display_count, :cond_page_num, :prev_page_flg, :next_page_flg,
                  :member_state_list, :authority_list, :gender_list, :country_list,
                  :language_list, :timezone_list, :mobile_carrier_list, :member_list
      
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 項目名ヘッダー
        @msg_headder = ''
        #######################################################################
        # キャッシュデータ
        #######################################################################
        @generic_code_cache = GenericCodeCache.instance
        member_state_cache = MemberStateCache.instance
        authority_cache = AuthorityCache.instance
        gender_cache   = GenderCache.instance
        country_cache  = CountryCache.instance
        language_cache = LanguageCache.instance
        timezone_cache = TimezoneCache.instance
        mobile_carrier_cache = MobileCarrierCache.instance
        
        #######################################################################
        # マスタデータ
        #######################################################################
        @member_state_list   = member_state_cache.member_state_list
        @authority_list  = authority_cache.authority_list
        @gender_list   = gender_cache.gender_list
        @country_list  = country_cache.country_list
        @language_list = language_cache.language_list
        @timezone_list = timezone_cache.timezone_list
        @mobile_carrier_list = mobile_carrier_cache.mobile_carrier_list
        
        #######################################################################
        # 検索結果
        #######################################################################
        @member_list = Array.new
        
        #######################################################################
        # 検索条件
        #######################################################################
        @cond_user_id     = @params[:cond_user_id]
        @cond_user_id_match    = @params[:cond_user_id_match]
        @cond_member_state_cls = @params[:cond_member_state_cls]
        @cond_member_state_id  = nil
        @cond_authority_cls    = @params[:cond_authority_cls]
        @cond_join_date   = date_time_param(:cond_join)
        @cond_join_date_comp   = @params[:cond_join_date_comp]
        @cond_nickname    = @params[:cond_nickname]
        @cond_nickname_match   = @params[:cond_nickname_match]
        @cond_last_name       = @params[:cond_last_name]
        @cond_first_name      = @params[:cond_first_name]
        @cond_name_match  = @params[:cond_name_match]
        @cond_yomigana_last   = @params[:cond_yomigana_last]
        @cond_yomigana_first  = @params[:cond_yomigana_first]
        @cond_yomigana_match  = @params[:cond_yomigana_match]
        @cond_gender_cls  = @params[:cond_gender]
        @cond_birthday    = date_time_param(:cond_birth)
        @cond_birthday_comp   = @params[:cond_birthday_comp]
        @cond_country_name_cd = @params[:cond_country_name_cd]
        @cond_lang_name_cd    = @params[:cond_lang_name_cd]
        @cond_timezone_id = @params[:cond_timezone]
        @cond_postcode    = @params[:cond_postcode]
        @cond_postcode_match  = @params[:cond_postcode_match]
        @cond_email       = @params[:cond_email]
        @cond_email_match     = @params[:cond_email_match]
        @cond_mobile_phone_no = @params[:cond_mobile_phone_no]
        @cond_mbl_num_match   = @params[:cond_mbl_num_match]
        @cond_mobile_carrier_cd = @params[:cond_mobile_carrier_cd]
        @cond_mobile_email    = @params[:cond_mobile_email]
        @cond_mbl_email_match   = @params[:cond_mbl_email_match]
        @cond_mobile_id_no    = @params[:cond_mobile_id_no]
        @cond_mbl_id_match    = @params[:cond_mbl_id_match]
        @cond_last_auth_date  = date_time_param(:cond_last_auth)
        @cond_last_auth_comp  = @params[:cond_last_auth_comp]
        # ソート条件
        @sort_field_1 = @params[:sort_field_1]
        @sort_field_2 = @params[:sort_field_2]
        @sort_field_3 = @params[:sort_field_3]
        @sort_order_1 = @params[:sort_order_1]
        @sort_order_2 = @params[:sort_order_2]
        @sort_order_3 = @params[:sort_order_3]
        # リミット件数
        @cond_display_count = @params[:cond_display_count]
        @cond_page_num = @params[:cond_page_num]
        @cond_page_num ||= '1'
        # 次ページ存在フラグ
        @prev_page_flg = false
        @next_page_flg = false
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック（アカウント抽出条件）
      def cond_account_item_chk?
        check_result = true
        # UserIDチェック
        unless blank?(@cond_user_id) then
          if overflow?(@cond_user_id, 32) then
            @error_msg_hash[:cond_user_id] = error_msg('user_id', :too_long, :count=>32)
            check_result = false
          elsif (/^[\w\-]*$/ =~ @cond_user_id).nil? then
            @error_msg_hash[:cond_user_id] = error_msg('user_id', :invalid)
            check_result = false
          end
          unless valid_match?(@cond_user_id_match) then
            @error_msg_hash[:cond_user_id] = error_msg('user_id', :invalid)
            check_result = false
          end
        end
        # 会員状態
        unless blank?(@cond_member_state_cls) then
          if !length_is?(@cond_member_state_cls, 3) then
            @error_msg_hash[:cond_member_state_cls] = error_msg('member_state', :wrong_length, :count=>3)
            check_result = false
          end
        end
        # 権限
        unless blank?(@cond_authority_cls) then
          if !length_is?(@cond_authority_cls, 3) then
            @error_msg_hash[:cond_authority_cls] = error_msg('authority', :wrong_length, :count=>3)
            check_result = false
          end
        end
        # 名前
        unless blank?(@cond_first_name) then
          # 名前（名）
          if overflow?(@cond_first_name, 20) then
            @error_msg_hash[:cond_name] = error_msg('name', :too_long, :count=>20)
            check_result = false
          end
        end
        # 名前（姓）
        unless blank?(@cond_last_name) then
          if overflow?(@cond_last_name, 20) then
            @error_msg_hash[:cond_name] = error_msg('name', :too_long, :count=>20)
            check_result = false
          end
        end
        unless valid_match?(@cond_name_match) then
          @error_msg_hash[:cond_name] = error_msg('name', :invalid)
          check_result = false
        end
        # ヨミガナ（名）
        unless blank?(@cond_yomigana_first) then
          if overflow?(@cond_yomigana_first, 30) then
            @error_msg_hash[:cond_yomigana] = error_msg('yomigana', :too_long, :count=>30)
            check_result = false
          elsif !yomigana?(@cond_yomigana_first) then
            @error_msg_hash[:cond_yomigana] = error_msg('yomigana', :invalid)
            check_result = false
          end
        end
        # ヨミガナ（姓）
        unless blank?(@cond_yomigana_last) then
          if overflow?(@cond_yomigana_last, 30) then
            @error_msg_hash[:cond_yomigana] = error_msg('yomigana', :too_long, :count=>30)
            check_result = false
          elsif !yomigana?(@cond_yomigana_last) then
            @error_msg_hash[:cond_yomigana] = error_msg('yomigana', :invalid)
            check_result = false
          end
        end
        unless valid_match?(@cond_yomigana_match) then
          @error_msg_hash[:cond_yomigana] = error_msg('yomigana', :invalid)
          check_result = false
        end
        # 性別
        unless blank?(@cond_gender_cls) then
          if !alphabetic?(@cond_gender_cls) then
            @error_msg_hash[:cond_gender] = error_msg('gender', :invalid)
            check_result = false
          end
        end
        # 誕生日
        unless blank?(@cond_birthday) then
          if !past_date?(@cond_birthday.year, @cond_birthday.month, @cond_birthday.day) then
            @error_msg_hash[:cond_birth] = error_msg('birthday', :past_date)
            check_result = false
          end
        end
        unless valid_comp?(@cond_birthday_comp) then
          @error_msg_hash[:cond_birth] = error_msg('birthday', :invalid)
          check_result = false
        end
        return check_result
      end

      # 単項目チェック（ペルソナ抽出条件）
      def cond_persona_item_chk?
        check_result = true
        # ニックネーム
        unless blank?(@cond_nickname) then
          if overflow?(@cond_nickname, 20) then
            @error_msg_hash[:cond_nickname] = error_msg('nickname', :too_long, :count=>20)
            check_result = false
          end
        end
        unless valid_match?(@cond_nickname_match) then
          @error_msg_hash[:cond_nickname] = error_msg('nickname', :invalid)
          check_result = false
        end
        # 国名コード
        unless blank?(@cond_country_name_cd) then
          if !length_is?(@cond_country_name_cd, 3) then
            @error_msg_hash[:cond_country_name_cd] = error_msg('country', :wrong_length, :count=>3)
            check_result = false
          elsif !alphabetic?(@cond_country_name_cd) then
            @error_msg_hash[:cond_country_name_cd] = error_msg('country', :invalid)
            check_result = false
          end
        end
        # 言語名コード
        unless blank?(@cond_lang_name_cd) then
          if !length_is?(@cond_lang_name_cd, 2) then
            @error_msg_hash[:cond_lang_name_cd] = error_msg('language', :wrong_length, :count=>2)
            check_result = false
          elsif !alphabetic?(@cond_lang_name_cd) then
            @error_msg_hash[:cond_lang_name_cd] = error_msg('language', :invalid)
            check_result = false
          end
        end
        # タイムゾーンID
        unless blank?(@cond_timezone_id) then
          if overflow?(@cond_timezone_id, 255) then
            @error_msg_hash[:cond_timezone] = error_msg('timezone', :too_long, :count=>255)
            check_result = false
          elsif !hankaku?(@cond_timezone_id) then
            @error_msg_hash[:cond_timezone] = error_msg('timezone', :invalid)
            check_result = false
          end
        end
        # 郵便番号
        unless blank?(@cond_postcode) then
          if overflow?(@cond_postcode, 9) then
            @error_msg_hash[:cond_postcode] = error_msg('postcode', :too_long, :count=>9)
            check_result = false
          elsif @cond_country_name_cd == 'JPN' && !length_is?(@cond_postcode, 7) then
            @error_msg_hash[:cond_postcode] = error_msg('postcode', :wrong_length, :count=>7)
            check_result = false
          elsif !numeric?(@cond_postcode) then
            @error_msg_hash[:cond_postcode] = error_msg('postcode', :invalid)
            check_result = false
          end
        end
        unless valid_match?(@cond_postcode_match) then
          @error_msg_hash[:cond_postcode] = error_msg('postcode', :invalid)
          check_result = false
        end
        # メールアドレス
        unless blank?(@cond_email) then
          if !hankaku?(@cond_email) then
            @error_msg_hash[:cond_email] = error_msg('email', :invalid)
            check_result = false
          elsif overflow?(@cond_email, 255) then
            @error_msg_hash[:cond_email] = error_msg('email', :too_long, :count=>255)
            check_result = false
          end
        end
        unless valid_match?(@cond_email_match) then
          @error_msg_hash[:cond_email] = error_msg('email', :invalid)
          check_result = false
        end
        # 携帯電話番号
        unless blank?(@cond_mobile_phone_no) then
          if !mobile_phone_no?(@cond_mobile_phone_no) then
            @error_msg_hash[:cond_mobile_num] = error_msg('mobile_num', :invalid)
            check_result = false
          end
        end
        unless valid_match?(@cond_mbl_num_match) then
          @error_msg_hash[:cond_mobile_num] = error_msg('mobile_num', :invalid)
          check_result = false
        end
        # 携帯キャリア
        unless blank?(@cond_mobile_carrier_cd) then
          if !length_is?(@cond_mobile_carrier_cd, 2) then
            @error_msg_hash[:@cond_mobile_carrier_cd] = error_msg('mobile_carrier', :wrong_length, :count=>2)
            check_result = false
          elsif !numeric?(@cond_mobile_carrier_cd) then
            @error_msg_hash[:@cond_mobile_carrier_cd] = error_msg('mobile_carrier', :invalid)
            check_result = false
          end
        end
        # 携帯メールアドレス
        unless blank?(@cond_mobile_email) then
          if !hankaku?(@cond_mobile_email) then
            @error_msg_hash[:cond_mobile_email] = error_msg('mobile_email', :invalid)
            check_result = false
          elsif overflow?(@cond_mobile_email, 255) then
            @error_msg_hash[:cond_mobile_email] = error_msg('mobile_email', :too_long, :count=>255)
            check_result = false
          end
        end
        unless valid_match?(@cond_mbl_email_match) then
          @error_msg_hash[:cond_mobile_email] = error_msg('mobile_email', :invalid)
          check_result = false
        end
        # 携帯個体識別番号
        unless blank?(@cond_mobile_id_no) then
          if !hankaku?(@cond_mobile_id_no) then
            @error_msg_hash[:cond_mobile_id_no] = error_msg('mobile_id_no', :invalid)
            check_result = false
          end
        end
        unless valid_match?(@cond_mbl_id_match) then
          @error_msg_hash[:cond_mobile_id_no] = error_msg('mobile_id_no', :invalid)
          check_result = false
        end
        return check_result
      end

      # 単項目チェック（認証履歴抽出条件）
      def cond_auth_history_item_chk?
        check_result = true
        # 最終認証日時
        unless blank?(@cond_last_auth_date) then
          if !valid_date?(@cond_last_auth_date.year, @cond_last_auth_date.month, @cond_last_auth_date.day) then
            @error_msg_hash[:cond_last_auth_date] = error_msg('last_auth_date', :invalid)
            check_result = false
          end
        end
        unless valid_comp?(@cond_last_auth_comp) then
          @error_msg_hash[:cond_last_auth_date] = error_msg('last_auth_date', :invalid)
          check_result = false
        end
        return check_result
      end

      # 単項目チェック（ソート条件）
      def cond_sort_chk?
        check_result = true
        # ソート項目１
        unless valid_sort_field?(@sort_field_1) then
          @error_msg_hash[:sort_cond] = error_msg('sort_items', :invalid)
          check_result = false
        end
        # ソート項目２
        unless valid_sort_field?(@sort_field_2) then
          @error_msg_hash[:sort_cond] = error_msg('sort_items', :invalid)
          check_result = false
        end
        # ソート項目３
        unless valid_sort_field?(@sort_field_3) then
          @error_msg_hash[:sort_cond] = error_msg('sort_items', :invalid)
          check_result = false
        end
        # ソート順序１
        unless valid_order?(@sort_order_1) then
          @error_msg_hash[:sort_cond] = error_msg('sort_items', :invalid)
          check_result = false
        end
        # ソート順序２
        unless valid_order?(@sort_order_2) then
          @error_msg_hash[:sort_cond] = error_msg('sort_items', :invalid)
          check_result = false
        end
        # ソート順序３
        unless valid_order?(@sort_order_3) then
          @error_msg_hash[:sort_cond] = error_msg('sort_items', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # 単項目チェック（抽出件数チェック）
      def cond_limit_chk?
        check_result = true
        unless valid_limit?(@cond_display_count) then
          @error_msg_hash[:display_number] = error_msg('display_number', :invalid)
          check_result = false
          @cond_display_count = '0'
        end
        # ページ番号チェック
        unless blank?(@cond_page_num) then
          if !numeric?(@cond_page_num) then
            @error_msg_hash[:cond_page_num] = error_msg('page_num', :invalid)
            check_result = false
          elsif @cond_page_num.to_i <= 0 then
            @error_msg_hash[:cond_page_num] = error_msg('page_num', :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # 項目関連チェック（ソート条件）
      def cond_sort_rel_chk?
        check_result = true
        fields_list = Array.new
        fields_list.push(@sort_field_1) unless blank?(@sort_field_1)
        fields_list.push(@sort_field_2) unless blank?(@sort_field_2)
        fields_list.push(@sort_field_3) unless blank?(@sort_field_3)
        item_cnt = fields_list.length
        return check_result if item_cnt == 0
        # 項目重複チェック
        unless fields_list.uniq.size == item_cnt then
          @error_msg_hash[:sort_cond] = error_msg('sort_items', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック（会員状態）
      def member_state_db_chk?
        check_result = true
        # 会員状態チェック
        unless blank?(@cond_member_state_cls) then
          cond_member_state = MemberStateCache.instance[@cond_member_state_cls]
          if cond_member_state.nil? then
            @error_msg_hash[:cond_member_state] = error_msg('member_state', :invalid)
            check_result = false
          else
            @cond_member_state_id = cond_member_state.id
          end
        end
        return check_result
      end
      
      # DB関連チェック（権限）
      def authority_db_chk?
        check_result = true
        # 権限チェック
        unless blank?(@cond_authority_cls) then
          if !AuthorityCache.instance.exist?(@cond_authority_cls) then
            @error_msg_hash[:cond_authority_cls] = error_msg('authority_cls', :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # DB関連チェック（性別）
      def gender_db_chk?
        check_result = true
        # 性別区分チェック
        unless blank?(@cond_gender_cls) then
          if !GenderCache.instance.exist?(@cond_gender_cls) then
            @error_msg_hash[:cond_gender] = error_msg('gender', :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # DB関連チェック（国）
      def country_db_chk?
        check_result = true
        # 国コードチェック
        unless blank?(@cond_country_name_cd) then
          if !CountryCache.instance.exist?(@cond_country_name_cd) then
            @error_msg_hash[:cond_country_name_cd] = error_msg('country', :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # DB関連チェック（言語）
      def language_db_chk?
        check_result = true
        # 言語名コードチェック
        unless blank?(@cond_lang_name_cd) then
          if !LanguageCache.instance.exist?(@cond_lang_name_cd) then
            @error_msg_hash[:cond_lang_name_cd] = error_msg('language', :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # DB関連チェック（タイムゾーン）
      def timezone_db_chk?
        check_result = true
        # タイムゾーンIDチェック
        unless blank?(@cond_timezone_id) then
          if !TimezoneCache.instance.exist?(@cond_timezone_id) then
            @error_msg_hash[:cond_timezone] = error_msg('timezone', :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # DB関連チェック（携帯キャリア）
      def mobile_carrier_db_chk?
        check_result = true
        # 携帯キャリアコードチェック
        unless blank?(@cond_mobile_carrier_cd) then
          if !MobileCarrierCache.instance.exist_cd?(@cond_mobile_carrier_cd) then
            @error_msg_hash[:cond_mobile_email] = error_msg('mobile_email', :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # 比較条件チェック
      def valid_comp?(comp_val)
        return @generic_code_cache.code_values(:COMP_COND_CLS).include?(comp_val)
      end
      
      # 比較条件チェック
      def valid_match?(match_val)
        return @generic_code_cache.code_values(:MATCH_COND_CLS).include?(match_val)
      end
      
      # ソート項目チェック
      def valid_sort_field?(item_name)
        return true if blank?(item_name)
        return @generic_code_cache.code_values(:SORT_FIELDS).include?(item_name)
      end
      
      # 並び順チェック
      def valid_order?(order)
        return @generic_code_cache.code_values(:SORT_ORDER_CLS).include?(order)
      end
      
      # リミット件数チェック
      def valid_limit?(limit_cnt)
        return @generic_code_cache.code_values(:COUNT_L).include?(limit_cnt)
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text(@msg_headder + '.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end