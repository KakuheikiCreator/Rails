# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：RegulationHost::RegulationHostController
# アクション：list
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/09/06 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/regulation_host_list/list_action'

class ListActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::RegulationHostList
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
      reg_host_params = {:system_id=>nil, :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil, :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
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
      assert(list_action.reg_host.system_id.nil?, "CASE:2-1-1-3")
      assert(list_action.reg_host.proxy_host.nil?, "CASE:2-1-1-4")
      assert(list_action.reg_host.proxy_ip_address.nil?, "CASE:2-1-1-5")
      assert(list_action.reg_host.remote_host.nil?, "CASE:2-1-1-6")
      assert(list_action.reg_host.ip_address.nil?, "CASE:2-1-1-7")
      assert(list_action.reg_host.remarks.nil?, "CASE:2-1-1-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-1-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-1-10")
      assert(list_action.disp_counts == 'ALL', "CASE:2-1-1-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-1-12")
      ent_list = list_action.search_list
      assert(ent_list[0].id == 1, "CASE:2-1-1-13-1")
      assert(ent_list[1].id == 2, "CASE:2-1-1-13-2")
      assert(ent_list[2].id == 3, "CASE:2-1-1-13-3")
      assert(ent_list[3].id == 4, "CASE:2-1-1-13-4")
      assert(ent_list[4].id == 5, "CASE:2-1-1-13-5")
      assert(ent_list[5].id == 6, "CASE:2-1-1-13-6")
      assert(ent_list[6].id == 7, "CASE:2-1-1-13-7")
      assert(ent_list[7].id == 8, "CASE:2-1-1-13-8")
      assert(ent_list[8].id == 10, "CASE:2-1-1-13-9")
      assert(ent_list[9].id == 11, "CASE:2-1-1-13-10")
      assert(ent_list[10].id == 9, "CASE:2-1-1-13-11")
#      idx = 0
#      list_action.search_list.each do |ent|
#        idx += 1
#        assert(ent.id == idx, "CASE:2-1-1-13")
#      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-1-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 正常（全検索条件指定、検索結果無し）
    begin
      system_id = '1'
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      proxy_ip_address = generate_str(CHAR_SET_NUMERIC, 15)
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 255)
      ip_address = generate_str(CHAR_SET_NUMERIC, 15)
      remarks = generate_str(CHAR_SET_ZENKAKU, 255)
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
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-2-1")
      # パラメータチェック
      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-1-2-2")
      # アクセサ
      assert(list_action.reg_host.system_id == system_id.to_i, "CASE:2-1-2-3")
      assert(list_action.reg_host.proxy_host == proxy_host, "CASE:2-1-2-4")
      assert(list_action.reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-2-5")
      assert(list_action.reg_host.remote_host == remote_host, "CASE:2-1-2-6")
      assert(list_action.reg_host.ip_address == ip_address, "CASE:2-1-2-7")
      assert(list_action.reg_host.remarks == remarks, "CASE:2-1-2-8")
      assert(list_action.sort_item == 'proxy_host', "CASE:2-1-2-9")
      assert(list_action.sort_order == 'DESC', "CASE:2-1-2-10")
      assert(list_action.disp_counts == '500', "CASE:2-1-2-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 0, "CASE:2-1-2-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-2-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # 正常（検索条件：システムID）
    begin
      system_id = '1'
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
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
      assert(list_action.reg_host.system_id == system_id.to_i, "CASE:2-1-3-3")
      assert(list_action.reg_host.proxy_host.nil?, "CASE:2-1-3-4")
      assert(list_action.reg_host.proxy_ip_address.nil?, "CASE:2-1-3-5")
      assert(list_action.reg_host.remote_host.nil?, "CASE:2-1-3-6")
      assert(list_action.reg_host.ip_address.nil?, "CASE:2-1-3-7")
      assert(list_action.reg_host.remarks.nil?, "CASE:2-1-3-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-3-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-3-10")
      assert(list_action.disp_counts == 'ALL', "CASE:2-1-3-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      search_list = list_action.search_list
      assert(search_list.size == 10, "CASE:2-1-3-12")
      search_list.each do |ent|
        assert(ent.system_id == 1, "CASE:2-1-3-13")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-3-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # 正常（検索条件：プロキシホスト）
    begin
      proxy_host = '^proxy2\.ne\.jp$'
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>proxy_host, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
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
      assert(list_action.reg_host.system_id.nil?, "CASE:2-1-4-3")
      assert(list_action.reg_host.proxy_host == proxy_host, "CASE:2-1-4-4")
      assert(list_action.reg_host.proxy_ip_address.nil?, "CASE:2-1-4-5")
      assert(list_action.reg_host.remote_host.nil?, "CASE:2-1-4-6")
      assert(list_action.reg_host.ip_address.nil?, "CASE:2-1-4-7")
      assert(list_action.reg_host.remarks.nil?, "CASE:2-1-4-8")
      assert(list_action.sort_item == 'remarks', "CASE:2-1-4-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-4-10")
      assert(list_action.disp_counts == '100', "CASE:2-1-4-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      search_list = list_action.search_list
      assert(search_list.size == 1, "CASE:2-1-4-12")
      assert(search_list[0].id == 2, "CASE:2-1-4-13")
      assert(search_list[0].proxy_host == proxy_host, "CASE:2-1-4-14")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-4-15")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
    # 正常（検索条件：プロキシIP）
    begin
      proxy_ip_address = '192.168.254.3'
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'remarks',
                        :sort_order=>'ASC',
                        :disp_counts=>'100'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-5-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-1-5-2")
      # アクセサ
      assert(list_action.reg_host.system_id.nil?, "CASE:2-1-5-3")
      assert(list_action.reg_host.proxy_host.nil?, "CASE:2-1-5-4")
      assert(list_action.reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-5-5")
      assert(list_action.reg_host.remote_host.nil?, "CASE:2-1-5-6")
      assert(list_action.reg_host.ip_address.nil?, "CASE:2-1-5-7")
      assert(list_action.reg_host.remarks.nil?, "CASE:2-1-5-8")
      assert(list_action.sort_item == 'remarks', "CASE:2-1-5-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-5-10")
      assert(list_action.disp_counts == '100', "CASE:2-1-5-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      search_list = list_action.search_list
      assert(search_list.size == 1, "CASE:2-1-5-12")
      assert(search_list[0].id == 3, "CASE:2-1-5-13")
      assert(search_list[0].proxy_ip_address == proxy_ip_address, "CASE:2-1-5-14")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-5-15")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-5")
    end
    # 正常（検索条件：クライアントホスト）
    begin
      remote_host = '^client4\.ne\.jp$'
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>remote_host, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'remarks',
                        :sort_order=>'ASC',
                        :disp_counts=>'100'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-6-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-1-6-2")
      # アクセサ
      assert(list_action.reg_host.system_id.nil?, "CASE:2-1-6-3")
      assert(list_action.reg_host.proxy_host.nil?, "CASE:2-1-6-4")
      assert(list_action.reg_host.proxy_ip_address.nil?, "CASE:2-1-6-5")
      assert(list_action.reg_host.remote_host == remote_host, "CASE:2-1-6-6")
      assert(list_action.reg_host.ip_address.nil?, "CASE:2-1-6-7")
      assert(list_action.reg_host.remarks.nil?, "CASE:2-1-6-8")
      assert(list_action.sort_item == 'remarks', "CASE:2-1-6-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-6-10")
      assert(list_action.disp_counts == '100', "CASE:2-1-6-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      search_list = list_action.search_list
      assert(search_list.size == 1, "CASE:2-1-6-12")
      assert(search_list[0].id == 4, "CASE:2-1-6-13")
      assert(search_list[0].remote_host == remote_host, "CASE:2-1-6-14")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-6-15")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-6")
    end
    # 正常（検索条件：クライアントIP）
    begin
      ip_address = '192.168.255.5'
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>ip_address,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'remarks',
                        :sort_order=>'ASC',
                        :disp_counts=>'100'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-7-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-1-7-2")
      # アクセサ
      assert(list_action.reg_host.system_id.nil?, "CASE:2-1-7-3")
      assert(list_action.reg_host.proxy_host.nil?, "CASE:2-1-7-4")
      assert(list_action.reg_host.proxy_ip_address.nil?, "CASE:2-1-7-5")
      assert(list_action.reg_host.remote_host.nil?, "CASE:2-1-7-6")
      assert(list_action.reg_host.ip_address == ip_address, "CASE:2-1-7-7")
      assert(list_action.reg_host.remarks.nil?, "CASE:2-1-7-8")
      assert(list_action.sort_item == 'remarks', "CASE:2-1-7-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-7-10")
      assert(list_action.disp_counts == '100', "CASE:2-1-7-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      search_list = list_action.search_list
      assert(search_list.size == 1, "CASE:2-1-7-12")
      assert(search_list[0].id == 5, "CASE:2-1-7-13")
      assert(search_list[0].ip_address == ip_address, "CASE:2-1-7-14")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-7-15")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-7")
    end
    # 正常（検索条件：備考）
    begin
      remarks = 'MyString'
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>remarks}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-8-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-1-8-2")
      # アクセサ
      assert(list_action.reg_host.system_id.nil?, "CASE:2-1-8-3")
      assert(list_action.reg_host.proxy_host.nil?, "CASE:2-1-8-4")
      assert(list_action.reg_host.proxy_ip_address.nil?, "CASE:2-1-8-5")
      assert(list_action.reg_host.remote_host.nil?, "CASE:2-1-8-6")
      assert(list_action.reg_host.ip_address.nil?, "CASE:2-1-8-7")
      assert(list_action.reg_host.remarks == remarks, "CASE:2-1-8-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-8-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-8-10")
      assert(list_action.disp_counts == 'ALL', "CASE:2-1-8-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      search_list = list_action.search_list
      assert(search_list.size == 11, "CASE:2-1-8-12")
      search_list.each do |ent|
        assert(ent.remarks == remarks, "CASE:2-1-8-13")
      end
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-8-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-8")
    end
    ###########################################################################
    # 単項目チェック
    ###########################################################################
    # 異常（システムID）
    begin
      system_id = 'a'
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
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
      reg_host = list_action.reg_host
#      Rails.logger.debug('system_id:' + reg_host.system_id.to_s)
      assert(reg_host.system_id == 0, "CASE:2-1-9-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-9-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-9-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-9-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-9-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-9-5")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-9-6")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-9-7")
      assert(list_action.disp_counts == '500', "CASE:2-1-9-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-9-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-9-10")
#      print_log('system_id:' + list_action.error_msg_hash[:system_id].to_s)
      assert(list_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-9-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-9")
    end
    # 異常（プロキシホスト文字数オーバー）
    begin
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 256)
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>proxy_host, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>nil,
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
      reg_host = list_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-10-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-10-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-10-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-10-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-10-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-10-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-10-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-10-10")
      assert(list_action.disp_counts == '500', "CASE:2-1-10-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-10-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-10-13")
#      print_log('host:' + list_action.error_msg_hash[:proxy_host].to_s)
      assert(list_action.error_msg_hash[:proxy_host] == 'プロキシホスト は不正な値です。', "CASE:2-1-10-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-10")
    end
    # 異常（プロキシIP文字数オーバー）
    begin
      proxy_ip_address = generate_str(CHAR_SET_NUMERIC, 16)
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>nil,
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
      reg_host = list_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-11-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-11-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-11-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-11-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-11-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-11-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-11-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-11-10")
      assert(list_action.disp_counts == '500', "CASE:2-1-11-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-11-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-11-13")
#      print_log('host:' + list_action.error_msg_hash[:proxy_ip_address].to_s)
      assert(list_action.error_msg_hash[:proxy_ip_address] == 'プロキシIP は不正な値です。', "CASE:2-1-11-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-11")
    end
    # 異常（クライアントホスト文字数オーバー）
    begin
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 256)
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>remote_host, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
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
      reg_host = list_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-12-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-12-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-12-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-12-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-12-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-12-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-12-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-12-10")
      assert(list_action.disp_counts == '500', "CASE:2-1-12-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-12-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-12-13")
#      print_log('host:' + list_action.error_msg_hash[:remote_host].to_s)
      assert(list_action.error_msg_hash[:remote_host] == 'クライアントホスト は不正な値です。', "CASE:2-1-12-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-12")
    end
    # 異常（クライアントIP文字数オーバー）
    begin
      ip_address = generate_str(CHAR_SET_NUMERIC, 16)
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>ip_address,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-13-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-13-2")
      # アクセサ
      reg_host = list_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-13-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-13-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-13-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-13-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-13-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-13-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-13-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-13-10")
      assert(list_action.disp_counts == '500', "CASE:2-1-13-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-13-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-13-13")
#      print_log('host:' + list_action.error_msg_hash[:ip_address].to_s)
      assert(list_action.error_msg_hash[:ip_address] == 'クライアントIP は不正な値です。', "CASE:2-1-13-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-13")
    end
    # 異常（備考文字数オーバー）
    begin
      err_remarks = generate_str(CHAR_SET_ZENKAKU, 256)
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>err_remarks}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>nil,
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-14-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-14-2")
      # アクセサ
      reg_host = list_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-14-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-14-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-14-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-14-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-14-7")
      assert(reg_host.remarks == err_remarks, "CASE:2-1-14-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-14-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-14-10")
      assert(list_action.disp_counts == '500', "CASE:2-1-14-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-14-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-14-13")
#      print_log('remarks:' + list_action.error_msg_hash[:remarks].to_s)
      assert(list_action.error_msg_hash[:remarks] == '備考 は不正な値です。', "CASE:2-1-14-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-14")
    end
    # 異常（ソート項目が空文字）
    begin
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'',
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-15-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-15-2")
      # アクセサ
      reg_host = list_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-15-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-15-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-15-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-15-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-15-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-15-8")
      assert(list_action.sort_item == '', "CASE:2-1-15-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-15-10")
      assert(list_action.disp_counts == '500', "CASE:2-1-15-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-15-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-15-13")
#      print_log('sort_cond:' + list_action.error_msg_hash[:sort_cond].to_s)
      assert(list_action.error_msg_hash[:sort_cond] == '検索結果並び順 を入力してください。', "CASE:2-1-15-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-15")
    end
    # 異常（存在しないソート項目）
    begin
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'err_system_id',
                        :sort_order=>nil,
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-16-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-16-2")
      # アクセサ
      reg_host = list_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-16-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-16-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-16-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-16-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-16-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-16-8")
      assert(list_action.sort_item == 'err_system_id', "CASE:2-1-16-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-16-10")
      assert(list_action.disp_counts == '500', "CASE:2-1-16-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-16-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-16-13")
#      print_log('sort_cond:' + list_action.error_msg_hash[:sort_cond].to_s)
      assert(list_action.error_msg_hash[:sort_cond] == '検索結果並び順 は不正な値です。', "CASE:2-1-16-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-16")
    end
    # 異常（ソート条件が汎用コードテーブルにない）
    begin
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ADSC',
                        :disp_counts=>nil}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-17-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-17-2")
      # アクセサ
      reg_host = list_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-17-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-17-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-17-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-17-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-17-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-17-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-17-9")
      assert(list_action.sort_order == 'ADSC', "CASE:2-1-17-10")
      assert(list_action.disp_counts == '500', "CASE:2-1-17-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-17-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-17-13")
#      print_log('remarks:' + list_action.error_msg_hash[:remarks].to_s)
      assert(list_action.error_msg_hash[:sort_cond] == '検索結果並び順 は不正な値です。', "CASE:2-1-17-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-17")
    end
    # 異常（検索件数・ソート条件共に指定なし）
    begin
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>''}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-18-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-18-2")
      # アクセサ
      reg_host = list_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-18-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-18-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-18-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-18-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-18-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-18-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-18-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-18-10")
      assert(list_action.disp_counts == '', "CASE:2-1-18-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-18-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-18-13")
