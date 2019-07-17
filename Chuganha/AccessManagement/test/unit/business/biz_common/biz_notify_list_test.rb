# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：処理通知ノードリスト
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/06/21 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'business/biz_common/biz_notify_list'

class BizNotifyListTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Business::BizCommon
  # 前処理
#  def setup
#    BizNotifyList.instance.data_load
#  end
  # 後処理
#  def teardown
#  end
  # コンストラクタテスト
  test "2-1:BizNotifyList Test:instance" do
    # コンストラクタ・proc_nodes(proc_id)
    begin
      notify_list = BizNotifyList.instance
      assert(!notify_list.nil?, "CASE:2-1-1")
      # アカウントチェック（有効）
      proc_id = 'TestProc2'
      node_list = notify_list.proc_nodes(proc_id)
      assert(node_list.size == 2, "CASE:2-1-2")
      assert(node_list[0] = 'masamune_svr', "CASE:2-1-2")
      assert(node_list[1] = 'dummy_svr_data', "CASE:2-1-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1")
    end
  end
  
  # 処理通知依頼
  test "2-2:BizNotifyList Test:notify_process?(proc_id)" do
    # コンストラクタ・proc_nodes(proc_id)
    begin
      notify_list = BizNotifyList.instance
      proc_id = 'TestProc'
      assert(notify_list.notify_process?(proc_id), "CASE:2-2-1")
      proc_id = 'TestProc2'
      assert(!notify_list.notify_process?(proc_id), "CASE:2-2-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2")
    end
  end
end
