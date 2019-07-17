# -*- coding: utf-8 -*-
###############################################################################
# ネットワークユーティリティモジュール
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2011/08/09 Nakanohito
# 更新日:
###############################################################################
require 'resolv'
require 'socket'
require 'whois'

module Common
  module NetUtilModule
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    ###########################################################################
    # 定数定義
    ###########################################################################
    # 正規表現（URIのヘッダー）
    REG_URI_HEADER      = /^(https?|ftp)$/
    # 正規表現（メールアドレス）
    REG_MAIL_ADDRESS    =
      /^(?:(?:(?:(?:[a-zA-Z0-9_!#\$\%&'*+\/=?\^`{}~|\-]+)(?:\.(?:[a-zA-Z0-9_!#\$\%&'*+\/=?\^`{}~|\-]+))*)|(?:"(?:\\[^\r\n]|[^\\"])*")))\@(?:(?:(?:(?:[a-zA-Z0-9_!#\$\%&'*+\/=?\^`{}~|\-]+)(?:\.(?:[a-zA-Z0-9_!#\$\%&'*+\/=?\^`{}~|\-]+))*)|(?:\[(?:\\\S|[\x21-\x5a\x5e-\x7e])*\])))$/
    # マッチングパターン（ホスト名）
    REG_FMT_HOST_NAME   =
      /^(([a-z0-9]{1}[a-z0-9\-]{0,61})?[a-z0-9]{1}\.)*([a-z0-9]{1}[a-z0-9\-]{0,61})?[a-z0-9]{1}$/
    # IPアドレス（10進表現）
    REG_FMT_IP_DECIMAL  =
      /^((1\d{2}|2[0-4]\d|25[0-5]|[1-9]?\d)\.){3}(1\d{2}|2[0-4]\d|25[0-5]|[1-9]?\d)$/
    # IPアドレス（10進表現）
    REG_IP_DECIMAL      =
      /((1\d{2}|2[0-4]\d|25[0-5]|[1-9]?\d)\.){3}(1\d{2}|2[0-4]\d|25[0-5]|[1-9]?\d)/
    # IPアドレス（16進表現）
    REG_IP_HEXADECIMAL  = /([a-fA-F0-9]{1,2}\.){3}[a-fA-F0-9]{1,2}/
    # IPアドレス（16進表現ピリオド無し）
    REG_IP_HEXADECIMAL2 = /(0x|[^a-zA-Z0-9])?[a-fA-F0-9]{8}/
    # IPアドレス（16進表現ピリオド無し）
    REG_IP_HEXADECIMAL3 = /[a-fA-F0-9]{8}/
    
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # URL書式チェック
    def valid_uri?(val)
      return false unless String === val
      return !(REG_URI_HEADER =~ URI.parse(val).scheme).nil?
    rescue URI::InvalidURIError => ex
      return false
    end

    # メールアドレス書式チェック
    def valid_email?(val)
      return false unless String === val
      return !(REG_MAIL_ADDRESS =~ val).nil?
    end

    # ホスト名書式チェック
    def valid_host_name?(val)
      return false unless String === val
      return false if val.length > 255
      host_name = val.downcase
      return !(REG_FMT_HOST_NAME =~ host_name).nil?
    end

    # IPアドレス書式チェック
    def valid_ip_address?(val)
      return false unless String === val
      return false if val.length > 15
      return !(REG_FMT_IP_DECIMAL =~ val).nil?
    end
    
    # ブラウザ判定
    def check_browser(user_agent)
      # User-Agent判定
      browser_name = 'other'
      browser_version = 'other'
      return [browser_name, browser_version] unless String === user_agent
      if /Opera/ =~ user_agent then
        # Wii
        if /Wii/ =~ user_agent then
          browser_name = 'Wii'
        # Nintendo DS
        elsif /Opera 8\.50/ =~ user_agent then
          browser_name = 'Nintendo DS'
        # Opera
        else
          browser_name = 'Opera'
        end
        str = user_agent[/Opera[ \/]\d+/]
        browser_version = str[/\d+/] unless str.nil?
      elsif /MSIE/ =~ user_agent then
        # Lunascape
        if /Lunascape/ =~ user_agent then
          browser_name = 'Lunascape'
          str = user_agent[/Lunascape \d+/]
          browser_version = str[/\d+/] unless str.nil?
        # Sleipnir
        elsif /Sleipnir/ =~ user_agent then
          browser_name = 'Sleipnir'
          str = user_agent[/Sleipnir\/\d+\.\d/]
          browser_version = str[/\d+\.\d/] unless str.nil?
        # Internet Explorer
        else
          browser_name = 'Internet Explorer'
          str = user_agent[/MSIE \d+/]
          browser_version = str[/\d+/] unless str.nil?
        end
      # Firefox
      elsif /Firefox/ =~ user_agent then
        browser_name = 'Firefox'
        str = user_agent[/Firefox\/\d+/]
        browser_version = str[/\d+/] unless str.nil?
      # Chrome
      elsif /Chrome/ =~ user_agent then
        browser_name = 'Chrome'
        str = user_agent[/Chrome\/\d+/]
        browser_version = str[/\d+/] unless str.nil?
      # Netscape
      elsif /Netscape/ =~ user_agent then
        browser_name = 'Netscape'
        str = user_agent[/Netscape\d?\/\d+/]
        browser_version = str[/\/\d+/][/\d+/] unless str.nil?
      elsif /AppleWebKit/ =~ user_agent then
        # iPod
        if /iPod/ =~ user_agent then
          browser_name = 'iPod'
        # iPhone
        elsif /iPhone/ =~ user_agent then
          browser_name = 'iPhone'
        # iPad
        elsif /iPad/ =~ user_agent then
          browser_name = 'iPad'
        # Safari
        else
          browser_name = 'Safari'
          str = user_agent[/Version\/\d+/]
          browser_version = str[/\d+/] unless str.nil?
        end
      # PSP
      elsif /PlayStation Portable/ =~ user_agent then
        browser_name = 'PlayStation Portable'
      # PlayStation2
      elsif /PS2/ =~ user_agent then
        browser_name = 'PlayStation2'
      # PlayStation3
      elsif /PLAYSTATION 3/ =~ user_agent then
        browser_name = 'PlayStation3'
      # Google bot
      elsif /Googlebot/ =~ user_agent then
        browser_name = 'Google bot'
      # msn bot
      elsif /msnbot/ =~ user_agent then
        browser_name = 'msn bot'
      # Yahoo bot
      elsif /Yahoo! Slurp/ =~ user_agent then
        browser_name = 'Yahoo bot'
      # Baidu
      elsif /http:\/\/www\.baidu\.jp/ =~ user_agent then
        browser_name = 'Baidu bot'
      # Naver
      elsif /http:\/\/help\.naver\.com\/robots/ =~ user_agent then
        browser_name = 'Naver bot'
      # Microsoft Academic Search bot
      elsif /^librabot/ =~ user_agent then
        browser_name = 'Microsoft Academic Search bot'
      end
      # ブラウザ返却
      return [browser_name, browser_version]
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
      ip_address = str[REG_IP_HEXADECIMAL]
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
    
    # リモートホスト情報抽出
    def ex_remote_host(request)
      return nil if request.nil?
      return [request.headers['REMOTE_HOST'], request.headers['REMOTE_ADDR']]
    rescue StandardError => ex
      return nil
    end
    
    # プロキシ使用時のクライアントホスト情報抽出
    def ex_proxy_client(request)
      return nil if request.nil?
      # クライアントホスト
      client_host = request.headers['HTTP_SP_HOST']
      # クライアントIP
      client_ip =   ambiguous_ex_ip(request.headers['HTTP_CLIENT_IP'])
      client_ip ||= ambiguous_ex_ip(request.headers['HTTP_CLIENTIP'])
      client_ip ||= ambiguous_ex_ip(request.headers['HTTP_FORWARDED'])
      client_ip ||= ambiguous_ex_ip(request.headers['HTTP_FROM'])
      client_ip ||= ambiguous_ex_ip(request.headers['HTTP_VIA'])
      client_ip ||= ambiguous_ex_ip(request.headers['HTTP_X_FORWARDED_FOR'])
      client_ip ||= ambiguous_ex_ip(request.headers['HTTP_X_LOCKING'])
      # クライアント情報逆引き
      client_host ||= inquiry_hostname(client_ip) unless client_ip.nil?
      client_ip ||= inquiry_address(client_host) unless client_host.nil?
      return [client_host, client_ip]
    rescue StandardError => ex
      return nil
    end
    
    # 言語コード（ISO 639）の抽出
    def ex_lang_code(str)
      return nil unless String === str
      return str.scan(/^[a-z]{2,3}/).first
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
    
    # ドメイン存在チェック
    def domain_exists?(domain_name)
      return false unless String === domain_name
      client = Whois::Client.new(:timeout => 10)
      ans = client.query(domain_name)
      return ans.registered?
    rescue StandardError => ex
      return false
    end

    # プロキシ使用チェック
    def use_proxy?(request)
      return true unless request.headers['HTTP_PROXY_CONNECTION'].nil?
      return true unless request.headers['HTTP_CACHE_CONTROL'].nil?
      return true unless request.headers['HTTP_IF_MODIFIED_SINCE'].nil?
      return true unless request.headers['HTTP_SP_HOST'].nil?
      return true unless request.headers['HTTP_CLIENT_IP'].nil?
      return true unless request.headers['HTTP_CLIENTIP'].nil?
      return true unless request.headers['HTTP_FORWARDED'].nil?
      return true unless request.headers['HTTP_FROM'].nil?
      return true unless request.headers['HTTP_VIA'].nil?
      return true unless request.headers['HTTP_X_FORWARDED_FOR'].nil?
      return true unless request.headers['HTTP_X_LOCKING'].nil?
      # プロキシ未使用の場合（プロキシ特有の変数を受信していない）
      return false
    rescue StandardError => ex
      return false
    end
    # 10進数表現への変換
    def to_decimal(hexadecimal_val)
      return ('0x' + hexadecimal_val.to_s).to_i(0)
    rescue StandardError => ex
      return nil
    end
  end
end