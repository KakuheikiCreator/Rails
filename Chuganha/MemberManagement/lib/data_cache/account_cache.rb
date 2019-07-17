# -*- coding: utf-8 -*-
###############################################################################
# アカウント情報キャッシュクラス
# 機能：DBから読み込んだアカウント情報のキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/21 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'common/code_conv/code_converter'
require 'biz_common/business_config'
require 'data_cache/data_updated_cache'
require 'data_cache/member_state_cache'
require 'data_cache/mobile_carrier_cache'

module DataCache
  # アカウント情報キャッシュクラス
  class AccountCache
    include Singleton
    include Common::CodeConv
    include BizCommon
    include DataCache
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 業務設定
      business_config = BusinessConfig.instance
      # 携帯認証タイムアウト
      @mobile_auth_timeout_min = business_config[:mobile_auth_timeout_min].to_i
      # 認証ロック閾値
      @lock_threshold = business_config[:auth_lock_threshold].to_i
      # 最大履歴数
      @max_history_number = business_config[:max_history_number].to_i
      # 内部データソルト
      @common_salt = CodeConverter.instance.hash_salt
      # データ更新バージョン
      @updated_version = nil
      # データ更新日時
      @updated_at = nil
      # アカウント情報ハッシュ
      @account_data_hash = nil
      # アカウント情報ハッシュ（キー：携帯電話番号）
      @mbl_no_hash = nil
      # アカウント情報ハッシュ（キー：携帯メールアドレス）
      @mbl_email_hash = nil
      # アカウント情報ハッシュ（キー：携帯個体識別番号）
      @mbl_id_no_hash = nil
      # データをメモリに展開
      data_load?(true)
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # データロード処理
    def data_load?(force_flg=false)
before_time = Time.now
proc_time = (Time.now.to_f - before_time.to_f) * 1000.0
Rails.logger.debug('AccountCache data_load? start:' + proc_time.to_s + " msec")
      # クリティカルセクションの実行
      @mutex.synchronize do
        data_updated_cache = DataUpdatedCache.instance
        unless force_flg then
          return false unless data_updated_cache.data_update?(:account, @updated_version)
        end
        # アカウント情報を不変オブジェクトの内部データとしてハッシュ化
        new_updated_at  = Time.now
        new_account_data_hash = Hash.new
        new_mbl_no_hash = Hash.new
        new_mbl_email_hash = Hash.new
        new_mbl_id_no_hash = Hash.new
        ent_list = Account.where('delete_flg = ?', false).includes(:persona)
        ent_list.each do |ent|
          data = AccountData.new(ent, @common_salt)
          new_account_data_hash[ent.user_id] = data
          new_mbl_no_hash[data.hsh_mobile_phone_no] = data
          new_mbl_email_hash[data.hsh_mobile_email] = data
          new_mbl_id_no_hash[data.hsh_mobile_id_no] = data unless data.hsh_mobile_id_no.nil?
        end
        @account_data_hash = new_account_data_hash
        @mbl_no_hash = new_mbl_no_hash
        @mbl_email_hash = new_mbl_email_hash
        @mbl_id_no_hash = new_mbl_id_no_hash
        @updated_at = new_updated_at
        @updated_version = data_updated_cache.current_version(:account)
      end
proc_time = (Time.now.to_f - before_time.to_f) * 1000.0
Rails.logger.debug('AccountCache data_load? end:' + proc_time.to_s + " msec")
    end
    
    # データ更新処理
    def data_update?(force_flg=false)
before_time = Time.now
proc_time = (Time.now.to_f - before_time.to_f) * 1000.0
Rails.logger.debug('AccountCache data_update? start:' + proc_time.to_s + " msec")
      # クリティカルセクションの実行
      @mutex.synchronize do
        data_updated_cache = DataUpdatedCache.instance
        unless force_flg then
