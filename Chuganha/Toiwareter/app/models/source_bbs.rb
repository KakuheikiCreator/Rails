# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所（電子掲示板）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/01 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/bbs_cache'

class SourceBbs < ActiveRecord::Base
  include DataCache
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_id, :bbs_id, :bbs_detail_name, :thread_title,
                  :posted_date, :posted_by, :quoted_source_url,
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
  validates :bbs_id,
    :presence => true
  validates :bbs_detail_name,
    :allow_nil => true,
    :length => {:maximum => 60}
  validates :thread_title,
    :allow_nil => true,
    :length => {:maximum => 80}
  validates :posted_date,
    :presence => true
  validates :posted_by,
    :presence => true,
    :length => {:maximum => 60}
  validates :quoted_source_url,
    :presence => true,
    :length => {:maximum => 255}
  
  #############################################################################
  # Solr設定
  #############################################################################
  searchable do
    text :bbs_name, :bbs_detail_name, :posted_by
    time :posted_date
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 電子掲示板名
  def bbs_name
    bbs_ent = BbsCache.instance[self.bbs_id]
    return nil if bbs_ent.nil?
    return bbs_ent.bbs_name
  end
  
  # 履歴生成
  def new_history
    ent = SourceHistoryBbs.new
    ent.source_id   = self.source_id
    ent.bbs_id      = self.bbs_id
    ent.bbs_detail_name   = self.bbs_detail_name
    ent.thread_title      = self.thread_title
    ent.posted_date       = self.posted_date
    ent.posted_by         = self.posted_by
    ent.quoted_source_url = self.quoted_source_url
    return ent
  end
end
