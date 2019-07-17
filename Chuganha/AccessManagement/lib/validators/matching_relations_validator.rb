# -*- coding: utf-8 -*-
###############################################################################
# 関連項目値のマッチングバリデータクラス
# Copyright:Copyright (c) 2011 仲観派
# 作成日:2012/01/12 Nakanohito
# 更新日:
###############################################################################
module Validators
  class MatchingRelationsValidator < ActiveModel::EachValidator
    public
    # 条件付きチェックバリデート
    def validate_each(record, attribute, value)
      # バリデート対象値判定
      return unless target_value?(value)
      # 関係項目値取得
      related_item = options[:item].to_s
      related_val = record.attributes[related_item]
      # 関連項目の値判定（ホワイトリスト）
      in_option = options[:in]
      unless in_option.nil? then
        add_message(record, attribute, related_item) unless inclusion?(value, related_val, in_option)
        return
      end
      # 関連項目の値判定（ブラックリスト）
      ex_option = options[:ex]
      unless ex_option.nil? then
        add_message(record, attribute, related_item) if inclusion?(value, related_val, ex_option)
        return
      end
      # 関連項目値のNULL判定
      add_message(record, attribute, related_item) if related_val.nil?
    end
    protected
    # バリデート対象値判定
    def target_value?(value)
      values = options[:values]
      return true if values == :all
      return value.nil? if values == :null
      return !value.nil? if values == :not_null
      return !values.index(value).nil?
    end
    # inclusionチェック
    def inclusion?(value, related_val, inclusion)
      return !inclusion.index(related_val).nil? if Array === inclusion
      if Hash === inclusion then
        return (related_val == inclusion[:null]) if value.nil?
        return (related_val == inclusion[:not_null]) if inclusion.key?(:not_null)
        return (related_val == inclusion[value])
      end
      return (inclusion === related_val) if Range === inclusion
      return false
    end
    # エラーメッセージ追加
    def add_message(record, attribute, related_item)
      message = I18n.t('errors.messages.consistency',
                       :target=>record.class.human_attribute_name(related_item))
      record.errors.add(attribute, message)
    end
  end
end