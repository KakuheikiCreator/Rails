# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：RegulationHostList::RegulationHostListController
# アクション：create
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/09/09 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/regulation_host_list/create_action'

class CreateActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::RegulationHostList
  include Mock
  # 前処理
  def setup
#    BizNotifyList.instance.data_load
  end
  # 後処理
#  def teardown
#  end
  # バリデーションチェック
  test "2-1:CreateAction Test:valid?" do
    # 正常（全項目入力）
    begin
      system_id = '1'
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      proxy_ip_address = '192.192.192.100'
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      ip_address = '255.255.255.100'
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name=>'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      # コンストラクタ生成
      create_action = CreateAction.new(controller)
      assert(!create_action.nil?, "CASE:2-1-1-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(create_action.valid?, "CASE:2-1-1-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id.to_i, "CASE:2-1-1-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-1-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-1-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-1-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-1-7")
      assert(reg_host.remarks == remarks, "CASE:2-1-1-8")
      assert(create_action.sort_item == 'system_id', "CASE:2-1-1-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-1-10")
      assert(create_action.disp_counts == 'ALL', "CASE:2-1-1-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 0, "CASE:2-1-1-12")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 正常（備考未入力、デフォルト以外の検索条件）
    begin
      system_id = '1'
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      proxy_ip_address = '192.168.100.100'
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      ip_address = '255.255.255.100'
      remarks = nil
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'proxy_host',
                        :sort_order=>'DESC',
                        :disp_counts=>'500'}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-2-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(create_action.valid?, "CASE:2-1-2-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id.to_i, "CASE:2-1-2-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-2-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-2-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-2-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-2-7")
      assert(reg_host.remarks == remarks, "CASE:2-1-2-5")
      assert(create_action.sort_item == 'proxy_host', "CASE:2-1-2-6")
      assert(create_action.sort_order == 'DESC', "CASE:2-1-2-7")
      assert(create_action.disp_counts == '500', "CASE:2-1-2-8")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 0, "CASE:2-1-2-9")
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
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      proxy_ip_address = '192.168.100.100'
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      ip_address = '255.255.255.100'
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-3-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.valid?, "CASE:2-1-3-2")
      # アクセサ
      reg_host = create_action.reg_host
#      print_log('system_id:' + reg_host.system_id.to_s)
      assert(reg_host.system_id == system_id, "CASE:2-1-3-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-3-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-3-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-3-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-3-7")
      assert(reg_host.remarks == remarks, "CASE:2-1-3-5")
      assert(create_action.sort_item == 'system_id', "CASE:2-1-3-6")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-3-7")
      assert(create_action.disp_counts == '500', "CASE:2-1-3-8")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-1-3-9")
#      print_log('system_id:' + create_action.error_msg_hash[:system_id].to_s)
      assert(create_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-3-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # 異常（システムID属性異常）
    begin
      system_id = 'a'
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      proxy_ip_address = '192.168.100.100'
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      ip_address = '255.255.255.100'
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-4-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.valid?, "CASE:2-1-4-2")
      # アクセサ
      reg_host = create_action.reg_host
#      print_log('system_id:' + reg_host.system_id.to_s)
      assert(reg_host.system_id == 0, "CASE:2-1-4-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-4-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-4-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-4-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-4-7")
      assert(reg_host.remarks == remarks, "CASE:2-1-4-8")
      assert(create_action.sort_item == 'system_id', "CASE:2-1-4-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-4-10")
      assert(create_action.disp_counts == '500', "CASE:2-1-4-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-1-4-12")
#      print_log('system_id:' + create_action.error_msg_hash[:system_id].to_s)
      assert(create_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-4-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
    # 異常（ホスト情報未入力）
    begin
      system_id = 1
      proxy_host = nil
      proxy_ip_address = nil
      remote_host = nil
      ip_address = nil
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-5-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.valid?, "CASE:2-1-5-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id, "CASE:2-1-5-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-5-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-5-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-5-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-5-7")
      assert(reg_host.remarks == remarks, "CASE:2-1-5-8")
      assert(create_action.sort_item == 'system_id', "CASE:2-1-5-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-5-10")
      assert(create_action.disp_counts == '500', "CASE:2-1-5-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-1-5-12")
#      print_log('host:' + create_action.error_msg_hash[:host].to_s)
      assert(create_action.error_msg_hash[:proxy_host] == 'プロキシホスト ,プロキシIP,クライアントホスト,クライアントIPの何れかを入力してください。', "CASE:2-1-5-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-5")
    end
    # 異常（クライアントホスト文字数オーバー）
    begin
      system_id = 1
      proxy_host = nil
      proxy_ip_address = nil
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 256)
      ip_address = nil
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-6-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.valid?, "CASE:2-1-6-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id, "CASE:2-1-6-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-6-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-6-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-6-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-6-7")
      assert(reg_host.remarks == remarks, "CASE:2-1-6-8")
      assert(create_action.sort_item == 'system_id', "CASE:2-1-6-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-6-10")
      assert(create_action.disp_counts == '500', "CASE:2-1-6-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-1-6-12")
