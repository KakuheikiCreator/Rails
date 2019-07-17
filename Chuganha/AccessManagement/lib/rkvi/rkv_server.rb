# -*- coding: utf-8 -*-
###############################################################################
# RKVサーバークラス（Remote Key Value Server）
# 概要：名前をキーとしたハッシュ形式でインスタンスを保持し、リモートオブジェクトのサーバーとして
#　　　　　共有されるハッシュデータとしてのサービスを提供する 
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/07/02 Nakanohito
# 更新日:
###############################################################################
require 'drb/drb'

module Rkvi
  # RKVサーバー
  class RkvServer
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize(uri, logger=nil)
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # Logger
      @logger = logger
      # 値ハッシュ
      @value_hash = Hash.new
      # サービスURI
      @server_uri = uri
      # サービススレッド
      @server_thread = nil
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # オブジェクト参照
    def [](key)
      # クリティカルセクションの実行
      @mutex.synchronize do
        log_warn(self.class.name + ' Key is null') if key.nil?
        return @value_hash[key]
      end
    end
    
    # オブジェクト設定
    def []=(key, value)
      # クリティカルセクションの実行
      @mutex.synchronize do
        log_warn(self.class.name + ' Key is null') if key.nil?
        @value_hash[key] = value
      end
    end
    
    # サーバー起動
    def boot_server?
      # クリティカルセクションの実行
      @mutex.synchronize do
        return true if !@server_thread.nil? && @server_thread.alive?
        # バックグラウンドでサーバースレッドを起動する 
        notify_que = Queue.new
        @server_thread = Thread.start do
          begin
            DRb.start_service(@server_uri, self)
            @value_hash[:boot_time] = Time.new
            notify_que.push(true)
            # サーバースレッドが停止しないようにする
            DRb.thread.join
          rescue
            notify_que.push(false)
          end
        end
        # サービス起動待ち
        return notify_que.pop
      end
    end
      
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # ログ出力（info）
    def log_info(message)
      @logger.info(message) unless @logger.nil?
    end
    
    # ログ出力（warn）
    def log_warn(message)
      @logger.warn(message) unless @logger.nil?
    end
  end
end