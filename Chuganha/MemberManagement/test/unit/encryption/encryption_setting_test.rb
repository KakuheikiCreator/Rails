require 'test_helper'
require 'encryption/encryption_setting'
require 'unit/unit_test_util'

###############################################################################
# ユニットテストクラス
# テスト対象：暗号設定情報保持クラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/07/03 Nakanohito
# 更新日:
###############################################################################
class EncryptionSettingTest < ActiveSupport::TestCase
  include Encryption
  include UnitTestUtil

  # テスト対象メソッド：initialize
  test "CASE:2-1-1 initialize" do
#    source = 'abcdefgHIJKLMN1234567+-*/=!?'
#    source = 'abcdefghデータ No.1'
#    print("source:", source, "\n")
#    crypt = EncryptionUtil.encryption(source)
#    print("size:", crypt.size, "\n")
#    print("encryption:", crypt.bytes.to_a, "\n")
#    print("encryption:", crypt, "\n")
#    print("decryption:", EncryptionUtil.decryption(crypt), "\n")
    # 正常ケース
    filedir = Rails.root + "config/"
    origin_name = "encryption_origin.yml" 
    file_name = "encryption.yml"
#    FileUtils.cp(filedir + origin_name, filedir + file_name)
    begin
#      Encryption:EncryptionSetting.instance
#      assert_equal(File.exist?(filedir + file_name), false, "CASE:2-1-1")
    rescue
      flunk("CASE:2-1-1")
    end
    # 異常ケース
  end

  # テスト対象メソッド：initialize
  test "CASE:2-1-2 initialize" do
    # 正常ケース
    filedir = Rails.root + "config/"
    file_name = "encryption.yml" 
#    File.delete(filedir + file_name)
    begin
#      Encryption:EncryptionSetting.instance
#      flunk("CASE:2-1-2")
    rescue
#      assert_equal(File.exist?(filedir + file_name), false, "CASE:2-1-2")
    end
    # 異常ケース
  end

  # テスト対象メソッド：initialize
  test "CASE:2-1-3 initialize" do
    # 正常ケース
    filedir = Rails.root + "config/"
    origin_name = "encryption_origin.yml" 
    file_name = "encryption.yml"
#    FileUtils.cp(filedir + origin_name, filedir + file_name)
#    File.chmod(111, filedir + file_name)
    begin
#      Encryption:EncryptionSetting.instance
#      flunk("CASE:2-1-3")
    rescue
#      File.chmod(777, filedir + file_name)
#      assert(File.exist?(filedir + file_name), "CASE:2-1-3")
    end
#    File.delete(filedir + file_name)
    # 異常ケース
  end

  # テスト対象メソッド：initialize
  test "CASE:2-1-4 initialize" do
    # 正常ケース
    filedir = Rails.root + "config/"
    origin_name = "encryption_origin.yml" 
    file_name = "encryption.yml"
#    FileUtils.cp(filedir + origin_name, filedir + file_name)
#    File.chmod(111, filedir + file_name)
    begin
      EncryptionSetting.instance
      flunk("CASE:2-1-3")
    rescue
      assert(File.exist?(filedir + file_name), "CASE:2-1-3")
    end
#    File.delete(filedir + file_name)
    # 異常ケース
  end

  # テスト対象メソッド：accessor
  test "CASE:2-2 accessor" do
    # 正常ケース
    filedir = Rails.root + "config/"
    origin_name = "encryption_origin.yml" 
    file_name = "encryption.yml" 
    FileUtils.cp(filedir + origin_name, filedir + file_name)
    assert_equal(EncryptionSetting.instance.encryption_algorithm, "AES128", "CASE:2-2-1 encryption_algorithm")
    assert_equal(EncryptionSetting.instance.encryption_password, "1234567890123456", "CASE:2-2-1 encryption_password")
    assert_equal(EncryptionSetting.instance.encryption_salt_size, 8, "CASE:2-2-1 encryption_salt_size")
    assert_equal(EncryptionSetting.instance.hash_salt_size, 8, "CASE:2-2-1 hash_salt_size")
    # 異常ケース
  end
end