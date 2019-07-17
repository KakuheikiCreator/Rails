# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所（雑誌）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/01 Nakanohito
# 更新日:
###############################################################################

class SourceOtherSite < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_id,
                  :site_name, :page_name, :posts_by, :job_title_id, :job_title,
                  :posted_date, :quoted_source_url,
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
  validates :site_name,
    :presence => true,
    :length => {:maximum => 60}
  validates :page_name,
    :allow_nil => true,
    :length => {:maximum => 80}
  validates :posts_by,
    :allow_nil => true,
    :length => {:maximum => 60}
  validates :job_title,
    :allow_nil => true,
    :length => {:maximum => 40}
  validates :quoted_source_url,
    :presence => true,
    :length => {:maximum => 255}
  
  #############################################################################
  # Solr設定
  #############################################################################
  searchable do
    text :site_name, :posts_by, :job_title
    integer :job_title_id
    time :posted_date
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 履歴生成
  def new_history
    ent = SourceHistoryOtherSite.new
    ent.source_id    = self.source_id
    ent.site_name    = self.site_name
    ent.page_name    = self.page_name
    ent.posts_by     = self.posts_by
    ent.job_title_id = self.job_title_id
    ent.job_title    = self.job_title
    ent.posted_date  = self.posted_date
    ent.quoted_source_url = self.quoted_source_url
    return ent
  end
end
