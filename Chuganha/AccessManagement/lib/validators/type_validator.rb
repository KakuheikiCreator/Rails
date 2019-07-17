# -*- coding: utf-8 -*-
###############################################################################
# 型バリデータクラス
# Copyright:Copyright (c) 2011 仲観派
# 作成日:2011/08/09 Nakanohito
# 更新日:
###############################################################################
module Validators
  class TypeValidator < ActiveModel::EachValidator
    # 型チェックバリデート
    def validate_each(record, attribute, value)
      type = nil
      case options[:type]
      when :Boolean
        record.errors.add(attribute, :invalid) unless TrueClass === value || FalseClass === value
        return
      when Integer
        type = Fixnum
      when DateTime
        type = Time
      end
      record.errors.add(attribute, :invalid) unless type === value
    end
  end
end