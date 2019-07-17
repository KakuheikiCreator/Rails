###############################################################################
# ネットワークチェックモジュール
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/08/09 Nakanohito
# 更新日:
###############################################################################
require 'socket'
require 'whois'

module Common
  module NetChkModule
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
      begin
        return (REG_URI_HEADER =~ URI.split(val).first) != nil
      rescue
        return false
      end
    end

    # メールアドレス書式チェック
    def valid_email?(val)
      return (REG_MAIL_ADDRESS =~ val) != nil
    end

    # ホスト名書式チェック
    def valid_host_name?(val)
      return false unless String === val
      return false if val.length > 255
      host_name = val.downcase
      return (REG_FMT_HOST_NAME =~ host_name) != nil
    end

    # IPアドレス書式チェック
    def valid_ip_address?(val)
      return false unless String === val
      return false if val.length > 15
      return (REG_FMT_IP_DECIMAL =~ val) != nil
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
      # ブラウザ情報返却
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
    
    # 10進数表現への変換
    def to_decimal(hexadecimal_val)
      return ('0x' + hexadecimal_val).to_i(0)
    end
    
    # IPアドレスからホスト名を取得
    def get_hostname(ip_address)
      return nil unless String === ip_address
      return Socket.gethostbyname(ip_address)[0]
    rescue
      return nil
    end
    
    # ホスト名からIPアドレスを取得
    def get_address(host_name)
      return nil unless String === host_name
      return IPSocket.getaddress(host_name)
    rescue
      return nil
    end
    
    # ドメイン存在チェック
    def domain_exists?(domain_name)
      return false unless String === domain_name
      client = Whois::Client.new(:timeout => 10)
      ans = client.query(domain_name)
      return ans.registered?
    rescue
      return false
    end
  end
end