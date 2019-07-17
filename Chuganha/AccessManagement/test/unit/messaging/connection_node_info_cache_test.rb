# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：接続ノード情報キャッシュ
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/12 Nakanohito
# 更新日:
###############################################################################
require 'kconv'
require 'test_helper'
require 'unit/unit_test_util'
require 'messaging/connection_node_info_cache'

class ConnectionNodeInfoCacheTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Messaging

  # テスト対象メソッド：instance
  test "CASE:2-01 instance" do
    # 正常ケース
    begin
      node_info_cache = ConnectionNodeInfoCache.instance
      assert(!node_info_cache.nil?, "CASE:2-1-1")
      assert(node_info_cache.local_info.node_id == "LOCAL", "CASE:2-1-2")
      assert(node_info_cache['MemberManagement'].node_id == 'MemberManagement', "CASE:2-1-3")
#      print_log("key_lifetime_sec:" + key_lifetime_sec.to_s)
#      print_log("lifetime:" + lifetime.to_s)
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1 Error")
    end
    # 異常ケース
  end
  
  # テスト対象メソッド：[]
  test "CASE:2-02 []" do
    # 正常ケース
    begin
      node_info_cache = ConnectionNodeInfoCache.instance
      assert(!node_info_cache.nil?, "CASE:2-2-1")
      assert(node_info_cache['MemberManagement'].node_id == 'MemberManagement', "CASE:2-2-1")
#      print_log("key_lifetime_sec:" + key_lifetime_sec.to_s)
#      print_log("lifetime:" + lifetime.to_s)
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2 Error")
    end
    # 異常ケース
    begin
      node_info_cache = ConnectionNodeInfoCache.instance
      assert(!node_info_cache.nil?, "CASE:2-2-1")
      assert(node_info_cache['NONE'].nil?, "CASE:2-2-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2 Error")
    end
  end
end