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
require 'business/biz_login/biz_login'

class BizLogin < ActiveSupport::TestCase
  include UnitTestUtil
  include Business::BizLogin
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
      biz_login = BizLogin.new(controller)
      # コンストラクタ生成
      assert(!biz_login.nil?, "CASE:2-1-1-1")
      # パラメータチェック
      assert(biz_login.valid?, "CASE:2-1-1-2")
      # アクセサ
      assert(biz_login.login_id == 'a', "CASE:2-1-1-3")
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
      biz_login = BizLogin.new(controller)
      # コンストラクタ生成
      assert(!biz_login.nil?, "CASE:2-1-2-1")
      # パラメータチェック
#      valid_flg = biz_login.valid?
#      print_log('err_msg:' + biz_login.error_msg_hash[:err_msg].to_s)
      assert(!biz_login.valid?, "CASE:2-1-2-2")
      # アクセサ
      print_log('login_id:' + biz_login.login_id.to_s)
      assert(biz_login.login_id == 'b', "CASE:2-1-2-3")
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
      biz_login = BizLogin.new(controller)
      # コンストラクタ生成
      assert(!biz_login.nil?, "CASE:2-1-2-1")
      # パラメータチェック
      assert(!biz_login.valid?, "CASE:2-1-2-2")
      # アクセサ
      assert(biz_login.login_id == 'a', "CASE:2-1-2-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
  end
end