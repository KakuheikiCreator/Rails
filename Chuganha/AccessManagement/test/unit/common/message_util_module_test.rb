# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：メッセージユーティリティモジュール
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/02/06 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'test_helper'
require 'common/message_util_module'

class MessageUtilModuleTest < ActiveSupport::TestCase
  include Common::MessageUtilModule

  # テスト対象メソッド：blank?
  test "CASE:2-1 MessageUtilModule Test:generate_error_msg" do
    # 正常ケース（オプション無し）
    message = error_msg('activerecord.attributes.browser.browser_name', 'invalid')
    assert_equal(message, "ブラウザ名 は不正な値です。","CASE:2-1-1")
    # 正常ケース（オプション有り）
    message = error_msg('activerecord.attributes.browser.browser_name', 'too_long', :count=>100)
    assert_equal(message, "ブラウザ名 は100文字以内で入力してください。","CASE:2-1-2")
    # 異常ケース
  end
end
