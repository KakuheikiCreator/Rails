# -*- coding: utf-8 -*-
###############################################################################
# IPアドレスフォーマットバリデータクラス
# Copyright:Copyright (c) 2011 仲観派
# 作成日:2011/08/18 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'
require 'common/validation_chk_module'

module Validators
  class IpAddressValidator < ActiveModel::EachValidator
    include Common::NetUtilModule
    include Common::ValidationChkModule
    # IPアドレスのフォーマットチェックバリデート
    def validate_each(record, attribute, value)
      # 自項目値のNULL判定
      return if options[:allow_nil] && blank?(value)
      record.errors.add(attribute, :invalid) unless valid_ip_address?(value)
    end
  end
end
