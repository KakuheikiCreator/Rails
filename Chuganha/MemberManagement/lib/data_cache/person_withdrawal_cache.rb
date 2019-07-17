# -*- coding: utf-8 -*-
###############################################################################
# 退会者情報キャッシュクラス
# 機能：DBから読み込んだ退会者情報のキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/06 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'common/code_conv/code_converter'
require 'data_cache/data_updated_cache'

module DataCache
  # 退会者情報キャッシュクラス
  class PersonWithdrawalCache
    include Singleton
    include Common::CodeConv
    include DataCache
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 内部データソルト
      @common_salt = CodeConverter.instance.hash_salt
      # データ更新日時
      @updated_at = nil
      # データ更新バージョン
      @updated_version = nil
      # 個人情報削除済みデータリスト
      @no_personal_info_list = nil
      # 退会者データハッシュ（キー：携帯電話番号のハッシュ値）
      @mbl_phone_no_hash = nil
      # 退会者データハッシュ（キー：携帯メールのハッシュ値）
      @mbl_email_hash = nil
      # 退会者データハッシュ（キー：携帯個体識別番号のハッシュ値）
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
      # クリティカルセクションの実行
      @mutex.synchronize do
        upd_cache = DataUpdatedCache.instance
        unless force_flg then
          return false unless upd_cache.data_update?(:person_withdrawal, @updated_version)
        end
        # 退会者情報を不変オブジェクトの内部データとしてハッシュ化
        new_updated_at = Time.now
        new_no_personal_info_list = Array.new
        new_mbl_phone_no_hash = Hash.new
        new_mbl_email_hash = Hash.new
        new_mbl_id_no_hash = Hash.new
        PersonWithdrawal.where("delete_flg = ?", false).each do |ent|
          data = PersonWithdrawalData.new(ent, @common_salt)
          if data.ehs_mobile_phone_no.nil? then
            new_no_personal_info_list.push(data)
          else
            new_mbl_phone_no_hash[data.ehs_mobile_phone_no] = data
            new_mbl_email_hash[data.ehs_mobile_email] = data
            new_mbl_id_no_hash[data.ehs_mobile_id_no] = data
          end
        end
        @no_personal_info_list = new_no_personal_info_list
        @mbl_phone_no_hash = new_mbl_phone_no_hash
        @mbl_email_hash = new_mbl_email_hash
        @mbl_id_no_hash = new_mbl_id_no_hash
        @updated_at = new_updated_at
        @updated_version = upd_cache.current_version(:person_withdrawal)
      end
    end
    
    # データ更新処理
    def data_update?(force_flg=false)
      # クリティカルセクションの実行
      @mutex.synchronize do
        unless force_flg then
          upd_cache = DataUpdatedCache.instance
          return false unless upd_cache.data_update?(:person_withdrawal, @updated_version)
        end
        # 退会者情報情報を不変オブジェクトの内部データに変換
        new_updated_at = Time.now
        add_no_personal_info_list = Array.new
        upd_mbl_phone_no_hash = Hash.new
        upd_mbl_email_hash = Hash.new
        upd_mbl_id_no_hash = Hash.new
        delete_list = Array.new
        PersonWithdrawal.where("updated_at > ?", @loaded_at).each do |ent|
          data = AccountData.new(ent, @common_salt)
          if ent.delete_flg then
            delete_list.push(data)
            next
          end
          if ent.enc_mobile_id_no.nil? then
            add_no_personal_info_list.push(data)
          else
            upd_mbl_phone_no_hash[data.ehs_mobile_phone_no] = data
            upd_mbl_email_hash[data.ehs_mobile_email] = data
            upd_mbl_id_no_hash[data.ehs_mobile_id_no] = data
          end
        end
        # データ削除
        delete_list.each do |del_data|
          @no_personal_info_list.delete_if do |chk_data|
            return del_data.id == chk_data.id
          end
          @mbl_phone_no_hash.delete(del_data.ehs_mobile_phone_no)
          @mbl_email_hash.delete(del_data.ehs_mobile_email)
          @mbl_id_no_hash.delete(del_data.ehs_mobile_id_no)
        end
        # データ更新
        @no_personal_info_list.concat(add_no_personal_info_list)
        @mbl_phone_no_hash.update(upd_mbl_phone_no_hash)
        @mbl_email_hash.update(upd_mbl_email_hash)
        @mbl_id_no_hash.update(upd_mbl_id_no_hash)
        @updated_at = new_updated_at
        @updated_version = upd_cache.current_version(:person_withdrawal)
      end
      return true
    end
    
    # 携帯電話番号の存在チェック
    def mobile_phone_no_exist?(mbl_phone_no)
      hash_val = CodeConverter.instance.hash(mbl_phone_no, @common_salt)
      return true if @mbl_phone_no_hash.key?(hash_val)
      @no_personal_info_list.each do |data|
        return true if data.mobile_phone_no?(mbl_phone_no)
      end
      return false
    end
    
    # 携帯メールの存在チェック
    def mobile_email_exist?(mbl_email)
      hash_val = CodeConverter.instance.hash(mbl_email, @common_salt)
      return true if @mbl_email_hash.key?(hash_val)
      @no_personal_info_list.each do |data|
        return true if data.mobile_email?(mbl_email)
      end
      return false
    end
    
    # 携帯個体識別番号の存在チェック
    def mobile_id_exist?(mbl_id_no)
      hash_val = CodeConverter.instance.hash(mbl_id_no, @common_salt)
      return true if @mbl_id_no_hash.key?(hash_val)
      @no_personal_info_list.each do |data|
        return true if data.mobile_id_no?(mbl_id_no)
      end
      return false
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # 退会者データクラス定義
    class PersonWithdrawalData
      include Common::CodeConv
      # アクセサー定義
      attr_reader :id, :ehs_mobile_phone_no, :ehs_mobile_email, :ehs_mobile_id_no
      # コンストラクタ
      def initialize(ent, common_salt)
        # アカウント情報
        @id = ent.id
        @salt = ent.salt
        @ehs_mobile_phone_no = nil
        @hsh_mobile_phone_no = ent.hsh_mobile_phone_no
        @ehs_mobile_email = nil
        @hsh_mobile_email = ent.hsh_mobile_email
        @ehs_mobile_id_no = nil
        @hsh_mobile_id_no = ent.hsh_mobile_id_no
        # 個人情報削除済み判定
        unless ent.enc_mobile_id_no.nil? then
          @ehs_mobile_phone_no = ent.dec_hash_value(:enc_mobile_phone_no, common_salt)
          @ehs_mobile_email = ent.dec_hash_value(:enc_mobile_email, common_salt)
          @ehs_mobile_id_no = ent.dec_hash_value(:enc_mobile_id_no, common_salt)
        end
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 携帯電話番号の有無チェック
      def mobile_phone_no?(mobile_phone_no)
        return @hsh_mobile_phone_no == CodeConverter.instance.hash(mobile_phone_no, @salt)
      end
      
      # 携帯メールアドレスの有無チェック
      def mobile_email?(mobile_email)
        return @hsh_mobile_email == CodeConverter.instance.hash(mobile_email, @salt)
      end
      
      # 携帯個体識別番号の有無チェック
      def mobile_id_no?(mobile_id_no)
        return @hsh_mobile_id_no == CodeConverter.instance.hash(mobile_id_no, @salt)
      end
    end
  end
end