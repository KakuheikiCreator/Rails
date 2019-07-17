# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：退会者
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/07 Nakanohito
# 更新日:
###############################################################################
require 'common/code_conv/code_converter'

module Seeds
  module SeedsPersonWithdrawal
    # 全データ削除
    def delete_all
      PersonWithdrawal.delete_all
    end
    module_function :delete_all
    
    # データ生成
    def create
      PersonWithdrawal.transaction do
        10000.times do |idx|
          create_ent(idx).save!
        end
      end
    end
    module_function :create
    
    # 退会者エンティティ生成
    def create_ent(idx)
      converter = Common::CodeConv::CodeConverter.instance
      salt = converter.hash_salt
      ent = PersonWithdrawal.new
      ent.user_id = 'PersonWithdrawal_' + idx.to_s
      ent.withdrawal_reason_id = (idx % 5) + 1
      ent.set_enc_value(:enc_withdrawal_reason_dtl, 'お腹が痛くなったから')
      ent.person_withdrawal_state_id = (idx % 2) + 1
      ent.join_date = Time.now - 60*60*24*365
      ent.withdrawal_date = Time.now - 60*60*24*31
      ent.member_state_id = 2
      ent.set_enc_value(:enc_authority_cls, 'GEN')
      ent.set_hash_value(:hsh_password, 'passwd_' + idx.to_s, salt)
      ent.set_hash_value(:hsh_temp_password, 'temp_pw_' + idx.to_s, salt)
      ent.set_enc_value(:enc_nickname, 'ニックネーム' + idx.to_s + '号')
      ent.set_enc_value(:enc_last_name, '仲観')
      ent.set_enc_value(:enc_first_name, 'タロウ')
      ent.set_enc_value(:enc_yomigana_last, 'チュウカン')
      ent.set_enc_value(:enc_yomigana_first, 'タロウ')
      ent.set_enc_value(:enc_gender_cls, 'M')
      ent.set_enc_value(:enc_birth_date, Time.now.to_s)
      ent.set_enc_value(:euc_country_name_cd, 'JPN')
      ent.set_enc_value(:euc_lang_name_cd, 'ja')
      ent.set_enc_value(:euc_timezone_id, 'Asia/Tokyo')
      ent.set_enc_value(:enc_postcode, '1234567')
      ent.set_enc_value(:enc_email, 'user_' + idx.to_s + '@nifty.com')
      ent.set_enc_value(:enc_mobile_phone_no, (10000000000 + idx).to_s)
      ent.set_hash_value(:hsh_mobile_phone_no, (10000000000 + idx).to_s, salt)
      ent.mobile_carrier_id = 1
      ent.set_enc_value(:enc_mobile_email, 'docodoco' + idx.to_s + '@docomo.ne.jp')
      ent.set_hash_value(:hsh_mobile_email, 'docodoco' + idx.to_s + '@docomo.ne.jp', salt)
      ent.set_enc_value(:enc_mobile_id_no, idx.to_s + '.docomo.ne.jp')
      ent.set_hash_value(:hsh_mobile_id_no, idx.to_s + '.docomo.ne.jp', salt)
      ent.set_enc_value(:enc_mobile_host, 's' + idx.to_s + '.xgsspn.imtp.tachikawa.spmode.ne.jp')
      ent.set_hash_value(:hsh_mobile_host, 's' + idx.to_s + '.xgsspn.imtp.tachikawa.spmode.ne.jp', salt)
      ent.last_authentication_date       = Time.now.to_s
      ent.last_authentication_result     = true
      ent.last_authentication_ip_address = '192.168.255.100'
      ent.last_authentication_referer    = 'http://www.test.page' + idx.to_s + '.ne.jp'
      ent.last_authentication_user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.75 Safari/535.7'
      ent.salt = salt
      return ent
    end
    module_function :create_ent
  
  end
end
