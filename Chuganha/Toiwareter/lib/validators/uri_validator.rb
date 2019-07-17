# -*- coding: utf-8 -*-
###############################################################################
# URIフォーマットバリデータクラス
# Copyright:Copyright (c) 2013 仲観派
# 作成日:2011/08/18 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'

module Validators
  class UriValidator < ActiveModel::EachValidator
    include Common::NetUtilModule
    # URIフォーマットチェックバリデート
    def validate_each(record, attribute, value)
      record.errors.add(attribute, :invalid) unless valid_uri?(value)
    end
  end
end