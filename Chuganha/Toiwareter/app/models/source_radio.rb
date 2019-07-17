# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所（ラジオ）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/01 Nakanohito
# 更新日:
###############################################################################

class SourceRadio < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_id,
                  :program_name, :broadcast_date, :production, :radio_station, 
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
  validates :program_name,
    :presence => true,
    :length => {:maximum => 60}
  validates :broadcast_date,
    :presence => true
  validates :production,
    :allow_nil => true,
    :length => {:maximum => 60}
  validates :radio_station,
    :presence => true,
    :length => {:maximum => 60}
  
  #############################################################################
  # Solr設定
  #############################################################################
  searchable do
    text :program_name, :production, :radio_station
    time :broadcast_date
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 履歴生成
  def new_history
    ent = SourceHistoryRadio.new
    ent.source_id      = self.source_id
    ent.program_name   = self.program_name
    ent.broadcast_date = self.broadcast_date
    ent.production     = self.production
    ent.radio_station  = self.radio_station
    return ent
  end
end
