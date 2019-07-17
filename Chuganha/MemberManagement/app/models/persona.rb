# -*- coding: utf-8 -*-
###############################################################################
# モデル：ペルソナ
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/31 Nakanohito
# 更新日:
###############################################################################
require 'common/model/db_code_conv_module'

class Persona < ActiveRecord::Base
  include Common::Model::DbCodeConvModule
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :account_id, :seq_no, :enc_nickname, :enc_country_name_cd, :enc_lang_name_cd,
                  :enc_timezone_id, :enc_postcode, :enc_email,
                  :enc_mobile_phone_no, :mobile_carrier_id, :enc_mobile_email,
                  :enc_mobile_id_no, :enc_mobile_host, :lock_version
                  
  #############################################################################
  # リレーション設定
  #############################################################################
  # アカウント
  belongs_to :account
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :account_id,
    :presence => true
  validates :seq_no,
    :presence => true
  validates :enc_nickname,
    :presence => true
  validates :enc_country_name_cd,
    :presence => true
  validates :enc_lang_name_cd,
    :presence => true
  validates :enc_timezone_id,
    :presence => true
  validates :enc_postcode,
    :presence => true
  validates :enc_email,
    :presence => true
  validates :enc_mobile_phone_no,
    :presence => true
  validates :mobile_carrier_id,
    :presence => true
  validates :enc_mobile_email,
    :presence => true

  #############################################################################
  # public定義
  #############################################################################
  public
  # 国取得
  def country
    country_name_cd = self.dec_value(:enc_country_name_cd)
    return nil if country_name_cd.nil?
    return Country.where("country_name_cd = ?", country_name_cd)[0]
  end
  
  # 言語取得
  def language
    lang_name_cd = self.dec_value(:enc_lang_name_cd)
    return nil if lang_name_cd.nil?
    return Language.where("lang_name_cd = ?", lang_name_cd)[0]
  end
  
  # タイムゾーン取得
  def timezone
    timezone_id = self.dec_value(:enc_timezone_id)
    return nil if timezone_id.nil?
    return Timezone.where("timezone_id = ?", timezone_id)[0]
  end
  
end
