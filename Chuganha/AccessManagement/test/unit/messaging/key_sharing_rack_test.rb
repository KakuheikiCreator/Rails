# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：キー共有ラッククラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/16 Nakanohito
# 更新日:
###############################################################################
require 'kconv'
require 'rack/mock'
require 'test_helper'
require 'unit/unit_test_util'
require 'uri'
require 'messaging/connection_node_info_cache'
require 'messaging/key_sharing_rack'
require 'messaging/key_sharing_xml'

class KeySharingRackTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Messaging
  #############################################################################
  # 前後処理
  #############################################################################
  # 前処理
  def setup
  end
  # 後処理
  def teardown
  end
  
  #############################################################################
  # テストケース
  #############################################################################
  # テスト対象メソッド：initialize
  test "CASE:2-01 initialize" do
    # 正常ケース
    begin
      app = KeySharingRack.new(Rails.logger)
      assert(!app.nil?, "CASE:2-1-1")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 異常ケース
  end

  # テスト対象メソッド：KeySharingParameters
  test "CASE:2-02 KeySharingParameters" do
    # 正常ケース（公開鍵交換リクエスト）
    print_log('CASE:2-02-01')
    begin
#      app = KeySharingRack.new(Rails.logger)
#      moc_req  = Rack::MockRequest.new(app)
#      res = moc_req.post('/rack_test/test', {:lint=>true, 'QUERY_STRING'=>'message=>0&message_mxl='+message_xml.to_s})
      opts = create_opts('POST', KeySharingXML::MSG_TYPE_EXCHANGE_REQ, 'MemberManagement', false)
      env  = Rack::MockRequest.env_for('/rack_test/test', opts)
#      print_log('ENV:' + env.to_s)
#      env = create_env('POST', KeySharingXML::MSG_TYPE_EXCHANGE_REQ, 'LOCAL', false)
      params = KeySharingRack::KeySharingParameters.new(env)
      # パラメータチェック
