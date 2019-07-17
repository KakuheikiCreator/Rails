# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：Regulationreferrer::RegulationreferrerController
# アクション：list
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/06/24 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/regulation_referrer_list/list_action'

class ListActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::RegulationReferrerList
  include Mock
  # 前処理
#  def setup
#    BizNotifyList.instance.data_load
#  end
  # 後処理
#  def teardown
#  end
  # バリデーションチェック
  test "2-1:ListAction Test:valid?" do
    # 正常（全件検索）
    begin
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-1-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-1-1-2")
      # アクセサ
      assert(list_action.reg_referrer.system_id.nil?, "CASE:2-1-1-3")
      assert(list_action.reg_referrer.referrer.nil?, "CASE:2-1-1-4")
      assert(list_action.reg_referrer.remarks.nil?, "CASE:2-1-1-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-1-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-1-7")
      assert(list_action.disp_counts == 'ALL', "CASE:2-1-1-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 4, "CASE:2-1-1-9")
      idx = 0
      list_action.search_list.each do |ent|
        idx += 1
        assert(ent.id == idx, "CASE:2-1-1-10")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-1-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 正常（全検索条件指定、検索結果無し）
    begin
      system_id = '1'
      referrer = generate_str(CHAR_SET_ALPHANUMERIC, 1024)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_referrer_params = {:system_id=>system_id, :referrer=>referrer, :remarks=>remarks}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'referrer',
                        :sort_order=>'DESC',
                        :disp_counts=>'500'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-2-1")
      # パラメータチェック
      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-1-2-2")
      # アクセサ
      assert(list_action.reg_referrer.system_id == system_id.to_i, "CASE:2-1-2-3")
      assert(list_action.reg_referrer.referrer == referrer, "CASE:2-1-2-4")
      assert(list_action.reg_referrer.remarks == remarks, "CASE:2-1-2-5")
      assert(list_action.sort_item == 'referrer', "CASE:2-1-2-6")
      assert(list_action.sort_order == 'DESC', "CASE:2-1-2-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-2-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 0, "CASE:2-1-2-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-2-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # 正常（検索条件：システムID）
    begin
      system_id = '1'
      referrer = nil
      remarks = nil
      reg_referrer_params = {:system_id=>system_id, :referrer=>referrer, :remarks=>remarks}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-3-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-1-3-2")
      # アクセサ
      assert(list_action.reg_referrer.system_id == 1, "CASE:2-1-3-3")
      assert(list_action.reg_referrer.referrer.nil?, "CASE:2-1-3-4")
      assert(list_action.reg_referrer.remarks.nil?, "CASE:2-1-3-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-3-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-3-7")
      assert(list_action.disp_counts == 'ALL', "CASE:2-1-3-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      search_list = list_action.search_list
      assert(search_list.size == 3, "CASE:2-1-3-9")
      assert(search_list[0].system_id == 1, "CASE:2-1-3-10")
      assert(search_list[1].system_id == 1, "CASE:2-1-3-11")
      assert(search_list[2].system_id == 1, "CASE:2-1-3-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-3-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # 正常（検索条件：リファラー）
    begin
      referrer = '^[A]$'
      reg_referrer_params = {:system_id=>nil, :referrer=>referrer, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'remarks',
                        :sort_order=>'ASC',
                        :disp_counts=>'100'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-4-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-1-4-2")
      # アクセサ
      assert(list_action.reg_referrer.system_id.nil?, "CASE:2-1-4-3")
      assert(list_action.reg_referrer.referrer == referrer, "CASE:2-1-4-4")
      assert(list_action.reg_referrer.remarks.nil?, "CASE:2-1-4-5")
      assert(list_action.sort_item == 'remarks', "CASE:2-1-4-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-4-7")
      assert(list_action.disp_counts == '100', "CASE:2-1-4-8")
      search_list = list_action.search_list
#      print_log('search_list:' + search_list.size.to_s)
      assert(search_list.size == 1, "CASE:2-1-4-9")
      assert(search_list[0].referrer == referrer, "CASE:2-1-4-10")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-4-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
    # 正常（検索条件：備考）
    begin
      remarks = 'MyString'
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>remarks}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-5-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-1-5-2")
      # アクセサ
      assert(list_action.reg_referrer.system_id.nil?, "CASE:2-1-5-3")
      assert(list_action.reg_referrer.referrer.nil?, "CASE:2-1-5-4")
      assert(list_action.reg_referrer.remarks == remarks, "CASE:2-1-5-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-5-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-5-7")
      assert(list_action.disp_counts == 'ALL', "CASE:2-1-5-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      search_list = list_action.search_list
      assert(search_list.size == 4, "CASE:2-1-5-9")
      assert(search_list[0].remarks == remarks, "CASE:2-1-5-10")
      assert(search_list[0].remarks == remarks, "CASE:2-1-5-11")
      assert(search_list[0].remarks == remarks, "CASE:2-1-5-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-5-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-5")
    end
    # 異常（システムID）
    begin
      reg_referrer_params = {:system_id=>'a', :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-6-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-6-2")
      # アクセサ
      reg_referrer = list_action.reg_referrer
#      Rails.logger.debug('system_id:' + reg_referrer.system_id.to_s)
      assert(reg_referrer.system_id == 0, "CASE:2-1-6-3")
      assert(reg_referrer.referrer.nil?, "CASE:2-1-6-4")
      assert(reg_referrer.remarks.nil?, "CASE:2-1-6-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-6-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-6-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-6-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 4, "CASE:2-1-6-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-6-10")
#      print_log('system_id:' + list_action.error_msg_hash[:system_id].to_s)
      assert(list_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-6-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-6")
    end
    # 異常（リファラー文字数オーバー）
    begin
      err_referrer = generate_str(CHAR_SET_ZENKAKU, 1025)
      reg_referrer_params = {:system_id=>nil, :referrer=>err_referrer, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-7-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-7-2")
      # アクセサ
      reg_referrer = list_action.reg_referrer
      assert(reg_referrer.system_id.nil?, "CASE:2-1-7-3")
      assert(reg_referrer.referrer == err_referrer, "CASE:2-1-7-4")
      assert(reg_referrer.remarks.nil?, "CASE:2-1-7-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-7-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-7-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-7-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 4, "CASE:2-1-7-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-7-10")
#      print_log('referrer:' + list_action.error_msg_hash[:referrer].to_s)
      assert(list_action.error_msg_hash[:referrer] == 'リファラー は不正な値です。', "CASE:2-1-7-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-7")
    end
    # 正常（正規表現ではないリファラー）
    begin
      err_referrer = '^www\\'
      reg_referrer_params = {:system_id=>nil, :referrer=>err_referrer, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-8-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-1-8-2")
      # アクセサ
      reg_referrer = list_action.reg_referrer
      assert(reg_referrer.system_id.nil?, "CASE:2-1-8-3")
      assert(reg_referrer.referrer == err_referrer, "CASE:2-1-8-4")
      assert(reg_referrer.remarks.nil?, "CASE:2-1-8-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-8-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-8-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-8-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 3, "CASE:2-1-8-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-8-10")
#      print_log('referrer:' + list_action.error_msg_hash[:referrer].to_s)
#      assert(list_action.error_msg_hash[:referrer] == 'リファラー は不正な値です。', "CASE:2-1-8-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-8")
    end
    # 異常（備考文字数オーバー）
    begin
      err_remarks = generate_str(CHAR_SET_ZENKAKU, 256)
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>err_remarks}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-9-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-9-2")
      # アクセサ
      reg_referrer = list_action.reg_referrer
      assert(reg_referrer.system_id.nil?, "CASE:2-1-9-3")
      assert(reg_referrer.referrer.nil?, "CASE:2-1-9-4")
      assert(reg_referrer.remarks == err_remarks, "CASE:2-1-9-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-9-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-9-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-9-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 4, "CASE:2-1-9-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-9-10")
#      print_log('remarks:' + list_action.error_msg_hash[:remarks].to_s)
      assert(list_action.error_msg_hash[:remarks] == '備考 は不正な値です。', "CASE:2-1-9-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-9")
    end
    # 異常（ソート項目が空文字）
    begin
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'',
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-10-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-10-2")
      # アクセサ
      reg_referrer = list_action.reg_referrer
      assert(reg_referrer.system_id.nil?, "CASE:2-1-10-3")
      assert(reg_referrer.referrer.nil?, "CASE:2-1-10-4")
      assert(reg_referrer.remarks.nil?, "CASE:2-1-10-5")
      assert(list_action.sort_item == '', "CASE:2-1-10-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-10-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-10-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 4, "CASE:2-1-10-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-10-10")
#      print_log('sort_cond:' + list_action.error_msg_hash[:sort_cond].to_s)
      assert(list_action.error_msg_hash[:sort_cond] == '検索結果並び順 を入力してください。', "CASE:2-1-10-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-10")
    end
    # 異常（存在しないソート項目）
    begin
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'err_system_id',
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-11-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-11-2")
      # アクセサ
      reg_referrer = list_action.reg_referrer
      assert(reg_referrer.system_id.nil?, "CASE:2-1-11-3")
      assert(reg_referrer.referrer.nil?, "CASE:2-1-11-4")
      assert(reg_referrer.remarks.nil?, "CASE:2-1-11-5")
      assert(list_action.sort_item == 'err_system_id', "CASE:2-1-11-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-11-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-11-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 4, "CASE:2-1-11-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-11-10")
#      print_log('sort_cond:' + list_action.error_msg_hash[:sort_cond].to_s)
      assert(list_action.error_msg_hash[:sort_cond] == '検索結果並び順 は不正な値です。', "CASE:2-1-11-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-11")
    end
    # 異常（ソート条件が汎用コードテーブルにない）
    begin
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ADSC',
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-12-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-12-2")
      # アクセサ
      reg_referrer = list_action.reg_referrer
      assert(reg_referrer.system_id.nil?, "CASE:2-1-12-3")
      assert(reg_referrer.referrer.nil?, "CASE:2-1-12-4")
      assert(reg_referrer.remarks.nil?, "CASE:2-1-12-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-12-6")
      assert(list_action.sort_order == 'ADSC', "CASE:2-1-12-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-12-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 4, "CASE:2-1-12-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-12-10")
#      print_log('remarks:' + list_action.error_msg_hash[:remarks].to_s)
      assert(list_action.error_msg_hash[:sort_cond] == '検索結果並び順 は不正な値です。', "CASE:2-1-12-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-12")
    end
    # 異常（検索件数・ソート条件共に指定なし）
    begin
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>''}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-13-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-13-2")
      # アクセサ
      reg_referrer = list_action.reg_referrer
      assert(reg_referrer.system_id.nil?, "CASE:2-1-13-3")
      assert(reg_referrer.referrer.nil?, "CASE:2-1-13-4")
      assert(reg_referrer.remarks.nil?, "CASE:2-1-13-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-13-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-13-7")
      assert(list_action.disp_counts == '', "CASE:2-1-13-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 4, "CASE:2-1-13-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-13-10")
#      print_log('disp_counts:' + list_action.error_msg_hash[:disp_counts].to_s)
      assert(list_action.error_msg_hash[:disp_counts] == '表示件数 を入力してください。', "CASE:2-1-13-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-13")
    end
    # 異常（検索件数が、汎用コードに存在しない値）
    begin
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>'a'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-14-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-14-2")
      # アクセサ
      reg_referrer = list_action.reg_referrer
      assert(reg_referrer.system_id.nil?, "CASE:2-1-14-3")
      assert(reg_referrer.referrer.nil?, "CASE:2-1-14-4")
      assert(reg_referrer.remarks.nil?, "CASE:2-1-14-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-14-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-14-7")
      assert(list_action.disp_counts == 'a', "CASE:2-1-14-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 4, "CASE:2-1-14-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-14-10")
#      print_log('disp_counts:' + list_action.error_msg_hash[:disp_counts].to_s)
      assert(list_action.error_msg_hash[:disp_counts] == '表示件数 は不正な値です。', "CASE:2-1-14-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-14")
    end
    # 異常（システムIDが、マスタに存在しない値）
    begin
      reg_referrer_params = {:system_id=>'100', :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-15-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-15-2")
      # アクセサ
      reg_referrer = list_action.reg_referrer
      assert(reg_referrer.system_id == 100, "CASE:2-1-15-3")
      assert(reg_referrer.referrer.nil?, "CASE:2-1-15-4")
      assert(reg_referrer.remarks.nil?, "CASE:2-1-15-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-15-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-15-7")
      assert(list_action.disp_counts == 'ALL', "CASE:2-1-15-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 4, "CASE:2-1-15-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-15-10")
#      print_log('disp_counts:' + list_action.error_msg_hash[:disp_counts].to_s)
      assert(list_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-15-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-15")
    end
  end
  
  # 検索処理
  test "2-2:ListAction Test:search_list" do
    # 正常（全件検索：抽出条件指定なし）
    begin
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-1-1")
      # パラメータチェック
      assert(list_action.valid?, "CASE:2-2-1-2")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      result_list = list_action.search_list
      assert(result_list.size == 4, "CASE:2-2-1-3")
      idx = 0
      result_list.each do |ent|
        idx += 1
        assert(ent.id == idx, "CASE:2-2-1-4")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-1-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    # 正常（抽出条件：システムID、リファラー、備考）
    begin
      system_id = '1'
      referrer = '^www\.msn\.co\.jp$'
      remarks = 'MyString'
      reg_referrer_params = {:system_id=>system_id, :referrer=>referrer, :remarks=>remarks}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-2-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-2-2-2")
      result_list = list_action.search_list
#      print_log('search_list size:' + result_list.size.to_s)
      assert(result_list.size == 1, "CASE:2-2-2-3")
      assert(result_list[0].id == 2, "CASE:2-2-2-4")
      assert(result_list[0].system_id == system_id.to_i, "CASE:2-2-2-5")
      assert(result_list[0].referrer == referrer, "CASE:2-2-2-6")
      assert(result_list[0].remarks == remarks, "CASE:2-2-2-7")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-2-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    # 正常（ソート条件：システムID 昇順）
    begin
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-3-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-2-3-2")
#      print_log('search_list:' + list_action.to_s)
      result_list = list_action.search_list
#      print_log('Search Test Begin!!!')
      assert(result_list.size == 4, "CASE:2-2-3-3")
#      print_log('Search Test 1 End!!!')
      assert(result_list[0].id == 1, "CASE:2-2-3-4")
      assert(result_list[0].system_id == 1, "CASE:2-2-3-5")
      assert(result_list[0].referrer == '^www\.yahoo\.co\.jp$', "CASE:2-2-3-6")
      assert(result_list[0].remarks == 'MyString', "CASE:2-2-3-7")
#      print_log('Search Test 2 End!!!')
      assert(result_list[1].id == 2, "CASE:2-2-3-4")
      assert(result_list[1].system_id == 1, "CASE:2-2-3-5")
      assert(result_list[1].referrer == '^www\.msn\.co\.jp$', "CASE:2-2-3-6")
      assert(result_list[1].remarks == 'MyString', "CASE:2-2-3-7")
#      print_log('Search Test 3 End!!!')
      assert(result_list[2].id == 3, "CASE:2-2-3-4")
      assert(result_list[2].system_id == 1, "CASE:2-2-3-5")
      assert(result_list[2].referrer == '^[A]$', "CASE:2-2-3-6")
      assert(result_list[2].remarks == 'MyString', "CASE:2-2-3-7")
#      print_log('Search Test 4 End!!!')
      assert(result_list[3].id == 4, "CASE:2-2-3-4")
      assert(result_list[3].system_id == 2, "CASE:2-2-3-5")
      assert(result_list[3].referrer == '^www\.goo\.co\.jp$', "CASE:2-2-3-6")
      assert(result_list[3].remarks == 'MyString', "CASE:2-2-3-7")
#      print_log('Search Test 5 End!!!')
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-3-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-3")
    end
    # 正常（ソート条件：リファラー 降順）
    begin
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'referrer',
                        :sort_order=>'DESC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-4-1")
      # パラメータチェック
      list_action.valid?
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-2-4-2")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      result_list = list_action.search_list
#      print_log('Search Test Begin!!!')
      assert(result_list.size == 4, "CASE:2-2-4-3")
#      print_log('Search Test 1 End!!!')
#      print_log('result_list[0].id:' + result_list[0].id.to_s)
      assert(result_list[0].id == 1, "CASE:2-2-4-4")
      assert(result_list[0].system_id == 1, "CASE:2-2-4-5")
      assert(result_list[0].referrer == '^www\.yahoo\.co\.jp$', "CASE:2-2-4-6")
      assert(result_list[0].remarks == 'MyString', "CASE:2-2-4-7")
#      print_log('Search Test 2 End!!!')
#      print_log('result_list[1].id:' + result_list[1].id.to_s)
      assert(result_list[1].id == 2, "CASE:2-2-4-4")
      assert(result_list[1].system_id == 1, "CASE:2-2-4-5")
      assert(result_list[1].referrer == '^www\.msn\.co\.jp$', "CASE:2-2-4-6")
      assert(result_list[1].remarks == 'MyString', "CASE:2-2-4-7")
#      print_log('Search Test 3 End!!!')
#      print_log('result_list[2].id:' + result_list[2].id.to_s)
      assert(result_list[2].id == 4, "CASE:2-2-4-4")
      assert(result_list[2].system_id == 2, "CASE:2-2-4-5")
      assert(result_list[2].referrer == '^www\.goo\.co\.jp$', "CASE:2-2-4-6")
      assert(result_list[2].remarks == 'MyString', "CASE:2-2-4-7")
#      print_log('Search Test 4 End!!!')
      assert(result_list[3].id == 3, "CASE:2-2-4-4")
      assert(result_list[3].system_id == 1, "CASE:2-2-4-5")
      assert(result_list[3].referrer == '^[A]$', "CASE:2-2-4-6")
      assert(result_list[3].remarks == 'MyString', "CASE:2-2-4-7")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-4-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-4")
    end
    # テストデータ更新
    ActiveRecord::Base.transaction do
      RegulationReferrer.delete_all
      1000.times do |i|
        ent = RegulationReferrer.new
        ent.system_id = 1
        ent.referrer = ('000000' + i.to_s).to_s[/\d{6}$/]
        ent.remarks = ('000000' + (1000 - i).to_s).to_s[/\d{6}$/]
        ent.save!
#        print_log('referrer :' + ent.referrer)
#        print_log('remarks:' + ent.remarks)
      end
    end
    # 正常（備考降順、検索結果件数）
    begin
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'remarks',
                        :sort_order=>'DESC',
                        :disp_counts=>'300'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-5-1")
      # パラメータチェック
      list_action.valid?
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-2-5-2")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      result_list = list_action.search_list
#      print_log('Search Test Begin!!!')
      assert(result_list.size == 300, "CASE:2-2-5-3")
#      print_log('Search Test 1 End!!!')
      result_list.size.times do |i|
        idx_str = ('000000' + i.to_s).to_s[/\d{6}$/]
        idx_str2 = ('000000' + (1000 - i).to_s).to_s[/\d{6}$/]
#        print_log('remarks:' + result_list[idx].remarks)
        assert(result_list[i].system_id == 1, "CASE:2-2-5-4")
        assert(result_list[i].referrer == idx_str, "CASE:2-2-5-5")
        assert(result_list[i].remarks == idx_str2, "CASE:2-2-5-6")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-5-7")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-5")
    end
    # 正常（リファラー昇順、検索結果件数）
    begin
      reg_referrer_params = {:system_id=>nil, :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'referrer',
                        :sort_order=>'ASC',
                        :disp_counts=>'100'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-6-1")
      # パラメータチェック
      list_action.valid?
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-2-6-2")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      result_list = list_action.search_list
#      print_log('Search Test Begin!!!')
      assert(result_list.size == 100, "CASE:2-2-6-3")
#      print_log('Search Test 1 End!!!')
      result_list.size.times do |i|
        idx_str = ('000000' + i.to_s).to_s[/\d{6}$/]
        idx_str2 = ('000000' + (1000 - i).to_s).to_s[/\d{6}$/]
#        print_log('referrer :' + result_list[i].referrer + ':' + idx_str)
#        print_log('remarks:' + result_list[i].remarks + ':' + idx_str2)
        assert(result_list[i].system_id == 1, "CASE:2-2-6-4")
        assert(result_list[i].referrer == idx_str, "CASE:2-2-6-5")
        assert(result_list[i].remarks == idx_str2, "CASE:2-2-6-6")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-6-7")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-6")
    end
    ###########################################################################
    # テストデータ更新
    RegulationReferrer.delete_all
    ActiveRecord::Base.transaction do
      1000.times do |i|
        ent = RegulationReferrer.new
        ent.system_id = 100000 - i
        ent.referrer = ('000000' + i.to_s).to_s[/\d{6}$/]
        ent.remarks = ('000000' + (1000 - i).to_s).to_s[/\d{6}$/]
        ent.save
      end
    end
    # 異常（パラメータエラー、デフォルト検索）
    begin
      reg_referrer_params = {:system_id=>'a', :referrer=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_referrer_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_referrer=>reg_referrer_params,
                        :sort_item=>'remarks',
                        :sort_order=>'ASC',
                        :disp_counts=>'500'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-2-7-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-2-7-2")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-2-7-3")
      # 検索結果確認
#      print_log('search_list:' + list_action.search_list.size.to_s)
      search_list = list_action.search_list
      assert(search_list.size == 500, "CASE:2-2-7-4")
      500.times do |i|
#        print_log('system_id:' + search_list[i].system_id.to_s)
        assert(search_list[i].system_id == 99001 + i, "CASE:2-2-7-5")
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-7")
    end
  end
end