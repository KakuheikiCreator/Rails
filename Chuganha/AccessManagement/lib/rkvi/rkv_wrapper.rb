# -*- coding: utf-8 -*-
###############################################################################
# RKVラッパークラス（Remote Key Value Server）
# 概要：リモートオブジェクトをラッピングし、接続エラー等のハンドリングを行う。
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/07/09 Nakanohito
# 更新日:
###############################################################################
require 'drb/drb'
require 'thread'
require 'rkvi/rkv_client'

module Rkvi
  # RKVラッパー
  class RkvWrapper
    # アクセサー設定
    attr_reader :wrap_obj
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize(rkv_key, wrap_obj)
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # リモートオブジェクトのキー
      @rkv_key = rkv_key
      # ラッピング対象
      @wrap_obj = wrap_obj
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # 定義していないメソッド呼び出しがされた場合
    def method_missing(name, *args, &block)
      begin
        return wrap_method_call(name, *args, &block)
      rescue DRb::DRbConnError=>ex
        # 接続エラーの場合はサーバー再接続
        rkv_client = RkvClient.instance
        rkv_client.refresh
        # クリティカルセクションの実行
        @mutex.synchronize do
          @wrap_obj = rkv_client[@rkv_key]
        end
        retry
      end
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # メソッド呼び出し
    def wrap_method_call(name, *args, &block)
      return @wrap_obj.__send__(name, *args) if block.nil?
      return @wrap_obj.__send__(name, *args, block)
    end
  end
end
