# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：メッセージ受信ラッククラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/26 Nakanohito
# 更新日:
###############################################################################
require 'rack/mock'
require 'test_helper'
require 'unit/unit_test_util'
require 'messaging/connection_node_info_cache'
require 'messaging/processing_xml'
require 'messaging/msg_process_manager'

class MsgReceiverRackTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Messaging
  #############################################################################
  # 前後処理
  #############################################################################
  # 前処理
  def setup
    # ノード情報初期化
    @node_info_cache = ConnectionNodeInfoCache.instance
    @from_node_id = 'MemberManagement'
#    @from_node_id = 'DummySender'
    @to_node_id = 'AccessManagement'
    @local_node_info = @node_info_cache.local_info
    @from_node_info = @node_info_cache[@from_node_id]
    @to_node_info = @node_info_cache[@to_node_id]
    @from_node_info.common_key
#    @local_node_info.common_key = @from_node_info.common_key
    # 処理マネージャー
    @manager = MsgProcessManager.instance
    @manager.logger = Rails.logger
    @process_id = 'TestProc'
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
      app = MsgReceiverRack.new(Rails.logger)
      assert(!app.nil?, "CASE:2-1-1")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 異常ケース
  end

  # テスト対象メソッド：MessageParameters
  test "CASE:2-02 MessageParameters" do
    # 正常ケース（メッセージ送信リクエスト）
    print_log('CASE:2-02-01')
    begin
#      app = MsgReceiverRack.new(Rails.logger)
#      moc_req  = Rack::MockRequest.new(app)
#      res = moc_req.post('/rack_test/test', {:lint=>true, 'QUERY_STRING'=>'message=>0&message_mxl='+message_xml.to_s})
      opts = create_opts('POST', ProcessingXML::MSG_TYPE_PROCESS_REQ, @from_node_id, @to_node_id, true)
      env  = Rack::MockRequest.env_for('/rack_test/test', opts)
#      env = create_env('POST', ProcessingXML::MSG_TYPE_EXCHANGE_REQ, 'LOCAL', false)
      params = MsgReceiverRack::MessageParameters.new(env)
      # パラメータチェック
