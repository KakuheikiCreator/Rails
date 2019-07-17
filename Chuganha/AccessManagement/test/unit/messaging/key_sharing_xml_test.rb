# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：キー共有メッセージクラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/15 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'messaging/connection_node_info_cache'
require 'messaging/key_sharing_xml'

class KeySharingXMLTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Messaging

  # テスト対象メソッド：initialize
  test "CASE:2-01 initialize" do
    node_info_cache = ConnectionNodeInfoCache.instance
    # 正常ケース（公開鍵交換リクエスト）
    begin
      node_info = node_info_cache['MemberManagement']
      msg = KeySharingXML.new(KeySharingXML::MSG_TYPE_EXCHANGE_REQ, node_info)
      assert(!msg.nil?, "CASE:2-1-1")
      xml_doc = REXML::Document.new(msg.to_s)
      # メッセージタイプ
      assert(xml_doc.elements[KeySharingXML::PATH_TYPE].text == KeySharingXML::MSG_TYPE_EXCHANGE_REQ, "CASE:2-1-2")
      # メッセージステータス
      assert(xml_doc.elements[KeySharingXML::PATH_STATUS].text == KeySharingXML::MSG_STATUS_OK, "CASE:2-1-3")
      # アカウント情報判定
      assert(xml_doc.elements[KeySharingXML::PATH_SENDER_ID].text == node_info.send_id, "CASE:2-1-4")
      assert(xml_doc.elements[KeySharingXML::PATH_SENDER_PW].nil?, "CASE:2-1-5")
      # 公開鍵情報判定
      local_info = node_info_cache.local_info
      assert(xml_doc.elements[KeySharingXML::PATH_PUBLIC_KEY].text == local_info.public_key.to_s, "CASE:2-1-6")
      # 共通鍵判定
      assert(xml_doc.elements[KeySharingXML::PATH_COMMON_KEY].nil?, "CASE:2-1-7")
      # 有効期限判定
      assert(xml_doc.elements[KeySharingXML::PATH_EXPIRATION].nil?, "CASE:2-1-8")
      # XML文字列を引数に生成
      msg_xml = KeySharingXML.new(xml_doc.to_s)
      # メッセージタイプ
      assert(msg_xml.msg_type == KeySharingXML::MSG_TYPE_EXCHANGE_REQ, "CASE:2-1-9")
      # メッセージステータス
      assert(msg_xml.status == KeySharingXML::MSG_STATUS_OK, "CASE:2-1-10")
      # アカウント情報判定
      assert(msg_xml.sender_id == node_info.send_id, "CASE:2-1-11")
      assert(msg_xml.sender_pw.nil?, "CASE:2-1-12")
      # 公開鍵情報判定
      local_info = node_info_cache.local_info
      assert(msg_xml.public_key == local_info.public_key.to_s, "CASE:2-1-13")
      # 共通鍵判定
      assert(msg_xml.common_key.nil?, "CASE:2-1-14")
      # 有効期限判定
      assert(msg_xml.expiration.nil?, "CASE:2-1-15")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1 Error")
    end
    print_log("MSG_TYPE_EXCHANGE_REQ OK!")
    # 正常ケース（公開鍵交換レスポンス）
    begin
      node_info = node_info_cache['MemberManagement']
      msg = KeySharingXML.new(KeySharingXML::MSG_TYPE_EXCHANGE_RES, node_info)
      assert(!msg.nil?, "CASE:2-1-1")
      xml_doc = REXML::Document.new(msg.to_s)
      # メッセージタイプ
      assert(xml_doc.elements[KeySharingXML::PATH_TYPE].text == KeySharingXML::MSG_TYPE_EXCHANGE_RES, "CASE:2-1-2")
      # メッセージステータス
      assert(xml_doc.elements[KeySharingXML::PATH_STATUS].text == KeySharingXML::MSG_STATUS_OK, "CASE:2-1-3")
      # アカウント情報判定
      assert(xml_doc.elements[KeySharingXML::PATH_SENDER_ID].nil?, "CASE:2-1-4")
      assert(xml_doc.elements[KeySharingXML::PATH_SENDER_PW].nil?, "CASE:2-1-5")
      # 公開鍵情報判定
      local_info = node_info_cache.local_info
      assert(xml_doc.elements[KeySharingXML::PATH_PUBLIC_KEY].text == local_info.public_key.to_s, "CASE:2-1-6")
      # 共通鍵判定
      assert(xml_doc.elements[KeySharingXML::PATH_COMMON_KEY].nil?, "CASE:2-1-7")
      # 有効期限判定
      assert(xml_doc.elements[KeySharingXML::PATH_EXPIRATION].nil?, "CASE:2-1-8")
      # XML文字列を引数に生成
      msg_xml = KeySharingXML.new(xml_doc.to_s)
      # メッセージタイプ
      assert(msg_xml.msg_type == KeySharingXML::MSG_TYPE_EXCHANGE_RES, "CASE:2-1-9")
      # メッセージステータス
      assert(msg_xml.status == KeySharingXML::MSG_STATUS_OK, "CASE:2-1-10")
      # アカウント情報判定
      assert(msg_xml.sender_id.nil?, "CASE:2-1-11")
      assert(msg_xml.sender_pw.nil?, "CASE:2-1-12")
      # 公開鍵情報判定
      local_info = node_info_cache.local_info
      assert(msg_xml.public_key == local_info.public_key.to_s, "CASE:2-1-13")
      # 共通鍵判定
      assert(msg_xml.common_key.nil?, "CASE:2-1-14")
      # 有効期限判定
      assert(msg_xml.expiration.nil?, "CASE:2-1-15")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1 Error")
    end
    print_log("MSG_TYPE_EXCHANGE_RES OK!")
    # 正常ケース（キー確認リクエスト）
    begin
      node_info = node_info_cache['MemberManagement']
      msg = KeySharingXML.new(KeySharingXML::MSG_TYPE_CONFIRMATION_REQ, node_info)
      assert(!msg.nil?, "CASE:2-1-1")
      xml_doc = REXML::Document.new(msg.to_s)
      # メッセージタイプ
      assert(xml_doc.elements[KeySharingXML::PATH_TYPE].text == KeySharingXML::MSG_TYPE_CONFIRMATION_REQ, "CASE:2-1-2")
      # メッセージステータス
      assert(xml_doc.elements[KeySharingXML::PATH_STATUS].text == KeySharingXML::MSG_STATUS_OK, "CASE:2-1-3")
      # アカウント情報判定
      assert(xml_doc.elements[KeySharingXML::PATH_SENDER_ID].text == node_info.send_id, "CASE:2-1-4")
      assert(xml_doc.elements[KeySharingXML::PATH_SENDER_PW].text == node_info.send_pw, "CASE:2-1-5")
      # 公開鍵情報判定
      assert(xml_doc.elements[KeySharingXML::PATH_PUBLIC_KEY].nil?, "CASE:2-1-6")
      # 共通鍵判定
      assert(xml_doc.elements[KeySharingXML::PATH_COMMON_KEY].text == node_info.common_key, "CASE:2-1-7")
      # 有効期限判定
      assert(xml_doc.elements[KeySharingXML::PATH_EXPIRATION].nil?, "CASE:2-1-8")
      # XML文字列を引数に生成
      msg_xml = KeySharingXML.new(xml_doc.to_s)
      # メッセージタイプ
      assert(msg_xml.msg_type == KeySharingXML::MSG_TYPE_CONFIRMATION_REQ, "CASE:2-1-9")
      # メッセージステータス
      assert(msg_xml.status == KeySharingXML::MSG_STATUS_OK, "CASE:2-1-10")
      # アカウント情報判定
      assert(msg_xml.sender_id == node_info.send_id, "CASE:2-1-11")
      assert(msg_xml.sender_pw == node_info.send_pw, "CASE:2-1-12")
      # 公開鍵情報判定
      assert(msg_xml.public_key.nil?, "CASE:2-1-13")
      # 共通鍵判定
      assert(msg_xml.common_key == node_info.common_key, "CASE:2-1-14")
      # 有効期限判定
      assert(msg_xml.expiration.nil?, "CASE:2-1-15")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1 Error")
    end
    print_log("MSG_TYPE_CONFIRMATION_REQ OK!")
    # 正常ケース（キー確認レスポンス）
    begin
      node_info = node_info_cache['MemberManagement']
      node_info.common_key_expiration = Time.now.to_i
      msg = KeySharingXML.new(KeySharingXML::MSG_TYPE_CONFIRMATION_RES, node_info)
      assert(!msg.nil?, "CASE:2-1-1")
      xml_doc = REXML::Document.new(msg.to_s)
      # メッセージタイプ
      assert(xml_doc.elements[KeySharingXML::PATH_TYPE].text == KeySharingXML::MSG_TYPE_CONFIRMATION_RES, "CASE:2-1-2")
      # メッセージステータス
      assert(xml_doc.elements[KeySharingXML::PATH_STATUS].text == KeySharingXML::MSG_STATUS_OK, "CASE:2-1-3")
      # アカウント情報判定
      assert(xml_doc.elements[KeySharingXML::PATH_SENDER_ID].text == node_info.send_id, "CASE:2-1-4")
      assert(xml_doc.elements[KeySharingXML::PATH_SENDER_PW].text == node_info.send_pw, "CASE:2-1-5")
      # 公開鍵情報判定
      assert(xml_doc.elements[KeySharingXML::PATH_PUBLIC_KEY].nil?, "CASE:2-1-6")
      # 共通鍵判定
      assert(xml_doc.elements[KeySharingXML::PATH_COMMON_KEY].nil?, "CASE:2-1-7")
      # 有効期限判定
      assert(xml_doc.elements[KeySharingXML::PATH_EXPIRATION].text == node_info.common_key_expiration.to_s, "CASE:2-1-8")
      # XML文字列を引数に生成
      msg_xml = KeySharingXML.new(xml_doc.to_s)
      # メッセージタイプ
      assert(msg_xml.msg_type == KeySharingXML::MSG_TYPE_CONFIRMATION_RES, "CASE:2-1-9")
      # メッセージステータス
      assert(msg_xml.status == KeySharingXML::MSG_STATUS_OK, "CASE:2-1-10")
      # アカウント情報判定
      assert(msg_xml.sender_id == node_info.send_id, "CASE:2-1-11")
      assert(msg_xml.sender_pw == node_info.send_pw, "CASE:2-1-12")
      # 公開鍵情報判定
      assert(msg_xml.public_key.nil?, "CASE:2-1-13")
      # 共通鍵判定
      assert(msg_xml.common_key.nil?, "CASE:2-1-14")
      # 有効期限判定
      assert(msg_xml.expiration == node_info.common_key_expiration.to_s, "CASE:2-1-15")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1 Error")
    end
    print_log("MSG_TYPE_CONFIRMATION_RES OK!")
    # 異常ケース（メッセージタイプエラー）
    begin
      node_info = node_info_cache['MemberManagement']
      msg = KeySharingXML.new('Error Message Type', node_info)
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
      msg = KeySharingXML.new(KeySharingXML::MSG_TYPE_EXCHANGE_REQ, node_info)
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