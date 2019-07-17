# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所履歴（Twitter）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/19 Nakanohito
# 更新日:
###############################################################################

class SourceHistoryTwitter < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_history_id,
                  :posted_date, :posted_by, :job_title_id, :job_title,
                  :quoted_source_url,
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
end