#      print_log('host:' + create_action.error_msg_hash[:host].to_s)
      assert(create_action.error_msg_hash[:remote_host] == 'クライアントホスト は255文字以内で入力してください。', "CASE:2-1-6-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-6")
    end
    # 異常（プロキシIP）
    begin
      system_id = 1
      proxy_host = nil
      proxy_ip_address = '192.168.256.10'
      remote_host = nil
      ip_address = nil
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-7-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.valid?, "CASE:2-1-7-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id, "CASE:2-1-7-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-7-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-7-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-7-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-7-7")
      assert(reg_host.remarks == remarks, "CASE:2-1-7-8")
      assert(create_action.sort_item == 'system_id', "CASE:2-1-7-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-7-10")
      assert(create_action.disp_counts == '500', "CASE:2-1-7-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-1-7-12")
#      print_log('host:' + create_action.error_msg_hash[:host].to_s)
      assert(create_action.error_msg_hash[:proxy_ip_address] == 'プロキシIP は不正な値です。', "CASE:2-1-7-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-7")
    end
    # 異常（備考文字数オーバー）
    begin
      system_id = 1
      proxy_host = nil
      proxy_ip_address = nil
      remote_host = nil
      ip_address = '192.168.200.10'
      remarks = generate_str(CHAR_SET_ZENKAKU, 256)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-8-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.valid?, "CASE:2-1-8-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id, "CASE:2-1-8-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-8-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-8-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-8-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-8-7")
      assert(reg_host.remarks == remarks, "CASE:2-1-8-8")
      assert(create_action.sort_item == 'system_id', "CASE:2-1-8-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-8-10")
      assert(create_action.disp_counts == '500', "CASE:2-1-8-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-1-8-12")
#      print_log('remarks:' + create_action.error_msg_hash[:remarks].to_s)
      assert(create_action.error_msg_hash[:remarks] == '備考 は255文字以内で入力してください。', "CASE:2-1-8-13")
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
      ip_address = '192.168.200.10'
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>ip_address,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'',
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-9-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.valid?, "CASE:2-1-9-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id, "CASE:2-1-9-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-9-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-9-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-9-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-9-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-9-8")
      assert(create_action.sort_item == '', "CASE:2-1-9-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-9-10")
      assert(create_action.disp_counts == '500', "CASE:2-1-9-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-1-9-12")
#      print_log('sort_cond:' + create_action.error_msg_hash[:sort_cond].to_s)
      assert(create_action.error_msg_hash[:sort_cond] == '検索結果並び順 を入力してください。', "CASE:2-1-9-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-9")
    end
    # 異常（ソート項目が存在しない項目名）
    begin
      system_id = 1
      ip_address = '192.168.200.10'
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>ip_address,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'err_system_id',
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-10-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.valid?, "CASE:2-1-10-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id, "CASE:2-1-10-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-10-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-10-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-10-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-10-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-10-8")
      assert(create_action.sort_item == 'err_system_id', "CASE:2-1-10-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-10-10")
      assert(create_action.disp_counts == '500', "CASE:2-1-10-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-1-10-12")
#      print_log('sort_cond:' + create_action.error_msg_hash[:sort_cond].to_s)
      assert(create_action.error_msg_hash[:sort_cond] == '検索結果並び順 は不正な値です。', "CASE:2-1-10-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-10")
    end
    # 異常（検索件数が空文字）
    begin
      system_id = 1
      ip_address = '192.168.200.10'
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>ip_address,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>''}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-11-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.valid?, "CASE:2-1-11-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id, "CASE:2-1-11-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-11-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-11-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-11-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-11-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-11-8")
      assert(create_action.sort_item == 'system_id', "CASE:2-1-11-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-11-10")
      assert(create_action.disp_counts == '', "CASE:2-1-11-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-1-11-12")
#      print_log('disp_counts:' + create_action.error_msg_hash[:disp_counts].to_s)
      assert(create_action.error_msg_hash[:disp_counts] == '表示件数 を入力してください。', "CASE:2-1-11-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-11")
    end
    # 異常（検索件数が、汎用コードに存在しない値）
    begin
      system_id = 1
      ip_address = '192.168.200.10'
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>ip_address,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>'a'}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-12-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.valid?, "CASE:2-1-12-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id, "CASE:2-1-12-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-12-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-12-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-12-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-12-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-12-8")
      assert(create_action.sort_item == 'system_id', "CASE:2-1-12-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-12-10")
      assert(create_action.disp_counts == 'a', "CASE:2-1-12-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-1-12-12")
