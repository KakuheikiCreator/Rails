# -*- coding: utf-8 -*-
###############################################################################
# モデル：データ更新日時
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/09 Nakanohito
# 更新日:
###############################################################################
class DataUpdatedDate < AccessManagementSuper
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :data_key, :data_update_time
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :data_key,
    :presence => true,
    :length => {:maximum => 255}
  validates :data_update_time,
    :presence => true
end
