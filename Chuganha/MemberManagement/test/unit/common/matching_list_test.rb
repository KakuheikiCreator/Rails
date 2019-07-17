###############################################################################
# ユニットテストクラス
# テスト対象：マッチングリスト
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/07/12 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'test_helper'
require 'common/matching_list'


class MatchingListTest < ActiveSupport::TestCase
  include Common

  # テスト対象メソッド：include?
  test "CASE:2-1 performance" do
    array_list = Array.new
    hash_list = Hash.new(false)
    matching_list = MatchingList.new(4)
    i=0
    max_cnt = 100000
    while i < max_cnt do
      str = generate_random_string(32)
      unless hash_list[str] then
        array_list.push(str)
        matching_list.push(str)
        hash_list[str] = true
        i += 1
      end
    end
    print("Array Start Time:", Time.now.instance_eval { '%s.%03d' % [strftime('%Y%m%d%H%M%S'), (usec / 1000.0).round] }, "\n")
    j = 0
    while j < 1000 do
      k = rand(max_cnt)
      str = array_list[k]
      j += 1 if array_list.include?(str)
    end
    print("Array End   Time:", Time.now.instance_eval { '%s.%03d' % [strftime('%Y%m%d%H%M%S'), (usec / 1000.0).round] }, "\n")
    print("Hash Start Time:", Time.now.instance_eval { '%s.%03d' % [strftime('%Y%m%d%H%M%S'), (usec / 1000.0).round] }, "\n")
    j = 0
    while j < 1000 do
      k = rand(max_cnt)
      str = array_list[k]
      j += 1 if hash_list[str]
    end
    print("Hash End   Time:", Time.now.instance_eval { '%s.%03d' % [strftime('%Y%m%d%H%M%S'), (usec / 1000.0).round] }, "\n")
    print("MatchingList Start Time:", Time.now.instance_eval { '%s.%03d' % [strftime('%Y%m%d%H%M%S'), (usec / 1000.0).round] }, "\n")
    j = 0
    while j < 1000 do
      k = rand(max_cnt)
      str = array_list[k]
      j += 1 if matching_list.include?(str)
    end
    print("MatchingList End   Time:", Time.now.instance_eval { '%s.%03d' % [strftime('%Y%m%d%H%M%S'), (usec / 1000.0).round] }, "\n")
    print("Last String:", str, "\n")
    # 正常ケース
    # 異常ケース
  end
  
  
  # ランダムな文字列生成処理
  def generate_random_string(size)
    # 生成対象の文字コードセット
    character_set = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    # 文字コードセットからランダムに文字を抽出して、指定された桁数の文字列を生成
    return Array.new(size){character_set[rand(character_set.size)]}.join
  end
end
