# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：Login::LoginController
# アクション：login
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/06/24 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/login/login_action'

class LoginActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::Login
  include Mock
  # 前処理
#  def setup
#    BizNotifyList.instance.data_load
#  end
  # 後処理
#  def teardown
#  end
  # ビジネスアクション
  test "2-1:BizNotifyList Test:valid?" do
    # 正常処理
    begin
      params={:controller_name => 'login',
              :method=>:POST,
              :session=>{},
              :params=>{:login_id=>'a',:password=>'b'}}
      controller = MockController.new(params)
      login_action = LoginAction.new(controller)
      # コンストラクタ生成
      assert(!login_action.nil?, "CASE:2-1-1-1")
      # パラメータチェック
      assert(login_action.valid?, "CASE:2-1-1-2")
      # アクセサ
      assert(login_action.login_id == 'a', "CASE:2-1-1-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 異常処理（ユーザーIDエラー）
    begin
      params={:controller_name => 'login',
              :method=>:POST,
              :session=>{},
              :params=>{:login_id=>'b',:password=>'b'}}
      controller = MockController.new(params)
      login_action = LoginAction.new(controller)
      # コンストラクタ生成
      assert(!login_action.nil?, "CASE:2-1-2-1")
      # パラメータチェック
#      valid_flg = login_action.valid?
#      print_log('err_msg:' + login_action.error_msg_hash[:err_msg].to_s)
      assert(!login_action.valid?, "CASE:2-1-2-2")
      # アクセサ
#      print_log('login_id:' + login_action.login_id.to_s)
      assert(login_action.login_id == 'b', "CASE:2-1-2-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # 異常処理（パスワードエラー）
    begin
      params={:controller_name => 'login',
              :method=>:POST,
              :session=>{},
              :params=>{:login_id=>'a',:password=>'c'}}
      controller = MockController.new(params)
      login_action = LoginAction.new(controller)
      # コンストラクタ生成
      assert(!login_action.nil?, "CASE:2-1-2-1")
      # パラメータチェック
      assert(!login_action.valid?, "CASE:2-1-2-2")
      # アクセサ
      assert(login_action.login_id == 'a', "CASE:2-1-2-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
  end
end