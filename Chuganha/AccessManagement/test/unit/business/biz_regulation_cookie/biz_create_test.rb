# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：RegulationCookie::RegulationCookieController
# アクション：create
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/06/28 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'business/biz_regulation_cookie/biz_create'
require 'data_cache/regulation_cookie_cache'

class BizCreate < ActiveSupport::TestCase
  include UnitTestUtil
  include Business::BizRegulationCookie
  include Mock
  include DataCache
  # 前処理
  def setup
#    BizNotifyList.instance.data_load
  end
  # 後処理
#  def teardown
#  end
  # バリデーションチェック
  test "2-1:BizCreate Test:valid?" do
    # 正常（全項目入力）
    begin
      system_id = 1
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name=>'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      # コンストラクタ生成
      biz_create = BizCreate.new(controller)
      assert(!biz_create.nil?, "CASE:2-1-1-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.valid?, "CASE:2-1-1-2")
      # アクセサ
      assert(biz_create.regulation_cookie.system_id == system_id, "CASE:2-1-1-3")
      assert(biz_create.regulation_cookie.cookie == cookie, "CASE:2-1-1-4")
      assert(biz_create.regulation_cookie.remarks == remarks, "CASE:2-1-1-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-1-1-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-1-7")
      assert(biz_create.disp_counts == 'ALL', "CASE:2-1-1-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 0, "CASE:2-1-1-9")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 正常（備考未入力、デフォルト以外の検索条件）
    begin
      system_id = '1'
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = nil
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'cookie',
                        :sort_order=>'DESC',
                        :disp_counts=>'500'}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-2-1")
      # パラメータチェック
      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.valid?, "CASE:2-1-2-2")
      # アクセサ
      assert(biz_create.regulation_cookie.system_id == system_id.to_i, "CASE:2-1-2-3")
      assert(biz_create.regulation_cookie.cookie == cookie, "CASE:2-1-2-4")
      assert(biz_create.regulation_cookie.remarks == remarks, "CASE:2-1-2-5")
      assert(biz_create.sort_item == 'cookie', "CASE:2-1-2-6")
      assert(biz_create.sort_order == 'DESC', "CASE:2-1-2-7")
      assert(biz_create.disp_counts == '500', "CASE:2-1-2-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 0, "CASE:2-1-2-9")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    ###########################################################################
    # 単項目チェック
    ###########################################################################
    # 異常（システムID未入力）
    begin
      system_id = nil
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-3-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.valid?, "CASE:2-1-3-2")
      # アクセサ
      regulation_cookie = biz_create.regulation_cookie
