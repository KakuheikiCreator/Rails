# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所履歴（雑誌）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/19 Nakanohito
# 更新日:
###############################################################################

class SourceHistoryMagazine < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_history_id, :magazine_cd, :magazine_name,
                  :article_title, :publisher, :release_date,
                  :reporter, :job_title_id, :job_title,
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
end
