# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所（音楽）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/01 Nakanohito
# 更新日:
###############################################################################

class SourceMusic < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_id,
                  :music_name, :lyricist, :composer, :jasrac_code, :iswc,
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
  validates :music_name,
    :presence => true,
    :length => {:maximum => 60}
  validates :lyricist,
    :allow_nil => true,
    :length => {:maximum => 60}
  validates :composer,
    :presence => true,
    :length => {:maximum => 60}
  validates :jasrac_code,
    :allow_nil => true,
    :length => {:maximum => 10}
  validates :iswc,
    :allow_nil => true,
    :length => {:maximum => 15}
  
  #############################################################################
  # Solr設定
  #############################################################################
  searchable do
    text :music_name, :lyricist, :composer
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 履歴生成
  def new_history
    ent = SourceHistoryMusic.new
    ent.source_id   = self.source_id
    ent.music_name  = self.music_name
    ent.lyricist    = self.lyricist
    ent.composer    = self.composer
    ent.jasrac_code = self.jasrac_code
    ent.iswc        = self.iswc
    return ent
  end
end
