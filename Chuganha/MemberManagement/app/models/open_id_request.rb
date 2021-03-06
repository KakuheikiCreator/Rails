# -*- coding: utf-8 -*-
###############################################################################
# モデル：OpenIDリクエスト
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/31 Nakanohito
# 更新日:
###############################################################################
class OpenIdRequest < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :token, :parameters, :lock_version
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :token,
    :presence => true,
    :length => {:maximum => 255}
  validates :parameters,
    :presence => true
end