#      print_log('disp_counts:' + create_action.error_msg_hash[:disp_counts].to_s)
      assert(create_action.error_msg_hash[:disp_counts] == '表示件数 は不正な値です。', "CASE:2-1-12-13")
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
      ip_address = '192.168.200.10'
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>ip_address,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-13-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.valid?, "CASE:2-1-13-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id, "CASE:2-1-13-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-13-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-13-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-13-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-13-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-13-8")
      assert(create_action.sort_item == 'system_id', "CASE:2-1-13-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-13-10")
      assert(create_action.disp_counts == 'ALL', "CASE:2-1-13-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-1-13-12")
#      print_log('disp_counts:' + create_action.error_msg_hash[:disp_counts].to_s)
      assert(create_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-13-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-13")
    end
    # 異常（重複データ有り）
    begin
      system_id = 1
      proxy_host = nil
      proxy_ip_address = nil
      remote_host = '^reg\.client\.ne\.jp$'
      ip_address = '255.255.255.1'
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-1-14-1")
      # パラメータチェック
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.valid?, "CASE:2-1-14-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id, "CASE:2-1-14-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-14-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-14-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-14-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-14-7")
      assert(reg_host.remarks == remarks, "CASE:2-1-14-8")
      assert(create_action.sort_item == 'system_id', "CASE:2-1-14-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-1-14-10")
      assert(create_action.disp_counts == 'ALL', "CASE:2-1-14-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-1-14-12")
#      print_log('disp_counts:' + create_action.error_msg_hash[:disp_counts].to_s)
      assert(create_action.error_msg_hash[:error_msg] == '重複データが存在します。', "CASE:2-1-14-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-14")
    end
  end
  
  # 永続化処理
  test "2-2:CreateAction Test:save_data?" do
    # 正常（全項目入力）
    begin
      system_id = 1
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      proxy_ip_address = '192.192.192.100'
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      ip_address = '255.255.255.100'
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name=>'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      # コンストラクタ生成
      create_action = CreateAction.new(controller)
      assert(!create_action.nil?, "CASE:2-2-1-1")
      # 永続化処理
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(create_action.save_data?, "CASE:2-2-1-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id, "CASE:2-2-1-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-2-1-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-2-1-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-2-1-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-2-1-7")
      assert(reg_host.remarks == remarks, "CASE:2-2-1-8")
      assert(create_action.sort_item == 'system_id', "CASE:2-2-1-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-2-1-10")
      assert(create_action.disp_counts == 'ALL', "CASE:2-2-1-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 0, "CASE:2-2-1-12")
      # 保存データ確認
      create_data = RegulationHost.duplicate(reg_host)
      assert(create_data.size == 1, "CASE:2-2-1-10")
      assert(create_data[0].system_id == system_id, "CASE:2-2-1-13")
      assert(create_data[0].proxy_host == proxy_host, "CASE:2-2-1-14")
      assert(create_data[0].proxy_ip_address == proxy_ip_address, "CASE:2-2-1-15")
      assert(create_data[0].remote_host == remote_host, "CASE:2-2-1-16")
      assert(create_data[0].ip_address == ip_address, "CASE:2-2-1-17")
      assert(create_data[0].remarks == remarks, "CASE:2-2-1-18")
      # 検索結果確認
      reg_host_list = create_action.reg_host_list
      assert(reg_host_list.size == 12, "CASE:2-2-1-19")
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
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      proxy_ip_address = '192.192.192.100'
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      ip_address = '255.255.255.100'
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name=>'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      create_action = CreateAction.new(controller)
      # コンストラクタ生成
      assert(!create_action.nil?, "CASE:2-2-2-1")
      # 永続化処理
#      create_action.valid?
#      print_log('error msg:' + create_action.error_msg_hash.to_s)
      assert(!create_action.save_data?, "CASE:2-2-2-2")
      # アクセサ
      reg_host = create_action.reg_host
      assert(reg_host.system_id == system_id, "CASE:2-2-2-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-2-2-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-2-2-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-2-2-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-2-2-7")
      assert(reg_host.remarks == remarks, "CASE:2-2-2-8")
      assert(create_action.sort_item == 'system_id', "CASE:2-2-2-9")
      assert(create_action.sort_order == 'ASC', "CASE:2-2-2-10")
      assert(create_action.disp_counts == 'ALL', "CASE:2-2-2-11")
      # エラーメッセージ
#      print_log('error hash:' + create_action.error_msg_hash.to_s)
      assert(create_action.error_msg_hash.size == 1, "CASE:2-2-2-12")
#      print_log('disp_counts:' + create_action.error_msg_hash[:disp_counts].to_s)
      assert(create_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-2-2-13")
      # 保存データ確認
      create_data = RegulationHost.duplicate(reg_host)
      assert(create_data.size == 0, "CASE:2-2-2-14")
      # 検索結果確認
      assert(create_action.reg_host_list.size == 12, "CASE:2-2-2-15")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
  end
end