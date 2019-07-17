# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：業務設定情報クラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/02/07 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'

class ReceivedInfoTest < ActiveSupport::TestCase
  include UnitTestUtil
  # 前処理
  def setup
  end
  # 後処理
  def teardown
  end
  # コンストラクタ
  test "2-1:ReceivedInfo Test:initialize" do
    ############################################################################
    # テスト項目：コンストラクタ
    ############################################################################
    begin
      # 設定情報ロード
      business_config = Business::BizCommon::BusinessConfig.instance
      assert(business_config.system_name == '仲観派', "CASE:2-1-1-1")
      assert(business_config.subsystem_name == 'Access Management', "CASE:2-1-1-2")
      assert(business_config.max_request_frequency == 10, "CASE:2-1-1-3")
      assert(business_config.max_function_state_hash_size == 30, "CASE:2-1-2-4")
      assert(business_config[:system_name] == '仲観派', "CASE:2-1-2-1")
      assert(business_config[:subsystem_name] == 'Access Management', "CASE:2-1-2-2")
      assert(business_config[:max_request_frequency] == 10, "CASE:2-1-2-3")
      assert(business_config[:max_function_state_hash_size] == 30, "CASE:2-1-2-4")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1")
    end
  end
end