#      print_log('log msg:' + params.log_message.to_s)
      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 200, "CASE:2-2-2")
      assert(params.err_message.nil?, "CASE:2-2-3")
      assert(params.log_message.nil?, "CASE:2-2-4")
      assert(ProcessingXML === params.message_xml, "CASE:2-2-5")
      assert(params.from_node_info.node_id == @to_node_info.send_id, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    ###########################################################################
    # 異常ケース（メソッドエラー）
    print_log('CASE:2-02-02')
    begin
      opts = create_opts('GET', ProcessingXML::MSG_TYPE_PROCESS_REQ, @from_node_id, @to_node_id, true)
      env  = Rack::MockRequest.env_for('/rack_test/test', opts)
      params = MsgReceiverRack::MessageParameters.new(env)
      # パラメータチェック
#      print_log('log msg:' + params.log_message.to_s)
      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 405, "CASE:2-2-2")
      assert(params.err_message == 'Method Not Allowed', "CASE:2-2-3")
      assert(params.log_message == 'MsgReceiverRack Request Method Error!!!', "CASE:2-2-4")
      assert(params.message_xml.nil?, "CASE:2-2-5")
      assert(params.from_node_info.nil?, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-2")
    end
    # 異常ケース（メッセージ存在エラー）
    print_log('CASE:2-02-03')
    begin
      # 暗号化されていないメッセージ
      opts = create_opts('POST', ProcessingXML::MSG_TYPE_PROCESS_REQ, @from_node_id, @to_node_id, false)
      env  = Rack::MockRequest.env_for('/rack_test/test', opts)
      params = MsgReceiverRack::MessageParameters.new(env)
      # パラメータチェック
#      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 400, "CASE:2-2-2")
      assert(params.err_message == 'Bad Request', "CASE:2-2-3")
      assert(params.log_message == 'MsgReceiverRack Request Message Error!!!', "CASE:2-2-4")
      assert(params.message_xml.nil?, "CASE:2-2-5")
      assert(params.from_node_info.nil?, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-3")
    end
    # 異常ケース（メッセージタイプエラー）
    print_log('CASE:2-02-04')
    begin
      # レスポンスメッセージ送信
      opts = create_opts('POST', ProcessingXML::MSG_TYPE_EXCHANGE_RES, @from_node_id, @to_node_id, true)
      env = Rack::MockRequest.env_for('/rack_test/test', opts)
      params = MsgReceiverRack::MessageParameters.new(env)
      # パラメータチェック
      print_log('log msg:' + params.log_message.to_s)
      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 400, "CASE:2-2-2")
      assert(params.err_message == 'Bad Request', "CASE:2-2-3")
      assert(params.log_message == 'MsgReceiverRack Request Message type Error!!!', "CASE:2-2-4")
      assert(!params.message_xml.nil?, "CASE:2-2-5")
      assert(params.from_node_info.nil?, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-4")
    end
    # 異常ケース（送信ノードエラー）
    print_log('CASE:2-02-05')
    begin
      # メッセージ生成
      message_xml = ProcessingXML.new(ProcessingXML::MSG_TYPE_PROCESS_REQ, @from_node_info)
      message_xml = REXML::Document.new(message_xml.to_s)
      message_xml.elements[MessageXML::PATH_SENDER_ID].text = 'ErrorID'
      # クエリー生成
      node_id = 'node_id=' + @from_node_info.node_id
      msg_doc = @from_node_info.common_encrypt(message_xml.to_s)
      message = 'message=' + escape([msg_doc].pack('m'))
      query_array = [node_id, message]
      opts = {'REQUEST_METHOD'=>'POST', 'QUERY_STRING'=>query_array.join('&').to_s}
      # テスト実行
      env = Rack::MockRequest.env_for('/rack_test/test', opts)
      params = MsgReceiverRack::MessageParameters.new(env)
      # パラメータチェック
      print_log('log msg:' + params.log_message.to_s)
      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 401, "CASE:2-2-2")
      assert(params.err_message == 'Unauthorized', "CASE:2-2-3")
      assert(params.log_message == 'MsgReceiverRack Request Invalid node Error!!!', "CASE:2-2-4")
      assert(!params.message_xml.nil?, "CASE:2-2-5")
      assert(params.from_node_info.nil?, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-5")
    end
    # 異常ケース（メッセージアカウントエラー）
    print_log('CASE:2-02-06')
    begin
      # メッセージ生成
      message_xml = ProcessingXML.new(ProcessingXML::MSG_TYPE_PROCESS_REQ, @from_node_info)
      message_xml = REXML::Document.new(message_xml.to_s)
      message_xml.elements[MessageXML::PATH_SENDER_PW].text = 'ErrorPW'
      # クエリー生成
      node_id = 'node_id=' + @from_node_info.node_id
      msg_doc = @from_node_info.common_encrypt(message_xml.to_s)
      message = 'message=' + escape([msg_doc].pack('m'))
      query_array = [node_id, message]
      opts = {'REQUEST_METHOD'=>'POST', 'QUERY_STRING'=>query_array.join('&').to_s}
#      opts = create_opts('POST', ProcessingXML::MSG_TYPE_PROCESS_REQ, 'AccountError', false)
      env  = Rack::MockRequest.env_for('/rack_test/test', opts)
      params = MsgReceiverRack::MessageParameters.new(env)
      # パラメータチェック
#      print_log('log msg:' + params.log_message.to_s)
      assert(!params.request.nil?, "CASE:2-2-1")
      assert(params.status == 401, "CASE:2-2-2")
      assert(params.err_message == 'Unauthorized', "CASE:2-2-3")
      assert(params.log_message == 'MsgReceiverRack Request Invalid account Error!!!', "CASE:2-2-4")
      assert(!params.message_xml.nil?, "CASE:2-2-5")
      assert(!params.from_node_info.nil?, "CASE:2-2-6")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-6")
    end
  end

  # テスト対象メソッド：call
  test "CASE:2-03 call" do
    # 正常ケース（メッセージ送信リクエスト）
    print_log('CASE:2-03-01')
    begin
      # 処理初期化
      @process = TestProcess.new
      @manager[@process_id] = @process
      # パラメータ生成
      opts = create_opts('POST', ProcessingXML::MSG_TYPE_PROCESS_REQ, @from_node_id, @to_node_id, true)
      opts[:lint] = true
      # テスト実行
      app = MsgReceiverRack.new(Rails.logger)
      moc_req  = Rack::MockRequest.new(app)
      res = moc_req.post('/rack_test/test', opts)
      sleep(1)
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
      xml_doc = @from_node_info.common_decrypt(msg_str_enc)
      msg_xml = REXML::Document.new(xml_doc)
      # ヘッダー判定
      status = msg_xml.elements[ProcessingXML::PATH_STATUS].text
      msg_type = msg_xml.elements[ProcessingXML::PATH_TYPE].text
      assert(status == ProcessingXML::MSG_STATUS_OK, "CASE:2-3-4")
      assert(msg_type == ProcessingXML::MSG_TYPE_PROCESS_RES, "CASE:2-3-5")
      # アカウント判定
      send_id = msg_xml.elements[ProcessingXML::PATH_SENDER_ID].text
      send_pw = msg_xml.elements[ProcessingXML::PATH_SENDER_PW].text
      assert(send_id == @from_node_id, "CASE:2-3-6")
      assert(@from_node_info.valid_password?(send_pw), "CASE:2-3-7")
      # 処理判定
      assert(@process.execute_flg, "CASE:2-3-8")
      assert(ProcessingXML === @process.execute_xml, "CASE:2-3-9")
      assert(@process.execute_cnt == 1, "CASE:2-3-10")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:02-03-01")
    end
    # 異常ケース（メッセージエラー）
    print_log('CASE:2-03-02')
    begin
      # 処理初期化
      @process = TestProcess.new
      @manager[@process_id] = @process
      # パラメータ生成
      opts = create_opts('GET', ProcessingXML::MSG_TYPE_PROCESS_REQ, @from_node_id, @to_node_id, true)
      opts[:lint] = true
      # テスト実行
      app = MsgReceiverRack.new(Rails.logger)
      moc_req  = Rack::MockRequest.new(app)
      res = moc_req.post('/rack_test/test', opts)
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
      # 処理判定
      assert(!@process.execute_flg, "CASE:2-3-8")
      assert(@process.execute_xml.nil?, "CASE:2-3-9")
      assert(@process.execute_cnt == 0, "CASE:2-3-10")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:02-03-02")
    end
    # 異常ケース（共通鍵確認リクエスト：アカウントエラー）
    print_log('CASE:2-03-03')
    begin
      # 処理初期化
      @process = TestProcess.new
      @manager[@process_id] = @process
      # メッセージ生成
      message_xml = ProcessingXML.new(ProcessingXML::MSG_TYPE_PROCESS_REQ, @from_node_info)
      message_xml = REXML::Document.new(message_xml.to_s)
      message_xml.elements[MessageXML::PATH_SENDER_PW].text = 'ErrorPW'
      # クエリー生成
      node_id = 'node_id=' + @from_node_info.node_id
      msg_doc = @from_node_info.common_encrypt(message_xml.to_s)
      message = 'message=' + escape([msg_doc].pack('m'))
      query_array = [node_id, message]
      opts = {'REQUEST_METHOD'=>'POST', 'QUERY_STRING'=>query_array.join('&').to_s}
#      opts = create_opts('POST', ProcessingXML::MSG_TYPE_PROCESS_REQ, 'AccountError', true)
#      opts[:lint] = true
      # テスト実行
      app = MsgReceiverRack.new(Rails.logger)
      moc_req  = Rack::MockRequest.new(app)
      res = moc_req.post('/rack_test/test', opts)
      # レスポンスチェック
#      print_log('Response:' + res.class.name)
#      print_log('Response:' + res.content_type.to_s)
      print_log('Response Status:' + res.status.to_s)
#      print_log('Response Errors:' + res.errors.to_s)
#      print_log('Response Headders:' + res.headers.to_s)
#      print_log('Response Body:' + res.body)
      assert(!res.nil?, "CASE:2-3-1")
      assert(res.status == 401, "CASE:2-3-2")
      assert(res.content_type == 'text/plain', "CASE:2-3-3")
      assert(res.body == 'Unauthorized', "CASE:2-3-4")
      # 処理判定
      assert(!@process.execute_flg, "CASE:2-3-8")
      assert(@process.execute_xml.nil?, "CASE:2-3-9")
      assert(@process.execute_cnt == 0, "CASE:2-3-10")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:02-03-03")
    end
  end
  
  # リクエストパラメータ生成
  def create_opts(method, msg_type, from_node_id, to_node_id, encryption_flg=false)
    # パラメータ生成 
    query_array = create_query(msg_type, from_node_id, to_node_id, encryption_flg)
    opts = {'REQUEST_METHOD'=>method,'QUERY_STRING'=>query_array.join('&').to_s}
    return opts
  end
  
  # クエリーマップ生成
  def create_query(msg_type, from_node_id, to_node_id, encryption_flg=false)
    # 送信元ノードの詐称
    from_node_info = @node_info_cache[from_node_id]
    to_node_info = @node_info_cache[to_node_id]
#    from_node_info.instance_variable_set(:@node_id, 'LOCAL')
#    @node_info_cache.instance_variable_set(:@local_info, from_node_info)
    # メッセージ設定
    message_xml = nil
    if msg_type == ProcessingXML::MSG_TYPE_PROCESS_REQ ||
       msg_type == ProcessingXML::MSG_TYPE_PROCESS_RES then
      message_xml = ProcessingXML.new(msg_type, to_node_info)
      message_xml.process_id = @process_id
    else
      message_xml_str = ProcessingXML.new(ProcessingXML::MSG_TYPE_PROCESS_REQ, to_node_info).to_s
      message_xml = REXML::Document.new(message_xml_str)
      message_xml.elements[ProcessingXML::PATH_TYPE].text = msg_type
      message_xml.elements[ProcessingXML::PATH_PROCESS_ID].text = @process_id
    end
#    Rails.logger.debug('send message:' + message_xml.to_s)
    msg_doc = nil
    if encryption_flg then
      msg_doc = from_node_info.common_encrypt(message_xml.to_s)
    else
      msg_doc = message_xml.to_s
    end
    message = 'message=' + escape([msg_doc].pack('m'))
#    message = 'message=' + [msg_doc].pack('m')
#    Rails.logger.debug('message:' + message)
    # 送信元ノードを元に戻す
#    from_node_info.instance_variable_set(:@node_id, from_node_id)
#    @node_info_cache.instance_variable_set(:@local_info, @node_info_cache['LOCAL'])
    # ノードID
    node_id = 'node_id=' + from_node_info.node_id
    return [node_id, message]
  end
  
  def escape(value)
    return URI.escape(value.to_s, /[^a-zA-Z0-9\-\.\_\~]/)
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
      Rails.logger.debug('Process ID:' + message_xml.process_id)
#      Rails.logger.debug('Check:' + (proc_id == 'test_proc_id').to_s)
      return message_xml.process_id == 'TestProc'
    end
  end
end