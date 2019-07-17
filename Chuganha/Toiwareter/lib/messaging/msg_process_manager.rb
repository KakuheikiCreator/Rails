# -*- coding: utf-8 -*-
###############################################################################
# メッセージ処理マネージャークラス
# 機能：受信したメッセージに対応した処理を実行するマネージャークラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/04/11 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'
require 'messaging/processing_xml'

module Messaging
  # メッセージ処理マネージャークラス
  class MsgProcessManager
    include Singleton
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # ロガー
      @logger = nil
      # 処理オブジェクトハッシュ
      @process_hash = Hash.new
      # 処理メッセージスレッド生成
      @messgae_queue  = Queue.new
      @process_thread = create_process_thread
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # ロガー設定
    def logger=(logger)
      # クリティカルセクションの実行
      @mutex.synchronize do
        @logger = logger
      end
    end
    
    # 処理オブジェクト参照
    def [](proc_id)
      # クリティカルセクションの実行
      @mutex.synchronize do
        return @process_hash[proc_id]
      end
    end
    
    # 処理オブジェクト設定
    def []=(proc_id, obj)
      # クリティカルセクションの実行
      @mutex.synchronize do
        @process_hash[proc_id] = obj
      end
    end
    
    # メッセージ処理依頼
    def processing_request(message_xml)
      # クリティカルセクションの実行
      @mutex.synchronize do
        @process_thread = create_process_thread unless @process_thread.alive?
        # 処理キューにメッセージXML投入
        @messgae_queue.push(Parameter.new(message_xml))
      end
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # 処理スレッド生成
    def create_process_thread
      return Thread.start do
        # パラメータ取得
        param = @messgae_queue.pop
        until param.nil? do
          # メッセージ処理
          unless msg_processing?(param.message_xml) then
            warn_log(param.message_xml)
            # リトライ処理
            if param.retry? then
              @mutex.synchronize do @messgae_queue.push(param) end
            end
          end
          # パラメータ取得
          param = @messgae_queue.pop
        end
      end
    end
    
    # メッセージ処理
    def msg_processing?(message_xml)
      return @process_hash[message_xml.process_id].execute?(message_xml)
    rescue StandardError => ex
      return false if @logger.nil?
      @logger.debug("Exception:" + ex.class.name)
      @logger.debug("Message  :" + ex.message)
      @logger.debug("Backtrace:" + ex.backtrace.join("\n"))
      return false
    end
    
    # 警告メッセージ表示
    def warn_log(message_xml)
      return if @logger.nil?
      # メッセージログ出力
      @logger.warn('ProcessManager Message processing failure. SENDER:' + message_xml.sender_id.to_s)
    rescue StandardError => ex
      # メッセージログ出力
      @logger.warn('ProcessManager Message processing failure. SENDER:Unknown')
    end
    
    # 処理パラメータクラス
    class Parameter
      # 最大リトライ回数
      MAX_RETRY_COUNT = 3
      # アクセサー定義
      attr_reader :message_xml
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(message_xml)
        # 処理メッセージ
        @message_xml = message_xml
        # 処理回数
        @retry_cnt = 0
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # リトライ判定
      def retry?
        @retry_cnt += 1
        return @retry_cnt <= MAX_RETRY_COUNT
      end
    end
  end
end