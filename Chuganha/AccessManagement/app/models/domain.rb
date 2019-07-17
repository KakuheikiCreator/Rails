# -*- coding: utf-8 -*-
###############################################################################
# モデル：ドメイン
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/09 Nakanohito
# 更新日:
###############################################################################
require 'validators/matching_relations_validator'
require 'validators/host_name_validator'

class Domain < AccessManagementSuper
  include Validators
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :domain_name, :domain_class, :date_confirmed, :remarks, :delete_flg
  #############################################################################
  # 定数定義
  #############################################################################
  # 固定ドメイン
  DOMAIN_CLASS_FIXED = 0
  # その他ドメイン
  DOMAIN_CLASS_OTHER = 1
  
  #############################################################################
  # リレーション設定
  #############################################################################
  # リクエスト解析結果
  has_many :request_analysis_result
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :domain_name,
    :presence => true,
    :host_name => {:allow_nil=>true}
  validates :domain_class,
    :presence => true,
    :inclusion => {:in => [DOMAIN_CLASS_FIXED, DOMAIN_CLASS_OTHER],
                   :allow_nil=>true}
  validates :date_confirmed,
    :matching_relations => {:values=>:all,
                            :item=>:domain_class,
                            :in=>{:null=>DOMAIN_CLASS_FIXED, :not_null=>DOMAIN_CLASS_OTHER}}
  
  #############################################################################
  # publicメソッド定義
  #############################################################################
  public
  
  # 固定ドメインチェック
  def fixed?
    return (self.domain_class == DOMAIN_CLASS_FIXED)
  end
end