Rails.logger.debug('AccountCache data_update? loaded_version:' + @updated_version.to_s)
          return false unless data_updated_cache.data_update?(:account, @updated_version)
        end
        # アカウント情報を不変オブジェクトの内部データとしてハッシュ化
        upd_updated_at  = Time.now
        upd_account_data_hash = Hash.new
        upd_mbl_no_hash = Hash.new
        upd_mbl_email_hash = Hash.new
        upd_mbl_id_no_hash = Hash.new
        delete_list = Array.new
        ent_list = Account.where("updated_at >= ?", @updated_at).includes(:persona)
        ent_list.each do |ent|
          data = AccountData.new(ent, @common_salt)
          if ent.delete_flg then
            delete_list.push(data)
          else
            upd_account_data_hash[data.user_id] = data
            upd_mbl_no_hash[data.hsh_mobile_phone_no] = data
            upd_mbl_email_hash[data.hsh_mobile_email] = data
            upd_mbl_id_no_hash[data.hsh_mobile_id_no] = data unless data.hsh_mobile_id_no.nil?
          end
        end
        # データ削除判定
        delete_list.each do |data|
          @account_data_hash.delete(data.user_id)
          @mbl_no_hash.delete(data.hsh_mobile_phone_no)
          @mbl_email_hash.delete(data.hsh_mobile_email)
          @mbl_id_no_hash.delete(data.hsh_mobile_id_no)
        end
        # データ更新処理
        @account_data_hash.update(upd_account_data_hash)
        @mbl_no_hash.update(upd_mbl_no_hash)
        @mbl_email_hash.update(upd_mbl_email_hash)
        @mbl_id_no_hash.update(upd_mbl_id_no_hash)
        @updated_at = upd_updated_at
        @updated_version = data_updated_cache.current_version(:account)
      end
proc_time = (Time.now.to_f - before_time.to_f) * 1000.0
Rails.logger.debug('AccountCache data_update? end:' + proc_time.to_s + " msec")
      return true
    end
    
    # ユーザーＩＤに対応するレコードを取得
    def user_id_rec(user_id)
      @mutex.synchronize do
        account_data = @account_data_hash[user_id]
        return nil if account_data.nil?
        return Account.find(account_data.id)
      end
    end
    
    # ユーザーIDの存在チェック
    def exist?(user_id)
      @mutex.synchronize do
        return @account_data_hash.key?(user_id)
      end
    end
    
    # 携帯電話番号の存在チェック
    def mobile_phone_no_exist?(phone_num)
      @mutex.synchronize do
        hsh_phone_num = CodeConverter.instance.hash(phone_num, @common_salt)
        return @mbl_no_hash.has_key?(hsh_phone_num)
      end
    end
    
    # 携帯メールの存在チェック
    def mobile_email_exist?(email)
      @mutex.synchronize do
        hsh_email = CodeConverter.instance.hash(email, @common_salt)
        return @mbl_email_hash.has_key?(hsh_email)
      end
    end
    
    # 携帯個体識別番号の存在チェック
    def mobile_id_no_exist?(mobile_id_no, ex_uid=nil)
      @mutex.synchronize do
        hsh_mobile_id_no = CodeConverter.instance.hash(mobile_id_no, @common_salt)
        account_data =  @mbl_id_no_hash[hsh_mobile_id_no]
        return false if account_data.nil?
        return account_data.user_id != ex_uid
      end
    end
    
    # アカウントチェック
    def valid_account?(chk_uid, chk_pw)
      @mutex.synchronize do
        account_data = @account_data_hash[chk_uid]
        return false if account_data.nil?
        return account_data.authentication?(chk_pw)
      end
    end
    
    # ユーザーIDの有効性チェック
    def valid_user?(chk_uid)
      @mutex.synchronize do
        account_data = @account_data_hash[chk_uid]
        return false if account_data.nil?
        member_state = MemberStateCache.instance[MemberState::MEMBER_STATE_CLS_DEFINITIVE]
        return account_data.member_state_id == member_state.id
      end
    end
    
    # 仮登録アカウント取得
    def provisional_account(chk_uid, chk_temp_pw, chk_mobile_carrier_cd)
      @mutex.synchronize do
        account_data = @account_data_hash[chk_uid]
        return nil if account_data.nil?
        # タイムアウト判定
        elapsed_time = (Time.now - account_data.updated_at) / 60 
        return nil unless elapsed_time.to_i <= @mobile_auth_timeout_min
        # 会員状態チェック
        provisional = MemberStateCache.instance[MemberState::MEMBER_STATE_CLS_PROVISIONAL]
        return nil if account_data.member_state_id != provisional.id
        # 一時パスワードチェック
        return nil unless account_data.temp_pw?(chk_temp_pw)
        # 携帯キャリアチェック
        return nil unless account_data.mobile_carrier?(chk_mobile_carrier_cd)
        # 対象データの検索
        return Account.find(account_data.id)
      end
    end
    
    # 仮更新アカウント取得
    def update_account(chk_uid, chk_temp_pw, chk_mobile_carrier_cd)
      @mutex.synchronize do
        account_data = @account_data_hash[chk_uid]
        return nil if account_data.nil?
        # タイムアウト判定
        elapsed_time = (Time.now - account_data.updated_at) / 60 
        return nil unless elapsed_time.to_i <= @mobile_auth_timeout_min
        # 会員状態チェック
        update_state = MemberStateCache.instance[MemberState::MEMBER_STATE_CLS_UPDATE]
        return nil if account_data.member_state_id != update_state.id
        # 一時パスワードチェック
        return nil unless account_data.temp_pw?(chk_temp_pw)
        # 携帯キャリアチェック
        return nil unless account_data.mobile_carrier?(chk_mobile_carrier_cd)
        # 対象データの検索
        return Account.find(account_data.id)
      end
    end
    
    # 認証結果アカウント取得
    def auth_result(chk_uid, result_flg, auth_time, request, svr_url)
      @mutex.synchronize do
        account_data = @account_data_hash[chk_uid]
        return if account_data.nil?
        # アカウントの永続化判定
        account = account_data.auth_result(result_flg, @lock_threshold)
        return nil if account.nil?
        # アカウント情報更新
        account.auth_result(result_flg, @lock_threshold)
        account.save!
        # 認証履歴生成
        history_ent = AuthenticationHistory.new
        history_ent.set_account_info(account)
        history_ent.set_auth_info(auth_time, result_flg, request, svr_url)
        history_ent.save!
        # 古い履歴の削除
        account.del_auth_history if account.last_auth_seq_no > @max_history_number
        # データ更新情報リフレッシュ
        @updated_at = Time.now
        @updated_version = DataUpdatedCache.instance.next_version(:account)
        return account
      end
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # アカウントデータクラス定義
    class AccountData
      include Common::CodeConv
      include DataCache
      # アクセサー定義
      attr_reader :id, :user_id, :member_state_id, :updated_at, :mobile_carrier_id,
                  :hsh_mobile_phone_no, :hsh_mobile_email, :hsh_mobile_id_no
      # コンストラクタ
      def initialize(ent, common_salt)
        # アカウント情報
        @id = ent.id
        @user_id = ent.user_id
        @hsh_password = ent.hsh_password
        @member_state_id = ent.member_state_id
        @hsh_temp_password = ent.hsh_temp_password
        @consecutive_failure_cnt = ent.consecutive_failure_cnt
        @salt = ent.salt
        @updated_at = ent.updated_at
        # ペルソナ情報
        persona_ent = ent.persona[0]
        @mobile_carrier_id = persona_ent.mobile_carrier_id
        @hsh_mobile_phone_no = persona_ent.dec_hash_value(:enc_mobile_phone_no, common_salt)
        @hsh_mobile_email    = persona_ent.dec_hash_value(:enc_mobile_email, common_salt)
        @hsh_mobile_id_no    = persona_ent.dec_hash_value(:enc_mobile_id_no, common_salt)
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 認証判定
      def authentication?(chk_pw)
        return false unless String === chk_pw
        # 会員状態チェック
        interim_data = MemberStateCache.instance[MemberState::MEMBER_STATE_CLS_DEFINITIVE]
        return false if @member_state_id != interim_data.id
        # パスワードチェック
        return @hsh_password == CodeConverter.instance.hash(chk_pw, @salt)
      end
      
      # 携帯キャリアコードチェック
      def mobile_carrier?(chk_mobile_carrier_cd)
        return false unless String === chk_mobile_carrier_cd
        mobile_ent = MobileCarrierCache.instance[@mobile_carrier_id]
        carrier_cd = mobile_ent.mobile_carrier_cd
