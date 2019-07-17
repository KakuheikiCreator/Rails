# -*- coding: utf-8 -*-
###############################################################################
# モデル：認証履歴
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/31 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'
require 'validators/ip_address_validator'
require 'validators/uri_validator'

class AuthenticationHistory < ActiveRecord::Base
  include Validators
  include Common::NetUtilModule
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :account_id, :seq_no, :server_url,
                  :authentication_date, :authentication_result,
                  :ip_address, :referer, :user_agent, :lock_version
  
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
  validates :server_url,
    :presence => true,
    :length => {:maximum => 255},
    :uri => true
  validates :authentication_date,
    :presence => true
  validates :authentication_result,
    :inclusion => {:in=>[true, false]}
  validates :ip_address,
    :allow_nil => true,
    :ip_address => true
  validates :referer,
    :allow_nil => true,
    :length => {:maximum => 255},
    :uri => true
  validates :user_agent,
    :allow_nil => true,
    :length => {:maximum => 255}

  #############################################################################
  # public定義
  #############################################################################
  public
  # アカウント情報設定
  def set_account_info(account)
    self.account_id = account.id
    self.seq_no = account.last_auth_seq_no
  end
  
  # 認証結果情報設定
  def set_auth_info(new_auth_time, new_auth_result, request, new_server_url=nil)
    self.server_url = new_server_url
    self.authentication_date = new_auth_time
    self.authentication_result = new_auth_result
    host_info = extract_host(request)
    if host_info.size == 2 then
      self.ip_address = host_info[1]
    else
      self.ip_address = host_info[3]
    end
    self.referer    = request.referer
    self.user_agent = request.headers['HTTP_USER_AGENT']
  end
  
end
