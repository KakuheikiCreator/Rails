# -*- coding: utf-8 -*-
###############################################################################
# 正規表現フォーマットバリデータクラス
# Copyright:Copyright (c) 2013 仲観派
# 作成日:2012/01/19 Nakanohito
# 更新日:
###############################################################################
require 'common/validation_chk_module'

module Validators
  class RegexpValidator < ActiveModel::EachValidator
    include Common::ValidationChkModule
    # URIフォーマットチェックバリデート
    def validate_each(record, attribute, value)
      record.errors.add(attribute, :invalid) unless regexp?(value)
    end
  end
end