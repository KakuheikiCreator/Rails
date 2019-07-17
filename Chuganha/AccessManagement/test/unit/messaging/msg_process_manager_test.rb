# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：処理マネージャークラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/25 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'messaging/connection_node_info_cache'
require 'messaging/processing_xml'
require 'messaging/msg_process_manager'

class MsgProcessManagerTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Messaging

  # テスト対象メソッド：initialize
  test "CASE:2-01 initialize" do
    # 正常ケース（処理依頼リクエスト）
    begin
      # 検証
      assert(!MsgProcessManager.instance.nil?, "CASE:2-1-1")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1 Error")
    end
    # 異常ケース
  end

  # テスト対象メソッド：logger=
  test "CASE:2-02 logger=" do
    # 正常ケース（処理依頼リクエスト）
    begin
      manager = MsgProcessManager.instance
      manager.logger = Rails.logger
      # 検証
      logger = manager.instance_variable_get(:@logger)
      assert(!logger.nil?, "CASE:2-2-1")
      assert(logger == Rails.logger, "CASE:2-2-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2 Error")
    end
    # 異常ケース
  end
  
  # テスト対象メソッド：[]、[]=
  test "CASE:2-03 []、[]=" do
    # 正常ケース（処理依頼リクエスト）
    begin
      PROCESS_ID = 'test_proc_id'
      PROCESS_OBJ = 'test_process'
      manager = MsgProcessManager.instance
      manager[PROCESS_ID] = PROCESS_OBJ
      # 検証
      get_process = manager[PROCESS_ID]
      assert(!get_process.nil?, "CASE:2-3-1")
      assert(get_process == PROCESS_OBJ, "CASE:2-3-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3 Error")
    end
    # 異常ケース
  end
  
  # テスト対象メソッド：processing_request
  test "CASE:2-04 processing_request" do
    PROCESS_ID = 'test_proc_id'
    ERROR_ID = 'test_error_id'
    manager = MsgProcessManager.instance
    manager.logger = Rails.logger
    node_info_cache = ConnectionNodeInfoCache.instance
    # 正常ケース（処理依頼リクエスト）
    begin
      test_process = TestProcess.new
      manager[PROCESS_ID] = test_process
      # テスト実行
      node_info = node_info_cache['MemberManagement']
      msg = ProcessingXML.new(ProcessingXML::MSG_TYPE_PROCESS_REQ, node_info)
      msg.process_id = PROCESS_ID
      manager.processing_request(msg)
      sleep(1)
      # 結果検証
#      print_log('execute_flg:' + test_process.execute_flg.to_s)
#      print_log('execute_xml:' + test_process.execute_xml.class.name)
#      print_log('execute_cnt:' + test_process.execute_cnt.to_s)
      assert(test_process.execute_flg, "CASE:2-4-1")
      assert(ProcessingXML === test_process.execute_xml, "CASE:2-4-2")
      assert(test_process.execute_cnt == 1, "CASE:2-4-3")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4 Error")
    end
    # 異常ケース（処理結果異常）
    begin
      test_process = TestProcess.new
      manager[ERROR_ID] = test_process
      # テスト実行
      node_info = node_info_cache['MemberManagement']
      msg = ProcessingXML.new(ProcessingXML::MSG_TYPE_PROCESS_REQ, node_info)
      msg.process_id = ERROR_ID
      manager.processing_request(msg)
      sleep(1)
      # 結果検証
#      print_log('execute_flg:' + test_process.execute_flg.to_s)
#      print_log('execute_xml:' + test_process.execute_xml.class.name)
#      print_log('execute_cnt:' + test_process.execute_cnt.to_s)
      assert(test_process.execute_flg, "CASE:2-4-4")
      assert(ProcessingXML === test_process.execute_xml, "CASE:2-4-5")
      assert(test_process.execute_cnt == 4, "CASE:2-4-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4 Error")
    end
    # 異常ケース（メッセージ異常 XML以外）
    begin
      test_process = TestProcess.new
      manager[PROCESS_ID] = test_process
      # テスト実行
      node_info = node_info_cache['MemberManagement']
      msg = 'Error Message'
      manager.processing_request(msg)
      sleep(1)
      # 結果検証
      print_log('execute_flg:' + test_process.execute_flg.to_s)
      print_log('execute_xml:' + test_process.execute_xml.class.name)
      print_log('execute_cnt:' + test_process.execute_cnt.to_s)
      assert(!test_process.execute_flg, "CASE:2-4-7")
      assert(test_process.execute_xml.nil?, "CASE:2-4-8")
      assert(test_process.execute_cnt == 0, "CASE:2-4-9")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4 Error")
    end
    # 異常ケース（メッセージ異常　送信IDなし）
    print_log('CASE:2-4-10')
    begin
      test_process = TestProcess.new
      manager[ERROR_ID] = test_process
      # テスト実行
      node_info = node_info_cache['MemberManagement']
      msg_xml = ProcessingXML.new(ProcessingXML::MSG_TYPE_PROCESS_REQ, node_info)
      message_doc = msg_xml.instance_variable_get(:@msg_xml)
      message_doc.root.delete_element(MessageXML::PATH_SENDER_ID)
      msg_xml.process_id = ERROR_ID
      manager.processing_request(msg_xml)
      sleep(1)
      # 結果検証
#      print_log('execute_flg:' + test_process.execute_flg.to_s)
#      print_log('execute_xml:' + test_process.execute_xml.class.name)
#      print_log('execute_cnt:' + test_process.execute_cnt.to_s)
      assert(test_process.execute_flg, "CASE:2-4-10")
      assert(ProcessingXML === test_process.execute_xml, "CASE:2-4-11")
      assert(test_process.execute_cnt == 4, "CASE:2-4-12")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4 Error")
    end
  end
  
  protected
  #############################################################################
  # テスト処理クラス
  #############################################################################
  class TestProcess
    include Messaging
    # アクセサー定義
    attr_reader :execute_flg, :execute_xml, :execute_cnt
    # コンストラクタ
    def initialize
      @execute_flg = false
      @execute_xml = nil
      @execute_cnt = 0
    end
    
    public
    # テスト処理
    def execute?(message_xml)
#      Rails.logger.debug('TestProcess execute!!! msg:' + message_xml.to_s)
      @execute_flg = true
      @execute_xml = message_xml
      @execute_cnt += 1
#      Rails.logger.debug('Process ID:' + proc_id)
#      Rails.logger.debug('Check:' + (proc_id == 'test_proc_id').to_s)
      return message_xml.process_id == 'test_proc_id'
    end
  end
end