# -*- coding: utf-8 -*-
###############################################################################
# モデル：ゲーム機
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/26 Nakanohito
# 更新日:
###############################################################################

class GameConsole < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :game_console_name, :lock_version
  
  #############################################################################
  # 定数定義
  #############################################################################
  # ID（その他）
  ID_OTHER = 9
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :game_console_name,
    :presence => true,
    :length => {:maximum => 255}
end