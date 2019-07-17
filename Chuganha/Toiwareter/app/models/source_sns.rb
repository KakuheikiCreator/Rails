# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所（SNS）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/01 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/sns_cache'

class SourceSns < ActiveRecord::Base
  include DataCache
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_id,
                  :sns_id, :sns_detail_name, :posted_date,
                  :posted_by, :job_title_id, :job_title,
                  :lock_version
  
  #############################################################################
  # リレーション設定
  #############################################################################
  # Quote
  belongs_to :quote
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :source_id,
    :presence => true
  validates :quote_id,
    :presence => true
  validates :sns_id,
    :presence => true
  validates :sns_detail_name,
    :allow_nil => true,
    :length => {:maximum => 60}
  validates :posted_date,
    :presence => true
  validates :posted_by,
    :presence => true,
    :length => {:maximum => 60}
  validates :job_title,
    :allow_nil => true,
    :length => {:maximum => 40}
  
  #############################################################################
  # Solr設定
  #############################################################################
  searchable do
    text :sns_name, :sns_detail_name, :posted_by, :job_title
    integer :job_title_id
    time :posted_date
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # SNS名
  def sns_name
    sns_ent = SnsCache.instance[self.sns_id]
    return nil if sns_ent.nil?
    return sns_ent.sns_name
  end
  
  # 履歴生成
  def new_history
    ent = SourceHistorySns.new
    ent.source_id       = self.source_id
    ent.sns_id          = self.sns_id
    ent.sns_detail_name = self.sns_detail_name
    ent.posted_date   = self.posted_date
    ent.posted_by     = self.posted_by
    ent.job_title_id  = self.job_title_id
    ent.job_title     = self.job_title
    return ent
  end
end
