# -*- coding: utf-8 -*-
###############################################################################
# メッセージ送信クラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/03 Nakanohito
# 更新日:
###############################################################################
require 'drb/drb'
require 'singleton'
require 'httpclient'
require 'nokogiri'
require 'messaging/connection_node_info_cache'
require 'messaging/msg_process_manager'
require 'messaging/key_sharing_xml'
require 'messaging/processing_xml'

module Messaging
  # メッセージ送信クラス
  class MessageSender
    include Singleton
    include DRbUndumped
    # アクセサー設定
    attr_writer :logger
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # Logger
      @logger = nil
      # ノード情報
      @node_info_cache = Messaging::ConnectionNodeInfoCache.instance
      @local_node_info = @node_info_cache.local_info
      # HTTPアクセスクライアント
      @client = HTTPClient.new
      # 送信スレッド生成
      @sender_queue  = Queue.new
      @sender_thread = create_sender_thread
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # 処理依頼メッセージ送信
    def processing_request?(to_node_id, process_id)
      info_log('Send Processing Message', to_node_id, process_id)
      # クリティカルセクションの実行
      @mutex.synchronize do
        params = SendParameters.new(to_node_id, process_id)
        unless params.valid? then
          warn_log('Parameter error ', to_node_id, process_id)
          return false
        end
        @sender_thread = create_sender_thread unless @sender_thread.alive?
        @sender_queue.push(params)
      end
      return true
    rescue StandardError => ex
      exception_log(ex)
      return false
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # 送信スレッド生成
    def create_sender_thread
      return Thread.start do
        params = @sender_queue.pop
        until params.nil? do
          # メッセージ送信処理
          unless send_message?(params) then
            # 再試行判定
            if params.retry? then
              @sender_queue.push(params)
            else
              warn_log(params.error_msg, params.to_node_info.node_id, params.process_id)
            end
          end
          params = @sender_queue.pop
        end
      end
    end
    
    # メッセージ送信
    def send_message?(params)
      # 共通鍵の有効期限判定
      to_node_info = params.to_node_info
      unless to_node_info.valid_common_key? then
        unless key_sharing?(params) then
          # 暗号鍵情報初期化
          params.to_node_info.init_key
          return false
        end
      end
      # メッセージの送信
      return submit?(params)
    end
    
    # キー共有処理
    def key_sharing?(params)
      # 公開鍵共有
      return false unless public_key_exchange?(params)
      # 共通鍵共有
      return common_key_share?(params)
    end
    
    # 公開鍵交換
    def public_key_exchange?(params)
      begin
        # 宛先ノード情報
        to_node_info = params.to_node_info
        # 公開鍵交換リクエストパラメータ生成
        send_xml = KeySharingXML.new(KeySharingXML::MSG_TYPE_EXCHANGE_REQ, to_node_info)
        post_data = {'message_type'=>KeySharingXML::MSG_TYPE_EXCHANGE_REQ,
                     'message'=>[send_xml.to_s].pack('m')}
        # 公開鍵交換リクエスト
        resp = @client.post(to_node_info.key_sharing_url, post_data)
        # レスポンス解析
        if resp.status != 200 then
          params.error_msg = 'Public key exchange error Response status:' + resp.status.to_s
          return false
        end
        # メッセージ復号化
        resp_xml = private_dec(resp.body)
        # メッセージステータスチェック
        if resp_xml.status != KeySharingXML::MSG_STATUS_OK then
          params.error_msg = 'Public key exchange error Message status:' + resp_xml.status.to_s
          return false
        end
        # メッセージタイプチェック
        if resp_xml.msg_type != KeySharingXML::MSG_TYPE_EXCHANGE_RES then
          params.error_msg = 'Public key exchange error Message type:' + resp_xml.msg_type.to_s
          return false
        end
        # 公開鍵設定
        to_node_info.public_key = resp_xml.public_key
        return true
      rescue StandardError => ex
        params.error_msg = 'Public key exchange error'
        exception_log(ex)
        return false
      end
    end
    
    # 共通鍵共有
    def common_key_share?(params)
      begin
        # 宛先ノード情報
        to_node_info = params.to_node_info
        # 共通鍵確認リクエストパラメータ生成
        send_xml = KeySharingXML.new(KeySharingXML::MSG_TYPE_CONFIRMATION_REQ, to_node_info)
        send_msg = to_node_info.public_encrypt(send_xml.to_s)
        post_data = {'message_type'=>KeySharingXML::MSG_TYPE_CONFIRMATION_REQ,
                     'message'=>[send_msg].pack('m')}
        # 共通鍵確認リクエスト
        resp = @client.post(to_node_info.key_sharing_url, post_data)
        # レスポンス解析
        if resp.status != 200 then
          params.error_msg = 'Common key exchange error Response status:' + resp.status.to_s
          return false
        end
        # メッセージ復号化
        resp_xml = private_dec(resp.body)
        # メッセージステータスチェック
        if resp_xml.status != KeySharingXML::MSG_STATUS_OK then
          params.error_msg = 'Common key exchange error Message status:' + resp_xml.status.to_s
          return false
        end
        # メッセージタイプチェック
        if resp_xml.msg_type != KeySharingXML::MSG_TYPE_CONFIRMATION_RES then
          params.error_msg = 'Common key exchange error Message type:' + resp_xml.msg_type.to_s
          return false
        end
        # ノードアカウントチェック
        if resp_xml.sender_id != to_node_info.node_id then
          params.error_msg = 'Common key exchange error ID:' + resp_xml.sender_id.to_s
          return false
        end
        unless to_node_info.valid_password?(resp_xml.sender_pw) then
          params.error_msg = 'Common key exchange error PW:' + resp_xml.sender_pw.to_s
          return false
        end
        # 共通鍵有効期限設定
        to_node_info.common_key_expiration = resp_xml.expiration
        return true
      rescue StandardError => ex
        params.error_msg = 'Common key exchange error'
        exception_log(ex)
        return false
      end
    end
    
    # メッセージ送信
    def submit?(params)
      begin
        # 宛先ノード情報
        to_node_info = params.to_node_info
        # 処理依頼リクエストメッセージ生成
        send_xml = ProcessingXML.new(ProcessingXML::MSG_TYPE_PROCESS_REQ, to_node_info)
        send_xml.process_id = params.process_id
        send_msg = to_node_info.common_encrypt(send_xml.to_s)
        # ポストデータ編集
        post_data = {'node_id'=>to_node_info.send_id.to_s,
                     'message'=>[send_msg].pack('m')}
        # メッセージ送信リクエスト
        resp = @client.post(to_node_info.destination_url, post_data)
        # レスポンス解析
        if resp.status != 200 then
          # 暗号鍵情報初期化
          params.to_node_info.init_key if resp.status == 400
          params.error_msg = 'Message sending error Response status:' + resp.status.to_s
          return false
        end
        # メッセージ復号化
        resp_xml = ProcessingXML.new(to_node_info.common_decrypt(message_ext(resp.body)))
        # メッセージステータスチェック
        if resp_xml.status != ProcessingXML::MSG_STATUS_OK then
          params.error_msg = 'Message sending error Message status:' + resp_xml.status.to_s
          return false
        end
        # メッセージタイプチェック
        if resp_xml.msg_type != ProcessingXML::MSG_TYPE_PROCESS_RES then
          params.error_msg = 'Message sending error Message type:' + resp_xml.msg_type.to_s
          return false
        end
        # ノードアカウントチェック
        if resp_xml.sender_id != to_node_info.node_id then
          params.error_msg = 'Message sending error ID:' + resp_xml.sender_id.to_s
          return false
        end
        unless to_node_info.valid_password?(resp_xml.sender_pw) then
          params.error_msg = 'Message sending error PW:' + resp_xml.sender_pw.to_s
          return false
        end
        return true
      rescue StandardError => ex
        params.to_node_info.init_key
        params.error_msg = 'Message sending error'
        exception_log(ex)
        return false
      end
    end
    
    # メッセージ復号処理（秘密鍵）
    def private_dec(html_str)
      msg_str = @local_node_info.private_decrypt(message_ext(html_str))
      return KeySharingXML.new(msg_str)
    end
    
    # メッセージ抽出処理
    def message_ext(html_str)
      html_doc = Nokogiri::HTML(html_str)
      msg_str_64 = html_doc.at_css('#message').get_attribute('value')
      return msg_str_64.unpack('m')[0]
    end
    
    # 情報メッセージ出力
    def info_log(message, to_node_id, process_id=nil)
      return if @logger.nil?
      footer_msg = (' (' + to_node_id.to_s + ':)').to_s if process_id.nil? 
      footer_msg ||= (' (' + to_node_id.to_s + ':' + process_id.to_s + ')').to_s 
      @logger.info('MessageSender ' + message + footer_msg)
    end
    
    # 警告メッセージ出力
    def warn_log(message, to_node_id, process_id=nil)
      return if @logger.nil?
      footer_msg = (' (' + to_node_id.to_s + ':)').to_s if process_id.nil? 
      footer_msg ||= (' (' + to_node_id.to_s + ':' + process_id.to_s + ')').to_s 
      @logger.warn('MessageSender ' + message + footer_msg)
    end
    
    # 例外ログ
    def exception_log(ex)
      return if @logger.nil?
      @logger.debug("Exception:" + ex.class.name)
      @logger.debug("Message  :" + ex.message)
      @logger.debug("Backtrace:" + ex.backtrace.join("\n"))
    end
    
    # 送信パラメータクラス
    class SendParameters
      # 再試行回数
      MAX_RETRY_COUNT = 3
      # アクセサー定義
      attr_reader :to_node_id, :to_node_info, :process_id
      attr_accessor :error_msg
      #########################################################################
      # 初期化メソッド
      #########################################################################
      def initialize(to_node_id, process_id)
        # 接続ノード情報設定
        node_info_cache = Messaging::ConnectionNodeInfoCache.instance
        @to_node_id = to_node_id
        @to_node_info = node_info_cache[@to_node_id]
        # 処理ID
        @process_id = process_id
        # 再試行回数
        @retry_count = 0
        # エラーメッセージ
        @error_msg = nil
      end
      #########################################################################
      # public定義
      #########################################################################
      public
      # 有効なパラメータか判定
      def valid?
        process_manager = Messaging::MsgProcessManager.instance
        return !@to_node_info.nil? && !process_manager[@process_id].nil?
      end
      # 有効な回数か判定
      def retry?
        @retry_count+= 1
        return @retry_count < MAX_RETRY_COUNT
      end
    end
  end
end
