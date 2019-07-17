###############################################################################
# 暗号化ユーティリティクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/07/05 Nakanohito
# 更新日:
###############################################################################
require 'openssl'

module Encryption

  class EncryptionUtil
  
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    
    # ハッシュ用ソルト生成
    def self.generate_hash_salt
      # ハッシュ用ソルトのサイズでランダムな文字列を生成
      return self.generate_random_string(EncryptionSetting.instance.hash_salt_size)
    end
    
    # 暗号化メソッド
    def self.encryption(data)
      # 暗号化アルゴリズムを指定して、暗号化オブジェクトを生成
      encoder = OpenSSL::Cipher.new(EncryptionSetting.instance.encryption_algorithm)
      # 暗号化モード
      encoder.encrypt 
      # 暗号化する際のキー文字列をセット
      encoder.pkcs5_keyivgen(EncryptionSetting.instance.encryption_password)
      # 暗号化処理
      return encoder.update(self.generate_encryption_salt + data) + encoder.final
    end
    
    # 復号化メソッド
    def self.decryption(data)
      # 暗号化アルゴリズムを指定して、復号化オブジェクトを生成
      decoder = OpenSSL::Cipher.new(EncryptionSetting.instance.encryption_algorithm)
      # 復号化モード
      decoder.decrypt 
      # 暗号化する際のキー文字列をセット
      decoder.pkcs5_keyivgen(EncryptionSetting.instance.encryption_password)
      # 復号化処理
      result = decoder.update(data) + decoder.final
      return result.slice!(EncryptionSetting.instance.encryption_salt_size, result.size)
    end
    
    # ハッシュ化メソッド
    def self.hash(data, salt)
       return OpenSSL::Digest::SHA256.digest(salt.concat(data))
    end
  
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    
    # ランダムな文字列生成処理
    def self.generate_random_string(size)
      # 生成対象の文字コードセット
      character_set = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
      # 文字コードセットからランダムに文字を抽出して、指定された桁数の文字列を生成
      return Array.new(size){character_set[rand(character_set.size)]}.join
    end
    
    # 暗号化用ソルト生成
    def self.generate_encryption_salt
      # 暗号化用ソルトのサイズでランダムな文字列を生成
      return self.generate_random_string(EncryptionSetting.instance.encryption_salt_size)
    end
  end

end