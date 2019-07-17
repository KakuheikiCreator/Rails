# -*- coding: utf-8 -*-
###############################################################################
# Rack用ネットワークユーティリティモジュール
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/08 Nakanohito
# 更新日:
###############################################################################
require 'rubygems'
require 'resolv'
require 'socket'

module Messaging
  # メッセージネットワークユーティリティモジュール
  module RackNetUtilModule
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    ###########################################################################
    # 定数定義
    ###########################################################################
    # IPアドレス（10進表現）
    REG_IP_DECIMAL      =
      /((1\d{2}|2[0-4]\d|25[0-5]|[1-9]?\d)\.){3}(1\d{2}|2[0-4]\d|25[0-5]|[1-9]?\d)/
    # IPアドレス（16進表現）
    REG_IP_HEXADECIMAL1 = /([a-fA-F0-9]{1,2}\.){3}[a-fA-F0-9]{1,2}/
    # IPアドレス（16進表現ピリオド無し）
    REG_IP_HEXADECIMAL2 = /(0x|[^a-zA-Z0-9])?[a-fA-F0-9]{8}/
    # IPアドレス（16進表現ピリオド無し）
    REG_IP_HEXADECIMAL3 = /[a-fA-F0-9]{8}/
    
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # IPの抽出（試行順序：通常表記→16進数表現）
    def ambiguous_ex_ip(str)
      return nil unless String === str
      # IPの記述判定（通常の記述）
      ip_address = extract_ip(str)
      return ip_address unless ip_address.nil?
      # IPの記述判定（16進表現）
      return extract_ip_0x(str)
    end
    
    # ホスト情報抽出
    def extract_host(request)
      # プロキシ使用
      return ex_proxy_client(request) + ex_remote_host(request) if use_proxy?(request)
      # プロキシ不使用
      return ex_remote_host(request)
    end
    
    # IPの抽出
    def extract_ip(str)
      return nil unless String === str
      # IPの記述判定（通常の記述）
      return str[REG_IP_DECIMAL]
    end
    
    # IPの抽出（16進表現）
    def extract_ip_0x(str)
      return nil unless String === str
      # IPの記述判定（16進表現）
      ip_address = str[REG_IP_HEXADECIMAL1]
      unless ip_address.nil? then
        ip_pieces = ip_address.split(/\./)
        ip_address = to_decimal(ip_pieces[0]).to_s + '.' +
                     to_decimal(ip_pieces[1]).to_s + '.' +
                     to_decimal(ip_pieces[2]).to_s + '.' +
                     to_decimal(ip_pieces[3]).to_s
        return ip_address
      end
      # IPの記述判定（16進表現ピリオド無し）
      ip_address = str[REG_IP_HEXADECIMAL2]
      unless ip_address.nil? then
        # 16進数表現部分だけ抽出
        wk_ip_address = ip_address[REG_IP_HEXADECIMAL3]
        ip_pieces = wk_ip_address.chars.to_a
        ip_address = to_decimal(ip_pieces[0,2].join).to_s + '.' +
                     to_decimal(ip_pieces[2,2].join).to_s + '.' +
                     to_decimal(ip_pieces[4,2].join).to_s + '.' +
                     to_decimal(ip_pieces[6,2].join).to_s
        return ip_address
      end
      # IPの記述無し
      return nil
    end
    
    # リモートホスト情報抽出
    def ex_remote_host(request)
      return nil if request.nil?
      return [request.env['REMOTE_HOST'], request.env['REMOTE_ADDR']]
    rescue StandardError => ex
      return nil
    end
    
    # プロキシ使用時のクライアントホスト情報抽出
    def ex_proxy_client(request)
      return nil if request.nil?
      # クライアントホスト
      client_host = request.env['HTTP_SP_HOST']
      # クライアントIP
      client_ip =   ambiguous_ex_ip(request.env['HTTP_CLIENT_IP'])
      client_ip ||= ambiguous_ex_ip(request.env['HTTP_CLIENTIP'])
      client_ip ||= ambiguous_ex_ip(request.env['HTTP_FORWARDED'])
      client_ip ||= ambiguous_ex_ip(request.env['HTTP_FROM'])
      client_ip ||= ambiguous_ex_ip(request.env['HTTP_VIA'])
      client_ip ||= ambiguous_ex_ip(request.env['HTTP_X_FORWARDED_FOR'])
      client_ip ||= ambiguous_ex_ip(request.env['HTTP_X_LOCKING'])
      # クライアント情報逆引き
      client_host ||= inquiry_hostname(client_ip) unless client_ip.nil?
      client_ip ||= inquiry_address(client_host) unless client_host.nil?
      return [client_host, client_ip]
    rescue StandardError => ex
      return nil
    end
    
    # IPアドレスからホスト名を取得
    def inquiry_hostname(ip_address)
      return nil unless String === ip_address
      host_name = Resolv.getname(ip_address)
      return nil if host_name == ip_address
      return host_name
    rescue StandardError => ex
      return nil
    end
    
    # ホスト名からIPアドレスを取得
    def inquiry_address(host_name)
      return nil unless String === host_name
      return IPSocket.getaddress(host_name)
    rescue StandardError => ex
      return nil
    end
    
    # 10進数表現への変換
    def to_decimal(hexadecimal_val)
      return ('0x' + hexadecimal_val.to_s).to_i(0)
    rescue StandardError => ex
      return nil
    end
    
    # プロキシ使用チェック
    def use_proxy?(request)
      return true unless request.env['HTTP_PROXY_CONNECTION'].nil?
      return true unless request.env['HTTP_CACHE_CONTROL'].nil?
      return true unless request.env['HTTP_IF_MODIFIED_SINCE'].nil?
      return true unless request.env['HTTP_SP_HOST'].nil?
      return true unless request.env['HTTP_CLIENT_IP'].nil?
      return true unless request.env['HTTP_CLIENTIP'].nil?
      return true unless request.env['HTTP_FORWARDED'].nil?
      return true unless request.env['HTTP_FROM'].nil?
      return true unless request.env['HTTP_VIA'].nil?
      return true unless request.env['HTTP_X_FORWARDED_FOR'].nil?
      return true unless request.env['HTTP_X_LOCKING'].nil?
      # プロキシ未使用の場合（プロキシ特有の変数を受信していない）
      return false
    rescue StandardError => ex
      return false
    end
  end
end
