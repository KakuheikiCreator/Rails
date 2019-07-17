# -*- coding: utf-8 -*-
###############################################################################
# モデル：退会者
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/31 Nakanohito
# 更新日:
###############################################################################
require 'common/model/db_code_conv_module'
require 'validators/ip_address_validator'

class PersonWithdrawal < ActiveRecord::Base
  include Common::Model::DbCodeConvModule
  include Validators
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :user_id, :withdrawal_reason_id, :enc_withdrawal_reason_dtl,
                  :person_withdrawal_state_id, :join_date, :withdrawal_date,
                  :member_state_id, :enc_authority_cls, :hsh_password, :hsh_temp_password,
                  :enc_nickname, :enc_last_name, :enc_first_name,
                  :enc_yomigana_last, :enc_yomigana_first,
                  :enc_gender_cls, :enc_birth_date, :enc_country_name_cd, :enc_lang_name_cd,
                  :enc_timezone_id, :enc_postcode, :enc_email,
                  :enc_mobile_phone_no, :hsh_mobile_phone_no, :mobile_carrier_id,
                  :enc_mobile_email, :hsh_mobile_email, :enc_mobile_id_no, :hsh_mobile_id_no,
                  :enc_mobile_host, :hsh_mobile_host,
                  :last_authentication_date, :last_authentication_result,
                  :last_authentication_ip_address, :last_authentication_referer, 
                  :last_authentication_user_agent, :salt, :delete_flg, :lock_version

  #############################################################################
  # リレーション設定
  #############################################################################
  # 会員状態
  belongs_to :member_state
  # 退会理由
  belongs_to :withdrawal_reason
  # 退会者状態
  belongs_to :person_withdrawal_state
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :user_id,
    :presence => true,
    :length => {:maximum => 32}
  validates :withdrawal_reason_id,
    :presence => true
  validates :enc_withdrawal_reason_dtl,
    :presence => true
  validates :person_withdrawal_state_id,
    :presence => true
  validates :join_date,
    :presence => true
  validates :withdrawal_date,
    :presence => true
  validates :member_state_id,
    :presence => true
  validates :enc_authority_cls,
    :presence => true
  validates :hsh_password,
    :presence => true,
    :length => {:is => 32}
  validates :hsh_temp_password,
    :allow_nil => true,
    :length => {:is => 32}
  validates :hsh_mobile_phone_no,
    :presence => true,
    :length => {:is => 32}
  validates :mobile_carrier_id,
    :presence => true
  validates :hsh_mobile_email,
    :presence => true,
    :length => {:is => 32}
  validates :hsh_mobile_id_no,
    :allow_nil => true,
    :length => {:is => 32}
  validates :hsh_mobile_host,
    :allow_nil => true,
    :length => {:is => 32}
  validates :last_authentication_ip_address,
    :allow_nil => true,
    :ip_address => true
  validates :last_authentication_referer,
    :allow_nil => true,
    :length => {:maximum => 255},
    :uri => true
  validates :last_authentication_user_agent,
    :allow_nil => true,
    :length => {:maximum => 255}
  validates :salt,
    :presence => true
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # アカウント情報設定
  def set_account_info(account)
    # アカウント情報設定
    self.user_id   = account.user_id
    self.join_date = account.join_date
    self.member_state_id   = account.member_state_id
    self.enc_authority_cls = account.enc_authority_cls
    self.hsh_password   = account.hsh_password
    self.hsh_temp_password = account.hsh_temp_password
    self.enc_last_name  = account.enc_last_name
    self.enc_first_name = account.enc_first_name
    self.enc_yomigana_last  = account.enc_yomigana_last
    self.enc_yomigana_first = account.enc_yomigana_first
    self.enc_gender_cls = account.enc_gender_cls
    self.enc_birth_date = account.enc_birth_date
    self.salt           = account.salt
    # ペルソナ情報設定
    persona = account.persona[0]
    self.enc_nickname = persona.enc_nickname
    self.enc_country_name_cd = persona.enc_country_name_cd
    self.enc_lang_name_cd    = persona.enc_lang_name_cd
    self.enc_timezone_id     = persona.enc_timezone_id
    self.enc_postcode = persona.enc_postcode
    self.enc_email    = persona.enc_email
    self.enc_mobile_phone_no = persona.enc_mobile_phone_no
    self.hsh_mobile_phone_no = persona.dec_hash_value(:enc_mobile_phone_no, account.salt)
    self.mobile_carrier_id   = persona.mobile_carrier_id
    self.enc_mobile_email    = persona.enc_mobile_email
    self.hsh_mobile_email    = persona.dec_hash_value(:enc_mobile_email, account.salt)
    self.enc_mobile_id_no    = persona.enc_mobile_id_no
    self.hsh_mobile_id_no    = persona.dec_hash_value(:enc_mobile_id_no, account.salt)
    self.enc_mobile_host     = persona.enc_mobile_host
    self.hsh_mobile_host     = persona.dec_hash_value(:enc_mobile_host, account.salt)
    # 最終認証情報設定
    last_auth_history = account.last_auth_history
    return if last_auth_history.nil?
    self.last_authentication_date       = last_auth_history.authentication_date
    self.last_authentication_result     = last_auth_history.authentication_result
    self.last_authentication_ip_address = last_auth_history.ip_address
    self.last_authentication_referer    = last_auth_history.referer
    self.last_authentication_user_agent = last_auth_history.user_agent
  end
end
