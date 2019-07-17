# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所（雑誌）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/01 Nakanohito
# 更新日:
###############################################################################

class SourceMagazine < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_id, :magazine_cd, :magazine_name,
                  :article_title, :publisher, :release_date,
                  :reporter, :job_title_id, :job_title,
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
  validates :magazine_cd,
    :allow_nil => true,
    :length => {:maximum => 11}
  validates :magazine_name,
    :presence => true,
    :length => {:maximum => 60}
  validates :article_title,
    :allow_nil => true,
    :length => {:maximum => 80}
  validates :publisher,
    :allow_nil => true,
    :length => {:maximum => 60}
  validates :release_date,
    :presence => true
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
    text :magazine_name, :publisher, :reporter, :job_title
    integer :job_title_id
    time :release_date
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 履歴生成
  def new_history
    ent = SourceHistoryMagazine.new
    ent.source_id     = self.source_id
    ent.magazine_cd   = self.magazine_cd
    ent.magazine_name = self.magazine_name
    ent.article_title = self.article_title
    ent.publisher     = self.publisher
    ent.release_date  = self.release_date
    ent.reporter      = self.reporter
    ent.job_title_id  = self.job_title_id
    ent.job_title     = self.job_title
    return ent
  end
end
