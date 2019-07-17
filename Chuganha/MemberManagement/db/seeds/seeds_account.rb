# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：アカウント
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/24 Nakanohito
# 更新日:
###############################################################################
require 'common/code_conv/code_converter'

module Seeds
  module SeedsAccount
    # 全データ削除
    def delete_all
      Account.delete_all
      Persona.delete_all
    end
    module_function :delete_all
    
    # データ生成
    def create
      ActiveRecord::Base.transaction do
        10000.times do |idx|
          account = account_ent(idx)
          account.save!
          account.reload
          persona = persona_ent(account, idx)
          persona.save!
        end
      end
    end
    module_function :create
    
    # アカウントエンティティ生成
    def account_ent(idx)
      authority_hash = {0=>'GEN', 1=>'ADM'}
      gender_hash = {0=>'M', 1=>'F'}
      converter = Common::CodeConv::CodeConverter.instance
      salt = converter.hash_salt
      ent = Account.new
      ent.user_id = 'abcdefghijklmnopqrstuvwxyz' + idx.to_s
      ent.set_hash_value(:hsh_password, 'abcdefghijklmnopqrstuvwxyz012345', salt)
      ent.member_state_id = ((idx + 1) % 4) + 1
      ent.set_enc_value(:enc_authority_cls, authority_hash[idx%2])
      ent.join_date = Time.now
      ent.set_hash_value(:hsh_temp_password, 'abcdefghijklmnopqrstuvwxyz012345', salt)
      ent.last_auth_seq_no = nil
      ent.consecutive_failure_cnt = 100
      ent.set_enc_value(:enc_last_name, '仲観')
      ent.set_enc_value(:enc_first_name, 'タロウ')
      ent.set_enc_value(:enc_yomigana_last, 'チュウカン')
      ent.set_enc_value(:enc_yomigana_first, 'タロウ')
      ent.set_enc_value(:enc_gender_cls, gender_hash[idx%2])
      ent.set_enc_value(:enc_birth_date, Time.now.to_s)
      ent.salt = salt
      ent.delete_flg = false
      return ent
    end
    module_function :account_ent
  
    # ペルソナエンティティ生成
    def persona_ent(account, idx)
      converter = Common::CodeConv::CodeConverter.instance
      ent = Persona.new
      ent.account_id = account.id
      ent.seq_no = 1
      ent.set_enc_value(:enc_nickname, 'ニックネーム' + idx.to_s + '号')
      ent.set_enc_value(:enc_country_name_cd, 'JP')
      ent.set_enc_value(:enc_lang_name_cd, 'ja')
      ent.set_enc_value(:enc_timezone_id, 'Asia/Tokyo')
      ent.set_enc_value(:enc_postcode, '1234567')
      ent.set_enc_value(:enc_email, 'user_' + idx.to_s + '@nifty.com')
      ent.set_enc_value(:enc_mobile_phone_no, (10000000000 + idx).to_s)
      ent.mobile_carrier_id = 1
      ent.set_enc_value(:enc_mobile_email, 'docodoco' + idx.to_s + '@docomo.ne.jp')
      ent.set_enc_value(:enc_mobile_id_no, idx.to_s + '.docomo.ne.jp')
      ent.set_enc_value(:enc_mobile_host, 's' + idx.to_s + '.xgsspn.imtp.tachikawa.spmode.ne.jp')
      return ent
    end
    module_function :persona_ent
  end

end
