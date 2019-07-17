# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：リクエストパラメータクラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/15 Nakanohito
# 更新日:
###############################################################################
require 'kconv'
require 'test_helper'
require 'unit/unit_test_util'
require 'messaging/request_parameters'

class RequestParametersTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Messaging

  # テスト対象メソッド：initialize
  test "CASE:2-01 initialize" do
    # 正常ケース（処理依頼リクエスト）
    begin
      msg = RequestParameters.new(Hash.new)
      assert(!msg.nil?, "CASE:2-1-1")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1 Error")
    end
    # 異常ケース
  end
end