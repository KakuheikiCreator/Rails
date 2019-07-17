# -*- coding: utf-8 -*-
###############################################################################
# 規制ホスト情報キャッシュクラス
# 機能：規制ホスト情報のキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'
require 'monitor'
require 'common/validation_chk_module'
require 'data_cache/system_cache'

module DataCache
  # 規制ホスト情報キャッシュクラス
  class RegulationHostCache
    include Singleton
    include Common::ValidationChkModule
    # アクセサー
    attr_reader :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @monitor = Monitor.new
      # 自システム取得
      @system = nil
      # 規制ホスト情報リスト
      @host_list = nil
      # キャッシュデータロード日時
      @loaded_at = nil
      # データをメモリに展開
      data_load
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # データロード処理
    def data_load
      loaded_at = Time.now
      new_system = SystemCache.instance.get_system
      new_host_list = new_system.regulation_host(true)
      new_host_list.each do |ent|
        if !valid_pattern?(ent.remote_host) || !valid_pattern?(ent.proxy_host) then
          raise 'RegulationHostCache Data Load Error RemoteHost:' +
                ent.remote_host.to_s + ' ProxyHost:' + ent.proxy_host.to_s
        end
      end
      # クリティカルセクションの実行
      @monitor.synchronize do
        @loaded_at = loaded_at
        @system = new_system
        @host_list = new_host_list
      end
    end
    
    # 規制対象チェック
    def regulation?(client_host, client_ip, proxy_host, proxy_ip)
      # クリティカルセクションの実行
      @monitor.synchronize do
        @host_list.each do |info|
          return true if match?(info.remote_host, client_host) && info.ip_address == client_ip &&
                         match?(info.proxy_host, proxy_host) && info.proxy_ip_address == proxy_ip
        end
        return false
      end
    end
    
    # キャッシュデータ追加
    def entry_data?(target_data)
      return false unless RegulationHost === target_data
      remote_host = target_data.remote_host
      ip_address  = target_data.ip_address
      proxy_host  = target_data.proxy_host
      proxy_ip_address = target_data.proxy_ip_address
      # クリティカルセクションの実行
      @monitor.synchronize do
        return false if regulation?(remote_host, ip_address, proxy_host, proxy_ip_address)
        @host_list.push(target_data)
      end
      return true
    end
    
    # キャッシュデータ削除
    def erase_data?(target_data)
      return false unless RegulationHost === target_data
      remote_host = target_data.remote_host
      ip_address  = target_data.ip_address
      proxy_host  = target_data.proxy_host
      proxy_ip_address = target_data.proxy_ip_address
      # クリティカルセクションの実行
      @monitor.synchronize do
        del_pos = 0
        @host_list.each do |ent|
          break if ent.remote_host == remote_host &&
                   ent.ip_address == ip_address &&
                   ent.proxy_host == proxy_host &&
                   ent.proxy_ip_address == proxy_ip_address
          del_pos += 1
        end
        return false if @host_list.size == del_pos
        @host_list.delete_at(del_pos)
      end
      return true
    end
    
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # 正規表現チェック（NULL有効）
    def valid_pattern?(pattern)
      return true if pattern.nil? 
      return regexp?(pattern)
    end
    
    # 比較（正規表現対応）
    def match?(reg_value, chk_value)
      return chk_value.nil? if reg_value.nil?
      return false if chk_value.nil?
      return !(Regexp.new(reg_value) =~ chk_value).nil?
    end
  end
end