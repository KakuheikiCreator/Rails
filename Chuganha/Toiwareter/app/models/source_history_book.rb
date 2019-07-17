# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所履歴（書籍）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/19 Nakanohito
# 更新日:
###############################################################################

class SourceHistoryBook < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_history_id, :isbn, :book_title, :publisher, :release_date,
                  :author, :job_title_id, :job_title,
                  :lock_version
  
  #############################################################################
  # リレーション設定
  #############################################################################
  # QuoteHistory
  belongs_to :quote_history
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :source_id,
    :presence => true
  validates :quote_history_id,
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
end
