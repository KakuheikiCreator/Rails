# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所履歴（新聞）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/19 Nakanohito
# 更新日:
###############################################################################

class SourceHistoryNewspaper < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_history_id,
                  :newspaper_id, :newspaper_detail, :posted_date, :newspaper_cls,
                  :headline, :reporter, :job_title_id, :job_title,
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
end
