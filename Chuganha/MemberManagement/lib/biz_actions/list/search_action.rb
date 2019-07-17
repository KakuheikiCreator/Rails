# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員情報の一覧表示アクション
# コントローラー：List::ListController
# アクション：list
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/18 Nakanohito
# 更新日:
###############################################################################
require 'common/code_conv/encryption_setting'
require 'biz_actions/list/base_action'
require 'biz_actions/list/sql_member_list'

module BizActions
  module List
    class SearchAction < BizActions::List::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @msg_headder = 'list'
        @btn_val = @params[:commit]
        @search_page_num = search_page_number
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 会員検索処理
      def search_list?
        ActiveRecord::Base.transaction do
          return false unless valid?
          set_variable
          sql_params = @params.dup
          sql_params[:cond_member_state_id] = @cond_member_state_id
          sql_params[:cond_join_date] = @cond_join_date
          sql_params[:cond_birthday] = @cond_birthday
          sql_params[:cond_last_auth_date] = @cond_last_auth_date
          sql_params[:cond_page_num] = @search_page_num
          list_sql = SQLMemberList.new(sql_params)
          @member_list = Account.find_by_sql(list_sql.sql_params)
          clear_variable
          # 現在ページ情報更新
          @prev_page_flg = @search_page_num.to_i > 1
          @next_page_flg = @member_list.size > @cond_display_count.to_i
          @cond_page_num = @search_page_num
        end
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # アカウント抽出条件チェック
        check_result = cond_account_item_chk?
        # ペルソナ抽出条件チェック
        check_result = false unless cond_persona_item_chk?
        # 認証履歴抽出条件チェック
        check_result = false unless cond_auth_history_item_chk?
        # ソート条件チェック
        check_result = false unless cond_sort_chk?
        # 表示件数チェック
        check_result = false unless cond_limit_chk?
        # ページ判定
        if @btn_val == view_text('list.item_names.prev_page') && @cond_page_num == 1 then
          @error_msg_hash[:cond_page_num] = error_msg('cond_page_num', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # 項目関連チェック
      def related_items_chk?
        # ソート条件関係チェック
        return cond_sort_rel_chk?
      end
      
      # DB関連チェック
      def db_related_chk?
        # 会員状態存在チェック
        check_result = member_state_db_chk?
        # 権限存在チェック
        check_result = false unless authority_db_chk?
        # 性別存在チェック
        check_result = false unless gender_db_chk?
        # 国存在チェック
        check_result = false unless country_db_chk?
        # 言語存在チェック
        check_result = false unless language_db_chk?
        # タイムゾーン存在チェック
        check_result = false unless timezone_db_chk?
        # 携帯キャリア存在チェック
        check_result = false unless mobile_carrier_db_chk?
        return check_result
      end
      
      # ページ番号取得
      def search_page_number
        if @btn_val == view_text('list.item_names.prev_page') then
          return (@cond_page_num.to_i - 1).to_s
        elsif @btn_val == view_text('list.item_names.next_page') then
          return (@cond_page_num.to_i + 1).to_s
        end
        return @cond_page_num
      end
      
      # DB変数設定
      def set_variable
        setting = Common::CodeConv::EncryptionSetting.instance
        ret_val = Account.connection.execute("SET @PW='" + setting.encryption_password + "';")
      end
      
      # DB変数クリア
      def clear_variable
        ret_val = Account.connection.execute("SET @PW=NULL;")
      end
    end
  end
end