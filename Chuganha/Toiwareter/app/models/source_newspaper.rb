# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所（新聞）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/01 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/newspaper_cache'
require 'data_cache/job_title_cache'

class SourceNewspaper < ActiveRecord::Base
  include DataCache
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_id,
                  :newspaper_id, :newspaper_detail, :posted_date, :newspaper_cls,
                  :headline, :reporter, :job_title_id, :job_title,
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
  validates :newspaper_id,
    :presence => true
  validates :newspaper_detail,
    :allow_nil => true,
    :length => {:maximum => 60}
  validates :posted_date,
    :presence => true
  validates :newspaper_cls,
    :presence => true
  validates :headline,
    :presence => true,
    :length => {:maximum => 80}
  validates :reporter,
    :allow_nil => true,
    :length => {:maximum => 60}
  validates :job_title,
    :allow_nil => true,
    :length => {:maximum => 40}
  
  #############################################################################
  # Solr設定
  #############################################################################
  searchable do
    text :newspaper_name, :newspaper_detail, :reporter, :job_title
    integer :job_title_id
    time :posted_date
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 履歴生成
  def new_history
    ent = SourceHistoryNewspaper.new
    ent.source_id        = self.source_id
    ent.newspaper_id     = self.newspaper_id
    ent.newspaper_detail = self.newspaper_detail
    ent.posted_date      = self.posted_date
    ent.newspaper_cls    = self.newspaper_cls
    ent.headline     = self.headline
    ent.reporter     = self.reporter
    ent.job_title_id = self.job_title_id
    ent.job_title    = self.job_title
    return ent
  end
  
  # 新聞名
  def newspaper_name
    newspaper = NewspaperCache.instance[self.newspaper_id]
    return '' if newspaper.nil?
    return newspaper.newspaper_name
  end
  
  # 記者肩書き
  def job_title_name
    job_title = JobTitleCache.instance[self.job_title_id]
    return '' if job_title.nil?
    return job_title.job_title
  end
end