#      print_log('disp_counts:' + list_action.error_msg_hash[:disp_counts].to_s)
      assert(list_action.error_msg_hash[:disp_counts] == '表示件数 を入力してください。', "CASE:2-1-18-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-18")
    end
    # 異常（検索件数が、汎用コードに存在しない値）
    begin
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>'a'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-19-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-19-2")
      # アクセサ
      reg_host = list_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-19-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-19-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-19-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-19-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-19-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-19-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-19-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-19-10")
      assert(list_action.disp_counts == 'a', "CASE:2-1-19-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-19-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-19-13")
#      print_log('disp_counts:' + list_action.error_msg_hash[:disp_counts].to_s)
      assert(list_action.error_msg_hash[:disp_counts] == '表示件数 は不正な値です。', "CASE:2-1-19-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-19")
    end
    # 異常（存在しないパラメータ）
    begin
      reg_host_params = {:system_id=>nil, :error_item=>'a', :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>nil,
                        :disp_counts=>'500'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-20-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(list_action.valid?, "CASE:2-1-20-2")
      # アクセサ
      reg_host = list_action.reg_host
      assert(reg_host.system_id.nil?, "CASE:2-1-20-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-20-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-20-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-20-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-20-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-20-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-20-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-20-10")
      assert(list_action.disp_counts == '500', "CASE:2-1-20-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-20-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-1-20-13")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-20")
    end
    # 異常（全項目）
    begin
      system_id = 'a'
      proxy_host = generate_str(CHAR_SET_ALPHANUMERIC, 256)
      proxy_ip_address = generate_str(CHAR_SET_NUMERIC, 16)
      remote_host = generate_str(CHAR_SET_ALPHANUMERIC, 256)
      ip_address = generate_str(CHAR_SET_NUMERIC, 16)
      remarks = generate_str(CHAR_SET_ZENKAKU, 256)
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>proxy_host, :proxy_ip_address=>proxy_ip_address,
                         :remote_host=>remote_host, :ip_address=>ip_address,
                         :remarks=>remarks}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'err_item',
                        :sort_order=>'ADSC',
                        :disp_counts=>'a'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-21-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-21-2")
      # アクセサ
      reg_host = list_action.reg_host
