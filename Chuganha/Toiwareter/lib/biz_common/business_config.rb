# -*- coding: utf-8 -*-
###############################################################################
# 業務設定情報クラス
# 概要：業務的な設定情報を保持するクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/02/05 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'
require 'yaml'

module BizCommon
  class BusinessConfig
    include Singleton
    # アクセサー
    attr_reader :system_name, :subsystem_name, :root_path,
                :max_request_frequency, :max_function_state_hash_size
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # アカウント情報ロードパス
      @load_path = Rails.root.join('config', 'business', 'business_config.yml').to_s
      # アカウント情報データ
      @config_infos = nil
      # 設定情報
      @system_name = nil
      @subsystem_name = nil
      @root_path = nil
      @max_request_frequency = nil
      @max_function_state_hash_size = nil
      # データをメモリに展開
      data_load
    end
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # データロード処理
    def data_load
      # Config Load
      @mutex.synchronize do
        @config_infos   = YAML.load_file(@load_path)
        @system_name    = param('system_name')
        @subsystem_name = param('subsystem_name')
        @root_path      = param('root_path')
        @root_path      ||= ""
        @max_request_frequency = int_param('max_request_frequency')
        @max_function_state_hash_size = int_param('max_function_state_hash_size')
      end
    end
    
    # メンバーアクセス
    def [](key)
      return @config_infos[key.to_s]
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # パラメータ取得
    def param(path)
      current = @config_infos
      path.split(".").each do |elm|
        current = current[elm]
        return nil if current.nil?
      end
      return current
    end
    
    # 整数パラメータ取得
    def int_param(path)
      value = param(path)
      return nil if value.nil?
      return value.to_i
    end
  end
end