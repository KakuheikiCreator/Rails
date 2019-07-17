###############################################################################
# ユニットテストクラス
# テスト対象：バリデーションチェックモジュール
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/06/30 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'test_helper'
require 'encryption/encryption_util'

class EncryptionUtilTest < ActiveSupport::TestCase
  include Encryption

  # テスト対象メソッド：blank?
  test "CASE:2-1 generate_hash_salt" do
    # 正常ケース
    assert_equal(EncryptionUtil.generate_hash_salt.size, EncryptionSetting.instance.hash_salt_size,"CASE:2-1-1")
    # 異常ケース
  end

  # テスト対象メソッド：encryption decryption
  test "CASE:2-2 and 2-3 encryption and decryption" do
    # 正常ケース
    origin_data = "Successful Test"
    crypt = EncryptionUtil.encryption(origin_data)
    assert_equal(crypt.size, 32, "CASE:2-2-1")
    decode_data = EncryptionUtil.decryption(crypt)
    assert_equal(decode_data, origin_data, "CASE:2-3-1")
    # 異常ケース
  end

  # テスト対象メソッド：hash
  test "CASE:2-4 hash" do
    # 正常ケース
    hash_code = EncryptionUtil.hash("abc*ABC", EncryptionUtil.generate_hash_salt)
    assert_equal(hash_code.class.name, "String", "CASE:2-4-1")
    assert_equal(hash_code.size, 32, "CASE:2-4-1")
    # 異常ケース：なし
  end
  
end
