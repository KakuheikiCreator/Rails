# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員情報の仮登録アクション
# コントローラー：Registration::RegistrationController
# アクション：step_5
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/28 Nakanohito
# 更新日:
###############################################################################
require 'common/code_conv/code_converter'
require 'biz_actions/registration/base_action'
require 'biz_process/process_executer'
require 'biz_process/mailers/reg_confirm_process'
require 'data_cache/account_cache'
require 'data_cache/member_state_cache'

module BizActions
  module Registration
    class Step5Action < BizActions::Registration::BaseAction
      include Common::CodeConv
      include DataCache
      include BizProcess
      include BizProcess::Mailers
      # 定数
      CHAR_SET_ALPHANUMERIC = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @msg_headder = 'step_3'
        @button = @params[:commit]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 仮登録通知メール送信確認
      def send_mail?
before_time = Time.now
        # 会員情報修正判定
        return false if view_text('step_4.item_names.previous_step') == @button
        # トランザクション処理
        ActiveRecord::Base.transaction do
          # アカウントキャッシュリロード
          AccountCache.instance.data_update?
          return false unless valid?
          # パスワードリセットコード生成
          temp_password = random_string
Rails.logger.debug('Step5Action temp_password:' + temp_password)
          # アカウント保存
          account = account_ent(temp_password)
          account.save!
          # ペルソナ保存
          persona = persona_ent(account)
          persona.save!
          # データ更新情報更新
          upd_cache = DataUpdatedCache.instance
          upd_cache.next_version(:account)
          upd_cache.next_version(:persona)
proc_time = (Time.now.to_f - before_time.to_f) * 1000.0
Rails.logger.debug('Step5Action send_mail? 1:' + proc_time.to_s + " msec")
          # 仮登録完了メール送信
          process = RegConfirmProcess.new
          process.user_id  = @user_id
          process.nickname = @nickname
          process.mobile_email  = @mobile_email
          process.temp_password = temp_password
          ProcessExecuter.instance.entry_process?(process)
proc_time = (Time.now.to_f - before_time.to_f) * 1000.0
Rails.logger.debug('Step5Action send_mail? 2:' + proc_time.to_s + " msec")
        end
        # セッションクリア
        @controller.reset_session
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # アカウント生成
      def account_ent(temp_password)
        hash_salt = CodeConverter.instance.hash_salt
        account = Account.new
        account.user_id = @user_id
        account.set_hash_value(:hsh_password, @password, hash_salt)
        state_ent = MemberStateCache.instance[MemberState::MEMBER_STATE_CLS_PROVISIONAL]
        account.member_state_id = state_ent.id
        account.set_enc_value(:enc_authority_cls, Authority::AUTHORITY_CLS_GENERAL)
        account.join_date = Time.now
        account.set_hash_value(:hsh_temp_password, temp_password, hash_salt)
        account.consecutive_failure_cnt = 0
        account.set_enc_value(:enc_last_name, @last_name)
        account.set_enc_value(:enc_first_name, @first_name)
        account.set_enc_value(:enc_yomigana_last, @yomigana_last)
        account.set_enc_value(:enc_yomigana_first, @yomigana_first)
        account.set_enc_value(:enc_gender_cls, @gender_cls)
        account.set_enc_value(:enc_birth_date, @birth_day.to_s)
        account.salt = hash_salt
        return account
      end
      
      # ペルソナ生成
      def persona_ent(account)
        persona = Persona.new
        persona.account_id = account.id
        persona.seq_no = 1
        persona.set_enc_value(:enc_nickname, @nickname)
        persona.set_enc_value(:enc_country_name_cd, @country_name_cd)
        persona.set_enc_value(:enc_lang_name_cd, @lang_name_cd)
        persona.set_enc_value(:enc_timezone_id, @timezone_id)
        persona.set_enc_value(:enc_postcode, @postcode)
        persona.set_enc_value(:enc_email, @email)
        persona.set_enc_value(:enc_mobile_phone_no, @mobile_phone_no)
        persona.mobile_carrier_id = @mobile_carrier_id
        persona.set_enc_value(:enc_mobile_email, @mobile_email)
        return persona
      end
      
      # ランダムな文字列生成処理
      def random_string(size=32)
        # 文字コードセットからランダムに文字を抽出して、指定された桁数の文字列を生成
        return Array.new(size){CHAR_SET_ALPHANUMERIC[rand(CHAR_SET_ALPHANUMERIC.size)]}.join
      end
      
      # 単項目チェック
      def single_item_chk?
        # 入力された会員情報の単項目チェック
        check_result = account_item_chk?
        # クリックされたボタンのチェック
        check_result = false if view_text('step_4.item_names.next_step') != @button
        return check_result
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
        # DB関連チェック（退会者）
#        check_result = false unless person_withdrawal_db_chk?
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