#      Rails.logger.debug('system_id:' + reg_host.system_id.to_s)
      assert(reg_host.system_id == 0, "CASE:2-1-21-3")
      assert(reg_host.proxy_host == proxy_host, "CASE:2-1-21-4")
      assert(reg_host.proxy_ip_address == proxy_ip_address, "CASE:2-1-21-5")
      assert(reg_host.remote_host == remote_host, "CASE:2-1-21-6")
      assert(reg_host.ip_address == ip_address, "CASE:2-1-21-7")
      assert(reg_host.remarks == remarks, "CASE:2-1-21-5")
      assert(list_action.sort_item == 'err_item', "CASE:2-1-21-6")
      assert(list_action.sort_order == 'ADSC', "CASE:2-1-21-7")
      assert(list_action.disp_counts == 'a', "CASE:2-1-21-8")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-21-9")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 8, "CASE:2-1-21-10")
#      print_log('system_id:' + list_action.error_msg_hash[:system_id].to_s)
      assert(list_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-21-11")
      assert(list_action.error_msg_hash[:proxy_host] == 'プロキシホスト は不正な値です。', "CASE:2-1-21-12")
      assert(list_action.error_msg_hash[:proxy_ip_address] == 'プロキシIP は不正な値です。', "CASE:2-1-21-13")
      assert(list_action.error_msg_hash[:remote_host] == 'クライアントホスト は不正な値です。', "CASE:2-1-21-14")
      assert(list_action.error_msg_hash[:ip_address] == 'クライアントIP は不正な値です。', "CASE:2-1-21-15")
      assert(list_action.error_msg_hash[:remarks] == '備考 は不正な値です。', "CASE:2-1-21-16")
      assert(list_action.error_msg_hash[:sort_cond] == '検索結果並び順 は不正な値です。', "CASE:2-1-21-17")
      assert(list_action.error_msg_hash[:disp_counts] == '表示件数 は不正な値です。', "CASE:2-1-21-18")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-21")
    end
    ###########################################################################
    # DB関連チェック
    ###########################################################################
    # 異常（システムIDが、マスタに存在しない値）
    begin
      system_id = '100'
      reg_host_params = {:system_id=>system_id,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'system_id',
                        :sort_order=>'ASC',
                        :disp_counts=>'ALL'}}
      controller = MockController.new(params)
      list_action = ListAction.new(controller)
      # コンストラクタ生成
      assert(!list_action.nil?, "CASE:2-1-22-1")
      # パラメータチェック
