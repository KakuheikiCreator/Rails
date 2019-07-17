# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：キー共有メッセージクラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/06/07 Nakanohito
# 更新日:
###############################################################################
require 'kconv'
require 'test_helper'
require 'unit/unit_test_util'
require 'messaging/connection_node_info_cache'
require 'messaging/message_xml'

class MessageXMLTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Messaging

  # テスト対象メソッド：initialize
  test "CASE:2-01 initialize" do
    node_info_cache = ConnectionNodeInfoCache.instance
    print_log("MessageXMLTest 2-01")
    # 正常ケース（メッセージタイプ・宛先指定）
    begin
      to_node_info = node_info_cache['masamune']
      msg_xml = MessageXML.new(MessageXML::MSG_TYPE_EXCHANGE_REQ, to_node_info)
      assert(!msg_xml.nil?, "CASE:2-1-1")
      # メッセージタイプ
      assert(msg_xml.msg_type == MessageXML::MSG_TYPE_EXCHANGE_REQ, "CASE:2-1-2")
      # メッセージステータス
      assert(msg_xml.status == MessageXML::MSG_STATUS_OK, "CASE:2-1-3")
      # 送信ノードID
      assert(msg_xml.sender_id == to_node_info.send_id, "CASE:2-1-4")
      # 送信ノードPW
      assert(msg_xml.sender_pw == to_node_info.send_pw, "CASE:2-1-5")
      # 文字列化
      xml_doc = REXML::Document.new(msg_xml.to_s)
      # メッセージタイプ
      assert(xml_doc.elements[MessageXML::PATH_TYPE].text == MessageXML::MSG_TYPE_EXCHANGE_REQ, "CASE:2-1-6")
      # メッセージステータス
      assert(xml_doc.elements[MessageXML::PATH_STATUS].text == MessageXML::MSG_STATUS_OK, "CASE:2-1-7")
      # アカウント情報判定
      assert(xml_doc.elements[MessageXML::PATH_SENDER_ID].text == to_node_info.send_id, "CASE:2-1-8")
      assert(xml_doc.elements[MessageXML::PATH_SENDER_PW].text == to_node_info.send_pw, "CASE:2-1-9")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-01-01 Error")
    end
    print_log("MessageXMLTest 2-02")
    # 正常ケース（XML文字列を引数に指定）
    begin
      to_node_info = node_info_cache['masamune']
      msg_xml = MessageXML.new(MessageXML::MSG_TYPE_EXCHANGE_REQ, to_node_info)
      assert(!msg_xml.nil?, "CASE:2-1-10")
      xml_doc = MessageXML.new(msg_xml.to_s)
      # メッセージタイプ
      assert(msg_xml.msg_type == MessageXML::MSG_TYPE_EXCHANGE_REQ, "CASE:2-1-11")
      # メッセージステータス
      assert(msg_xml.status == MessageXML::MSG_STATUS_OK, "CASE:2-1-12")
      # アカウント情報判定
      assert(msg_xml.sender_id == to_node_info.send_id, "CASE:2-1-13")
      assert(msg_xml.sender_pw == to_node_info.send_pw, "CASE:2-1-13")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-01-02 Error")
    end
    # 異常ケース（宛先ノード情報エラー）
    begin
      node_info = 'Error Node Info'
      msg = MessageXML.new(MessageXML::MSG_TYPE_PROCESS_REQ, node_info)
      flunk("CASE:2-1-8 Error")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      # エラーメッセージ判定
      assert(ex.message == 'Destination node information error', "CASE:2-1-8")
    end
    
  end
  
  # テスト対象メソッド：アクセサー
  test "CASE:2-02 accessor" do
    node_info_cache = ConnectionNodeInfoCache.instance
    # 正常ケース（アクセサーチェック）
    begin
      to_node_info = node_info_cache['masamune']
      msg_xml = MessageXML.new(MessageXML::MSG_TYPE_EXCHANGE_REQ, to_node_info)
      assert(!msg_xml.nil?, "CASE:2-2-1")
      # メッセージタイプ
      assert(msg_xml.msg_type == MessageXML::MSG_TYPE_EXCHANGE_REQ, "CASE:2-2-2")
      # メッセージステータス
      assert(msg_xml.status == MessageXML::MSG_STATUS_OK, "CASE:2-2-3")
      msg_xml.status = MessageXML::MSG_STATUS_NG
      assert(msg_xml.status == MessageXML::MSG_STATUS_NG, "CASE:2-2-4")
      # 送信ノードID
      assert(msg_xml.sender_id == to_node_info.send_id, "CASE:2-2-5")
      msg_xml.sender_id = 'test send_id'
      assert(msg_xml.sender_id == 'test send_id', "CASE:2-2-6")
      # 送信ノードPW
      assert(msg_xml.sender_pw == to_node_info.send_pw, "CASE:2-2-7")
      msg_xml.sender_pw = 'test send_pw'
      assert(msg_xml.sender_pw == 'test send_pw', "CASE:2-2-8")
      # 文字列化
      xml_doc = REXML::Document.new(msg_xml.to_s)
      # メッセージタイプ
      assert(xml_doc.elements[MessageXML::PATH_TYPE].text == MessageXML::MSG_TYPE_EXCHANGE_REQ, "CASE:2-2-9")
      # メッセージステータス
      assert(xml_doc.elements[MessageXML::PATH_STATUS].text == MessageXML::MSG_STATUS_NG, "CASE:2-2-4")
      # アカウント情報判定
      assert(xml_doc.elements[MessageXML::PATH_SENDER_ID].text == 'test send_id', "CASE:2-2-6")
      assert(xml_doc.elements[MessageXML::PATH_SENDER_PW].text == 'test send_pw', "CASE:2-2-8")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-02-01 Error")
    end
  end
end