# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：RegulationCookie::RegulationCookieController
# アクション：delete
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/06/28 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'business/biz_regulation_cookie/biz_delete'
require 'data_cache/regulation_cookie_cache'
require 'rkvi/rkv_client'

class BizDelete < ActiveSupport::TestCase
  include UnitTestUtil
  include Business::BizRegulationCookie
  include Mock
  include DataCache
  # 前処理
#  def setup
#    BizNotifyList.instance.data_load
#  end
  # 後処理
#  def teardown
#  end
  # バリデーションチェック
  test "2-1:BizDelete Test:valid?" do
    # データ更新日時ハッシュ更新
    loaded_at_hash = Rkvi::RkvClient.instance[:updated_at]
    # 更新日時
    bef_time = Time.now
    loaded_at_hash[:regulation_cookie] = bef_time
    # 正常（全項目入力）
    begin
      target_data = RegulationCookie.where({:cookie => '^[123]$'})
      delete_id = target_data[0].id
      params={:controller_name=>'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:delete_id=>delete_id}}
      controller = MockController.new(params)
      biz_delete = BizDelete.new(controller)
      # コンストラクタ生成
      assert(!biz_delete.nil?, "CASE:2-1-1-1")
      # パラメータチェック
      biz_delete.valid?
#      print_log('error msg:' + biz_delete.error_msg_hash.to_s)
      assert(biz_delete.valid?, "CASE:2-1-1-2")
      # アクセサ
      assert(biz_delete.regulation_cookie.system_id.nil?, "CASE:2-1-1-3")
      assert(biz_delete.regulation_cookie.cookie.nil?, "CASE:2-1-1-4")
      assert(biz_delete.regulation_cookie.remarks.nil?, "CASE:2-1-1-5")
      assert(biz_delete.sort_item == 'system_id', "CASE:2-1-1-6")
      assert(biz_delete.sort_order == 'ASC', "CASE:2-1-1-7")
      assert(biz_delete.disp_counts == '500', "CASE:2-1-1-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_delete.error_msg_hash.to_s)
      assert(biz_delete.error_msg_hash.size == 0, "CASE:2-1-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    ###########################################################################
    # 単項目チェック
    ###########################################################################
    # 異常（ID未入力）
    begin
      delete_id = nil
      params={:controller_name=>'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:delete_id=>delete_id}}
      controller = MockController.new(params)
      biz_delete = BizDelete.new(controller)
      # コンストラクタ生成
      assert(!biz_delete.nil?, "CASE:2-1-2-1")
      # パラメータチェック
#      biz_delete.valid?
#      print_log('error msg:' + biz_delete.error_msg_hash.to_s)
      assert(!biz_delete.valid?, "CASE:2-1-2-2")
      # アクセサ
      regulation_cookie = biz_delete.regulation_cookie
#      print_log('system_id:' + regulation_cookie.system_id.to_s)
      assert(regulation_cookie.system_id.nil?, "CASE:2-1-2-3")
      assert(regulation_cookie.cookie.nil?, "CASE:2-1-2-4")
      assert(regulation_cookie.remarks.nil?, "CASE:2-1-2-5")
      assert(biz_delete.sort_item == 'system_id', "CASE:2-1-2-6")
      assert(biz_delete.sort_order == 'ASC', "CASE:2-1-2-7")
      assert(biz_delete.disp_counts == '500', "CASE:2-1-2-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_delete.error_msg_hash.to_s)
      assert(biz_delete.error_msg_hash.size == 1, "CASE:2-1-2-10")
#      print_log('error_msg:' + biz_delete.error_msg_hash[:error_msg].to_s)
      assert(biz_delete.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # 異常（数値以外のID）
    begin
      delete_id = 'a'
      params={:controller_name=>'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:delete_id=>delete_id}}
      controller = MockController.new(params)
      biz_delete = BizDelete.new(controller)
      # コンストラクタ生成
      assert(!biz_delete.nil?, "CASE:2-1-3-1")
      # パラメータチェック
#      biz_delete.valid?
#      print_log('error msg:' + biz_delete.error_msg_hash.to_s)
      assert(!biz_delete.valid?, "CASE:2-1-3-2")
      # アクセサ
      regulation_cookie = biz_delete.regulation_cookie
#      print_log('system_id:' + regulation_cookie.system_id.to_s)
      assert(regulation_cookie.system_id.nil?, "CASE:2-1-3-3")
      assert(regulation_cookie.cookie.nil?, "CASE:2-1-3-4")
      assert(regulation_cookie.remarks.nil?, "CASE:2-1-3-5")
      assert(biz_delete.sort_item == 'system_id', "CASE:2-1-3-6")
      assert(biz_delete.sort_order == 'ASC', "CASE:2-1-3-7")
      assert(biz_delete.disp_counts == '500', "CASE:2-1-3-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_delete.error_msg_hash.to_s)
      assert(biz_delete.error_msg_hash.size == 1, "CASE:2-1-3-10")
#      print_log('error_msg:' + biz_delete.error_msg_hash[:error_msg].to_s)
      assert(biz_delete.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-3-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    ###########################################################################
    # DB関連チェック
    ###########################################################################
    # 異常（対象データ無し）
    begin
      delete_id = 100
      params={:controller_name=>'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:delete_id=>delete_id}}
      controller = MockController.new(params)
      biz_delete = BizDelete.new(controller)
      # コンストラクタ生成
      assert(!biz_delete.nil?, "CASE:2-1-4-1")
      # パラメータチェック
#      biz_delete.valid?
#      print_log('error msg:' + biz_delete.error_msg_hash.to_s)
      assert(!biz_delete.valid?, "CASE:2-1-4-2")
      # アクセサ
      regulation_cookie = biz_delete.regulation_cookie
      assert(regulation_cookie.system_id.nil?, "CASE:2-1-4-3")
      assert(regulation_cookie.cookie.nil?, "CASE:2-1-4-4")
      assert(regulation_cookie.remarks.nil?, "CASE:2-1-4-5")
      assert(biz_delete.sort_item == 'system_id', "CASE:2-1-4-6")
      assert(biz_delete.sort_order == 'ASC', "CASE:2-1-4-7")
      assert(biz_delete.disp_counts == '500', "CASE:2-1-4-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_delete.error_msg_hash.to_s)
      assert(biz_delete.error_msg_hash.size == 1, "CASE:2-1-4-10")
#      print_log('error_msg:' + biz_delete.error_msg_hash[:error_msg].to_s)
      assert(biz_delete.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-1-4-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
  end
  
  # 削除処理
  test "2-2:BizDelete Test:delete_data?" do
    # 正常（全項目入力）
    begin
      target_data = RegulationCookie.where({:cookie => '^[123]$'})
      delete_id = target_data[0].id
      params={:controller_name=>'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:delete_id=>delete_id}}
      controller = MockController.new(params)
      biz_delete = BizDelete.new(controller)
      # コンストラクタ生成
      assert(!biz_delete.nil?, "CASE:2-2-1-1")
      # 削除処理
      biz_delete.valid?
#      print_log('error msg:' + biz_delete.error_msg_hash.to_s)
      assert(biz_delete.delete_data?, "CASE:2-2-1-2")
      # アクセサ
      assert(biz_delete.regulation_cookie.system_id.nil?, "CASE:2-2-1-3")
      assert(biz_delete.regulation_cookie.cookie.nil?, "CASE:2-2-1-4")
      assert(biz_delete.regulation_cookie.remarks.nil?, "CASE:2-2-1-5")
      assert(biz_delete.sort_item == 'system_id', "CASE:2-2-1-6")
      assert(biz_delete.sort_order == 'ASC', "CASE:2-2-1-7")
      assert(biz_delete.disp_counts == '500', "CASE:2-2-1-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_delete.error_msg_hash.to_s)
      assert(biz_delete.error_msg_hash.size == 0, "CASE:2-2-1-9")
      # 削除データ確認
      delete_data = RegulationCookie.where(:id=>delete_id)
      assert(delete_data.size == 0, "CASE:2-2-1-10")
      # 検索結果確認
      regulation_cookies = biz_delete.regulation_cookies
      assert(regulation_cookies.size == 3, "CASE:2-2-1-11")
      # キャッシュデータ確認（自システムデータのみキャッシュ）
      cache = RegulationCookieCache.instance
      assert(!cache.regulation?(target_data[0].cookie), "CASE:2-2-1-12")
      cookie_list = cache.instance_variable_get(:@regulation_cookie_list)
#      print_log('cookie_list size:' + cookie_list.size.to_s)
      assert(cookie_list.size == 2, "CASE:2-2-1-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    ###########################################################################
    # 異常ケース
    ###########################################################################
    # 異常（対象データが存在しない）
    begin
      delete_id = 100
      params={:controller_name=>'regulation_cookie',
              :method=>:POST,
              :session=>{},
              :params=>{:delete_id=>delete_id}}
      controller = MockController.new(params)
      biz_delete = BizDelete.new(controller)
      # コンストラクタ生成
      assert(!biz_delete.nil?, "CASE:2-2-2-1")
      # 削除処理
#      biz_delete.valid?
#      print_log('error msg:' + biz_delete.error_msg_hash.to_s)
      assert(!biz_delete.delete_data?, "CASE:2-2-2-2")
      # アクセサ
      assert(biz_delete.regulation_cookie.system_id.nil?, "CASE:2-2-2-3")
      assert(biz_delete.regulation_cookie.cookie.nil?, "CASE:2-2-2-4")
      assert(biz_delete.regulation_cookie.remarks.nil?, "CASE:2-2-2-5")
      assert(biz_delete.sort_item == 'system_id', "CASE:2-2-2-6")
      assert(biz_delete.sort_order == 'ASC', "CASE:2-2-2-7")
      assert(biz_delete.disp_counts == '500', "CASE:2-2-2-8")
      # エラーメッセージ
#      print_log('error hash:' + biz_delete.error_msg_hash.to_s)
      assert(biz_delete.error_msg_hash.size == 1, "CASE:2-2-2-9")
#      print_log('error_msg:' + biz_delete.error_msg_hash[:error_msg].to_s)
      assert(biz_delete.error_msg_hash[:error_msg] == '対象データ が見つかりません。', "CASE:2-2-2-10")
      # 検索結果確認
#      print_log('Result Size:' + biz_delete.regulation_cookies.size.to_s)
      assert(biz_delete.regulation_cookies.size == 3, "CASE:2-2-2-11")
      # キャッシュデータ確認（自システムデータのみキャッシュ）
      cache = RegulationCookieCache.instance
      cookie_list = cache.instance_variable_get(:@regulation_cookie_list)
#      print_log('cookie_list size:' + cookie_list.size.to_s)
      assert(cookie_list.size == 2, "CASE:2-2-2-12")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
  end
end