#      list_action.valid?
#      print_log('error msg:' + list_action.error_msg_hash.to_s)
      assert(!list_action.valid?, "CASE:2-1-22-2")
      # アクセサ
      reg_host = list_action.reg_host
      assert(reg_host.system_id == 100, "CASE:2-1-22-3")
      assert(reg_host.proxy_host.nil?, "CASE:2-1-22-4")
      assert(reg_host.proxy_ip_address.nil?, "CASE:2-1-22-5")
      assert(reg_host.remote_host.nil?, "CASE:2-1-22-6")
      assert(reg_host.ip_address.nil?, "CASE:2-1-22-7")
      assert(reg_host.remarks.nil?, "CASE:2-1-22-8")
      assert(list_action.sort_item == 'system_id', "CASE:2-1-22-9")
      assert(list_action.sort_order == 'ASC', "CASE:2-1-22-10")
      assert(list_action.disp_counts == 'ALL', "CASE:2-1-22-11")
#      print_log('search_list:' + list_action.search_list.size.to_s)
      assert(list_action.search_list.size == 11, "CASE:2-1-22-12")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 1, "CASE:2-1-22-13")
#      print_log('disp_counts:' + list_action.error_msg_hash[:disp_counts].to_s)
      assert(list_action.error_msg_hash[:system_id] == 'システム名 は不正な値です。', "CASE:2-1-22-14")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-22")
    end
  end
  
  # 検索処理
  test "2-2:ListAction Test:search_list" do
    # 正常（全件検索：抽出条件指定なし）
    begin
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
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
      assert(result_list.size == 11, "CASE:2-2-1-3")
      assert(result_list[0].id == 1, "CASE:2-2-1-4")
      assert(result_list[1].id == 2, "CASE:2-2-1-4")
      assert(result_list[2].id == 3, "CASE:2-2-1-4")
      assert(result_list[3].id == 4, "CASE:2-2-1-4")
      assert(result_list[4].id == 5, "CASE:2-2-1-4")
      assert(result_list[5].id == 6, "CASE:2-2-1-4")
      assert(result_list[6].id == 7, "CASE:2-2-1-4")
      assert(result_list[7].id == 8, "CASE:2-2-1-4")
      assert(result_list[8].id == 10, "CASE:2-2-1-4")
      assert(result_list[9].id == 11, "CASE:2-2-1-4")
      assert(result_list[10].id == 9, "CASE:2-2-1-4")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-1-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    # 正常（全抽出条件指定）
    begin
      reg_host_params = {:system_id=>1,
                         :proxy_host=>'^proxy2\.ne\.jp$', :proxy_ip_address=>'192.168.254.2',
                         :remote_host=>'^client2\.ne\.jp$', :ip_address=>'192.168.255.2',
                         :remarks=>'MyString'}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
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
      assert(result_list[0].system_id == 1, "CASE:2-2-2-5")
      assert(result_list[0].proxy_host == '^proxy2\.ne\.jp$', "CASE:2-2-2-6")
      assert(result_list[0].proxy_ip_address == '192.168.254.2', "CASE:2-2-2-7")
      assert(result_list[0].remote_host == '^client2\.ne\.jp$', "CASE:2-2-2-8")
      assert(result_list[0].ip_address == '192.168.255.2', "CASE:2-2-2-9")
      assert(result_list[0].remarks == 'MyString', "CASE:2-2-2-10")
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-2-11")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    # 正常（ソート条件：システムID 昇順）
    begin
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
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
      assert(result_list.size == 11, "CASE:2-2-3-3")
      assert(result_list[0].id == 1, "CASE:2-2-3-4")
      assert(result_list[1].id == 2, "CASE:2-2-3-5")
      assert(result_list[2].id == 3, "CASE:2-2-3-6")
      assert(result_list[3].id == 4, "CASE:2-2-3-7")
      assert(result_list[4].id == 5, "CASE:2-2-3-8")
      assert(result_list[5].id == 6, "CASE:2-2-3-9")
      assert(result_list[6].id == 7, "CASE:2-2-3-10")
      assert(result_list[7].id == 8, "CASE:2-2-3-11")
      assert(result_list[8].id == 10, "CASE:2-2-3-12")
      assert(result_list[9].id == 11, "CASE:2-2-3-13")
      assert(result_list[10].id == 9, "CASE:2-2-3-14")
