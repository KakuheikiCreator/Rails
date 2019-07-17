# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：アカウント情報キャッシュクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/06/21 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'data_cache/account_cache'

class AccountCacheTest < ActiveSupport::TestCase
  include UnitTestUtil
  include DataCache
  # 前処理
  def setup
    AccountCache.instance.data_load
  end
  # 後処理
#  def teardown
#  end
  # 汎用コード生成テスト
  test "2-1:AccountCache Test:instance" do
    # コンストラクタ・valid_account?(id, password)
    begin
      cache = AccountCache.instance
      assert(!cache.nil?, "CASE:2-1-1")
      # アカウントチェック（有効）
      id = 'a'
      password = 'b'
      assert(cache.valid_account?(id, password), "CASE:2-1-2")
      id = 'test_user'
      password = 'test_pw'
      assert(cache.valid_account?(id, password), "CASE:2-1-2")
      # アカウントチェック（無効）
      id = 'a'
      password = 'bc'
      assert(!cache.valid_account?(id, password), "CASE:2-1-3")
      id = 'abc'
      password = 'b'
      assert(!cache.valid_account?(id, password), "CASE:2-1-3")
      id = ''
      password = 'b'
      assert(!cache.valid_account?(id, password), "CASE:2-1-3")
      id = 'a'
      password = ''
      assert(!cache.valid_account?(id, password), "CASE:2-1-3")
      id = ''
      password = ''
      assert(!cache.valid_account?(id, password), "CASE:2-1-3")
      id = nil
      password = 'b'
      assert(!cache.valid_account?(id, password), "CASE:2-1-4")
      id = 'a'
      password = nil
      assert(!cache.valid_account?(id, password), "CASE:2-1-4")
      id = nil
      password = nil
      assert(!cache.valid_account?(id, password), "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
  end
end
