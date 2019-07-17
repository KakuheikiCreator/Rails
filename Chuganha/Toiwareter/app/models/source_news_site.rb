# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所（ニュースサイト）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/01 Nakanohito
# 更新日:
###############################################################################

class SourceNewsSite < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_id,
                  :site_name, :article_title, :posted_date,
                  :reporter, :job_title_id, :job_title, :quoted_source_url,
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
  validates :article_title,
    :presence => true,
    :length => {:maximum => 80}
  validates :reporter,
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
    text :site_name, :reporter, :job_title
    integer :job_title_id
    time :posted_date
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 履歴生成
  def new_history
    ent = SourceHistoryNewsSite.new
    ent.source_id     = self.source_id
    ent.site_name     = self.site_name
    ent.article_title = self.article_title
    ent.posted_date   = self.posted_date
    ent.reporter      = self.reporter
    ent.job_title_id  = self.job_title_id
    ent.job_title     = self.job_title
    ent.quoted_source_url = self.quoted_source_url
    return ent
  end
end
