# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所履歴（テレビ）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/19 Nakanohito
# 更新日:
###############################################################################

class SourceHistoryTv < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_history_id,
                  :program_name, :broadcast_date, :production, :tv_station,
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
  validates :program_name,
    :presence => true,
    :length => {:maximum => 60}
  validates :broadcast_date,
    :presence => true
  validates :production,
    :allow_nil => true,
    :length => {:maximum => 60}
  validates :tv_station,
    :presence => true,
    :length => {:maximum => 60}
end
