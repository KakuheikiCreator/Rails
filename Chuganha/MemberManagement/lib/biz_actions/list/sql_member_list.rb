# -*- coding: utf-8 -*-
###############################################################################
# 会員情報一覧検索SQL生成クラス
# 概要：会員データを問い合わせるSELECT文とバインド変数を生成する
# コントローラー：List::ListController
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/19 Nakanohito
# 更新日:
###############################################################################
require 'common/validation_chk_module'
require 'common/code_conv/encryption_setting'
require 'common/model/db_util_module'
require 'data_cache/mobile_carrier_cache'

module BizActions
  module List
    class SQLMemberList
      include Common::ValidationChkModule
      include Common::CodeConv
      include Common::Model::DbUtilModule
      include DataCache
      # アクセサー定義
      attr_reader :statement, :bind_params, :sql_params
      #########################################################################
      # メソッド定義
      #########################################################################
      # 初期化メソッド
      def initialize(params)
        # 暗号化項目値開始位置
        @enc_val_pos = EncryptionSetting.instance.encryption_salt_size + 1
        # パラメータ
        @params = params
        # バインド変数配列
        @bind_params = Array.new
        # SELECT文
        @statement = generate_select
        # SQLパラメータ
        @sql_params = @bind_params.dup.unshift(@statement)
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # SELECT文生成
      def generate_select
        sql_array = Array.new
        sql_array.push('SELECT ')
        sql_array.push(part_of_item)
        # FROM句
        sql_array.push(' FROM ')
        sql_array.push(part_of_tables)
        # WHERE句
        part_of_where(sql_array)
        # ORDER BY句
        part_of_order(sql_array)
        # LIMIT句
        sql_array.push(' LIMIT ')
        sql_array.push(part_of_limit)
        return sql_array.join
      end
      
      # 項目リスト生成
      def part_of_item
        item_sql = Array.new
        item_sql.push('accounts.id')
        item_sql.push('accounts.user_id')
        item_sql.push('accounts.member_state_id')
        item_sql.push('accounts.enc_authority_cls')
        item_sql.push('accounts.join_date')
        item_sql.push('accounts.enc_last_name')
        item_sql.push('accounts.enc_first_name')
        item_sql.push('accounts.enc_yomigana_last')
        item_sql.push('accounts.enc_yomigana_first')
        item_sql.push('accounts.enc_gender_cls')
        item_sql.push('personas.enc_nickname')
        item_sql.push('personas.enc_postcode')
        item_sql.push('authentication_histories.authentication_date')
        return item_sql.join(',')
      end
      
      # テーブルリスト生成
      def part_of_tables
        tables_sql = Array.new
        tables_sql.push('accounts inner join personas on accounts.id = personas.account_id')
        tables_sql.push(' left join authentication_histories on')
        tables_sql.push(' accounts.id = authentication_histories.account_id AND')
        tables_sql.push(' accounts.last_auth_seq_no = authentication_histories.seq_no')
        return tables_sql.join
      end
      
      # 抽出条件生成
      def part_of_where(sql_array)
        where_sql = Array.new
        # 抽出条件（削除フラグ）
        where_sql.push('accounts.delete_flg = ?')
        @bind_params.push(false)
        # 抽出条件（UserID）
        cond_user_id = @params[:cond_user_id].to_s
        unless blank?(cond_user_id) then
          cond_user_id_match = @params[:cond_user_id_match].to_s
          where_sql.push(match_statement('accounts.user_id', cond_user_id_match))
          @bind_params.push(match_param(cond_user_id, cond_user_id_match))
        end
        # 抽出条件（会員状態）
        cond_member_state_id = @params[:cond_member_state_id]
        unless blank?(cond_member_state_id) then
          where_sql.push('accounts.member_state_id = ?')
          @bind_params.push(cond_member_state_id.to_i)
        end
        # 抽出条件（権限）
        cond_authority_cls = @params[:cond_authority_cls].to_s
        unless blank?(cond_authority_cls) then
          where_sql.push(dec_match_statement('accounts.enc_authority_cls'))
          @bind_params.push(cond_authority_cls)
        end
        # 抽出条件（入会日時）
        cond_join_date = @params[:cond_join_date]
        unless blank?(cond_join_date) then
          cond_join_date_comp = @params[:cond_join_date_comp].to_s
          where_sql.push(comp_statement('accounts.join_date', cond_join_date_comp))
          @bind_params.push(cond_join_date)
        end
        # 名前（姓）
        cond_last_name = @params[:cond_last_name].to_s
        cond_name_match = @params[:cond_name_match].to_s
        unless blank?(cond_last_name) then
          where_sql.push(dec_match_statement('accounts.enc_last_name', cond_name_match))
          @bind_params.push(match_param(cond_last_name, cond_name_match))
        end
        # 名前（名）
        cond_first_name = @params[:cond_first_name].to_s
        unless blank?(cond_first_name) then
          where_sql.push(dec_match_statement('accounts.enc_first_name', cond_name_match))
          @bind_params.push(match_param(cond_first_name, cond_name_match))
        end
        # ヨミガナ（姓）
        cond_yomigana_last = @params[:cond_yomigana_last].to_s
        cond_yomigana_match = @params[:cond_yomigana_match].to_s
        unless blank?(cond_yomigana_last) then
          where_sql.push(dec_match_statement('accounts.enc_yomigana_last', cond_yomigana_match))
          @bind_params.push(match_param(cond_yomigana_last, cond_yomigana_match))
        end
        # ヨミガナ（名）
        cond_yomigana_first = @params[:cond_yomigana_first].to_s
        unless blank?(cond_yomigana_first) then
          where_sql.push(dec_match_statement('accounts.enc_yomigana_first', cond_yomigana_match))
          @bind_params.push(match_param(cond_yomigana_first, cond_yomigana_match))
        end
        # 性別
        cond_gender_cls = @params[:cond_gender].to_s
        unless blank?(cond_gender_cls) then
          where_sql.push(dec_match_statement('accounts.enc_gender_cls'))
          @bind_params.push(cond_gender_cls)
        end
        # 生年月日
        cond_birthday = @params[:cond_birthday].to_s
        unless blank?(cond_birthday) then
          cond_birthday_comp = @params[:cond_birthday_comp].to_s
          where_sql.push(dec_comp_statement('accounts.enc_birth_date', cond_birthday_comp))
          @bind_params.push(cond_birthday)
        end
        # ニックネーム
        cond_nickname = @params[:cond_nickname].to_s
        unless blank?(cond_nickname) then
          cond_nickname_match = @params[:cond_nickname_match].to_s
          where_sql.push(dec_match_statement('personas.enc_nickname', cond_nickname_match))
          @bind_params.push(match_param(cond_nickname, cond_nickname_match))
        end
        # 居住国
        cond_country_name_cd = @params[:cond_country_name_cd].to_s
        unless blank?(cond_country_name_cd) then
          where_sql.push(dec_match_statement('personas.enc_country_name_cd'))
          @bind_params.push(cond_country_name_cd)
        end
        # 言語
        cond_lang_name_cd = @params[:cond_lang_name_cd].to_s
        unless blank?(cond_lang_name_cd) then
          where_sql.push(dec_match_statement('personas.enc_lang_name_cd'))
          @bind_params.push(cond_lang_name_cd)
        end
        # タイムゾーン
        cond_timezone = @params[:cond_timezone].to_s
        unless blank?(cond_timezone) then
          where_sql.push(dec_match_statement('personas.enc_timezone_id'))
          @bind_params.push(cond_timezone)
        end
        # 郵便番号
        cond_postcode = @params[:cond_postcode].to_s
        unless blank?(cond_postcode) then
          cond_postcode_match = @params[:cond_postcode_match].to_s
          where_sql.push(dec_match_statement('personas.enc_postcode', cond_postcode_match))
          @bind_params.push(match_param(cond_postcode, cond_postcode_match))
        end
        # メール
        cond_email = @params[:cond_email].to_s
        unless blank?(cond_email) then
          cond_email_match = @params[:cond_email_match].to_s
          where_sql.push(dec_match_statement('personas.enc_email', cond_email_match))
          @bind_params.push(match_param(cond_email, cond_email_match))
        end
        # 携帯電話番号
        cond_mobile_phone_no = @params[:cond_mobile_phone_no].to_s
        unless blank?(cond_mobile_phone_no) then
          cond_mbl_num_match = @params[:cond_mbl_num_match].to_s
          where_sql.push(dec_match_statement('personas.enc_mobile_phone_no', cond_mbl_num_match))
          @bind_params.push(match_param(cond_mobile_phone_no, cond_mbl_num_match))
        end
        # 携帯キャリア
        cond_mobile_carrier_cd = @params[:cond_mobile_carrier_cd].to_s
        unless blank?(cond_mobile_carrier_cd) then
          ques_list = Array.new
          MobileCarrierCache.instance.id_list(cond_mobile_carrier_cd).each do |id|
            ques_list.push('?')
            @bind_params.push(id)
          end          
          where_sql.push('personas.mobile_carrier_id IN(' + ques_list.join(',') + ')')
        end
        # 携帯メール
        cond_mobile_email = @params[:cond_mobile_email].to_s
        unless blank?(cond_mobile_email) then
          cond_mbl_email_match = @params[:cond_mbl_email_match].to_s
          where_sql.push(dec_match_statement('personas.enc_mobile_email', cond_mbl_email_match))
          @bind_params.push(match_param(cond_mobile_email, cond_mbl_email_match))
        end
        # 個体識別番号
        cond_mobile_id_no = @params[:cond_mobile_id_no].to_s
        unless blank?(cond_mobile_id_no) then
          cond_mbl_id_match = @params[:cond_mbl_id_match].to_s
          where_sql.push(dec_match_statement('personas.enc_mobile_id_no', cond_mbl_id_match))
          @bind_params.push(match_param(cond_mobile_id_no, cond_mbl_id_match))
        end
        # 最終認証日時
        cond_last_auth_date = @params[:cond_last_auth_date]
        unless blank?(cond_last_auth_date) then
          cond_last_auth_comp = @params[:cond_last_auth_comp].to_s
          where_sql.push(comp_statement('authentication_histories.authentication_date', cond_last_auth_comp))
          @bind_params.push(cond_last_auth_date)
        end
        return if where_sql.empty?
        sql_array.push(' WHERE ')
        sql_array.push(where_sql.join(' AND '))
      end
      
      # OrderBy句生成
      def part_of_order(sql_array)
        field_1 = @params[:sort_field_1]
        field_2 = @params[:sort_field_2]
        field_3 = @params[:sort_field_3]
        return if blank?(field_1) && blank?(field_2) && blank?(field_3)
        sql_array.push(' ORDER BY ')
        order_sql = Array.new
        order_sql.push(order_statement(field_1, @params[:sort_order_1])) unless blank?(field_1)
        order_sql.push(order_statement(field_2, @params[:sort_order_2])) unless blank?(field_2)
        order_sql.push(order_statement(field_3, @params[:sort_order_3])) unless blank?(field_3)
        sql_array.push(order_sql.join(','))
      end
      
      # Limit句生成
      def part_of_limit
        # 次ページ判定の為に＋１件検索
        limit_cnt = @params[:cond_display_count]
        page_num  = @params[:cond_page_num]
        unless numeric?(page_num) then
          @bind_params.push(limit_cnt.to_i + 1)
          return '?'
        end
        offset = (page_num.to_i - 1) * limit_cnt.to_i
        @bind_params.push(offset.to_i)
        @bind_params.push(limit_cnt.to_i + 1)
        return '?, ?'
      end
      
      # 項目復号化文生成
      def dec_item_statement(item)
        return 'SUBSTRING(CONVERT(AES_DECRYPT(' + item + ', @PW), CHAR), ' + @enc_val_pos.to_s + ')'
      end
      
      # 復号化コンペア条件生成
      def dec_comp_statement(item, comp_cond='EQ')
        return comp_statement(dec_item_statement(item), comp_cond)
      end
      
      # 復号化マッチング条件生成
      def dec_match_statement(item, match_cond='E')
        return match_statement(dec_item_statement(item), match_cond)
      end
      
      # 復号化マッチングパラメータ生成
      def order_statement(item_name, order)
        table_name = nil
        if Account.attribute_names.include?(item_name) then
          table_name = 'accounts.'
        elsif Persona.attribute_names.include?(item_name) then
          table_name = 'personas.'
        elsif AuthenticationHistory.attribute_names.include?(item_name) then
          table_name = 'authentication_histories.'
        end
        return table_name + item_name + ' ' + order unless table_name.nil?
        # 暗号化項目処理
        case item_name
        when 'authority_cls' then
          table_name = 'accounts.'
        when 'last_name' then
          table_name = 'accounts.'
        when 'first_name' then
          table_name = 'accounts.'
        when 'yomigana_last' then
          table_name = 'accounts.'
        when 'yomigana_first' then
          table_name = 'accounts.'
        when 'gender_cls' then
          table_name = 'accounts.'
        when 'birth_date' then
          table_name = 'accounts.'
        when 'nickname' then
          table_name = 'personas.'
        when 'country_name_cd' then
          table_name = 'personas.'
        when 'lang_name_cd' then
          table_name = 'personas.'
        when 'timezone_id' then
          table_name = 'personas.'
        when 'postcode' then
          table_name = 'personas.'
        when 'email' then
          table_name = 'personas.'
        when 'mobile_phone_no' then
          table_name = 'personas.'
        when 'mobile_id_no' then
          table_name = 'personas.'
        when 'mobile_email' then
          table_name = 'personas.'
        end
        return dec_item_statement(table_name + 'enc_' + item_name) + ' ' + order
      end
    end
  end
end