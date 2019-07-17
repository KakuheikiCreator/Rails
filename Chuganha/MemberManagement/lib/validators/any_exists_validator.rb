# -*- coding: utf-8 -*-
###############################################################################
# 関連項目存在バリデータクラス
# Copyright:Copyright (c) 2011 仲観派
# 作成日:2011/08/15 Nakanohito
# 更新日:
###############################################################################
require 'common/validation_chk_module'

module Validators
  class AnyExistsValidator < ActiveModel::EachValidator
    include Common::ValidationChkModule
    # 条件付きチェックバリデート
    def validate_each(record, attribute, value)
      # 自項目値のNULL判定
      return if options[:allow_nil] && blank?(value)
      return unless blank?(value)
      # グループ項目値取得
      items = options[:items]
      raise ArgumentError, 'invalid argument' unless Array === items
      # グループ項目値のNULL判定
      items.each do |item|
        return unless blank?(record.attributes[item.to_s])
      end
      # グループ項目値が全てNULL
      item_names = ['']
      items.each do |item| item_names.push(record.class.human_attribute_name(item.to_s)) end
      record.errors.add(attribute, I18n.t('errors.messages.any_exists', :items=>item_names.join(',')))
    end
    
    # 未入力判定
    def nil_or_empty?(value)
      return true if value.nil?
      return String === value && value.empty?
    end
  end
end