#      print_log('log msg:' + params.log_message.to_s)
      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 200, "CASE:2-2-2")
      assert(params.err_message.nil?, "CASE:2-2-3")
      assert(params.log_message.nil?, "CASE:2-2-4")
      assert(!params.message_xml.nil?, "CASE:2-2-5")
      assert(!params.from_node_info.nil?, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    # 正常ケース（共通鍵共有リクエスト）
    print_log('CASE:2-02-02')
    begin
      opts = create_opts('POST', KeySharingXML::MSG_TYPE_CONFIRMATION_REQ, 'MemberManagement', true)
      env  = Rack::MockRequest.env_for('/rack_test/test', opts)
      params = KeySharingRack::KeySharingParameters.new(env)
      # パラメータチェック
#      print_log('log msg:' + params.log_message.to_s)
      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 200, "CASE:2-2-2")
      assert(params.err_message.nil?, "CASE:2-2-3")
      assert(params.log_message.nil?, "CASE:2-2-4")
      assert(!params.message_xml.nil?, "CASE:2-2-5")
      assert(!params.from_node_info.nil?, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    ###########################################################################
    # 異常ケース（メソッドエラー）
    print_log('CASE:2-02-03')
    begin
      opts = create_opts('GET', KeySharingXML::MSG_TYPE_CONFIRMATION_REQ, 'MemberManagement', true)
      env  = Rack::MockRequest.env_for('/rack_test/test', opts)
      params = KeySharingRack::KeySharingParameters.new(env)
      # パラメータチェック
#      print_log('log msg:' + params.log_message.to_s)
      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 405, "CASE:2-2-2")
      assert(params.err_message == 'Method Not Allowed', "CASE:2-2-3")
      assert(params.log_message == 'KeySharingRack Request Method Error!!!', "CASE:2-2-4")
      assert(params.message_xml.nil?, "CASE:2-2-5")
      assert(params.from_node_info.nil?, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-3")
    end
    # 異常ケース（メッセージ存在エラー）
    print_log('CASE:2-02-04')
    begin
      opts = create_opts('POST', 100, 'MemberManagement', true)
      env  = Rack::MockRequest.env_for('/rack_test/test', opts)
      params = KeySharingRack::KeySharingParameters.new(env)
      # パラメータチェック
#      print_log('log msg:' + params.log_message.to_s)
      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 400, "CASE:2-2-2")
      assert(params.err_message == 'Bad Request', "CASE:2-2-3")
      assert(params.log_message == 'KeySharingRack Request Message Error!!!', "CASE:2-2-4")
      assert(params.message_xml.nil?, "CASE:2-2-5")
      assert(params.from_node_info.nil?, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-4")
    end
    # 異常ケース（メッセージタイプエラー）
    print_log('CASE:2-02-05')
    begin
      opts = create_opts('POST', KeySharingXML::MSG_TYPE_EXCHANGE_REQ, 'MemberManagement', false)
      query_array = create_query(KeySharingXML::MSG_TYPE_EXCHANGE_REQ,
                                 KeySharingXML::MSG_TYPE_EXCHANGE_RES, 'MemberManagement', false)
      opts['QUERY_STRING'] = query_array.join('&').to_s
      env = Rack::MockRequest.env_for('/rack_test/test', opts)
      params = KeySharingRack::KeySharingParameters.new(env)
      # パラメータチェック
#      print_log('log msg:' + params.log_message.to_s)
      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 400, "CASE:2-2-2")
      assert(params.err_message == 'Bad Request', "CASE:2-2-3")
      assert(params.log_message == 'KeySharingRack Request Message type Error!!!', "CASE:2-2-4")
      assert(!params.message_xml.nil?, "CASE:2-2-5")
      assert(params.from_node_info.nil?, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-5")
    end
    # 異常ケース（送信ノードエラー）
    print_log('CASE:2-02-06')
    begin
      # メッセージタイプ設定
      message_type = 'message_type=' + KeySharingXML::MSG_TYPE_EXCHANGE_REQ
      # メッセージ生成
      node_info_cache = Messaging::ConnectionNodeInfoCache.instance
      node_info = node_info_cache['AccessManagement']
      message_xml = KeySharingXML.new(KeySharingXML::MSG_TYPE_EXCHANGE_REQ, node_info)
      message_xml = REXML::Document.new(message_xml.to_s)
      message_xml.elements[MessageXML::PATH_SENDER_ID].text = 'ErrorID'
      # クエリー生成
      local_node_info = node_info_cache.local_info
#      msg_doc = local_node_info.public_encrypt(message_xml.to_s)
#      message = 'message=' + [msg_doc].pack('m')
      message = 'message=' + escape([message_xml.to_s].pack('m'))
      query_array = [message_type, message]
      opts = {'REQUEST_METHOD'=>'POST', 'QUERY_STRING'=>query_array.join('&').to_s}
      # テスト実行
#      env = Rack::MockRequest.env_for('/rack_test/test', opts)
      env = Rack::MockRequest.env_for('/messaging/key_sharing', opts)
      params = KeySharingRack::KeySharingParameters.new(env)
      # パラメータチェック
#      print_log('log msg:' + params.log_message.to_s)
#      print_log('Status:' + params.status.to_s)
#      print_log('log_message:' + params.log_message.to_s)
      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 401, "CASE:2-2-2")
      assert(params.err_message == 'Unauthorized', "CASE:2-2-3")
      assert(params.log_message == 'KeySharingRack Request Invalid node Error!!!', "CASE:2-2-4")
      assert(!params.message_xml.nil?, "CASE:2-2-5")
      assert(params.from_node_info.nil?, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-6")
    end
    # 異常ケース（メッセージアカウントエラー）
    print_log('CASE:2-02-07')
    begin
      # メッセージタイプ設定
      message_type = 'message_type=' + KeySharingXML::MSG_TYPE_CONFIRMATION_REQ
      # メッセージ生成
      node_info_cache = Messaging::ConnectionNodeInfoCache.instance
      node_info = node_info_cache['MemberManagement']
      message_xml = KeySharingXML.new(KeySharingXML::MSG_TYPE_CONFIRMATION_REQ, node_info)
      message_xml = REXML::Document.new(message_xml.to_s)
      message_xml.elements[MessageXML::PATH_SENDER_PW].text = 'ErrorPW'
      # クエリー生成
      local_node_info = node_info_cache.local_info
      msg_doc = local_node_info.public_encrypt(message_xml.to_s)
      message = 'message=' + escape([msg_doc].pack('m'))
      query_array = [message_type, message]
      opts = {'REQUEST_METHOD'=>'POST', 'QUERY_STRING'=>query_array.join('&').to_s}
#      opts = create_opts('POST', KeySharingXML::MSG_TYPE_CONFIRMATION_REQ, 'AccountError', false)
      env  = Rack::MockRequest.env_for('/messaging/key_sharing', opts)
      params = KeySharingRack::KeySharingParameters.new(env)
      # パラメータチェック
#      print_log('log msg:' + params.log_message.to_s)
      print_log('Status:' + params.status.to_s)
      print_log('log_message:' + params.log_message.to_s)
      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 401, "CASE:2-2-2")
      assert(params.err_message == 'Unauthorized', "CASE:2-2-3")
      assert(params.log_message == 'KeySharingRack Request Invalid account Error!!!', "CASE:2-2-4")
      assert(!params.message_xml.nil?, "CASE:2-2-5")
      assert(!params.from_node_info.nil?, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-7")
    end
  end

  # テスト対象メソッド：call
  test "CASE:2-03 call" do
    node_info_cache = Messaging::ConnectionNodeInfoCache.instance
    local_info = node_info_cache.local_info
    dummy_info = node_info_cache['DummySender']
#    sender_info = node_info_cache['MemberManagement']
    sender_info = node_info_cache['AccessManagement']
    # 正常ケース（公開鍵交換リクエスト）
    print_log('CASE:2-03-01')
    begin
      # パラメータ生成
      opts = create_opts('POST', KeySharingXML::MSG_TYPE_EXCHANGE_REQ, 'DummySender', false)
      opts[:lint] = true
      # テスト実行
      app = KeySharingRack.new(Rails.logger)
      moc_req  = Rack::MockRequest.new(app)
      res = moc_req.post('/messaging/key_sharing', opts)
#      print_log('Response:' + res.class.name)
#      print_log('Response:' + res.content_type.to_s)
#      print_log('Response Status:' + res.status.to_s)
#      print_log('Response Errors:' + res.errors.to_s)
#      print_log('Response Headders:' + res.headers.to_s)
#      print_log('Response Body:' + res.body)
      # パラメータチェック
      assert(!res.nil?, "CASE:2-3-1")
      assert(res.status == 200, "CASE:2-3-2")
      assert(!res.body.nil?, "CASE:2-3-3")
      html_doc = Nokogiri::HTML(res.body)
      enc_message = html_doc.at_css('#message').get_attribute('value')
      msg_str_enc = enc_message.unpack('m')[0]
      xml_doc = dummy_info.private_decrypt(msg_str_enc)
      msg_xml = REXML::Document.new(xml_doc)
      msg_type = msg_xml.elements[KeySharingXML::PATH_TYPE].text
      status = msg_xml.elements[KeySharingXML::PATH_STATUS].text
      recv_public_key = msg_xml.elements[KeySharingXML::PATH_PUBLIC_KEY].text
      rack_public_key = node_info_cache.local_info.public_key
      assert(msg_type == KeySharingXML::MSG_TYPE_EXCHANGE_RES, "CASE:2-3-4")
      assert(status == '0', "CASE:2-3-5")
      assert(msg_xml.elements[KeySharingXML::PATH_SENDER_ID].nil?, "CASE:2-3-6")
      assert(msg_xml.elements[KeySharingXML::PATH_SENDER_PW].nil?, "CASE:2-3-7")
      assert(recv_public_key == rack_public_key.to_s, "CASE:2-3-8")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:02-03-01")
    end
    # 正常ケース（共通鍵確認リクエスト）
    print_log('CASE:2-03-02')
    begin
      # パラメータ生成
      opts = create_opts('POST', KeySharingXML::MSG_TYPE_CONFIRMATION_REQ, 'DummySender', true)
      opts[:lint] = true
      send_key = local_info.common_key
#      local_info.common_key = nil
      dummy_info.common_key = nil
      sender_info.common_key = nil
      # テスト実行
      app = KeySharingRack.new(Rails.logger)
      moc_req  = Rack::MockRequest.new(app)
      res = moc_req.post('/messaging/key_sharing', opts)
#      print_log('Response:' + res.class.name)
#      print_log('Response:' + res.content_type.to_s)
#      print_log('Response Status:' + res.status.to_s)
#      print_log('Response Errors:' + res.errors.to_s)
#      print_log('Response Headders:' + res.headers.to_s)
#      print_log('Response Body:' + res.body)
      # レスポンスチェック
      resp_time = Time.now
      assert(!res.nil?, "CASE:2-3-1")
      assert(res.status == 200, "CASE:2-3-2")
      assert(!res.body.nil?, "CASE:2-3-3")
      # メッセージチェック
      html_doc = Nokogiri::HTML(res.body)
      enc_message = html_doc.at_css('#message').get_attribute('value')
      msg_str_enc = enc_message.unpack('m')[0]
      xml_doc = dummy_info.private_decrypt(msg_str_enc)
      msg_xml = REXML::Document.new(xml_doc)
      msg_type = msg_xml.elements[KeySharingXML::PATH_TYPE].text
      status = msg_xml.elements[KeySharingXML::PATH_STATUS].text
      send_id = msg_xml.elements[KeySharingXML::PATH_SENDER_ID].text
      send_pw = msg_xml.elements[KeySharingXML::PATH_SENDER_PW].text
      common_key = msg_xml.elements[KeySharingXML::PATH_COMMON_KEY]
      exp_str = msg_xml.elements[KeySharingXML::PATH_EXPIRATION].text
      assert(msg_type == KeySharingXML::MSG_TYPE_CONFIRMATION_RES, "CASE:2-3-4")
      assert(status == '0', "CASE:2-3-5")
#      print_log('send_id:' + send_id)
#      print_log('send_pw:' + send_pw)
      assert(send_id == sender_info.send_id, "CASE:2-3-6")
      assert(send_pw == sender_info.send_pw, "CASE:2-3-7")
      # 共通鍵情報の比較
      print_log('send  key:' + send_key.to_s)
      print_log('local key:' + local_info.common_key.to_s)
      print_log('dummy key:' + dummy_info.common_key.to_s)
      print_log('sender key:' + sender_info.common_key.to_s)
      assert(common_key.nil?, "CASE:2-3-8")
      assert(local_info.common_key == sender_info.common_key, "CASE:2-3-9")
#      assert(sender_info.common_key == send_key, "CASE:2-3-9")
      expiration = Time.at(exp_str.to_i)
      print_log('resp_time:' + resp_time.to_s)
      print_log('expiration:' + expiration.to_s)
      limit_time = Time.at(resp_time.to_i + (60*60*24*3))
#      assert(resp_time.to_i == expiration.to_i, "CASE:2-3-10")
      assert(limit_time.year == expiration.year, "CASE:2-3-10")
      assert(limit_time.month == expiration.month, "CASE:2-3-11")
      assert(limit_time.day == expiration.day, "CASE:2-3-12")
      assert(limit_time.hour == expiration.hour, "CASE:2-3-13")
      assert(limit_time.min == expiration.min, "CASE:2-3-14")
      assert(limit_time.sec == expiration.sec, "CASE:2-3-15")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:02-03-02")
    end
    # 異常ケース（共通鍵確認リクエスト：）
    print_log('CASE:2-03-03')
    begin
      # パラメータ生成
      opts = create_opts('GET', KeySharingXML::MSG_TYPE_CONFIRMATION_REQ, 'DummySender', true)
      opts[:lint] = true
      # テスト実行
      app = KeySharingRack.new(Rails.logger)
      moc_req  = Rack::MockRequest.new(app)
      res = moc_req.post('/messaging/key_sharing', opts)
      # レスポンスチェック
#      print_log('Response:' + res.class.name)
#      print_log('Response:' + res.content_type.to_s)
#      print_log('Response Status:' + res.status.to_s)
#      print_log('Response Errors:' + res.errors.to_s)
#      print_log('Response Headders:' + res.headers.to_s)
#      print_log('Response Body:' + res.body)
      assert(!res.nil?, "CASE:2-3-1")
      assert(res.status == 405, "CASE:2-3-2")
      assert(res.content_type == 'text/plain', "CASE:2-3-3")
      assert(res.body == 'Method Not Allowed', "CASE:2-3-4")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:02-03-03")
    end
    # 異常ケース（共通鍵確認リクエスト：アカウントエラー）
    print_log('CASE:02-03-04')
    begin
      # パラメータ生成
      # メッセージタイプ設定
      message_type = 'message_type=' + KeySharingXML::MSG_TYPE_CONFIRMATION_REQ
      # メッセージ生成
      node_info_cache = Messaging::ConnectionNodeInfoCache.instance
#      node_info = node_info_cache['MemberManagement']
      node_info = node_info_cache['DummySender']
      message_xml = KeySharingXML.new(KeySharingXML::MSG_TYPE_CONFIRMATION_REQ, node_info)
      message_xml = REXML::Document.new(message_xml.to_s)
      message_xml.elements[MessageXML::PATH_SENDER_PW].text = 'ErrorPW'
      # クエリー生成
      local_node_info = node_info_cache.local_info
      msg_doc = local_node_info.public_encrypt(message_xml.to_s)
#      to_node_info = node_info_cache['MemberManagement']
#      msg_doc = to_node_info.public_encrypt(message_xml.to_s)
      message = 'message=' + escape([msg_doc].pack('m'))
      query_array = [message_type, message]
      opts = {'REQUEST_METHOD'=>'POST', 'QUERY_STRING'=>query_array.join('&').to_s}
#      opts = create_opts('POST', KeySharingXML::MSG_TYPE_CONFIRMATION_REQ, 'AccountError', true)
#      opts[:lint] = true
      # テスト実行
      app = KeySharingRack.new(Rails.logger)
      moc_req  = Rack::MockRequest.new(app)
      res = moc_req.post('/messaging/key_sharing', opts)
      # レスポンスチェック
#      print_log('Response:' + res.class.name)
      print_log('Response:' + res.content_type.to_s)
      print_log('Response Status:' + res.status.to_s)
      print_log('Response Errors:' + res.errors.to_s)
      print_log('Response Headders:' + res.headers.to_s)
      print_log('Response Body:' + res.body)
      assert(!res.nil?, "CASE:2-3-1")
      assert(res.status == 401, "CASE:2-3-2")
      assert(res.content_type == 'text/plain', "CASE:2-3-3")
      assert(res.body == 'Unauthorized', "CASE:2-3-4")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:02-03-04")
    end
  end
  
  # リクエストパラメータ生成
  def create_opts(method, msg_type, from_node_id, encryption_flg=false)
    # パラメータ生成 
    query_array = create_query(msg_type, msg_type, from_node_id, encryption_flg)
    opts = {'REQUEST_METHOD'=>method,'QUERY_STRING'=>query_array.join('&').to_s}
    return opts
  end
  
  # クエリーマップ生成
  def create_query(msg_type, xml_msg_type, from_node_id, encryption_flg=false)
    # 送信元ノードの詐称
    node_info_cache = Messaging::ConnectionNodeInfoCache.instance
    from_node_info = node_info_cache[from_node_id]
    from_node_info.instance_variable_set(:@node_id, 'LOCAL')
    node_info_cache.instance_variable_set(:@local_info, from_node_info)
    to_node_info = node_info_cache['LOCAL']
    # メッセージタイプ設定
    message_type = 'message_type=' + msg_type.to_s
    # メッセージ設定
    message_xml_str = nil
    if xml_msg_type == KeySharingXML::MSG_TYPE_EXCHANGE_REQ ||
       xml_msg_type == KeySharingXML::MSG_TYPE_EXCHANGE_RES ||
       xml_msg_type == KeySharingXML::MSG_TYPE_CONFIRMATION_REQ ||
       xml_msg_type == KeySharingXML::MSG_TYPE_CONFIRMATION_RES then
      message_xml_str = KeySharingXML.new(xml_msg_type, to_node_info).to_s
    else
      message_xml_str = KeySharingXML.new(KeySharingXML::MSG_TYPE_EXCHANGE_REQ, to_node_info).to_s
      message_xml = REXML::Document.new(message_xml_str)
      message_xml.elements[MessageXML::PATH_TYPE].text = xml_msg_type
      message_xml_str = message_xml.to_s
    end
#    Rails.logger.debug('send message:' + message_xml.to_s)
    msg_doc = nil
    if encryption_flg then
      msg_doc = to_node_info.public_encrypt(message_xml_str)
    else
      msg_doc = message_xml_str
    end
    message = 'message=' + escape([msg_doc].pack('m'))
#    Rails.logger.debug('message:' + message)
    # 送信元ノードを元に戻す
    from_node_info.instance_variable_set(:@node_id, from_node_id)
    node_info_cache.instance_variable_set(:@local_info, node_info_cache['LOCAL'])
    return [message_type, message]
  end
  
  def escape(value)
    return URI.escape(value.to_s, /[^a-zA-Z0-9\-\.\_\~]/)
  end
end