# -*- coding: utf-8 -*-
###############################################################################
# モデル：OpenID組織
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/31 Nakanohito
# 更新日:
###############################################################################

class OpenIdAssociation < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :server_url, :secret, :handle, :assoc_type, :issued, :lifetime, :lock_version
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :server_url,
    :presence => true
  validates :secret,
    :presence => true
  validates :handle,
    :presence => true,
    :length => {:maximum => 255}
  validates :assoc_type,
    :presence => true,
    :length => {:maximum => 255}
  validates :issued,
    :presence => true
  validates :lifetime,
    :presence => true
end
