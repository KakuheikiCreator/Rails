# -*- coding: utf-8 -*-
###############################################################################
# モデル：各モデルのスーパークラス
# 概要：別DBへのコネクションプールがモデル毎に作られるのを回避する為に、スーパークラスを作成
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/30 Nakanohito
# 更新日:
###############################################################################

class AccessManagementSuper < ActiveRecord::Base
  self.abstract_class = true
#  establish_connection :dummy
end