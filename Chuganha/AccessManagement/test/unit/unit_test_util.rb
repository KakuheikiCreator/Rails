# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストユーティリティクラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/16 Nakanohito
# 更新日:
###############################################################################
module UnitTestUtil
  CHAR_SET_HANKAKU         = (' '..'~').to_a + ('｡'..'ﾟ').to_a    # 半角
  CHAR_SET_ZENKAKU         = ('あ'..'ん').to_a + ('ア'..'ン').to_a # 全角
  CHAR_SET_ALPHABETIC      = ('A'..'Z').to_a + ('a'..'z').to_a   # 英字
  CHAR_SET_NUMERIC         = ('0'..'9').to_a   # 数字
  CHAR_SET_ALPHANUMERIC    = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a # 正規表現（英数字）
  CHAR_SET_YOMIGANA        = ('ア'..'ヴ').to_a + ['・', '＝', 'ー'] # ヨミガナ

  # ランダム文字列生成
  def generate_str(character_set, size)
    # 生成対象の文字コードセット
    # 文字コードセットからランダムに文字を抽出して、指定された桁数の文字列を生成
    return Array.new(size){character_set[rand(character_set.size)]}.join
  end
  # 日時パラメータを生成
  def date_time_param(year, month, day, hour=0, minute=0, second=0)
    params = {:year=>year.to_s, :month=>month.to_s, :day=>day.to_s}
    params[:hour]   = hour.to_s unless hour.nil?
    params[:minute] = minute.to_s unless minute.nil?
    params[:second] = second.to_s unless second.nil?
    return params
  end
  # 日時を生成
  def local_date_time(year, month, day, hour=0, minute=0, second=0)
    return DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, second.to_i, DateTime.now.offset)
  end
  # ログメッセージ出力
  def print_log(message)
    Rails.logger.info(message)
  end
  # エラーログメッセージ出力
  def error_log(message, ex=nil)
    if ActiveModel::Errors === ex then
      ex.errors.each do |attr, msg|
        Rails.logger.error(message + ":" + attr + ":" + msg)
      end
    else
      Rails.logger.error(message)
    end
  end
end