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

class MessageSenderSvrTest < ActiveSupport::TestCase
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
    node_info_cache = Messaging::ConnectionNodeInfoCache.instance
    lcl_send_node = node_info_cache.local_info
    lcl_recv_node = node_info_cache['masamune_svr']
    svr_send_node = node_info_cache['masamune_client'].clone
    svr_recv_node = node_info_cache['masamune_svr'].clone
    err_id_node = node_info_cache['masamune_err_1']
    err_pw_node = node_info_cache['masamune_err_2']
    # モックサーバー設定
    http_client = TestHTTPClient.new
    http_client.client_node_info = svr_send_node
    http_client.server_node_info = svr_recv_node
    sender = MessageSender.instance
    # ステータス関係
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
      # 検証
      exec_flg = sender.processing_request?(lcl_recv_node.node_id, 'TestProc')
      sleep(2)
      assert(exec_flg, "CASE:2-4-1-1")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-01 Error")
    end
    # 異常ケース（送信先ノードエラー）
    print_log("CASE:2-04-04")
    begin
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
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # レスポンス生成処理
    def create_response(request_info)
#      Rails.logger.debug('post_data:' + request_info.post_data.to_s)
      req_msg_xml = ex_msg_xml(request_info)
      # メッセージ処理
#      Rails.logger.debug('message_type:' + req_msg_xml.elements[KeySharingXML::PATH_TYPE].text)
      case req_msg_xml.elements[KeySharingXML::PATH_TYPE].text
      when KeySharingXML::MSG_TYPE_EXCHANGE_REQ then
        @client_node_info.public_key = req_msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
      when KeySharingXML::MSG_TYPE_CONFIRMATION_REQ then
        @client_node_info.common_key = req_msg_xml.elements[KeySharingXML::PATH_COMMON_KEY].text
      end
      # レスポンス生成
      params = @resp_array.shift
#      Rails.logger.debug('params[0]:' + params[0].to_s)
#      Rails.logger.debug('params:' + params.to_s)
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
      Rails.logger.debug('Request Message Dec:' + msg_str)
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