#      print_log('system_id:' + regulation_cookie.system_id.to_s)
      assert(regulation_cookie.system_id == system_id, "CASE:2-1-3-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-3-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-3-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-1-3-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-3-7")
      assert(biz_create.disp_counts == '500', "CASE:2-1-3-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 2, "CASE:2-1-3-9")
#      print_log('system_name:' + biz_create.error_msg_hash[:system_name].to_s)
      assert(biz_create.error_msg_hash[:system_name] == 'システム名 は不正な値です。', "CASE:2-1-3-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # 異常（システムID属性異常）
    begin
      system_id = 'a'
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-4-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.valid?, "CASE:2-1-4-2")
      # アクセサ
      regulation_cookie = biz_create.regulation_cookie
#      print_log('system_id:' + regulation_cookie.system_id.to_s)
      assert(regulation_cookie.system_id == 0, "CASE:2-1-4-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-4-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-4-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-1-4-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-4-7")
      assert(biz_create.disp_counts == '500', "CASE:2-1-4-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 1, "CASE:2-1-4-9")
#      print_log('system_name:' + biz_create.error_msg_hash[:system_name].to_s)
      assert(biz_create.error_msg_hash[:system_name] == 'システム名 は不正な値です。', "CASE:2-1-4-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
    # 異常（クッキー未入力）
    begin
      system_id = 1
      cookie = nil
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-5-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.valid?, "CASE:2-1-5-2")
      # アクセサ
      regulation_cookie = biz_create.regulation_cookie
      assert(regulation_cookie.system_id == system_id, "CASE:2-1-5-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-5-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-5-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-1-5-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-5-7")
      assert(biz_create.disp_counts == '500', "CASE:2-1-5-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 1, "CASE:2-1-5-9")
#      print_log('cookie:' + biz_create.error_msg_hash[:cookie].to_s)
      assert(biz_create.error_msg_hash[:cookie] == 'クッキー を入力してください。', "CASE:2-1-5-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-5")
    end
    # 異常（クッキー文字数オーバー）
    begin
      system_id = 1
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1025)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-6-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.valid?, "CASE:2-1-6-2")
      # アクセサ
      regulation_cookie = biz_create.regulation_cookie
      assert(regulation_cookie.system_id == system_id, "CASE:2-1-6-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-6-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-6-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-1-6-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-6-7")
      assert(biz_create.disp_counts == '500', "CASE:2-1-6-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 1, "CASE:2-1-6-9")
#      print_log('cookie:' + biz_create.error_msg_hash[:cookie].to_s)
      assert(biz_create.error_msg_hash[:cookie] == 'クッキー は1024文字以内で入力してください。', "CASE:2-1-6-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-6")
    end
    # 異常（正規表現ではないクッキー）
    begin
      system_id = 1
      cookie = '^['
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-7-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.valid?, "CASE:2-1-7-2")
      # アクセサ
      regulation_cookie = biz_create.regulation_cookie
      assert(regulation_cookie.system_id == system_id, "CASE:2-1-7-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-7-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-7-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-1-7-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-7-7")
      assert(biz_create.disp_counts == '500', "CASE:2-1-7-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 1, "CASE:2-1-7-9")
#      print_log('cookie:' + biz_create.error_msg_hash[:cookie].to_s)
      assert(biz_create.error_msg_hash[:cookie] == 'クッキー は不正な値です。', "CASE:2-1-7-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-7")
    end
    # 異常（備考文字数オーバー）
    begin
      system_id = 1
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 256)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-8-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.valid?, "CASE:2-1-8-2")
      # アクセサ
      regulation_cookie = biz_create.regulation_cookie
      assert(regulation_cookie.system_id == system_id, "CASE:2-1-8-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-8-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-8-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-1-8-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-8-7")
      assert(biz_create.disp_counts == '500', "CASE:2-1-8-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 1, "CASE:2-1-8-9")
#      print_log('remarks:' + biz_create.error_msg_hash[:remarks].to_s)
      assert(biz_create.error_msg_hash[:remarks] == '備考 は255文字以内で入力してください。', "CASE:2-1-8-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-8")
    end
    ###########################################################################
    # 異常（ソート項目が空文字）
    begin
      system_id = 1
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'',
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-9-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.valid?, "CASE:2-1-9-2")
      # アクセサ
      regulation_cookie = biz_create.regulation_cookie
      assert(regulation_cookie.system_id == system_id, "CASE:2-1-9-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-9-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-9-5")
      assert(biz_create.sort_item == '', "CASE:2-1-9-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-9-7")
      assert(biz_create.disp_counts == '500', "CASE:2-1-9-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 1, "CASE:2-1-9-9")
#      print_log('sort_cond:' + biz_create.error_msg_hash[:sort_cond].to_s)
      assert(biz_create.error_msg_hash[:sort_cond] == '検索結果並び順 を入力してください。', "CASE:2-1-9-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-9")
    end
    # 異常（ソート項目が存在しない項目名）
    begin
      system_id = 1
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'err_system_id',
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-10-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.valid?, "CASE:2-1-10-2")
      # アクセサ
      regulation_cookie = biz_create.regulation_cookie
      assert(regulation_cookie.system_id == system_id, "CASE:2-1-10-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-10-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-10-5")
      assert(biz_create.sort_item == 'err_system_id', "CASE:2-1-10-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-10-7")
      assert(biz_create.disp_counts == '500', "CASE:2-1-10-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 1, "CASE:2-1-10-9")
#      print_log('sort_cond:' + biz_create.error_msg_hash[:sort_cond].to_s)
      assert(biz_create.error_msg_hash[:sort_cond] == '検索結果並び順 は不正な値です。', "CASE:2-1-10-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-10")
    end
    # 異常（検索件数が空文字）
    begin
      system_id = 1
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>''}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-11-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.valid?, "CASE:2-1-11-2")
      # アクセサ
      regulation_cookie = biz_create.regulation_cookie
      assert(regulation_cookie.system_id == system_id, "CASE:2-1-11-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-11-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-11-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-1-11-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-11-7")
      assert(biz_create.disp_counts == '', "CASE:2-1-11-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 1, "CASE:2-1-11-9")
#      print_log('disp_counts:' + biz_create.error_msg_hash[:disp_counts].to_s)
      assert(biz_create.error_msg_hash[:disp_counts] == '表示件数 を入力してください。', "CASE:2-1-11-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-11")
    end
    # 異常（検索件数が、汎用コードに存在しない値）
    begin
      system_id = 1
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>'a'}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-12-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.valid?, "CASE:2-1-12-2")
      # アクセサ
      regulation_cookie = biz_create.regulation_cookie
      assert(regulation_cookie.system_id == system_id, "CASE:2-1-12-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-12-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-12-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-1-12-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-12-7")
      assert(biz_create.disp_counts == 'a', "CASE:2-1-12-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 1, "CASE:2-1-12-9")
#      print_log('disp_counts:' + biz_create.error_msg_hash[:disp_counts].to_s)
      assert(biz_create.error_msg_hash[:disp_counts] == '表示件数 は不正な値です。', "CASE:2-1-12-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-12")
    end
    ###########################################################################
    # DB関連チェック
    ###########################################################################
    # 異常（システムIDが、マスタに存在しない値）
    begin
      system_id = 100
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-13-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.valid?, "CASE:2-1-13-2")
      # アクセサ
      regulation_cookie = biz_create.regulation_cookie
      assert(regulation_cookie.system_id == system_id, "CASE:2-1-13-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-13-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-13-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-1-13-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-13-7")
      assert(biz_create.disp_counts == 'ALL', "CASE:2-1-13-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 1, "CASE:2-1-13-9")
#      print_log('disp_counts:' + biz_create.error_msg_hash[:disp_counts].to_s)
      assert(biz_create.error_msg_hash[:system_name] == 'システム名 は不正な値です。', "CASE:2-1-13-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-13")
    end
    # 異常（重複データ有り）
    begin
      system_id = 1
      cookie = '^[123]$'
      remarks = nil
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name => 'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-1-14-1")
      # パラメータチェック
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.valid?, "CASE:2-1-14-2")
      # アクセサ
      regulation_cookie = biz_create.regulation_cookie
      assert(regulation_cookie.system_id == system_id, "CASE:2-1-14-3")
      assert(regulation_cookie.cookie == cookie, "CASE:2-1-14-4")
      assert(regulation_cookie.remarks == remarks, "CASE:2-1-14-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-1-14-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-1-14-7")
      assert(biz_create.disp_counts == 'ALL', "CASE:2-1-14-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 1, "CASE:2-1-14-9")
#      print_log('disp_counts:' + biz_create.error_msg_hash[:disp_counts].to_s)
      assert(biz_create.error_msg_hash[:error_msg] == '重複データが存在します。', "CASE:2-1-14-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-14")
    end
  end
  
  # 永続化処理
  test "2-2:BizCreate Test:save_data?" do
    # 正常（全項目入力）
    begin
      system_id = 1
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name=>'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      # コンストラクタ生成
      biz_create = BizCreate.new(controller)
      assert(!biz_create.nil?, "CASE:2-2-1-1")
      # 永続化処理
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.save_data?, "CASE:2-2-1-2")
      # アクセサ
      assert(biz_create.regulation_cookie.system_id == system_id, "CASE:2-2-1-3")
      assert(biz_create.regulation_cookie.cookie == cookie, "CASE:2-2-1-4")
      assert(biz_create.regulation_cookie.remarks == remarks, "CASE:2-2-1-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-2-1-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-2-1-7")
      assert(biz_create.disp_counts == 'ALL', "CASE:2-2-1-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 0, "CASE:2-2-1-9")
      # 保存データ確認
      create_data = RegulationCookie.duplicate(biz_create.regulation_cookie)
      assert(create_data.size == 1, "CASE:2-2-1-10")
      assert(create_data[0].system_id == system_id, "CASE:2-2-1-11")
      assert(create_data[0].cookie == cookie, "CASE:2-2-1-12")
      assert(create_data[0].remarks == remarks, "CASE:2-2-1-13")
      # 検索結果確認
      regulation_cookies = biz_create.regulation_cookies
      assert(regulation_cookies.size == 5, "CASE:2-2-1-14")
      # キャッシュデータ確認
      assert(RegulationCookieCache.instance.regulation?(cookie), "CASE:2-2-1-15")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    ###########################################################################
    # 異常ケース
    ###########################################################################
    # 異常（存在しないsystem_id）
    begin
      system_id = 100
      cookie = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_cookie_params = {:system_id=>system_id, :cookie=>cookie, :remarks=>remarks}
      params={:controller_name=>'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_cookie=>reg_cookie_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      biz_create = BizCreate.new(controller)
      # コンストラクタ生成
      assert(!biz_create.nil?, "CASE:2-2-2-1")
      # 永続化処理
#      biz_create.valid?
#      print_log('error msg:' + biz_create.error_msg_hash.to_s)
      assert(!biz_create.save_data?, "CASE:2-2-2-2")
      # アクセサ
      assert(biz_create.regulation_cookie.system_id == system_id, "CASE:2-2-2-3")
      assert(biz_create.regulation_cookie.cookie == cookie, "CASE:2-2-2-4")
      assert(biz_create.regulation_cookie.remarks == remarks, "CASE:2-2-2-5")
      assert(biz_create.sort_item == 'system_id', "CASE:2-2-2-6")
      assert(biz_create.sort_order == 'ASC', "CASE:2-2-2-7")
      assert(biz_create.disp_counts == 'ALL', "CASE:2-2-2-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_create.error_msg_hash.to_s)
      assert(biz_create.error_msg_hash.size == 1, "CASE:2-2-2-9")
#      print_log('disp_counts:' + biz_create.error_msg_hash[:disp_counts].to_s)
      assert(biz_create.error_msg_hash[:system_name] == 'システム名 は不正な値です。', "CASE:2-2-2-10")
      # 保存データ確認
      create_data = RegulationCookie.duplicate(biz_create.regulation_cookie)
      assert(create_data.size == 0, "CASE:2-2-2-11")
      # 検索結果確認
      assert(biz_create.regulation_cookies.size == 5, "CASE:2-2-2-12")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
  end
end