# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員情報の更新アクション
# コントローラー：Update::UpdateController
# アクション：update
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/15 Nakanohito
# 更新日:
###############################################################################
require 'common/code_conv/code_converter'
require 'biz_actions/update/base_action'
require 'biz_process/process_executer'
require 'biz_process/mailers/reg_confirm_process'
require 'biz_process/mailers/upd_confirm_process'
require 'data_cache/data_updated_cache'

module BizActions
  module Update
    class UpdateAction < BizActions::Update::BaseAction
      include Common::CodeConv
      include BizProcess
      include BizProcess::Mailers
      include DataCache
      # 定数
      CHAR_SET_ALPHANUMERIC = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 項目名ヘッダー
        @msg_headder = 'update'
        # ボタン
        @button = @params[:commit]
        # メール送信済みフラグ
        @send_mail_flg = false
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 値修正判定
      def correct?
        return view_text('confirmation.item_names.correct_btn') == @button
      end
      
      # メール送信判定
      def send_mail?
        return @send_mail_flg
      end
      
      # 会員情報仮更新処理
      def update?
        # トランザクション処理
        ActiveRecord::Base.transaction do
          # アカウントキャッシュリロード
          AccountCache.instance.data_update?
          return false unless valid?
          # 一時パスワード生成
          temp_password = nil
          if MemberState::MEMBER_STATE_CLS_PROVISIONAL == @upd_member_state_cls ||
             MemberState::MEMBER_STATE_CLS_UPDATE == @upd_member_state_cls then
            # 実行ユーザーが管理者で仮登録・仮更新の場合
            temp_password = random_string
          end
          # アカウント更新
          account = account_ent(temp_password)
          account.save!
          # ペルソナ更新
          persona = persona_ent(account)
          persona.save!
          # データ更新情報更新
          upd_cache = DataUpdatedCache.instance
          upd_cache.next_version(:account)
          upd_cache.next_version(:persona)
          # メール送信判定
Rails.logger.debug('Update temp_password:' + temp_password.to_s)
          if MemberState::MEMBER_STATE_CLS_PROVISIONAL == @upd_member_state_cls then
            # 仮登録完了メール送信
            process = RegConfirmProcess.new
            process.user_id  = @user_id
            process.nickname = @nickname
            process.mobile_email  = @mobile_email
            process.temp_password = temp_password
            ProcessExecuter.instance.entry_process?(process)
            @send_mail_flg = true
          elsif MemberState::MEMBER_STATE_CLS_UPDATE == @upd_member_state_cls then
            # 仮更新完了メール送信
            process = UpdConfirmProcess.new
            process.user_id  = @user_id
            process.nickname = @nickname
            process.mobile_email  = @mobile_email
            process.temp_password = temp_password
            ProcessExecuter.instance.entry_process?(process)
            @send_mail_flg = true
          end
          # セッション情報処理
          if !admin? then
            # セッションクリア（管理者以外）
            @controller.reset_session
          elsif @session[:user_id] == @user_id then
            # 管理者が自分の会員情報を更新する場合にはセッション情報更新
            @session[:authority_cls] = @upd_authority_cls
            @session[:nickname] = @upd_nickname
          end
        end
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # アカウント編集
      def account_ent(temp_password)
        hash_salt = CodeConverter.instance.hash_salt
        account = AccountCache.instance.user_id_rec(@user_id)
        account.set_hash_value(:hsh_password, @upd_password, hash_salt)
        account.member_state_id = MemberStateCache.instance[@upd_member_state_cls].id
        account.set_enc_value(:enc_authority_cls, @upd_authority_cls)
        account.set_hash_value(:hsh_temp_password, temp_password, hash_salt)
        account.set_enc_value(:enc_last_name, @upd_last_name)
        account.set_enc_value(:enc_first_name, @upd_first_name)
        account.set_enc_value(:enc_yomigana_last, @upd_yomigana_last)
        account.set_enc_value(:enc_yomigana_first, @upd_yomigana_first)
        account.set_enc_value(:enc_gender_cls, @upd_gender_cls)
        account.set_enc_value(:enc_birth_date, @upd_birthday.to_s)
        account.salt = hash_salt
        return account
      end
      
      # ペルソナ編集
      def persona_ent(account)
        persona = account.persona[0]
        persona.set_enc_value(:enc_nickname, @upd_nickname)
        persona.set_enc_value(:enc_country_name_cd, @upd_country_name_cd)
        persona.set_enc_value(:enc_lang_name_cd, @upd_lang_name_cd)
        persona.set_enc_value(:enc_timezone_id, @upd_timezone_id)
        persona.set_enc_value(:enc_postcode, @upd_postcode)
        persona.set_enc_value(:enc_email, @upd_email)
        persona.set_enc_value(:enc_mobile_phone_no, @upd_mobile_phone_no)
        persona.mobile_carrier_id = @upd_mobile_carrier_id
        persona.set_enc_value(:enc_mobile_email, @upd_mobile_email)
        return persona
      end
      
      # ランダムな文字列生成処理
      def random_string(size=32)
        # 文字コードセットからランダムに文字を抽出して、指定された桁数の文字列を生成
        return Array.new(size){CHAR_SET_ALPHANUMERIC[rand(CHAR_SET_ALPHANUMERIC.size)]}.join
      end
      
      # 単項目チェック
      def single_item_chk?
        # 更新項目チェック
        return upd_item_chk?
      end
      
      # 項目関連チェック
      def related_items_chk?
        # 会員情報の項目関連チェック
        return account_item_rel_chk?
      end
      
      # DB関連チェック
      def db_related_chk?
        # DB関連チェック（アカウント）
        check_result = account_db_chk?
        # DB関連チェック（ペルソナ）
#        check_result = false unless persona_db_chk?
        # DB関連チェック（会員状態）
        check_result = false unless member_state_db_chk?
        # DB関連チェック（権限）
        check_result = false unless authority_db_chk?
        # DB関連チェック（性別）
        check_result = false unless gender_db_chk?
        # DB関連チェック（国）
        check_result = false unless country_db_chk?
        # DB関連チェック（言語）
        check_result = false unless language_db_chk?
        # DB関連チェック（タイムゾーン）
        check_result = false unless timezone_db_chk?
        # DB関連チェック（携帯キャリア）
        check_result = false unless mobile_carrier_db_chk?
        return check_result
      end
    end
  end
end