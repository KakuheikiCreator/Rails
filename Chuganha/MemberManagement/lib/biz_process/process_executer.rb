# -*- coding: utf-8 -*-
###############################################################################
# 業務処理実行クラス
# 機能：登録された処理をバックグラウンドスレッドで実行する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/08 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'
require 'biz_common/biz_logger'
require 'biz_process/business_process'

module BizProcess
  # 業務処理実行クラス
  class ProcessExecuter
    include Singleton
    include BizCommon
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # ロガー
      @logger = BizLogger.new('biz_process.log')
      # 処理メッセージスレッド生成
      @messgae_queue  = Queue.new
      @process_thread = create_process_thread
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # 処理エントリ
    def entry_process?(process)
      return false unless BusinessProcess === process
      # クリティカルセクションの実行
      @mutex.synchronize do
        @process_thread = create_process_thread unless @process_thread.alive?
        # ロガー設定
        process.logger = @logger
        # 処理キューにメッセージXML投入
        @messgae_queue.push(process)
      end
      return true
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # 処理スレッド生成
    def create_process_thread
      return Thread.start do
        # パラメータ取得
        process = @messgae_queue.pop
        # 処理実行ループ
        until process.nil? do
          begin
            process.execution
          rescue StandardError=>ex
            @logger.error("Process Error:" + process.process_name)
            @logger.error("Exception    :" + ex.class.name)
            @logger.error("Message      :" + ex.message)
            @logger.error("Backtrace    :" + ex.backtrace.join("\n"))
          end
          # プロセス取得
          process = @messgae_queue.pop
        end
      end
    end
  end
end