# -*- coding: utf-8 -*-
###############################################################################
# メッセージリクエスト受信クラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/07 Nakanohito
# 更新日:
###############################################################################
require 'rubygems'
require 'messaging/connection_node_info_cache'
require 'messaging/msg_process_manager'
require 'messaging/processing_xml'
require 'messaging/receiver_rack'
require 'messaging/request_parameters'

module Messaging
  class MsgReceiverRack < ReceiverRack
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize(logger)
      super(logger)
      # メッセージ処理マネージャー
      @process_manager = Messaging::MsgProcessManager.instance
      @process_manager.logger = @logger
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # 受信処理
    def call(env)
      # リクエストパラメータ生成
      params = MessageParameters.new(env)
      if params.status != 200 then
        warn_log(params.request, params.log_message)
        return [params.status, {'Content-Type'=>'text/plain'}, [params.err_message]]
      end
      # 処理キューに受信XML投入
      @process_manager.processing_request(params.message_xml)
      # 返信メッセージ生成
      return response(params, ProcessingXML.new(MSG_TYPE_PROCESS_RES, params.from_node_info))
    rescue StandardError => ex
      exception_log(ex)
      return [400, {'Content-Type'=>'text/plain'}, ['Bad Request']]
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # レスポンス生成処理
    def response(params, resp_message_xml)
      enc_value = params.from_node_info.common_encrypt(resp_message_xml.to_s)
      res = Rack::Response.new
      res['Content-Type'] = 'text/html'
      res.write('<html><head><title>Response Message</title></head><body>')
      res.write('<input type="hidden" id="message" value="')
      res.write([enc_value].pack('m'))
      res.write('">')
      res.write('</body></html>')
      return res.finish
    end
    
    # メッセージリクエストパラメータクラス
    class MessageParameters < RequestParameters
      # アクセサー定義
      attr_reader :from_node_info
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(env)
        super(env)
        # 送信元ノード情報
        @from_node_info = nil
        # リクエストチェック処理
        check_request
      end
      #########################################################################
      # protected定義
      #########################################################################
      protected
      def check_request
        # リクエストメソッドチェック
        unless @request.post? then
          # 警告メッセージ表示
          @status = 405
          @err_message = 'Method Not Allowed'
          @log_message = 'MsgReceiverRack Request Method Error!!!'
          return
        end
        # メッセージ存在チェック
        msg_str = decode_message(DECRYPTION_COMMON)
        if msg_str.nil? then
          @status = 400
          @err_message = 'Bad Request'
          @log_message = 'MsgReceiverRack Request Message Error!!!'
          return
        end
        # メッセージタイプチェック
        @message_xml = ProcessingXML.new(msg_str)
        if @message_xml.msg_type != ProcessingXML::MSG_TYPE_PROCESS_REQ then
          # 警告メッセージ表示
          @status = 400
          @err_message = 'Bad Request'
          @log_message = 'MsgReceiverRack Request Message type Error!!!'
          return
        end
        # 送信ノードチェック
        @from_node_info = @node_info_cache[@message_xml.sender_id]
        if @from_node_info.nil? then
          # 警告メッセージ表示
          @status = 401
          @err_message = 'Unauthorized'
          @log_message = 'MsgReceiverRack Request Invalid node Error!!!'
          return
        end
        # メッセージアカウントチェック
        unless @from_node_info.valid_password?(@message_xml.sender_pw) then
          # 警告メッセージ表示
          @status = 401
          @err_message = 'Unauthorized'
          @log_message = 'MsgReceiverRack Request Invalid account Error!!!'
          return
        end
      end
    end
  end
end
