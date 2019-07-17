# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：処理依頼メッセージXMLクラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/15 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'messaging/connection_node_info_cache'
require 'messaging/processing_xml'

class ProcessingXMLTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Messaging

  # テスト対象メソッド：initialize
  test "CASE:2-01 initialize" do
    node_info_cache = ConnectionNodeInfoCache.instance
    # 正常ケース（処理依頼リクエスト）
    begin
      node_info = node_info_cache['MemberManagement']
      msg = ProcessingXML.new(ProcessingXML::MSG_TYPE_PROCESS_REQ, node_info)
      msg.process_id = 'test_process_id'
      assert(!msg.nil?, "CASE:2-1-1")
      xml_doc = REXML::Document.new(msg.to_s)
      # メッセージタイプ
      assert(xml_doc.elements[ProcessingXML::PATH_TYPE].text == ProcessingXML::MSG_TYPE_PROCESS_REQ, "CASE:2-1-2")
      # メッセージステータス
      assert(xml_doc.elements[ProcessingXML::PATH_STATUS].text == ProcessingXML::MSG_STATUS_OK, "CASE:2-1-3")
      # アカウント情報判定
      assert(xml_doc.elements[ProcessingXML::PATH_SENDER_ID].text == node_info.send_id, "CASE:2-1-4")
      assert(xml_doc.elements[ProcessingXML::PATH_SENDER_PW].text == node_info.send_pw, "CASE:2-1-5")
      # 処理ID判定
      assert(xml_doc.elements[ProcessingXML::PATH_PROCESS_ID].text == 'test_process_id', "CASE:2-1-6")
#      print_log("key_lifetime_sec:" + key_lifetime_sec.to_s)
#      print_log("lifetime:" + lifetime.to_s)
      # XML文字列を引数に生成
      msg_xml = ProcessingXML.new(xml_doc.to_s)
      # メッセージタイプ
      assert(msg_xml.msg_type == ProcessingXML::MSG_TYPE_PROCESS_REQ, "CASE:2-1-7")
      # メッセージステータス
      assert(msg_xml.status == ProcessingXML::MSG_STATUS_OK, "CASE:2-1-8")
      # アカウント情報取得
      assert(msg_xml.sender_id == node_info.send_id, "CASE:2-1-9")
      assert(msg_xml.sender_pw == node_info.send_pw, "CASE:2-1-10")
      # アカウント情報設定
      msg_xml.sender_id = 'Test Sender_ID'
      msg_xml.sender_pw ='Test Sender_PW'
      assert(msg_xml.sender_id == 'Test Sender_ID', "CASE:2-1-11")
      assert(msg_xml.sender_pw == 'Test Sender_PW', "CASE:2-1-12")
      # 処理ID
      assert(msg_xml.process_id == 'test_process_id', "CASE:2-1-13")
      msg_xml.process_id = 'new_process_id'
      assert(msg_xml.process_id == 'new_process_id', "CASE:2-1-14")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1 Error")
    end
    print_log("MSG_TYPE_EXCHANGE_REQ OK!")
    # 正常ケース（処理依頼レスポンス）
    begin
      node_info = node_info_cache['MemberManagement']
      msg = ProcessingXML.new(ProcessingXML::MSG_TYPE_PROCESS_RES, node_info)
      msg.process_id = 'test_process_id'
      assert(!msg.nil?, "CASE:2-1-1")
      xml_doc = REXML::Document.new(msg.to_s)
      # メッセージタイプ
      assert(xml_doc.elements[ProcessingXML::PATH_TYPE].text == ProcessingXML::MSG_TYPE_PROCESS_RES, "CASE:2-1-2")
      # メッセージステータス
      assert(xml_doc.elements[ProcessingXML::PATH_STATUS].text == ProcessingXML::MSG_STATUS_OK, "CASE:2-1-3")
      # アカウント情報判定
      assert(xml_doc.elements[ProcessingXML::PATH_SENDER_ID].text == node_info.send_id, "CASE:2-1-4")
      assert(xml_doc.elements[ProcessingXML::PATH_SENDER_PW].text == node_info.send_pw, "CASE:2-1-5")
      # 処理ID判定
      assert(xml_doc.elements[ProcessingXML::PATH_PROCESS_ID].text == 'test_process_id', "CASE:2-1-6")
#      print_log("key_lifetime_sec:" + key_lifetime_sec.to_s)
#      print_log("lifetime:" + lifetime.to_s)
      # XML文字列を引数に生成
      msg_xml = ProcessingXML.new(xml_doc.to_s)
      # メッセージタイプ
      assert(msg_xml.msg_type == ProcessingXML::MSG_TYPE_PROCESS_RES, "CASE:2-1-7")
      # メッセージステータス
      assert(msg_xml.status == ProcessingXML::MSG_STATUS_OK, "CASE:2-1-8")
      # アカウント情報判定
      assert(msg_xml.sender_id == node_info.send_id, "CASE:2-1-9")
      assert(msg_xml.sender_pw == node_info.send_pw, "CASE:2-1-10")
      # 処理ID
      assert(msg_xml.process_id == 'test_process_id', "CASE:2-1-11")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1 Error")
    end
    print_log("MSG_TYPE_EXCHANGE_RES OK!")
    # 異常ケース（メッセージタイプエラー）
    begin
      node_info = node_info_cache['MemberManagement']
      msg = ProcessingXML.new('Message type Error', node_info)
      flunk("CASE:2-1 Error")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      # エラーメッセージ判定
      assert(ex.message == 'Message type Error', "CASE:2-1-16")
    end
    print_log("MSG_TYPE Error! OK")
    # 異常ケース（宛先ノード情報エラー）
    begin
      node_info = 'MemberManagement'
      msg = ProcessingXML.new(ProcessingXML::MSG_TYPE_EXCHANGE_REQ, node_info)
      flunk("CASE:2-1 Error")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      # エラーメッセージ判定
      assert(ex.message == 'Destination node information error', "CASE:2-1-17")
    end
    print_log("Node Info Error OK!")
  end
end