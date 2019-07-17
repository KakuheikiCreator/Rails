# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：メッセージ送信クラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/27 Nakanohito
# 更新日:
###############################################################################
require 'openssl'
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_httpclient'
require 'unit/mock/mock_key_sharing_xml'
require 'messaging/message_sender'
require 'messaging/message_xml'
require 'messaging/key_sharing_xml'
require 'messaging/processing_xml'

class MessageSenderTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Messaging

  # テスト対象メソッド：initialize
  test "CASE:2-01 initialize" do
    # 正常ケース
    begin
      # 検証
      assert(!MessageSender.instance.nil?, "CASE:2-1-1")
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
    # 正常ケース（ロガー設定）
    begin
      sender = MessageSender.instance
      sender.logger = Rails.logger
      # 検証
      assert(sender.instance_variable_get(:@logger) == Rails.logger, "CASE:2-2-1")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2 Error")
    end
    # 異常ケース
  end

  # テスト対象メソッド：SendParameter
  test "CASE:2-03 SendParameter" do
    # 正常ケース（コンストラクタ）
    begin
      # 接続ノード情報設定
      node_info_cache = Messaging::ConnectionNodeInfoCache.instance
      to_node_id = 'AccessManagement'
      to_node_info = node_info_cache[to_node_id]
      process_id = 'TestProc'
      # パラメータ生成
      params = MessageSender::SendParameters.new(to_node_id, process_id)
      assert(params.to_node_id == to_node_id, "CASE:2-3-1")
      assert(params.to_node_info == to_node_info, "CASE:2-3-2")
      assert(params.process_id == process_id, "CASE:2-3-3")
      assert(params.valid?, "CASE:2-3-4")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-1 Error")
    end
    # 正常ケース（バリデーションエラー：ノード情報無し）
    begin
      # 接続ノード情報設定
      to_node_id = 'None'
      process_id = 'TestProc'
      # パラメータ生成
      params = MessageSender::SendParameters.new(to_node_id, process_id)
      assert(!params.valid?, "CASE:2-3-5")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-5 Error")
    end
    # 正常ケース（バリデーションエラー：プロセス無し）
    begin
      # 接続ノード情報設定
      node_info_cache = Messaging::ConnectionNodeInfoCache.instance
      to_node_id = 'AccessManagement'
      to_node_info = node_info_cache[to_node_id]
      process_id = 'ErrorProc'
      # パラメータ生成
      params = MessageSender::SendParameters.new(to_node_id, process_id)
      assert(!params.valid?, "CASE:2-3-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-6 Error")
    end
    # 正常ケース（リトライ判定）
    begin
      # 接続ノード情報設定
      to_node_id = 'AccessManagement'
      process_id = 'TestProc'
      # パラメータ生成
      params = MessageSender::SendParameters.new(to_node_id, process_id)
      assert(params.retry?, "CASE:2-3-7")
      assert(params.retry?, "CASE:2-3-8")
      assert(!params.retry?, "CASE:2-3-9")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-7 Error")
    end
    # 異常ケース
  end
  
  # テスト対象メソッド：processing_request?
  test "CASE:2-04 processing_request?" do
    # ノード情報関係
#    print_log("CASE:2-04-00-1")
    node_info_cache = Messaging::ConnectionNodeInfoCache.instance
    lcl_send_node = node_info_cache.local_info
    lcl_recv_node = node_info_cache['masamune']
    svr_send_node = node_info_cache['masamune_client'].clone
    svr_recv_node = node_info_cache['masamune'].clone
    err_id_node = node_info_cache['masamune_err_1']
    err_pw_node = node_info_cache['masamune_err_2']
    # モックサーバー設定
#    print_log("CASE:2-04-00-2")
    http_client = TestHTTPClient.new
    http_client.client_node_info = svr_send_node
    http_client.server_node_info = svr_recv_node
    sender = MessageSender.instance
    sender.logger = Rails.logger
    sender.instance_variable_set(:@client, http_client)
    # ステータス関係
#    print_log("CASE:2-04-00-3")
    STATUS_OK = MessageXML::MSG_STATUS_OK
    STATUS_NG = MessageXML::MSG_STATUS_NG
    TYPE_EXCHANGE_REQ = MessageXML::MSG_TYPE_EXCHANGE_REQ = '0' # 公開鍵交換リクエスト
    TYPE_EXCHANGE_RES = MessageXML::MSG_TYPE_EXCHANGE_RES = '1' # 公開鍵交換レスポンス
    TYPE_CONFIRMATION_REQ = MessageXML::MSG_TYPE_CONFIRMATION_REQ = '2' # キー確認リクエスト
    TYPE_CONFIRMATION_RES = MessageXML::MSG_TYPE_CONFIRMATION_RES = '3' # キー確認レスポンス
    TYPE_PROCESS_REQ = MessageXML::MSG_TYPE_PROCESS_REQ = '4' # 処理リクエスト
    TYPE_PROCESS_RES = MessageXML::MSG_TYPE_PROCESS_RES = '5' # 処理リクエスト

    # 正常ケース（正常実行）
    print_log("CASE:2-04-01")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      common_key = lcl_recv_node.common_key
      svr_send_node.common_key = common_key
      lcl_recv_node.common_key_expiration = svr_send_node.common_key_expiration
      # レスポンス生成
      resp_xml = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_xml)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(2)
      assert(exec_flg, "CASE:2-4-1-1")
      # 送信メッセージ検証
      request_info = http_client.request_array.shift
      assert(request_info.uri == lcl_recv_node.destination_url, "CASE:2-4-1-2")
      post_data = request_info.post_data
      assert(post_data['node_id'] == lcl_recv_node.send_id, "CASE:2-4-1-3")
      # 送信メッセージXML検証
      msg_64 = post_data['message']
      msg_str = lcl_recv_node.common_decrypt(msg_64.unpack('m')[0])
      msg_xml = REXML::Document.new(msg_str)
      assert(msg_xml.elements[MessageXML::PATH_TYPE].text == TYPE_PROCESS_REQ, "CASE:2-4-1-4")
      assert(msg_xml.elements[MessageXML::PATH_STATUS].text == STATUS_OK, "CASE:2-4-1-5")
      assert(msg_xml.elements[MessageXML::PATH_SENDER_ID].text == lcl_recv_node.send_id, "CASE:2-4-1-6")
      assert(msg_xml.elements[MessageXML::PATH_SENDER_PW].text == lcl_recv_node.send_pw, "CASE:2-4-1-7")
      assert(msg_xml.elements[ProcessingXML::PATH_PROCESS_ID].text == 'TestProc', "CASE:2-4-1-8")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-01 Error")
    end
    # 正常ケース（送信スレッド停止）
    print_log("CASE:2-04-02")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      common_key = lcl_recv_node.common_key
      svr_send_node.common_key = common_key
      lcl_recv_node.common_key_expiration = svr_send_node.common_key_expiration
      # レスポンス生成
      resp_xml = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_xml)
      # 送信スレッド停止
      sender.instance_variable_get(:@sender_thread).kill
