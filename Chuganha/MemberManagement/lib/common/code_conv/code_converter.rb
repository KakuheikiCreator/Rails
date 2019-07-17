# -*- coding: utf-8 -*-
###############################################################################
# コード変換クラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/11/03 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'openssl'
require 'common/code_conv/encryption_setting'

module Common::CodeConv
  class CodeConverter
    include Singleton
    CHAR_SET_HANKAKU = (' '..'~').to_a + ('｡'..'ﾟ').to_a    # 半角
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    # 初期処理
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 暗号化設定
      @enc_setting = Common::CodeConv::EncryptionSetting.instance
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # ハッシュ用ソルト生成
    def hash_salt
      @mutex.synchronize do
        # ハッシュ用ソルトのサイズでランダムな文字列を生成
        return random_string(@enc_setting.hash_salt_size)
      end
    end
    
    # 暗号化メソッド
    def encryption(data)
      @mutex.synchronize do
        encoder = create_encoder
        # 暗号化用ソルト生成
        salt = random_string(@enc_setting.encryption_salt_size)
        # 暗号化処理
        return encoder.update(salt + data) + encoder.final
      end
    end
    
    # 復号化メソッド
    def decryption(data)
      @mutex.synchronize do
        decoder = create_decoder
        # 復号化処理
        result = (decoder.update(data) + decoder.final).force_encoding("UTF-8")
        return result[@enc_setting.encryption_salt_size, result.size]
      end
    end
    
    # ハッシュ化メソッド
    def hash(data, salt)
      @mutex.synchronize do
        return OpenSSL::Digest::SHA256.digest(salt + data)
      end
    end
  
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # エンコーダー生成
    def create_encoder
      # エンコーダー
      encoder = OpenSSL::Cipher.new(@enc_setting.encryption_algorithm)
      # 暗号化モード
      encoder.encrypt
      # キーと初期化ベクトルとパディングを設定
      encoder.key = @enc_setting.encryption_password
      encoder.iv = cipher_iv
      return encoder
    end
    
    # デコーダー生成
    def create_decoder
      # 暗号化アルゴリズムを指定して、復号化オブジェクトを生成
      decoder = OpenSSL::Cipher.new(@enc_setting.encryption_algorithm)
      # 復号化モード
      decoder.decrypt
      # キーと初期化ベクトルとパディングを設定
      decoder.key = @enc_setting.encryption_password
      decoder.iv = cipher_iv
      return decoder
    end
    
    # 暗号化の初期ベクトルを生成
    def cipher_iv
      return "\000" * @enc_setting.encryption_password.length
    end
    
    # ランダムな文字列生成処理
    def random_string(size)
      # 文字コードセットからランダムに文字を抽出して、指定された桁数の文字列を生成
      return Array.new(size){CHAR_SET_HANKAKU[rand(CHAR_SET_HANKAKU.size)]}.join
    end
  end
end