#      print_log('Search Test 5 End!!!')
      # エラーメッセージ
#      print_log('error hash:' + list_action.error_msg_hash.to_s)
      assert(list_action.error_msg_hash.size == 0, "CASE:2-2-3-15")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-3")
    end
    # 正常（ソート条件：プロキシホスト降順）
    begin
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'proxy_host',
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
#      result_list.each do |ent|
#        print_log('id:' + ent.id.to_s)
#      end
      assert(result_list.size == 11, "CASE:2-2-4-3")
      assert(result_list[0].id == 9, "CASE:2-2-4-4")
      assert(result_list[1].id == 8, "CASE:2-2-4-5")
      assert(result_list[2].id == 6, "CASE:2-2-4-6")
      assert(result_list[3].id == 5, "CASE:2-2-4-7")
      assert(result_list[4].id == 4, "CASE:2-2-4-8")
      assert(result_list[5].id == 2, "CASE:2-2-4-9")
      assert(result_list[6].id == 1, "CASE:2-2-4-10")
      assert(result_list[7].id == 11, "CASE:2-2-4-11")
      assert(result_list[8].id == 7, "CASE:2-2-4-12")
      assert(result_list[9].id == 3, "CASE:2-2-4-13")
      assert(result_list[10].id == 10, "CASE:2-2-4-14")
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
      RegulationHost.delete_all
      1000.times do |i|
        ent = RegulationHost.new
        ent.system_id = 1
        ent.remote_host = ('000000' + i.to_s).to_s[/\d{6}$/]
        ent.remarks = ('000000' + (1000 - i).to_s).to_s[/\d{6}$/]
        ent.save!
