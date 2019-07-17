# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所（Twitter）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/01 Nakanohito
# 更新日:
###############################################################################

class SourceTwitter < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_id,
                  :posted_date, :posted_by, :job_title_id, :job_title,
                  :quoted_source_url,
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
  validates :posted_date,
    :presence => true
  validates :posted_by,
    :presence => true,
    :length => {:maximum => 60}
  validates :job_title,
    :allow_nil => true,
    :length => {:maximum => 60}
  validates :quoted_source_url,
    :presence => true,
    :length => {:maximum => 255}
  
  #############################################################################
  # Solr設定
  #############################################################################
  searchable do
    text :posted_by, :job_title
    integer :job_title_id
    time :posted_date
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 履歴生成
  def new_history
    ent = SourceHistoryTwitter.new
    ent.source_id    = self.source_id
    ent.posted_date  = self.posted_date
    ent.posted_by    = self.posted_by
    ent.job_title_id = self.job_title_id
    ent.job_title    = self.job_title
    ent.quoted_source_url = self.quoted_source_url
    return ent
  end
end
