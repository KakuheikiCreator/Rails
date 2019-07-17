# -*- coding: utf-8 -*-
###############################################################################
# ホスト名フォーマットバリデータクラス
# Copyright:Copyright (c) 2011 仲観派
# 作成日:2011/08/18 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'
require 'common/validation_chk_module'

module Validators
  class HostNameValidator < ActiveModel::EachValidator
    include Common::NetUtilModule
    include Common::ValidationChkModule
    # ホスト名フォーマットバリデート
    def validate_each(record, attribute, value)
      # 自項目値のNULL判定
      return if options[:allow_nil] && blank?(value)
      record.errors.add(attribute, :invalid) unless valid_host_name?(value)
    end
  end
end