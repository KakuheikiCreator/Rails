# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所（書籍）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/01 Nakanohito
# 更新日:
###############################################################################

class SourceBook < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_id, :isbn, :book_title, :publisher, :release_date,
                  :author, :job_title_id, :job_title,
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
  validates :isbn,
    :allow_nil => true,
    :length => {:maximum => 17}
  validates :book_title,
    :allow_nil => true,
    :length => {:maximum => 60}
  validates :publisher,
    :allow_nil => true,
    :length => {:maximum => 60}
  validates :author,
    :presence => true,
    :length => {:maximum => 60}
  validates :job_title,
    :allow_nil => true,
    :length => {:maximum => 40}
  
  #############################################################################
  # Solr設定
  #############################################################################
  searchable do
    text :book_title, :publisher, :author, :job_title
    integer :job_title_id
    time :release_date
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 履歴生成
  def new_history
    ent = SourceHistoryBook.new
    ent.source_id   = self.source_id
    ent.isbn        = self.isbn
    ent.book_title  = self.book_title
    ent.publisher   = self.publisher
    ent.release_date  = self.release_date
    ent.author        = self.author
    ent.job_title_id  = self.job_title_id
    ent.job_title     = self.job_title
    return ent
  end

end
