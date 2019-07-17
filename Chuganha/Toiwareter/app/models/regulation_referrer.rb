# -*- coding: utf-8 -*-
###############################################################################
# モデル：規制リファラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
require 'common/model/where_clause'
require 'common/validation_chk_module'
require 'validators/regexp_validator'

class RegulationReferrer < AccessManagementSuper
  include Common::Model
  include Common::ValidationChkModule
  include Validators
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :system_id, :referrer, :remarks
  
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
  validates :referrer,
    :presence => true,
    :length => {:maximum => 1024, :allow_nil=>true},
    :regexp => {:allow_nil=>true}
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
    # リファラー
    where_clause.p_match(:referrer=>referrer) unless blank?(referrer)
    # 備考
    where_clause.p_match(:remarks=>remarks) unless blank?(remarks)
    return where_clause.to_condition
  end
  
  # 重複データ検索条件生成
  def generate_duplicate_condition
    return {:system_id => system_id,
            :referrer => referrer}
  end
end
