# -*- coding: utf-8 -*-
###############################################################################
# キー共有リクエスト受信クラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/07 Nakanohito
# 更新日:
###############################################################################
require 'rubygems'
require 'messaging/key_sharing_xml'
require 'messaging/receiver_rack'
require 'messaging/request_parameters'

module Messaging
  class KeySharingRack < ReceiverRack
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize(logger)
      super(logger)
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # 受信処理
    def call(env)
      # リクエストパラメータ生成
      params = KeySharingParameters.new(env)
      if params.status != 200 then
        warn_log(params.request, params.log_message)
        return [params.status, {'Content-Type'=>'text/plain'}, [params.err_message]]
      end
      #　メッセージタイプ判定
      msg_xml = params.message_xml
      node_info = params.from_node_info
      resp_message_xml = nil
      if params.message_type == MSG_TYPE_EXCHANGE_REQ then
        # 公開鍵交換処理
        node_info.public_key = msg_xml.public_key
        resp_message_xml = KeySharingXML.new(MSG_TYPE_EXCHANGE_RES, node_info)
      else
        # 共通鍵共有処理
        node_info.common_key = msg_xml.common_key
        resp_message_xml = KeySharingXML.new(MSG_TYPE_CONFIRMATION_RES, node_info)
      end
      # 返信メッセージ生成
      return response(node_info, resp_message_xml)
    rescue StandardError => ex
      exception_log(ex)
      return [400, {'Content-Type'=>'text/plain'}, ['Bad Request']]
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # レスポンス生成処理
    def response(node_info, resp_message_xml)
      enc_value = node_info.public_encrypt(resp_message_xml.to_s)
      res = Rack::Response.new
      res['Content-Type'] = 'text/html'
      res.write('<html><head><title>Response Message</title></head><body>')
      res.write('<input type="hidden" id="message" value="')
      res.write([enc_value].pack('m'))
      res.write('">')
      res.write('</body></html>')
      return res.finish
    end
    
    # リクエストパラメータクラス
    class KeySharingParameters < RequestParameters
      # アクセサー定義
      attr_reader :message_type, :from_node_info
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(env)
        super(env)
        # メッセージタイプ
        @message_type = nil
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
          @log_message = 'KeySharingRack Request Method Error!!!'
          return
        end
        # メッセージ存在チェック
        msg_str = nil
        @message_type = @request.params['message_type']
        if @message_type == KeySharingXML::MSG_TYPE_EXCHANGE_REQ then
          msg_str = decode_message(DECRYPTION_DEFAULT)
        elsif @message_type == KeySharingXML::MSG_TYPE_CONFIRMATION_REQ then
          msg_str = decode_message(DECRYPTION_PRIVATE)
        end
        if msg_str.nil? then
          @status = 400
          @err_message = 'Bad Request'
          @log_message = 'KeySharingRack Request Message Error!!!'
          return
        end
        @message_xml = KeySharingXML.new(msg_str)
        # メッセージタイプチェック
        if @message_type != @message_xml.msg_type then
          # 警告メッセージ表示
          @status = 400
          @err_message = 'Bad Request'
          @log_message = 'KeySharingRack Request Message type Error!!!'
          return
        end
        # 送信ノードチェック
        @from_node_info = @message_xml.from_node_info
        if @from_node_info.nil? then
          # 警告メッセージ表示
          @status = 401
          @err_message = 'Unauthorized'
          @log_message = 'KeySharingRack Request Invalid node Error!!!'
          return
        end
        # メッセージアカウントチェック
        if @message_type == KeySharingXML::MSG_TYPE_CONFIRMATION_REQ &&
           !@from_node_info.valid_password?(@message_xml.sender_pw) then
          # 警告メッセージ表示
          @status = 401
          @err_message = 'Unauthorized'
          @log_message = 'KeySharingRack Request Invalid account Error!!!'
          return
        end
      end
    end
  end
end