#      print_log('Alive?:' + sender.instance_variable_get(:@sender_thread).alive?.to_s)
      sleep(1)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(2)
      assert(exec_flg, "CASE:2-4-2-1")
      # 送信メッセージ検証
      request_info = http_client.request_array.shift
      assert(request_info.uri == lcl_recv_node.destination_url, "CASE:2-4-2-2")
      post_data = request_info.post_data
      assert(post_data['node_id'] == lcl_recv_node.send_id, "CASE:2-4-2-3")
      # 送信メッセージXML検証
      msg_64 = post_data['message']
      msg_str = lcl_recv_node.common_decrypt(msg_64.unpack('m')[0])
      msg_xml = REXML::Document.new(msg_str)
      assert(msg_xml.elements[MessageXML::PATH_TYPE].text == TYPE_PROCESS_REQ, "CASE:2-4-2-4")
      assert(msg_xml.elements[MessageXML::PATH_STATUS].text == STATUS_OK, "CASE:2-4-2-5")
      assert(msg_xml.elements[MessageXML::PATH_SENDER_ID].text == lcl_recv_node.send_id, "CASE:2-4-2-6")
      assert(msg_xml.elements[MessageXML::PATH_SENDER_PW].text == lcl_recv_node.send_pw, "CASE:2-4-2-7")
      assert(msg_xml.elements[ProcessingXML::PATH_PROCESS_ID].text == 'TestProc', "CASE:2-4-2-8")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-02 Error")
    end
    # 正常ケース（キー交換有り）
    print_log("CASE:2-04-03")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
#      common_key = lcl_recv_node.common_key
#      svr_send_node.common_key = common_key
#      lcl_recv_node.common_key_expiration = svr_send_node.common_key_expiration
      rsa_gen(lcl_send_node)
      rsa_gen(svr_recv_node)
      lcl_recv_node.common_key = nil
      svr_send_node.common_key = nil
      lcl_recv_node.instance_variable_set(:@common_key_expiration, -1)
      svr_send_node.instance_variable_set(:@common_key_expiration, -1)
      # レスポンス生成
#      print_log('lcl_send_node.public_key:' + lcl_send_node.public_key.to_s)
#      print_log('svr_recv_node.public_key:' + svr_recv_node.public_key.to_s)
      resp_xml_1 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_xml_2 = key_sharing(TYPE_CONFIRMATION_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_xml_3 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_xml_1, false)
      http_client.push_response(200, resp_xml_2, false)
      http_client.push_response(200, resp_xml_3)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(2)
      assert(exec_flg, "CASE:2-4-3-1")
      # 公開鍵交換メッセージ検証
      request_info = http_client.request_array.shift
      assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-3-2")
      post_data = request_info.post_data
      assert(post_data['message_type'] == TYPE_EXCHANGE_REQ, "CASE:2-4-3-3")
      msg_str = post_data['message'].unpack('m')[0]
      msg_xml = REXML::Document.new(msg_str)
      sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
      assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-3-4")
      public_key_str = msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
#      print_log("receive public_key:" + public_key_str)
#      print_log("local   public_key:" + local_node_info.public_key.to_s)
      assert(public_key_str == lcl_send_node.public_key.to_s, "CASE:2-4-3-5")
      # 共通鍵交換メッセージ検証
      request_info = http_client.request_array.shift
      print_log("request_info.uri:" + request_info.uri)
      print_log("lcl_recv_node.key_sharing_url:" + lcl_recv_node.key_sharing_url)
      assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-3-6")
      post_data = request_info.post_data
#      print_log("message_type:" + post_data['message_type'])
      assert(post_data['message_type'] == TYPE_CONFIRMATION_REQ, "CASE:2-4-3-7")
      msg_str = post_data['message'].unpack('m')[0]
      msg_xml = REXML::Document.new(svr_recv_node.private_decrypt(msg_str))
      sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
      assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-3-8")
      sender_pw = msg_xml.elements[MessageXML::PATH_SENDER_PW].text
      assert(sender_pw == lcl_recv_node.send_pw, "CASE:2-4-3-9")
      common_key = msg_xml.elements[KeySharingXML::PATH_COMMON_KEY].text
      assert(common_key == lcl_recv_node.common_key, "CASE:2-4-3-10")
      # 送信メッセージ検証
      request_info = http_client.request_array.shift
      assert(request_info.uri == lcl_recv_node.destination_url, "CASE:2-4-3-11")
      post_data = request_info.post_data
      assert(post_data['node_id'] == lcl_recv_node.send_id, "CASE:2-4-3-12")
      # 送信メッセージXML検証
      msg_64 = post_data['message']
      msg_str = lcl_recv_node.common_decrypt(msg_64.unpack('m')[0])
      msg_xml = REXML::Document.new(msg_str)
      assert(msg_xml.elements[MessageXML::PATH_TYPE].text == TYPE_PROCESS_REQ, "CASE:2-4-3-13")
      assert(msg_xml.elements[MessageXML::PATH_STATUS].text == STATUS_OK, "CASE:2-4-3-14")
      assert(msg_xml.elements[MessageXML::PATH_SENDER_ID].text == lcl_recv_node.send_id, "CASE:2-4-3-15")
      assert(msg_xml.elements[MessageXML::PATH_SENDER_PW].text == lcl_recv_node.send_pw, "CASE:2-4-3-16")
      assert(msg_xml.elements[ProcessingXML::PATH_PROCESS_ID].text == 'TestProc', "CASE:2-4-3-17")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-03 Error")
    end
    # 異常ケース（送信先ノードエラー）
    print_log("CASE:2-04-04")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # 検証
      exec_flg = sender.processing_request?('Error Node', 'TestProc')
      assert(!exec_flg, "CASE:2-4-4-1")
      assert(http_client.request_array.empty?, "CASE:2-4-4-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-04 Error")
    end
    # 異常ケース（処理IDエラー）
    print_log("CASE:2-04-05")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # 検証
      exec_flg = sender.processing_request?('masamune', 'ErrorProc')
      assert(!exec_flg, "CASE:2-4-5-1")
      assert(http_client.request_array.empty?, "CASE:2-4-5-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-05 Error")
    end
    # 異常ケース（公開鍵交換時の返信ステータスエラー）
    print_log("CASE:2-04-06")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      rsa_gen(lcl_send_node)
      rsa_gen(svr_recv_node)
      lcl_recv_node.common_key = nil
      svr_send_node.common_key = nil
      lcl_recv_node.instance_variable_set(:@common_key_expiration, -1)
      svr_send_node.instance_variable_set(:@common_key_expiration, -1)
      # レスポンス生成
      resp_msg_1 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_2 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_3 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(0, resp_msg_1, false)
      http_client.push_response(0, resp_msg_2, false)
      http_client.push_response(0, resp_msg_3, false)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(3)
      assert(exec_flg, "CASE:2-4-6-1")
      # 公開鍵交換リクエスト検証
