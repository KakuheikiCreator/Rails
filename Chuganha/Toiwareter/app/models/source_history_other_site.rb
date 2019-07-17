# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所履歴（雑誌）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/19 Nakanohito
# 更新日:
###############################################################################

class SourceHistoryOtherSite < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_history_id,
                  :site_name, :page_name, :posts_by, :job_title_id, :job_title,
                  :posted_date, :quoted_source_url,
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
end
