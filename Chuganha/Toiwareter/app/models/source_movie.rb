# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所（雑誌）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/01 Nakanohito
# 更新日:
###############################################################################

class SourceMovie < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_id,
                  :title, :production, :sold_by, :release_date, 
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
  validates :title,
    :presence => true,
    :length => {:maximum => 60}
  validates :production,
    :presence => true,
    :length => {:maximum => 60}
  validates :sold_by,
    :allow_nil => true,
    :length => {:maximum => 60}
  
  #############################################################################
  # Solr設定
  #############################################################################
  searchable do
    text :title, :production, :sold_by
    time :release_date
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 履歴生成
  def new_history
    ent = SourceHistoryMovie.new
    ent.source_id    = self.source_id
    ent.title        = self.title
    ent.production   = self.production
    ent.sold_by      = self.sold_by
    ent.release_date = self.release_date
    return ent
  end
end