Rails.logger.debug('mobile_carrier? 1:' + carrier_cd.to_s)
Rails.logger.debug('mobile_carrier? 2:' + chk_mobile_carrier_cd.to_s)
        return true if carrier_cd == chk_mobile_carrier_cd
        # ディズニーモバイル対策
        if carrier_cd == MobileCarrier::CARRIER_CD_DISNEY then
          return true if MobileCarrier::CARRIER_CD_DOCOMO == chk_mobile_carrier_cd
          return true if MobileCarrier::CARRIER_CD_SOFTBANK == chk_mobile_carrier_cd
        end
        return false
      end
      
      # 一時パスワードチェック
      def temp_pw?(chk_temp_pw)
        return false unless String === chk_temp_pw
Rails.logger.debug('temp_pw? 1:' + chk_temp_pw)
Rails.logger.debug('temp_pw? 2:' + CodeConverter.instance.hash(chk_temp_pw, @salt).unpack("H*")[0].to_s)
Rails.logger.debug('temp_pw? 3:' + @hsh_temp_password.unpack("H*")[0].to_s)
        # 一時パスワードチェック
        return @hsh_temp_password == CodeConverter.instance.hash(chk_temp_pw, @salt)
      end
      
      # 認証結果処理
      def auth_result(result_flg, lock_threshold)
        if result_flg then
          @consecutive_failure_cnt = 0
        else
          @consecutive_failure_cnt += 1
        end
        return nil if @consecutive_failure_cnt > lock_threshold
        return Account.find(@id)
      end
    end
  end
end