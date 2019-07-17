# -*- coding: utf-8 -*-
###############################################################################
# RKVクライアントクラス（Remote Key Value Server）
# 概要：名前をキーとしたハッシュ形式のリモートオブジェクトから値を取得する機能を提供する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/07/02 Nakanohito
# 更新日:
###############################################################################
require 'drb/drb'
require 'singleton'
require 'thread'
require 'rkvi/rkv_server'
require 'rkvi/rkv_wrapper'
require 'biz_common/business_config'

module Rkvi
  # RKVクライアント
  class RkvClient
    include Singleton
    include BizCommon
    # アクセサー設定
    attr_accessor :svr_initializer
    attr_reader :rkv_hash
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # クライアント側サービス開始
      DRb.start_service
      # サービスURI
      @service_uri = BusinessConfig.instance['rkv_uri']
      @service_uri ||= 'druby://localhost:12345'
      # リモートサーバーオブジェクト
      @rkv_hash = generate_rkv_hash(@service_uri)
      # リモートサーバー初期化オブジェクト
      @svr_initializer = nil
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # オブジェクト参照
    def [](key)
      # クリティカルセクションの実行
      @mutex.synchronize do
        begin
          ret_value = @rkv_hash[key]
          return RkvWrapper.new(key, ret_value) if DRb::DRbObject === ret_value
          return ret_value
        rescue DRb::DRbConnError
          # 接続エラーの場合はサーバー生成
          @rkv_hash = generate_rkv_hash(@service_uri)
          svr_init(@rkv_hash)
          retry
        end
      end
    end
    
    # オブジェクト設定
    def []=(key, value)
      # クリティカルセクションの実行
      @mutex.synchronize do
        begin
          @rkv_hash[key] = value.wrap_obj if RkvWrapper === value
          @rkv_hash[key] = value
        rescue DRb::DRbConnError
          # 接続エラーの場合はサーバー生成
          @rkv_hash = generate_rkv_hash(@service_uri)
          svr_init(@rkv_hash)
          retry
        end
      end
    end
    
    # サービス提供インスタンス判定
    def service_provider?
      # クリティカルセクションの実行
      @mutex.synchronize do
        return RkvServer === @rkv_hash
      end
    end
    
    # 接続のリフレッシュ
    def refresh
      # クリティカルセクションの実行
      @mutex.synchronize do
        # リモート接続している場合
        @rkv_hash = generate_rkv_hash(@service_uri) unless @rkv_hash.boot_server?
        svr_init(@rkv_hash)
      end
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # ハッシュ生成
    def generate_rkv_hash(service_uri)
      server_obj = nil
      # リモートオブジェクト取得
      boot_time = nil
      begin
        server_obj = DRbObject.new_with_uri(service_uri)
        boot_time = server_obj[:boot_time]
        Rails.logger.debug('RKV Remote connection is complete')
      rescue DRb::DRbConnError
        server_obj = RkvServer.new(service_uri, Rails.logger)
        Rails.logger.debug('RKV Server Boot:' + server_obj.boot_server?.to_s)
        boot_time = server_obj[:boot_time]
      end
      Rails.logger.debug('RKV Server startup time:' + boot_time.to_s)
      # サーバーを起動
      return server_obj
    end
    
    # サーバー初期化処理
    def svr_init(server_obj)
      return unless RkvServer === server_obj
      return if @svr_initializer.nil?
      @svr_initializer.init_server(server_obj)
    end
  end
end