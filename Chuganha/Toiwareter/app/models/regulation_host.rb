# -*- coding: utf-8 -*-
###############################################################################
# モデル：規制ホスト
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
require 'common/model/where_clause'
require 'common/validation_chk_module'
require 'validators/any_exists_validator'
require 'validators/ip_address_validator'
require 'validators/regexp_validator'

class RegulationHost < AccessManagementSuper
  include Common::Model
  include Common::ValidationChkModule
  include Validators
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :system_id, :proxy_host, :proxy_ip_address, :remote_host, :ip_address, :remarks
  
  #############################################################################
  # リレーション設定
  #############################################################################
  # システム
  belongs_to :system
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :system_id,
    :presence => true
  validates :proxy_host,
    :length => {:maximum => 255, :allow_nil=>true},
    :regexp => {:allow_nil => true},
    :any_exists => {:items => [:proxy_ip_address, :remote_host, :ip_address]}
  validates :proxy_ip_address,
    :allow_nil => true,
    :ip_address => true
  validates :remote_host,
    :length => {:maximum => 255, :allow_nil=>true},
    :regexp => {:allow_nil => true}
  validates :ip_address,
    :allow_nil => true,
    :ip_address => true
  validates :remarks,
    :allow_nil => true,
    :length => {:maximum => 255}
  
  #############################################################################
  # 検索条件定義
  #############################################################################
  # リスト検索
  scope :search_list, lambda { |ent|
    where(ent.search_condition)
  }
  
  # 重複データ検索
  scope :duplicate, lambda { |ent|
    where(ent.generate_duplicate_condition)
  }
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 検索条件リスト
  def search_condition
    where_clause = WhereClause.new
    # システムID
    where_clause.where(:system_id=>system_id) unless blank?(system_id)
    # リモートホスト（プロキシ）
    where_clause.p_match(:proxy_host=>proxy_host) unless blank?(proxy_host)
    # IPアドレス（プロキシ）
    where_clause.p_match(:proxy_ip_address=>proxy_ip_address) unless blank?(proxy_ip_address)
    # リモートホスト（クライアント）
    where_clause.p_match(:remote_host=>remote_host) unless blank?(remote_host)
    # IPアドレス（クライアント）
    where_clause.p_match(:ip_address=>ip_address) unless blank?(ip_address)
    # 備考
    where_clause.p_match(:remarks=>remarks) unless blank?(remarks)
    return where_clause.to_condition
  end
  
  # 重複データ検索条件生成
  def generate_duplicate_condition
    return {:system_id=>system_id,
            :proxy_host=>proxy_host,
            :proxy_ip_address=>proxy_ip_address,
            :remote_host=>remote_host,
            :ip_address=>ip_address}
  end
  
end
