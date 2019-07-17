# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所履歴（雑誌）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/19 Nakanohito
# 更新日:
###############################################################################

class SourceHistoryMovie < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_history_id,
                  :title, :production, :sold_by, :release_date, 
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
  validates :title,
    :presence => true,
    :length => {:maximum => 60}
  validates :production,
    :presence => true,
    :length => {:maximum => 60}
  validates :sold_by,
    :allow_nil => true,
    :length => {:maximum => 60}
  
end
