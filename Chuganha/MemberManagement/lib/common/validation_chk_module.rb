# -*- coding: utf-8 -*-
###############################################################################
# バリデーションチェックモジュール
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/06/25 Nakanohito
# 更新日:
###############################################################################
require 'date'

module Common
  module ValidationChkModule
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    ###########################################################################
    # 定数定義
    ###########################################################################
    REG_HANKAKU         = /^[ -~｡-ﾟ]*$/    # 正規表現（半角）
    REG_ZENKAKU         = /^[^ -~｡-ﾟ]*$/   # 正規表現（全角）
    REG_ALPHABETIC      = /^[A-Za-z]*$/    # 正規表現（英字）
    REG_NUMERIC         = /^[0-9]*$/       # 正規表現（数字）
    REG_ALPHANUMERIC    = /^[A-Za-z0-9]*$/ # 正規表現（英数字）
    REG_YOMIGANA        = /^[ア-ヴ・＝ー]*$/ # 正規表現（ヨミガナ）
    REG_MOBILE_PHONE_NO = /^0(7|8|9)0-?[0-9]{4}-?[0-9]{4}$/ # 正規表現（携帯電話番号）

    # ブランクチェック
    def blank?(val)
      return val.empty? if String === val
      return val.nil?
    end
    module_function :blank?

    # 文字数チェック
    def length_is?(val, size)
      unless (val.nil? || String === val || Numeric === val) && Numeric === size
        raise ArgumentError, 'invalid argument'
      end
      return false if size.to_i < 0
      return val.to_s.chars.count == size.to_i
    end

    # 桁あふれチェック
    def overflow?(val, size)
      unless (val.nil? || String === val || Numeric === val) && Numeric === size
        raise ArgumentError, 'invalid argument'
      end
      return true if size.to_i < 0
      return val.to_s.chars.count > size.to_i
    end

    # 半角チェック
    def hankaku?(val)
      return false unless String === val
      return (REG_HANKAKU =~ val) != nil
    end

    # 全角チェック
    def zenkaku?(val)
      return false unless String === val
      return (REG_ZENKAKU =~ val) != nil
    end

    # 半角英字チェック
    def alphabetic?(val)
      return false unless String === val
      return (REG_ALPHABETIC =~ val) != nil
    end

    # 半角数字チェック
    def numeric?(val)
      return false unless String === val
      return (REG_NUMERIC =~ val) != nil
    end

    # 半角英数字チェック
    def alphanumeric?(val)
      return false unless String === val
      return (REG_ALPHANUMERIC =~ val) != nil
    end

    # ヨミガナェック
    def yomigana?(val)
      return false unless String === val
      return (REG_YOMIGANA =~ val) != nil
    end

    # 日付妥当性チェック
    def valid_date?(year, month, day)
      return false if blank?(year) || blank?(month) || blank?(day)
      return false if month.to_i < 1 || day.to_i < 1
      return Date.valid_date?(year.to_i, month.to_i, day.to_i)
    rescue StandardError => ex
      return false
    end

    # 過去日付チェック
    def past_date?(year, month, day)
      return false unless valid_date?(year, month, day)
      target_date = Date.new(year.to_i, month.to_i, day.to_i)
      return target_date < Date.today
    end

    # 携帯電話番号書式チェック
    def mobile_phone_no?(val)
      return false unless String === val
      return (REG_MOBILE_PHONE_NO =~ val) != nil
    end

    # 正規表現書式チェック
    def regexp?(val)
      return false unless String === val
      return true unless Regexp.new(val).nil?
    rescue RegexpError => ex
      return false
    end
  end
end