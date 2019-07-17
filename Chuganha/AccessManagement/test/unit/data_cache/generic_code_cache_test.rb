# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：汎用コードキャッシュクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/06/21 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'data_cache/generic_code_cache'

class GenericCodeCacheTest < ActiveSupport::TestCase
  include UnitTestUtil
  include DataCache
  # 前処理
  def setup
    GenericCodeCache.instance.data_load
  end
  # 後処理
#  def teardown
#  end
  # コード情報クラステスト
  test "2-1:CodeInfo Test:instance" do
    # コンストラクタ
    begin
      code_id = 'test_code'
      values = {'key_1'=>'value_1', 'key_2'=>'value_2', 'key_3'=>'value_3'}
      code_info_param = {'code_name'=>'test_code_name', 'code_values'=>values}
      code_info = GenericCodeCache::CodeInfo.new(code_id, code_info_param)
      assert(!code_info.nil?, "CASE:2-1-1")
      assert(code_info.labels.size == 3, "CASE:2-1-2")
      code_info.labels.each do |label|
        assert(values.value?(label), "CASE:2-1-2")
      end
      assert(code_info.labels_hash.size == 3, "CASE:2-1-3")
      code_info.labels_hash.each_pair do |key, label|
        assert(values[label] == key, "CASE:2-1-3")
      end
      assert(code_info.values.size == 3, "CASE:2-1-4")
      code_info.values.each do |key|
        assert(values.key?(key), "CASE:2-1-4")
      end
      assert(code_info.code_name == 'test_code_name', "CASE:2-1-5")
      assert(code_info.code_hash.size == 3, "CASE:2-1-6")
      code_info.code_hash.each_pair do |key, label|
        assert(values[key] == label, "CASE:2-1-6")
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1")
    end
  end
  
  # 汎用コード生成テスト
  test "2-2:GenericCodeCache Test:instance" do
    # コンストラクタ・code_info
    begin
      cache = GenericCodeCache.instance
      assert(!cache.nil?, "CASE:2-2-1")
      # ja
      code_info = cache.code_info('MATCH_COND_CLS')
      assert(code_info.code_name == '一致条件区分', "CASE:2-2-2")
      assert(code_info.code_hash['E'] == 'と一致', "CASE:2-2-2")
      assert(code_info.code_hash['F'] == 'で始まる', "CASE:2-2-2")
      assert(code_info.code_hash['P'] == 'を含む', "CASE:2-2-2")
      assert(code_info.code_hash['B'] == 'で終わる', "CASE:2-2-2")
      # ja
      code_info = cache.code_info('MATCH_COND_CLS', 'ja')
      assert(code_info.code_name == '一致条件区分', "CASE:2-2-2")
      assert(code_info.code_hash['E'] == 'と一致', "CASE:2-2-2")
      assert(code_info.code_hash['F'] == 'で始まる', "CASE:2-2-2")
      assert(code_info.code_hash['P'] == 'を含む', "CASE:2-2-2")
      assert(code_info.code_hash['B'] == 'で終わる', "CASE:2-2-2")
      # en-US
      code_info = cache.code_info('COUNT_L', 'en-US')
      assert(code_info.code_name == 'Count', "CASE:2-2-2")
      assert(code_info.code_hash['ALL'] == 'All', "CASE:2-2-2")
      assert(code_info.code_hash['10'] == '10', "CASE:2-2-2")
      assert(code_info.code_hash['50'] == '50', "CASE:2-2-2")
      assert(code_info.code_hash['100'] == '100', "CASE:2-2-2")
      assert(code_info.code_hash['300'] == '300', "CASE:2-2-2")
      assert(code_info.code_hash['500'] == '500', "CASE:2-2-2")
      # none
      assert(cache.code_info('none').nil?, "CASE:2-2-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    # code_name
    begin
      cache = GenericCodeCache.instance
      # ja
      assert(cache.code_name('MATCH_COND_CLS', 'ja') == '一致条件区分', "CASE:2-2-4")
      # en-US
      assert(cache.code_name('COUNT_L', 'en-US') == 'Count', "CASE:2-2-4")
      # none
      assert(cache.code_name('none').nil?, "CASE:2-2-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    # code_values(code_id, locale=nil)
    begin
      cache = GenericCodeCache.instance
      # ja
      values = cache.code_values('COMP_COND_CLS', 'ja')
      assert(values.size == 6, "CASE:2-2-6")
      assert(values.include?('EQ'), "CASE:2-2-6")
      assert(values.include?('NE'), "CASE:2-2-6")
      assert(values.include?('LT'), "CASE:2-2-6")
      assert(values.include?('GT'), "CASE:2-2-6")
      assert(values.include?('LE'), "CASE:2-2-6")
      assert(values.include?('GE'), "CASE:2-2-6")
      # en
      values = cache.code_values('COMP_COND_CLS', 'en')
      assert(values.size == 6, "CASE:2-2-6")
      assert(values.include?('EQ'), "CASE:2-2-6")
      assert(values.include?('NE'), "CASE:2-2-6")
      assert(values.include?('LT'), "CASE:2-2-6")
      assert(values.include?('GT'), "CASE:2-2-6")
      assert(values.include?('LE'), "CASE:2-2-6")
      assert(values.include?('GE'), "CASE:2-2-6")
      # non
      values = cache.code_values('none', 'en')
      assert(values.nil?, "CASE:2-2-7")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    # code_labels(code_id, locale=nil)
    begin
      cache = GenericCodeCache.instance
      # ja
      labels = cache.code_labels('SORT_ORDER_CLS', 'ja')
      assert(labels.size == 2, "CASE:2-2-8")
      assert(labels.include?('昇順'), "CASE:2-2-8")
      assert(labels.include?('降順'), "CASE:2-2-8")
      # en
      labels = cache.code_labels('SORT_ORDER_CLS', 'en')
      assert(labels.size == 2, "CASE:2-2-8")
      assert(labels.include?('Ascending order'), "CASE:2-2-8")
      assert(labels.include?('Descending order'), "CASE:2-2-8")
      # none
      values = cache.code_labels(nil, 'en')
      assert(values.nil?, "CASE:2-2-9")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-4")
    end
  end
end
