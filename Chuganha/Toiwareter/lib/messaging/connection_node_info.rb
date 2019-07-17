# -*- coding: utf-8 -*-
###############################################################################
# 接続ノード情報
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/04/03 Nakanohito
# 更新日:
###############################################################################
require 'drb/drb'
require 'base64'
require 'openssl'
require "stringio"
require 'thread'

module Messaging
  # 接続ノード情報
  class ConnectionNodeInfo
    include DRbUndumped
    # ローカルノードID
    LOCAL_NODE_ID = 'LOCAL'
    # 共通鍵暗号関係
    COMMON_KEY_CIPHER = 'AES-256-CBC'
    COMMON_KEY_SIZE = 32
    # 公開鍵関係
    KEY_PAIR_LIFETIME_SEC = 600 # 有効期間
    KEY_SIZE = 2048             # 鍵のサイズ
    EXPONENT = (rand(32768)*2)+1  # 指数
    ENCRYPT_SIZE = 240          # 暗号化ブロックサイズ
    DECRYPT_SIZE = 256          # 復号化ブロックサイズ
    SALT_SIZE = 5               # ソルトサイズ
    # ランダム文字配列
    RANDOM_CHARS = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a +
                   '!#$\'()*-.:;=?@[]_`{}~'.split(//)
    # アクセサー定義
    attr_reader :node_id, :key_sharing_url, :destination_url,
                :send_id, :send_pw, :common_key_expiration
    # コンストラクタ
    def initialize(node_info)
      # 排他制御オブジェクト生成
      @monitor = Monitor.new
      # ノード情報初期化
      @node_id = node_info.elements['node_id'].text
      # 有効期間
      @key_lifetime = node_info.elements['key_lifetime'].text
      @key_lifetime_sec = unit_sec(@key_lifetime)
      # アクセスURL
      @key_sharing_url = node_info.elements['address/key_sharing'].text
      @destination_url = node_info.elements['address/destination'].text
      # 送信アカウント
      @send_id = node_info.elements['account/sending/id'].text
      @send_pw = node_info.elements['account/sending/password'].text
      # 受信アカウント
      @rcvd_pw_hash = node_info.elements['account/receiving/password_hash'].text
      # 公開鍵対
      @key_pair = nil
      @key_pair_expiration = -1
      # 共通鍵
      @common_key = nil
      @common_key_expiration = -1
    end
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # 共通鍵の取得処理
    def common_key
      # クリティカルセクションの実行
      @monitor.synchronize do
        return create_common_key unless valid_common_key?
        return @common_key
      end
    end
    
    # 共通鍵の設定処理
    def common_key=(new_common_key)
      # クリティカルセクションの実行
      @monitor.synchronize do
        # 鍵情報更新
        @common_key = new_common_key.freeze
        @common_key_expiration = (Time.now.to_i + @key_lifetime_sec.to_i).freeze
      end
    end
    
    # 共通鍵による暗号化
    def common_encrypt(value)
      # 暗号オブジェクト
      cipher = OpenSSL::Cipher::Cipher.new(COMMON_KEY_CIPHER)
      cipher.encrypt
      # クリティカルセクションの実行
      @monitor.synchronize do
        cipher.pkcs5_keyivgen(@common_key)
      end
      return cipher.update(create_salt + value) + cipher.final
    end
    
    # 共通鍵による復号化
    def common_decrypt(value)
      # 暗号オブジェクト
      cipher = OpenSSL::Cipher::Cipher.new(COMMON_KEY_CIPHER)
      cipher.decrypt
      # クリティカルセクションの実行
      @monitor.synchronize do
        cipher.pkcs5_keyivgen(@common_key)
      end
      dec_value = cipher.update(value) + cipher.final
      dec_value.slice!(0,SALT_SIZE)
      return dec_value
    end
    
    # 共通鍵の有効期限設定
    def common_key_expiration=(expiration)
      val = expiration.to_i.freeze
      # クリティカルセクションの実行
      @monitor.synchronize do
        @common_key_expiration = val if @common_key_expiration < val
      end
    end
    
    # キー初期化処理
    def init_key
      # クリティカルセクションの実行
      @monitor.synchronize do
        # 公開鍵対クリア
        @key_pair = nil
        @key_pair_expiration = -1
        # 共通鍵クリア
        @common_key = nil
        @common_key_expiration = -1
      end
    end
    
    # 送信元判定
    def local_node?
      # クリティカルセクションの実行
      @monitor.synchronize do
        return @node_id == LOCAL_NODE_ID
      end
    end
    
    # 公開鍵の取得処理
    def public_key
      # クリティカルセクションの実行
      @monitor.synchronize do
        return create_key_pair.public_key if local_node? && !valid_key_pair?
        return nil if @key_pair.nil?
        return @key_pair.public_key
      end
    end
    
    # 公開鍵の設定処理
    def public_key=(public_key_str)
      # クリティカルセクションの実行
      @monitor.synchronize do
        return if local_node?
        # 鍵情報更新
        @key_pair = OpenSSL::PKey::RSA.new(public_key_str).public_key
        @key_pair_expiration = (Time.now.to_i + KEY_PAIR_LIFETIME_SEC.to_i).freeze
      end
    end
    
    # 公開鍵による暗号化
    def public_encrypt(value)
      return nil unless String === value
      # 暗号化処理
      enc_buf = Array.new
      # クリティカルセクションの実行
      @monitor.synchronize do
        create_key_pair unless valid_key_pair?
        str_io = StringIO.new(value, 'r')
        str_val = str_io.read(ENCRYPT_SIZE)
        while String === str_val do
          enc_buf.push(@key_pair.public_encrypt(create_salt + str_val))
          str_val = str_io.read(ENCRYPT_SIZE)
        end
      end
      return enc_buf.join
    end
    
    # 秘密鍵による復号化
    def private_decrypt(value)
      return nil unless String === value
      # 復号化処理
      dec_buf = Array.new
      # クリティカルセクションの実行
      @monitor.synchronize do
        create_key_pair unless valid_key_pair?
        str_io = StringIO.new(value, 'r')
        str_val = str_io.read(DECRYPT_SIZE)
        while String === str_val do
          dec_blk = @key_pair.private_decrypt(str_val)
          dec_buf.push(dec_blk.byteslice(SALT_SIZE, ENCRYPT_SIZE))
          str_val = str_io.read(DECRYPT_SIZE)
        end
      end
      return dec_buf.join
    end
    
    # 共通キーの有効判定
    def valid_common_key?
      # クリティカルセクションの実行
      @monitor.synchronize do
        return Time.now.to_i < @common_key_expiration
      end
    end
    
    # アカウント判定
    def valid_password?(password)
      # クリティカルセクションの実行
      @monitor.synchronize do
        return false if password.nil?
        enc_pw = Base64::strict_encode64(OpenSSL::Digest::SHA256.digest(password)) 
        return enc_pw == @rcvd_pw_hash
      end
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # キーペアの有効判定
    def valid_key_pair?
      return Time.now.to_i < @key_pair_expiration
    end
    
    # 公開鍵対の生成
    def create_key_pair
      # initialize random seed（乱数を設定する事によって暗号化の予測不可能性を向上する）
      OpenSSL::Random.seed(OpenSSL::Random.random_bytes(16))
      # 新しいキー情報（RSA2048）を生成
      @key_pair = OpenSSL::PKey::RSA.generate(KEY_SIZE, EXPONENT)
      @key_pair_expiration = (Time.now.to_i + KEY_PAIR_LIFETIME_SEC).freeze
      return @key_pair
    end
    
    # 共通鍵の生成
    def create_common_key
      # 新しいキー情報（AES256）を生成
      @common_key = Array.new(COMMON_KEY_SIZE){RANDOM_CHARS[rand(RANDOM_CHARS.size)]}.join.freeze
      @common_key_expiration = Time.now.to_i + @key_lifetime_sec.to_i
      # 共通鍵を返却
      return @common_key
    end
    # ソルト生成
    def create_salt
      # 文字コードセットからランダムに文字を抽出して、指定された桁数の文字列を生成
      return Array.new(SALT_SIZE){RANDOM_CHARS[rand(RANDOM_CHARS.size)]}.join
    end
    
    # 有効期間単位秒
    def unit_sec(validity_period)
      if /^\d+[Dd]/ =~ validity_period then
        return 86400 * validity_period[/^\d+/].to_i # 日単為
      elsif /^\d+[Hh]/ =~ validity_period then
        return 3600 * validity_period[/^\d+/].to_i  # 時単位
      elsif /^\d+[Mm]/ =~ validity_period then
        return 60 * validity_period[/^\d+/].to_i    # 分単位
      end
      raise ArgumentError, 'invalid argument'
    end
  end
end
