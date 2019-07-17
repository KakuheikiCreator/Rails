# -*- coding: utf-8 -*-
###############################################################################
# モデル：出所（音楽）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/01 Nakanohito
# 更新日:
###############################################################################

class SourceHistoryMusic < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :source_id, :quote_history_id,
                  :music_name, :lyricist, :composer, :jasrac_code, :iswc,
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
  
end
