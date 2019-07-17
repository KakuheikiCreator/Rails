# -*- coding: utf-8 -*-
###############################################################################
# モデル：携帯キャリア
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/31 Nakanohito
# 更新日:
###############################################################################
class MobileCarrier < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :mobile_carrier_cd, :mobile_domain_no, :mobile_carrier, :domain, :lock_version
  
  #############################################################################
  # 定数定義
  #############################################################################
  # 携帯キャリアコード（Docomo）
  CARRIER_CD_DOCOMO   = '00'
  # 携帯キャリアコード（AU）
  CARRIER_CD_AU       = '01'
  # 携帯キャリアコード（SoftBank）
  CARRIER_CD_SOFTBANK = '02'
  # 携帯キャリアコード（Disney）
  CARRIER_CD_DISNEY   = '03'
  # 携帯キャリアコード（Willcom）
  CARRIER_CD_WILLCOM  = '04'
  # 携帯キャリアコード（イーモバイル）
  CARRIER_CD_EMOBILE  = '05'
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :mobile_carrier_cd,
    :presence => true,
    :length => {:is => 2}
  validates :mobile_domain_no,
    :presence => true
  validates :mobile_carrier,
    :presence => true,
    :length => {:maximum => 255}
  validates :domain,
    :presence => true,
    :length => {:maximum => 255}
end