#      print_log('Array List:' + http_client.request_array.size.to_s)
      assert(http_client.request_array.size == 3, "CASE:2-4-6-2")
      request_info = http_client.request_array.shift
      until request_info.nil? do
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-6-3")
        post_data = request_info.post_data
#      print_log('Message Type:' + post_data['message_type'].to_s)
        assert(post_data['message_type'] == TYPE_EXCHANGE_REQ, "CASE:2-4-6-4")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(msg_str)
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-6-5")
        public_key_str = msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
        assert(public_key_str == lcl_send_node.public_key.to_s, "CASE:2-4-6-6")
        request_info = http_client.request_array.shift
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-06 Error")
    end
    # 異常ケース（公開鍵交換時の返信メッセージステータスエラー）
    print_log("CASE:2-04-07")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      rsa_gen(lcl_send_node)
      rsa_gen(svr_recv_node)
      lcl_recv_node.common_key = nil
      svr_send_node.common_key = nil
      lcl_recv_node.instance_variable_set(:@common_key_expiration, -1)
      svr_send_node.instance_variable_set(:@common_key_expiration, -1)
      # レスポンス生成
      resp_msg_1 = key_sharing(TYPE_EXCHANGE_RES, STATUS_NG, svr_recv_node, svr_send_node)
      resp_msg_2 = key_sharing(TYPE_EXCHANGE_RES, 'ERROR', svr_recv_node, svr_send_node)
      resp_msg_3 = key_sharing(TYPE_EXCHANGE_RES, nil, svr_recv_node, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_msg_1, false)
      http_client.push_response(200, resp_msg_2, false)
      http_client.push_response(200, resp_msg_3, false)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(2)
      assert(exec_flg, "CASE:2-4-7-1")
      # 公開鍵交換リクエスト検証
      assert(http_client.request_array.size == 3, "CASE:2-4-7-2")
      request_info = http_client.request_array.shift
      until request_info.nil? do
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-7-3")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_EXCHANGE_REQ, "CASE:2-4-7-4")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(msg_str)
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-7-5")
        public_key_str = msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
        assert(public_key_str == lcl_send_node.public_key.to_s, "CASE:2-4-7-6")
        request_info = http_client.request_array.shift
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-07 Error")
    end
    # 異常ケース（公開鍵交換時の返信メッセージタイプエラー）
    print_log("CASE:2-04-08")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      rsa_gen(lcl_send_node)
      rsa_gen(svr_recv_node)
      lcl_recv_node.common_key = nil
      svr_send_node.common_key = nil
      lcl_recv_node.instance_variable_set(:@common_key_expiration, -1)
      svr_send_node.instance_variable_set(:@common_key_expiration, -1)
      # レスポンス生成
      resp_msg_1 = key_sharing(TYPE_EXCHANGE_REQ, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_2 = key_sharing(TYPE_EXCHANGE_REQ, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_3 = key_sharing(TYPE_EXCHANGE_REQ, STATUS_OK, svr_recv_node, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_msg_1, false)
      http_client.push_response(200, resp_msg_2, false)
      http_client.push_response(200, resp_msg_3, false)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(2)
      assert(exec_flg, "CASE:2-4-8-1")
      # 公開鍵交換リクエスト検証
      assert(http_client.request_array.size == 3, "CASE:2-4-8-2")
      request_info = http_client.request_array.shift
      until request_info.nil? do
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-8-3")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_EXCHANGE_REQ, "CASE:2-4-8-4")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(msg_str)
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-8-5")
        public_key_str = msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
        assert(public_key_str == lcl_send_node.public_key.to_s, "CASE:2-4-8-6")
        request_info = http_client.request_array.shift
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-08 Error")
    end
    # 異常ケース（共通鍵共有時の返信ステータスエラー）
    print_log("CASE:2-04-09")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      rsa_gen(lcl_send_node)
      rsa_gen(svr_recv_node)
      lcl_recv_node.common_key = nil
      svr_send_node.common_key = nil
      lcl_recv_node.instance_variable_set(:@common_key_expiration, -1)
      svr_send_node.instance_variable_set(:@common_key_expiration, -1)
      # レスポンス生成
      resp_msg_1 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_2 = key_sharing(TYPE_CONFIRMATION_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_3 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_4 = key_sharing(TYPE_CONFIRMATION_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_5 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_6 = key_sharing(TYPE_CONFIRMATION_RES, STATUS_OK, svr_recv_node, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_msg_1, false)
      http_client.push_response(199, resp_msg_2, false)
      http_client.push_response(200, resp_msg_3, false)
      http_client.push_response(201, resp_msg_4, false)
      http_client.push_response(200, resp_msg_5, false)
      http_client.push_response(0, resp_msg_6, false)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(2)
      assert(exec_flg, "CASE:2-4-9-1")
      assert(http_client.request_array.size == 6, "CASE:2-4-9-2")
      bef_common_key = nil
      3.times do
        # 公開鍵交換リクエスト検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-9-3")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_EXCHANGE_REQ, "CASE:2-4-9-4")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(msg_str)
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-9-5")
        public_key_str = msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
        assert(public_key_str == lcl_send_node.public_key.to_s, "CASE:2-4-9-6")
        # 共通鍵共有リクエスト検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-9-7")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_CONFIRMATION_REQ, "CASE:2-4-9-8")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(svr_recv_node.private_decrypt(msg_str))
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-9-9")
        sender_pw = msg_xml.elements[MessageXML::PATH_SENDER_PW].text
        assert(sender_pw == lcl_recv_node.send_pw, "CASE:2-4-9-10")
        common_key = msg_xml.elements[KeySharingXML::PATH_COMMON_KEY].text
#        print_log('node common_key:' + lcl_recv_node.common_key)
#        print_log('send common_key:' + common_key)
        assert(common_key != lcl_recv_node.common_key, "CASE:2-4-9-11")
        assert(common_key != bef_common_key, "CASE:2-4-9-12")
        bef_common_key = common_key
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-09 Error")
    end
    # 異常ケース（共通鍵共有時の返信メッセージステータスエラー）
    print_log("CASE:2-04-10")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      rsa_gen(lcl_send_node)
      rsa_gen(svr_recv_node)
      lcl_recv_node.common_key = nil
      svr_send_node.common_key = nil
      lcl_recv_node.instance_variable_set(:@common_key_expiration, -1)
      svr_send_node.instance_variable_set(:@common_key_expiration, -1)
      # レスポンス生成
      resp_msg_1 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_2 = key_sharing(TYPE_CONFIRMATION_RES, STATUS_NG, svr_recv_node, svr_send_node)
      resp_msg_3 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_4 = key_sharing(TYPE_CONFIRMATION_RES, 'ERROR', svr_recv_node, svr_send_node)
      resp_msg_5 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_6 = key_sharing(TYPE_CONFIRMATION_RES, nil, svr_recv_node, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_msg_1, false)
      http_client.push_response(200, resp_msg_2, false)
      http_client.push_response(200, resp_msg_3, false)
      http_client.push_response(200, resp_msg_4, false)
      http_client.push_response(200, resp_msg_5, false)
      http_client.push_response(200, resp_msg_6, false)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(2)
      assert(exec_flg, "CASE:2-4-10-1")
      assert(http_client.request_array.size == 6, "CASE:2-4-10-2")
      bef_common_key = nil
      3.times do
        # 公開鍵交換リクエスト検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-10-3")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_EXCHANGE_REQ, "CASE:2-4-10-4")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(msg_str)
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-10-5")
        public_key_str = msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
        assert(public_key_str == lcl_send_node.public_key.to_s, "CASE:2-4-10-6")
        # 共通鍵共有リクエスト検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-10-7")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_CONFIRMATION_REQ, "CASE:2-4-10-8")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(svr_recv_node.private_decrypt(msg_str))
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-10-9")
        sender_pw = msg_xml.elements[MessageXML::PATH_SENDER_PW].text
        assert(sender_pw == lcl_recv_node.send_pw, "CASE:2-4-10-10")
        common_key = msg_xml.elements[KeySharingXML::PATH_COMMON_KEY].text
#        print_log('node common_key:' + lcl_recv_node.common_key)
#        print_log('send common_key:' + common_key)
        assert(common_key != lcl_recv_node.common_key, "CASE:2-4-10-11")
        assert(common_key != bef_common_key, "CASE:2-4-10-12")
        bef_common_key = common_key
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-10 Error")
    end
    # 異常ケース（共通鍵共有時の返信メッセージタイプエラー）
    print_log("CASE:2-04-11")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      rsa_gen(lcl_send_node)
      rsa_gen(svr_recv_node)
      lcl_recv_node.common_key = nil
      svr_send_node.common_key = nil
      lcl_recv_node.instance_variable_set(:@common_key_expiration, -1)
      svr_send_node.instance_variable_set(:@common_key_expiration, -1)
      # レスポンス生成
      resp_msg_1 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_2 = key_sharing(TYPE_CONFIRMATION_REQ, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_3 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_4 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_5 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_6 = key_sharing(TYPE_CONFIRMATION_REQ, STATUS_OK, svr_recv_node, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_msg_1, false)
      http_client.push_response(200, resp_msg_2, false)
      http_client.push_response(200, resp_msg_3, false)
      http_client.push_response(200, resp_msg_4, false)
      http_client.push_response(200, resp_msg_5, false)
      http_client.push_response(200, resp_msg_6, false)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(2)
      assert(exec_flg, "CASE:2-4-11-1")
      assert(http_client.request_array.size == 6, "CASE:2-4-11-2")
      bef_common_key = nil
      3.times do
        # 公開鍵交換リクエスト検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-11-3")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_EXCHANGE_REQ, "CASE:2-4-11-4")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(msg_str)
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-11-5")
        public_key_str = msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
        assert(public_key_str == lcl_send_node.public_key.to_s, "CASE:2-4-11-6")
        # 共通鍵共有リクエスト検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-11-7")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_CONFIRMATION_REQ, "CASE:2-4-11-8")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(svr_recv_node.private_decrypt(msg_str))
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-11-9")
        sender_pw = msg_xml.elements[MessageXML::PATH_SENDER_PW].text
        assert(sender_pw == lcl_recv_node.send_pw, "CASE:2-4-11-10")
        common_key = msg_xml.elements[KeySharingXML::PATH_COMMON_KEY].text
#        print_log('node common_key:' + lcl_recv_node.common_key)
#        print_log('send common_key:' + common_key)
        assert(common_key != lcl_recv_node.common_key, "CASE:2-4-11-11")
        assert(common_key != bef_common_key, "CASE:2-4-11-12")
        bef_common_key = common_key
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-11 Error")
    end
    # 異常ケース（共通鍵共有時の返信メッセージの送信ノードIDエラー）
    print_log("CASE:2-04-12")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      rsa_gen(lcl_send_node)
      rsa_gen(svr_recv_node)
      rsa_gen(err_id_node)
      lcl_recv_node.common_key = nil
      svr_send_node.common_key = nil
      err_id_node.common_key = nil
      lcl_recv_node.instance_variable_set(:@common_key_expiration, -1)
      svr_send_node.instance_variable_set(:@common_key_expiration, -1)
      err_id_node.instance_variable_set(:@common_key_expiration, -1)
      # レスポンス生成
      resp_msg_1 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_2 = key_sharing(TYPE_CONFIRMATION_RES, STATUS_OK, svr_recv_node, err_id_node)
      resp_msg_3 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_4 = key_sharing(TYPE_CONFIRMATION_RES, STATUS_OK, svr_recv_node, err_id_node)
      resp_msg_5 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_6 = key_sharing(TYPE_CONFIRMATION_RES, STATUS_OK, svr_recv_node, err_id_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_msg_1, false)
      http_client.push_response(200, resp_msg_2, false)
      http_client.push_response(200, resp_msg_3, false)
      http_client.push_response(200, resp_msg_4, false)
      http_client.push_response(200, resp_msg_5, false)
      http_client.push_response(200, resp_msg_6, false)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(3)
      assert(exec_flg, "CASE:2-4-12-1")
      assert(http_client.request_array.size == 6, "CASE:2-4-12-2")
      bef_common_key = nil
      3.times do
        # 公開鍵交換リクエスト検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-12-3")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_EXCHANGE_REQ, "CASE:2-4-12-4")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(msg_str)
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-12-5")
        public_key_str = msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
        assert(public_key_str == lcl_send_node.public_key.to_s, "CASE:2-4-12-6")
        # 共通鍵共有リクエスト検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-12-7")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_CONFIRMATION_REQ, "CASE:2-4-12-8")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(svr_recv_node.private_decrypt(msg_str))
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-12-9")
        sender_pw = msg_xml.elements[MessageXML::PATH_SENDER_PW].text
        assert(sender_pw == lcl_recv_node.send_pw, "CASE:2-4-12-10")
        common_key = msg_xml.elements[KeySharingXML::PATH_COMMON_KEY].text
#        print_log('node common_key:' + lcl_recv_node.common_key)
#        print_log('send common_key:' + common_key)
        assert(common_key != lcl_recv_node.common_key, "CASE:2-4-12-11")
        assert(common_key != bef_common_key, "CASE:2-4-12-12")
        bef_common_key = common_key
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-12 Error")
    end
    # 異常ケース（共通鍵共有時の返信メッセージの送信ノードPWエラー）
    print_log("CASE:2-04-13")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      rsa_gen(lcl_send_node)
      rsa_gen(svr_recv_node)
      rsa_gen(err_pw_node)
      lcl_recv_node.common_key = nil
      svr_send_node.common_key = nil
      err_pw_node.common_key = nil
      lcl_recv_node.instance_variable_set(:@common_key_expiration, -1)
      svr_send_node.instance_variable_set(:@common_key_expiration, -1)
      err_pw_node.instance_variable_set(:@common_key_expiration, -1)
      # レスポンス生成
      resp_msg_1 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_2 = key_sharing(TYPE_CONFIRMATION_RES, STATUS_OK, svr_recv_node, err_pw_node)
      resp_msg_3 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_4 = key_sharing(TYPE_CONFIRMATION_RES, STATUS_OK, svr_recv_node, err_pw_node)
      resp_msg_5 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_6 = key_sharing(TYPE_CONFIRMATION_RES, STATUS_OK, svr_recv_node, err_pw_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_msg_1, false)
      http_client.push_response(200, resp_msg_2, false)
      http_client.push_response(200, resp_msg_3, false)
      http_client.push_response(200, resp_msg_4, false)
      http_client.push_response(200, resp_msg_5, false)
      http_client.push_response(200, resp_msg_6, false)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(3)
      assert(exec_flg, "CASE:2-4-13-1")
      assert(http_client.request_array.size == 6, "CASE:2-4-13-2")
      bef_common_key = nil
      3.times do
        # 公開鍵交換リクエスト検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-13-3")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_EXCHANGE_REQ, "CASE:2-4-13-4")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(msg_str)
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-13-5")
        public_key_str = msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
        assert(public_key_str == lcl_send_node.public_key.to_s, "CASE:2-4-13-6")
        # 共通鍵共有リクエスト検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-13-7")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_CONFIRMATION_REQ, "CASE:2-4-13-8")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(svr_recv_node.private_decrypt(msg_str))
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-13-9")
        sender_pw = msg_xml.elements[MessageXML::PATH_SENDER_PW].text
        assert(sender_pw == lcl_recv_node.send_pw, "CASE:2-4-13-10")
        common_key = msg_xml.elements[KeySharingXML::PATH_COMMON_KEY].text
#        print_log('node common_key:' + lcl_recv_node.common_key)
#        print_log('send common_key:' + common_key)
        assert(common_key != lcl_recv_node.common_key, "CASE:2-4-13-11")
        assert(common_key != bef_common_key, "CASE:2-4-13-12")
        bef_common_key = common_key
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-13 Error")
    end
    # 異常ケース（メッセージ送信時の返信ステータスエラー）
    print_log("CASE:2-04-14")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      common_key = lcl_recv_node.common_key
      svr_send_node.common_key = common_key
      lcl_recv_node.common_key_expiration = svr_send_node.common_key_expiration
      # レスポンス生成
      resp_msg_1 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      resp_msg_2 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      resp_msg_3 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(0,   resp_msg_1)
      http_client.push_response(199, resp_msg_2)
      http_client.push_response(201, resp_msg_3)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(4)
      assert(exec_flg, "CASE:2-4-14-1")
      assert(http_client.request_array.size == 3, "CASE:2-4-14-2")
      3.times do
        # 送信メッセージ検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.destination_url, "CASE:2-4-14-3")
        post_data = request_info.post_data
        assert(post_data['node_id'] == lcl_recv_node.send_id, "CASE:2-4-14-4")
        # 送信メッセージXML検証
        msg_64 = post_data['message']
        msg_str = lcl_recv_node.common_decrypt(msg_64.unpack('m')[0])
        msg_xml = REXML::Document.new(msg_str)
        wk_msg_type = msg_xml.elements[MessageXML::PATH_TYPE].text
        assert(wk_msg_type == TYPE_PROCESS_REQ, "CASE:2-4-14-5")
        assert(msg_xml.elements[MessageXML::PATH_STATUS].text == STATUS_OK, "CASE:2-4-14-6")
        assert(msg_xml.elements[MessageXML::PATH_SENDER_ID].text == lcl_recv_node.send_id, "CASE:2-4-14-7")
        assert(msg_xml.elements[MessageXML::PATH_SENDER_PW].text == lcl_recv_node.send_pw, "CASE:2-4-14-8")
        assert(msg_xml.elements[ProcessingXML::PATH_PROCESS_ID].text == 'TestProc', "CASE:2-4-14-9")
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-14 Error")
    end
    # 異常ケース（メッセージ送信時の返信ステータスエラー:400）
    print_log("CASE:2-04-15")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      common_key = lcl_recv_node.common_key
      svr_send_node.common_key = common_key
      lcl_recv_node.common_key_expiration = svr_send_node.common_key_expiration
      # レスポンス生成
      resp_msg_1 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      resp_msg_2 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_3 = key_sharing(TYPE_CONFIRMATION_RES, STATUS_OK, svr_recv_node, svr_send_node)
      resp_msg_4 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      resp_msg_5 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(400, resp_msg_1)
      http_client.push_response(200, resp_msg_2, false)
      http_client.push_response(200, resp_msg_3, false)
      http_client.push_response(399, resp_msg_4)
      http_client.push_response(401, resp_msg_5)
      # 実行
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(4)
      # 検証
      assert(exec_flg, "CASE:2-4-15-1")
#      print_log('Request Array Size:' + http_client.request_array.size.to_s)
      assert(http_client.request_array.size == 5, "CASE:2-4-15-2")
      http_client.request_array.each_with_index do |req_info, idx|
#        print_log('Index:' + idx.to_s)
        if idx == 0 || idx == 3 || idx == 4 then
          assert(req_info.uri == lcl_recv_node.destination_url, "CASE:2-4-15-3")
          post_data = req_info.post_data
          assert(post_data['node_id'] == lcl_recv_node.send_id, "CASE:2-4-15-4")
          # 送信メッセージXML検証
          msg_64 = post_data['message']
          msg_str = nil
          if idx == 0 then
            clone_node = lcl_recv_node.clone
            clone_node.common_key = common_key
            msg_str = clone_node.common_decrypt(msg_64.unpack('m')[0])
          else
            msg_str = lcl_recv_node.common_decrypt(msg_64.unpack('m')[0])
          end
#          print_log('received 1:' + request_info.received.to_s)
#          print_log('msg_str  1:' + msg_str.to_s)
#          next
          msg_xml = REXML::Document.new(msg_str)
          assert(msg_xml.elements[MessageXML::PATH_TYPE].text == TYPE_PROCESS_REQ, "CASE:2-4-15-5")
          assert(msg_xml.elements[MessageXML::PATH_STATUS].text == STATUS_OK, "CASE:2-4-15-6")
          assert(msg_xml.elements[MessageXML::PATH_SENDER_ID].text == lcl_recv_node.send_id, "CASE:2-4-15-7")
          assert(msg_xml.elements[MessageXML::PATH_SENDER_PW].text == lcl_recv_node.send_pw, "CASE:2-4-15-8")
          assert(msg_xml.elements[ProcessingXML::PATH_PROCESS_ID].text == 'TestProc', "CASE:2-4-15-9")
        else
          assert(req_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-15-10")
          msg_64 = req_info.post_data['message']
#          clone_node = lcl_recv_node.clone
#          clone_node.common_key = common_key
#          msg_str = clone_node.common_decrypt(msg_64.unpack('m')[0])
#          msg_str = lcl_recv_node.common_decrypt(msg_64.unpack('m')[0])
#          print_log('received 2:' + request_info.received.to_s)
#          print_log('msg_str  2:' + msg_str.to_s)
#          next
          msg_str = msg_64.unpack('m')[0]
#          print_log('received 2:' + request_info.received.to_s)
#          print_log('msg_str  2:' + msg_str.to_s)
          if idx == 1 then
            # 公開鍵交換
            msg_xml = REXML::Document.new(msg_str)
            wk_sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
            assert(wk_sender_id == lcl_recv_node.send_id, "CASE:2-4-15-11")
            wk_public_key_str = msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
            assert(wk_public_key_str == lcl_send_node.public_key.to_s, "CASE:2-4-15-12")
          else
            # 共通鍵確認
            msg_xml = REXML::Document.new(svr_recv_node.private_decrypt(msg_str))
            wk_sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
            assert(wk_sender_id == lcl_recv_node.send_id, "CASE:2-4-15-13")
            wk_sender_pw = msg_xml.elements[MessageXML::PATH_SENDER_PW].text
            assert(wk_sender_pw == lcl_recv_node.send_pw, "CASE:2-4-15-14")
            wk_common_key = msg_xml.elements[KeySharingXML::PATH_COMMON_KEY].text
            assert(wk_common_key == lcl_recv_node.common_key, "CASE:2-4-14-15")
          end
        end
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-15 Error")
    end
    # 異常ケース（メッセージ送信時の返信メッセージステータスエラー）
    print_log("CASE:2-04-16")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      common_key = lcl_recv_node.common_key
      svr_send_node.common_key = common_key
      lcl_recv_node.common_key_expiration = svr_send_node.common_key_expiration
      # レスポンス生成
      resp_msg_1 = processing(TYPE_PROCESS_RES, STATUS_NG, svr_send_node)
      resp_msg_2 = processing(TYPE_PROCESS_RES, 'Error', svr_send_node)
      resp_msg_3 = processing(TYPE_PROCESS_RES, nil, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_msg_1)
      http_client.push_response(200, resp_msg_2)
      http_client.push_response(200, resp_msg_3)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(3)
      assert(exec_flg, "CASE:2-4-16-1")
      assert(http_client.request_array.size == 3, "CASE:2-4-16-2")
      3.times do
        # 送信メッセージ検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.destination_url, "CASE:2-4-16-3")
        post_data = request_info.post_data
        assert(post_data['node_id'] == lcl_recv_node.send_id, "CASE:2-4-16-4")
        # 送信メッセージXML検証
        msg_64 = post_data['message']
        msg_str = lcl_recv_node.common_decrypt(msg_64.unpack('m')[0])
        msg_xml = REXML::Document.new(msg_str)
        assert(msg_xml.elements[MessageXML::PATH_TYPE].text == TYPE_PROCESS_REQ, "CASE:2-4-16-5")
        assert(msg_xml.elements[MessageXML::PATH_STATUS].text == STATUS_OK, "CASE:2-4-16-6")
        assert(msg_xml.elements[MessageXML::PATH_SENDER_ID].text == lcl_recv_node.send_id, "CASE:2-4-16-7")
        assert(msg_xml.elements[MessageXML::PATH_SENDER_PW].text == lcl_recv_node.send_pw, "CASE:2-4-16-8")
        assert(msg_xml.elements[ProcessingXML::PATH_PROCESS_ID].text == 'TestProc', "CASE:2-4-16-9")
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-16 Error")
    end
    # 異常ケース（メッセージ送信時の返信メッセージタイプエラー）
    print_log("CASE:2-04-17")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      common_key = lcl_recv_node.common_key
      svr_send_node.common_key = common_key
      lcl_recv_node.common_key_expiration = svr_send_node.common_key_expiration
      # レスポンス生成
      resp_msg_1 = processing(TYPE_PROCESS_REQ, STATUS_OK, svr_send_node)
      resp_msg_2 = processing(TYPE_PROCESS_REQ, STATUS_OK, svr_send_node)
      resp_msg_3 = processing(TYPE_PROCESS_REQ, STATUS_OK, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_msg_1)
      http_client.push_response(200, resp_msg_2)
      http_client.push_response(200, resp_msg_3)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(3)
      assert(exec_flg, "CASE:2-4-17-1")
      assert(http_client.request_array.size == 3, "CASE:2-4-17-2")
      3.times do
        # 送信メッセージ検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.destination_url, "CASE:2-4-17-3")
        post_data = request_info.post_data
        assert(post_data['node_id'] == lcl_recv_node.send_id, "CASE:2-4-17-4")
        # 送信メッセージXML検証
        msg_64 = post_data['message']
        msg_str = lcl_recv_node.common_decrypt(msg_64.unpack('m')[0])
        msg_xml = REXML::Document.new(msg_str)
        assert(msg_xml.elements[MessageXML::PATH_TYPE].text == TYPE_PROCESS_REQ, "CASE:2-4-17-5")
        assert(msg_xml.elements[MessageXML::PATH_STATUS].text == STATUS_OK, "CASE:2-4-17-6")
        assert(msg_xml.elements[MessageXML::PATH_SENDER_ID].text == lcl_recv_node.send_id, "CASE:2-4-17-7")
        assert(msg_xml.elements[MessageXML::PATH_SENDER_PW].text == lcl_recv_node.send_pw, "CASE:2-4-17-8")
        assert(msg_xml.elements[ProcessingXML::PATH_PROCESS_ID].text == 'TestProc', "CASE:2-4-17-9")
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-17 Error")
    end
    # 異常ケース（メッセージ送信時の返信メッセージのノードIDエラー）
    print_log("CASE:2-04-18")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      common_key = lcl_recv_node.common_key
      err_id_node.common_key = common_key
      lcl_recv_node.common_key_expiration = err_id_node.common_key_expiration
      # レスポンス生成
      resp_msg_1 = processing(TYPE_PROCESS_RES, STATUS_OK, err_id_node)
      resp_msg_2 = processing(TYPE_PROCESS_RES, STATUS_OK, err_id_node)
      resp_msg_3 = processing(TYPE_PROCESS_RES, STATUS_OK, err_id_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_msg_1)
      http_client.push_response(200, resp_msg_2)
      http_client.push_response(200, resp_msg_3)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(3)
      assert(exec_flg, "CASE:2-4-18-1")
      assert(http_client.request_array.size == 3, "CASE:2-4-18-2")
      3.times do
        # 送信メッセージ検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.destination_url, "CASE:2-4-18-3")
        post_data = request_info.post_data
        assert(post_data['node_id'] == lcl_recv_node.send_id, "CASE:2-4-18-4")
        # 送信メッセージXML検証
        msg_64 = post_data['message']
        msg_str = lcl_recv_node.common_decrypt(msg_64.unpack('m')[0])
        msg_xml = REXML::Document.new(msg_str)
        assert(msg_xml.elements[MessageXML::PATH_TYPE].text == TYPE_PROCESS_REQ, "CASE:2-4-18-5")
        assert(msg_xml.elements[MessageXML::PATH_STATUS].text == STATUS_OK, "CASE:2-4-18-6")
        assert(msg_xml.elements[MessageXML::PATH_SENDER_ID].text == lcl_recv_node.send_id, "CASE:2-4-18-7")
        assert(msg_xml.elements[MessageXML::PATH_SENDER_PW].text == lcl_recv_node.send_pw, "CASE:2-4-18-8")
        assert(msg_xml.elements[ProcessingXML::PATH_PROCESS_ID].text == 'TestProc', "CASE:2-4-18-9")
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-18 Error")
    end
    # 異常ケース（メッセージ送信時の返信メッセージのノードPWエラー）
    print_log("CASE:2-04-19")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      common_key = lcl_recv_node.common_key
      err_pw_node.common_key = common_key
      lcl_recv_node.common_key_expiration = err_pw_node.common_key_expiration
      # レスポンス生成
      resp_msg_1 = processing(TYPE_PROCESS_RES, STATUS_OK, err_pw_node)
      resp_msg_2 = processing(TYPE_PROCESS_RES, STATUS_OK, err_pw_node)
      resp_msg_3 = processing(TYPE_PROCESS_RES, STATUS_OK, err_pw_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_msg_1)
      http_client.push_response(200, resp_msg_2)
      http_client.push_response(200, resp_msg_3)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(3)
      assert(exec_flg, "CASE:2-4-19-1")
      assert(http_client.request_array.size == 3, "CASE:2-4-19-2")
      3.times do
        # 送信メッセージ検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.destination_url, "CASE:2-4-19-3")
        post_data = request_info.post_data
        assert(post_data['node_id'] == lcl_recv_node.send_id, "CASE:2-4-19-4")
        # 送信メッセージXML検証
        msg_64 = post_data['message']
        msg_str = lcl_recv_node.common_decrypt(msg_64.unpack('m')[0])
        msg_xml = REXML::Document.new(msg_str)
        assert(msg_xml.elements[MessageXML::PATH_TYPE].text == TYPE_PROCESS_REQ, "CASE:2-4-19-5")
        assert(msg_xml.elements[MessageXML::PATH_STATUS].text == STATUS_OK, "CASE:2-4-19-6")
        assert(msg_xml.elements[MessageXML::PATH_SENDER_ID].text == lcl_recv_node.send_id, "CASE:2-4-19-7")
        assert(msg_xml.elements[MessageXML::PATH_SENDER_PW].text == lcl_recv_node.send_pw, "CASE:2-4-19-8")
        assert(msg_xml.elements[ProcessingXML::PATH_PROCESS_ID].text == 'TestProc', "CASE:2-4-19-9")
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-19 Error")
    end
    # 異常ケース（送信前処理時例外発生）
    print_log("CASE:2-04-20")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      common_key = lcl_recv_node.common_key
      svr_send_node.common_key = common_key
      lcl_recv_node.common_key_expiration = svr_send_node.common_key_expiration
      # レスポンス生成
      resp_xml = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_xml)
      # 検証
      exec_flg = sender.processing_request?(Time.new, 'TestProc')
      sleep(3)
      assert(!exec_flg, "CASE:2-4-20-1")
      # 送信メッセージ検証
      assert(http_client.request_array.empty?, "CASE:2-4-20-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-20 Error")
    end
    # 異常ケース（公開鍵交換時例外発生）
    print_log("CASE:2-04-21")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      rsa_gen(lcl_send_node)
      rsa_gen(svr_recv_node)
      rsa_gen(err_pw_node)
      lcl_recv_node.common_key = nil
      svr_send_node.common_key = nil
      err_pw_node.common_key = nil
      lcl_recv_node.instance_variable_set(:@common_key_expiration, -1)
      svr_send_node.instance_variable_set(:@common_key_expiration, -1)
      err_pw_node.instance_variable_set(:@common_key_expiration, -1)
      # レスポンス生成
#      resp_xml_1 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
#      resp_xml_2 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
#      resp_xml_3 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_exception('Exception 1')
      http_client.push_exception('Exception 2')
      http_client.push_exception('Exception 3')
#      http_client.push_response(200, Time.new, false)
#      http_client.push_response(200, Time.new, false)
#      http_client.push_response(200, Time.new, false)
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(3)
      assert(exec_flg, "CASE:2-4-21-1")
      assert(http_client.request_array.size == 3, "CASE:2-4-21-2")
      bef_common_key = nil
      3.times do
        # 公開鍵交換リクエスト検証
        request_info = http_client.request_array.shift
        assert(!request_info.nil?, "CASE:2-4-21-3")
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-21 Error")
    end
    # 異常ケース（共通鍵交換時例外発生）
    print_log("CASE:2-04-22")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      rsa_gen(lcl_send_node)
      rsa_gen(svr_recv_node)
      rsa_gen(err_pw_node)
      lcl_recv_node.common_key = nil
      svr_send_node.common_key = nil
      err_pw_node.common_key = nil
      lcl_recv_node.instance_variable_set(:@common_key_expiration, -1)
      svr_send_node.instance_variable_set(:@common_key_expiration, -1)
      err_pw_node.instance_variable_set(:@common_key_expiration, -1)
      # レスポンス生成
      resp_msg_1 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
#      resp_msg_2 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      resp_msg_3 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
#      resp_msg_4 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      resp_msg_5 = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
#      resp_msg_6 = processing(TYPE_PROCESS_RES, STATUS_OK, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_response(200, resp_msg_1, false)
      http_client.push_exception('Exception 1')
      http_client.push_response(200, resp_msg_3, false)
      http_client.push_exception('Exception 2')
      http_client.push_response(200, resp_msg_5, false)
      http_client.push_exception('Exception 3')
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(3)
      assert(exec_flg, "CASE:2-4-22-1")
      assert(http_client.request_array.size == 6, "CASE:2-4-22-2")
      bef_common_key = nil
      3.times do
        # 公開鍵交換リクエスト検証
        request_info = http_client.request_array.shift
        assert(request_info.uri == lcl_recv_node.key_sharing_url, "CASE:2-4-22-3")
        post_data = request_info.post_data
        assert(post_data['message_type'] == TYPE_EXCHANGE_REQ, "CASE:2-4-22-4")
        msg_str = post_data['message'].unpack('m')[0]
        msg_xml = REXML::Document.new(msg_str)
        sender_id = msg_xml.elements[MessageXML::PATH_SENDER_ID].text
        assert(sender_id == lcl_recv_node.send_id, "CASE:2-4-22-5")
        public_key_str = msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
        assert(public_key_str == lcl_send_node.public_key.to_s, "CASE:2-4-22-6")
        # 共通鍵共有リクエスト検証
        request_info = http_client.request_array.shift
        assert(!request_info.nil?, "CASE:2-4-22-7")
      end
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-22 Error")
    end
    # 異常ケース（メッセージ送信時例外発生）
    print_log("CASE:2-04-23")
    begin
      # リクエストクリア
      http_client.request_array.clear
      # キー状態設定
      common_key = lcl_recv_node.common_key
      svr_send_node.common_key = common_key
      lcl_recv_node.common_key_expiration = svr_send_node.common_key_expiration
      # レスポンス生成
#      resp_xml = key_sharing(TYPE_EXCHANGE_RES, STATUS_OK, svr_recv_node, svr_send_node)
      # ダミーレスポンス設定
      http_client.resp_array.clear
      http_client.push_exception('Exception 1')
      http_client.push_exception('Exception 2')
      http_client.push_exception('Exception 3')
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(3)
      assert(exec_flg, "CASE:2-4-23-1")
      # 送信メッセージ検証
      assert(http_client.request_array.size == 3, "CASE:2-4-23-4")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-23 Error")
    end
  end
  
  #############################################################################
  # テスト用レスポンスメッセージ生成
  #############################################################################
  # キー共有メッセージ生成処理
  def key_sharing(msg_type, msg_status, from_node, to_node)
    origin_msg = Mock::MockKeySharingXML.new(msg_type, from_node, to_node)
    msg_xml = REXML::Document.new(origin_msg.to_s)
    msg_xml.elements[MessageXML::PATH_STATUS].text = msg_status
    return msg_xml
  end
  
  # 送信メッセージ生成処理
  def processing(msg_type, msg_status, to_node_info)
    origin_msg = ProcessingXML.new(msg_type, to_node_info)
    msg_xml = REXML::Document.new(origin_msg.to_s)
    msg_xml.elements[MessageXML::PATH_STATUS].text = msg_status
    return msg_xml
  end
  
  # 公開鍵暗号生成
  def rsa_gen(node_info)
    # initialize random seed（乱数を設定する事によって暗号化の予測不可能性を向上する）
    OpenSSL::Random.seed(OpenSSL::Random.random_bytes(16))
    # 新しいキー情報（RSA2048）を生成
    key_pair = OpenSSL::PKey::RSA.generate(2048, 17)
    key_pair_expiration = (Time.now.to_i + 600).freeze
    node_info.instance_variable_set(:@key_pair, key_pair)
    node_info.instance_variable_set(:@key_pair_expiration, key_pair_expiration)
  end
  
  #############################################################################
  # テスト用HTTPクライアント
  #############################################################################
  class TestHTTPClient < Mock::MockHTTPClient
    include Messaging
    # アクセスメソッド定義
    attr_accessor :client_node_info, :server_node_info
    attr_reader :resp_array, :recv_node_info
    # コンストラクタ
    def initialize
      super
      @info_cache = Messaging::ConnectionNodeInfoCache.instance
      @resp_array = Array.new
      @client_node_info = nil
      @server_node_info = nil
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # レスポンス追加処理
    def push_response(status, msg_xml, cmn_enc_flg=true)
      @resp_array.push([status, msg_xml, cmn_enc_flg])
    end
    
    # 例外レスポンス追加処理
    def push_exception(message)
      @resp_array.push([message])
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # レスポンス生成処理
    def create_response(request_info)
#      Rails.logger.debug('post_data:' + request_info.post_data.to_s)
      req_msg_xml = ex_msg_xml(request_info)
      # メッセージ処理
#      Rails.logger.debug('request message:' + req_msg_xml.to_s)
#      Rails.logger.debug('message_type:' + req_msg_xml.elements[KeySharingXML::PATH_TYPE].text)
      case req_msg_xml.elements[KeySharingXML::PATH_TYPE].text
      when KeySharingXML::MSG_TYPE_EXCHANGE_REQ then
        @client_node_info.public_key = req_msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
      when KeySharingXML::MSG_TYPE_CONFIRMATION_REQ then
        @client_node_info.common_key = req_msg_xml.elements[KeySharingXML::PATH_COMMON_KEY].text
      end
      # レスポンス生成
      params = @resp_array.shift
      raise params[0] if params.size == 1
#      Rails.logger.debug('params[0]:' + params[0].to_s)
#      Rails.logger.debug('params:' + params.to_s)
#      Rails.logger.debug('params[1]:' + params[1].to_s)
      body = create_body(params[1], params[2])
      return ResponseInfo.new(params[0], body)
    end
    # ノード情報取得
    def ex_msg_xml(request_info)
      node_id = request_info.post_data['node_id']
      msg_enc = request_info.post_data['message'].unpack('m')[0]
#      Rails.logger.debug('Request node_id:' + node_id.to_s)
#      Rails.logger.debug('Request Message Enc:' + msg_enc.to_s)
      msg_str = nil
      if node_id.nil? then
        case request_info.post_data['message_type']
        when KeySharingXML::MSG_TYPE_EXCHANGE_REQ then
          msg_str = msg_enc
        when KeySharingXML::MSG_TYPE_CONFIRMATION_REQ then
          msg_str = @server_node_info.private_decrypt(msg_enc)
        end
      else
        msg_str = @client_node_info.common_decrypt(msg_enc)
      end
#      Rails.logger.debug('Request Message Dec:' + msg_str)
      return REXML::Document.new(msg_str)
    end
    # 返信メッセージ生成
    def create_body(msg_xml, cmn_ent_flg)
#      Rails.logger.debug('Response Message:' + msg_xml.to_s)
      enc_msg = nil
      if cmn_ent_flg then
        enc_msg = @client_node_info.common_encrypt(msg_xml.to_s)
      else
        enc_msg = @client_node_info.public_encrypt(msg_xml.to_s)
      end
      body = '<html><head><title>Response Message</title></head><body>'
      body += '<input type="hidden" id="message" value="'
      body += [enc_msg].pack('m')
      body += '"></body></html>'
#      Rails.logger.debug('Response:' + body)
      return body
    end
  end
end