#        print_log('host :' + ent.host)
#        print_log('remarks:' + ent.remarks)
      end
    end
    # 正常（備考降順、検索結果件数）
    begin
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
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
        assert(result_list[i].remote_host == idx_str, "CASE:2-2-5-5")
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
    # 正常（リモートホスト昇順、検索結果件数）
    begin
      reg_host_params = {:system_id=>nil,
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
                        :sort_item=>'remote_host',
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
#        print_log('host :' + result_list[i].host + ':' + idx_str)
#        print_log('remarks:' + result_list[i].remarks + ':' + idx_str2)
        assert(result_list[i].system_id == 1, "CASE:2-2-6-4")
        assert(result_list[i].remote_host == idx_str, "CASE:2-2-6-5")
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
    RegulationHost.delete_all
    ActiveRecord::Base.transaction do
      1000.times do |i|
        ent = RegulationHost.new
        ent.system_id = 100000 - i
        ent.remote_host = ('000000' + i.to_s).to_s[/\d{6}$/]
        ent.remarks = ('000000' + (1000 - i).to_s).to_s[/\d{6}$/]
        ent.save
      end
    end
    # 異常（パラメータエラー、デフォルト検索）
    begin
      reg_host_params = {:system_id=>'a',
                         :proxy_host=>nil, :proxy_ip_address=>nil,
                         :remote_host=>nil, :ip_address=>nil,
                         :remarks=>nil}
      params={:controller_name => 'regulation_host_list',
              :method=>:POST,
              :session=>{},
              :params=>{:regulation_host=>reg_host_params,
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