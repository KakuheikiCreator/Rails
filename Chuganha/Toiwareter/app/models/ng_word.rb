# -*- coding: utf-8 -*-
###############################################################################
# モデル：NGワード
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/12 Nakanohito
# 更新日:
###############################################################################

class NgWord < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :ng_word, :replace_word, :replace_count, :lock_version
end
