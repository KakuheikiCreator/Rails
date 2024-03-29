# -*- coding: utf-8 -*-
###############################################################################
# モデル：会員状態
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/31 Nakanohito
# 更新日:
###############################################################################
class MemberState < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :member_state_cls, :member_state, :member_state_simple, :lock_version
  
  #############################################################################
  # 定数定義
  #############################################################################
  # 会員状態（仮登録）
  MEMBER_STATE_CLS_PROVISIONAL = 'PRG'
  # 会員状態（本登録）
  MEMBER_STATE_CLS_DEFINITIVE  = 'DRG'
  # 会員状態（仮更新）
  MEMBER_STATE_CLS_UPDATE = 'PUD'
  # 会員状態（資格停止）
  MEMBER_STATE_CLS_STOP   = 'QST'
  
  #############################################################################
  # リレーション設定
  #############################################################################
  # アカウント
  has_many :account
  # 退会者
  has_many :person_withdrawal            
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :member_state_cls,
    :presence => true,
    :length => {:is => 3}
  validates :member_state,
    :presence => true,
    :length => {:maximum => 255}
  validates :member_state_simple,
    :presence => true,
    :length => {:maximum => 255}
end
