# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：接続ノード情報
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/12 Nakanohito
# 更新日:
###############################################################################
require 'openssl'
require 'test_helper'
require 'unit/unit_test_util'
require 'messaging/connection_node_info'

class ConnectionNodeInfoTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Messaging

  # テスト対象メソッド：initialize
  test "CASE:2-01 initialize" do
    # 正常ケース
    begin
      node_info = ConnectionNodeInfo.new(message_xml.root)
      lifetime = 60*60*24*3
      assert(!node_info.nil?, "CASE:2-1-1")
      assert(node_info.node_id == "LOCAL", "CASE:2-1-2")
      key_lifetime = node_info.instance_variable_get(:@key_lifetime)
      assert(key_lifetime == "3d", "CASE:2-1-3")
      key_lifetime_sec = node_info.instance_variable_get(:@key_lifetime_sec)
#      print_log("key_lifetime_sec:" + key_lifetime_sec.to_s)
#      print_log("lifetime:" + lifetime.to_s)
      assert(key_lifetime_sec == lifetime, "CASE:2-1-4")
      assert(node_info.key_sharing_url == "http://localhost:3001/messaging/key_sharing", "CASE:2-1-5")
      assert(node_info.destination_url == "http://localhost:3001/messaging/msg_receiver", "CASE:2-1-6")
      assert(node_info.send_id == "AccessManagement", "CASE:2-1-7")
      assert(node_info.send_pw == "oredayooreoreore", "CASE:2-1-8")
      assert(node_info.common_key_expiration == -1, "CASE:2-1-9")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 異常ケース
    begin
      node_info = ConnectionNodeInfo.new(message_xml.root.delete_element('node_id'))
      flunk("CASE:2-1-2")
    rescue StandardError => ex
      assert(true, "CASE:2-1-2")
    end
  end

  # テスト対象メソッド：common_key
  test "CASE:2-02 common_key" do
    # 正常ケース
    begin
      node_info = ConnectionNodeInfo.new(message_xml.root)
      # 新規生成
      common_key_1 = node_info.common_key
      assert_equal(common_key_1.length, 32, "CASE:2-2-1")
      # 生成済み値取得
      common_key_2 = node_info.common_key
      assert_equal(common_key_1, common_key_2, "CASE:2-2-2")
      # 新規生成
      node_info.instance_variable_set(:@common_key_expiration, Time.now.to_i)
      common_key_3 = node_info.common_key
      assert(common_key_1 != common_key_3, "CASE:2-2-3")
      # 生成済み値取得
      common_key_4 = node_info.common_key
      assert_equal(common_key_3, common_key_4, "CASE:2-2-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-2-1")
    end
    # 異常ケース
  end

  # テスト対象メソッド：common_key=
  test "CASE:2-03 common_key=" do
    # 正常ケース
    begin
      node_info = ConnectionNodeInfo.new(message_xml.root)
      common_key = '12345678901234567890123456789012'
      # 共通鍵設定
      node_info.common_key = common_key
      limit_time = Time.now.to_i + 60*60*24*3
      key_expiration = node_info.instance_variable_get(:@common_key_expiration)
#      print_log("Now Time:" + Time.now.to_i.to_s)
#      print_log("key_expiration:" + key_expiration.to_s)
#      print_log("limit_time:" + limit_time.to_s)
      assert(node_info.common_key == common_key, "CASE:2-3-1")
      assert(key_expiration == limit_time, "CASE:2-3-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-1")
    end
  end

  # テスト対象メソッド：common_encrypt
  test "CASE:2-04 common_encrypt" do
    # 正常ケース
    begin
      # 暗号化対象
      value = generate_str(CHAR_SET_ALPHANUMERIC, 4096)
#      value = '世界を揺るがす秘密を内に隠した白い悪魔'
      # 共通鍵新規生成
      node_info = ConnectionNodeInfo.new(message_xml.root)
      common_key = node_info.common_key
      print_log("target value :" + value.to_s)
      # 暗号化
      encrypt_value = node_info.common_encrypt(value)
#      print_log("encrypt_value:" + encrypt_value.to_s)
#      print_log("encrypt_value:" + encrypt_value.class.name)
      # 復号化
      cipher = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
      cipher.decrypt
      cipher.pkcs5_keyivgen(common_key)
      decrypt_value = (cipher.update(encrypt_value) + cipher.final)
      decrypt_value.slice!(0,ConnectionNodeInfo::SALT_SIZE)
      # 値比較
      print_log("decrypt_value:" + decrypt_value)
#      print_log("decrypt_value:" + decrypt_value.class.name)
      assert(decrypt_value == value, "CASE:2-4-1")
      # 同値を再度暗号化した結果が異なる事を判定
      encrypt_value_next = node_info.common_encrypt(value)
      print_log('encrypt_value 1:' + [encrypt_value].pack('m').to_s)
      print_log('encrypt_value 2:' + [encrypt_value_next].pack('m').to_s)
      assert(encrypt_value != encrypt_value_next, "CASE:2-4-2")
      decrypt_value_next = node_info.common_decrypt(encrypt_value_next)
      assert(decrypt_value == decrypt_value_next, "CASE:2-4-3")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-1")
    end
    # 異常ケース（引数異常）
    begin
      # 暗号化対象
      value = Time.new
      # 共通鍵新規生成
      node_info = ConnectionNodeInfo.new(message_xml.root)
      common_key = node_info.common_key
      # 暗号化
      encrypt_value = node_info.common_encrypt(value)
      flunk("CASE:2-4-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      assert(true, "CASE:2-4-2")
    end
  end

  # テスト対象メソッド：common_decrypt
  test "CASE:2-05 common_decrypt" do
    # 正常ケース
    begin
      # 暗号化対象
      value = generate_str(CHAR_SET_ALPHANUMERIC, 4096)
#      value = '世界を揺るがす秘密を内に隠した白い悪魔'
      print_log("target value :" + value.to_s)
      # 共通鍵新規生成
      node_info = ConnectionNodeInfo.new(message_xml.root)
      common_key = node_info.common_key
      # 暗号化
      encrypt_value = node_info.common_encrypt(value)
#      print_log("encrypt_value:" + encrypt_value.toutf8)
      # 復号化
      decrypt_value = node_info.common_decrypt(encrypt_value)
      print_log("decrypt_value:" + decrypt_value)
#      print_log("decrypt_value:" + decrypt_value)
#      print_log("decrypt_value:" + decrypt_value.class.name)
      # 値比較
      assert(decrypt_value == value, "CASE:2-5-1")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-5-1")
    end
    # 異常ケース（引数異常）
    begin
      # 暗号化対象
      value = Time.new
      # 共通鍵新規生成
      node_info = ConnectionNodeInfo.new(message_xml.root)
      common_key = node_info.common_key
      # 暗号化
      encrypt_value = node_info.common_decrypt(value)
      flunk("CASE:2-5-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      assert(true, "CASE:2-5-2")
    end
  end

  # テスト対象メソッド：local_node?
  test "CASE:2-06 local_node?" do
    # 正常ケース
    begin
      # ローカルノード判定
      node_info = ConnectionNodeInfo.new(message_xml.root)
      assert(node_info.local_node?, "CASE:2-6-1")
      message_xml_obj = message_xml
      message_xml_obj.root.elements['node_id'].text = 'other node id'
      node_info = ConnectionNodeInfo.new(message_xml_obj.root)
#      print_log("node_id:" + node_info.node_id)
      assert(!node_info.local_node?, "CASE:2-6-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-6-1")
    end
  end
  
  # テスト対象メソッド：public_encrypt and private_decrypt
  test "CASE:2-07 public_encrypt and private_decrypt" do
    # 正常ケース
    begin
      # 暗号化対象
#      value = '世界を揺るがす秘密を内に隠した白い悪魔'
      value = generate_str(CHAR_SET_ALPHANUMERIC, 4096)
#      print_log("target_value:" + value)
#      print_log("target_value size:" + value.bytesize.to_s)
      # 共通鍵新規生成
      node_info = ConnectionNodeInfo.new(message_xml.root)
      # 公開鍵で暗号化
      encrypt_value_1 = node_info.public_encrypt(value)
      encrypt_value_2 = node_info.public_encrypt(value)
#      print_log("encrypt_value:" + encrypt_value.toutf8)
#      print_log("encrypt_value size:" + encrypt_value.bytesize.to_s)
      pack_val_1 = [encrypt_value_1].pack('m')
      pack_val_2 = [encrypt_value_2].pack('m')
      unpack_val_1 = pack_val_1.unpack('m')[0]
      unpack_val_2 = pack_val_2.unpack('m')[0]
      # 秘密鍵で復号化
      decrypt_value_1 = node_info.private_decrypt(unpack_val_1)
      decrypt_value_2 = node_info.private_decrypt(unpack_val_2)
#      decrypt_value = node_info.private_decrypt(encrypt_value)
#      print_log("decrypt_value:" + decrypt_value)
#      print_log("decrypt_value size:" + decrypt_value.bytesize.to_s)
#      print_log("decrypt_value:" + decrypt_value.class.name)
      # 値比較
      assert(decrypt_value_1 == value, "CASE:2-7-1")
      assert(decrypt_value_2 == value, "CASE:2-7-1")
      # 暗号文比較
      assert(encrypt_value_1 != encrypt_value_2, "CASE:2-7-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-1")
    end
    # 正常ケース（生成キー判定）
    begin
      # 暗号化対象
#      value = '世界を揺るがす秘密を内に隠した白い悪魔'
      value = generate_str(CHAR_SET_ALPHANUMERIC, 4096)
      # 共通鍵新規生成
      node_info = ConnectionNodeInfo.new(message_xml.root)
      # 公開鍵で暗号化
      encrypt_value = node_info.public_encrypt(value)
      # 秘密鍵で復号化
      decrypt_value = node_info.private_decrypt(encrypt_value)
      # 再度公開鍵で暗号化
      encrypt_value_next = node_info.public_encrypt(value)
      # 再度秘密鍵で復号化
      decrypt_value_next = node_info.private_decrypt(encrypt_value_next)
      # 値比較
      print_log('encrypt_value 1:' + [encrypt_value].pack('m').to_s)
      print_log('encrypt_value 2:' + [encrypt_value_next].pack('m').to_s)
      assert(decrypt_value == value, "CASE:2-7-1")
      assert(decrypt_value_next == value, "CASE:2-7-2")
      assert(encrypt_value != encrypt_value_next, "CASE:2-7-3")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-2")
    end
    # 異常ケース（パラメータエラー）
    begin
      # 共通鍵新規生成
      node_info = ConnectionNodeInfo.new(message_xml.root)
      # 公開鍵で暗号化
      encrypt_value = node_info.public_encrypt(4096)
      assert(encrypt_value.nil?, "CASE:2-7-3")
      # 秘密鍵で復号化
      decrypt_value = node_info.private_decrypt(4096)
      assert(decrypt_value.nil?, "CASE:2-7-4")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-3")
    end
  end

  # テスト対象メソッド：public_key
  test "CASE:2-08 public_key" do
    # 正常ケース
    begin
      node_info = ConnectionNodeInfo.new(message_xml.root)
      # 新規生成
      public_key_1 = node_info.public_key
#      print_log("public_key_1:" + public_key_1.to_s)
#      print_log("public_key_1:" + public_key_1.to_s.length.to_s)
      assert(!public_key_1.nil?, "CASE:2-8-1")
      # 生成済み値取得
      public_key_2 = node_info.public_key
      assert_equal(public_key_1.to_s, public_key_2.to_s, "CASE:2-8-2")
      # 新規生成（有効期限切れ）
      node_info.instance_variable_set(:@key_pair_expiration, Time.now.to_i)
      public_key_3 = node_info.public_key
      assert(public_key_1.to_s != public_key_3.to_s, "CASE:2-8-3")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-1")
    end
    # 異常ケース
    begin
      message_xml_obj = message_xml
      message_xml_obj.root.elements['node_id'].text = 'other node id'
      node_info = ConnectionNodeInfo.new(message_xml_obj.root)
      # 新規生成（ローカルノード以外）
      assert(!node_info.local_node?, "CASE:2-8-4")
      assert(node_info.public_key.nil?, "CASE:2-8-5")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-4")
    end
  end

  # テスト対象メソッド：public_key=
  test "CASE:2-09 public_key=" do
    # 正常ケース（ローカルノード以外）
    begin
      message_xml_obj = message_xml
      message_xml_obj.root.elements['node_id'].text = 'other node id'
      node_info = ConnectionNodeInfo.new(message_xml_obj.root)
      key_pair = OpenSSL::PKey::RSA.generate(2048)
      # 公開鍵設定
      node_info.public_key = key_pair.to_s
      check_expiration = Time.now.to_i + 600
      key_pair_expiration = node_info.instance_variable_get(:@key_pair_expiration)
#      print_log("public_key_1:" + key_pair.public_key.to_s)
#      print_log("public_key_2:" + node_info.public_key.to_s)
      assert_equal(node_info.public_key.to_s, key_pair.public_key.to_s, "CASE:2-9-1")
#      print_log("check_expiration:" + check_expiration.to_s)
#      print_log("key_pair_expiration:" + key_pair_expiration.to_s)
      assert_equal(key_pair_expiration, check_expiration, "CASE:2-9-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-9-1")
    end
    # 正常ケース（ローカルノード）
    begin
      node_info = ConnectionNodeInfo.new(message_xml.root)
      key_pair = OpenSSL::PKey::RSA.generate(2048)
      # 公開鍵設定
      node_info.public_key = key_pair.to_s
      check_expiration = Time.now.to_i + 600
      key_pair_expiration = node_info.instance_variable_get(:@key_pair_expiration)
#      print_log("public_key_1:" + key_pair.public_key.to_s)
#      print_log("public_key_2:" + node_info.public_key.to_s)
      assert(node_info.public_key.to_s != key_pair.public_key.to_s, "CASE:2-9-3")
#      print_log("check_expiration:" + check_expiration.to_s)
#      print_log("key_pair_expiration:" + key_pair_expiration.to_s)
      assert(key_pair_expiration != check_expiration, "CASE:2-9-4")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-9-3")
    end
    # 異常ケース
  end

  # テスト対象メソッド：valid_common_key?
  test "CASE:2-10 valid_common_key?" do
    # 正常ケース（ローカルノード以外）
    begin
      node_info = ConnectionNodeInfo.new(message_xml.root)
      #　共通鍵有効期限判定（期限切れ）
      node_info.instance_variable_set(:@common_key_expiration, Time.now.to_i - 1)
      assert(!node_info.valid_common_key?, "CASE:2-10-1")
      node_info.instance_variable_set(:@common_key_expiration, Time.now.to_i)
      assert(!node_info.valid_common_key?, "CASE:2-10-1")
      #　共通鍵有効期限判定（期限内）
      node_info.instance_variable_set(:@common_key_expiration, Time.now.to_i + 1)
      assert(node_info.valid_common_key?, "CASE:2-10-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-10-1")
    end
  end

  # テスト対象メソッド：valid_password?
  test "CASE:2-11 valid_password?" do
    # 正常ケース（ローカルノード以外）
    begin
      password = 'oredayooreoreore'
      error_pw = 'oredayone?'
#      print_log("password_hash:" + OpenSSL::Digest::SHA256.digest(password).toutf8)
      #　パスワード一致
      node_info = ConnectionNodeInfo.new(message_xml.root)
      assert(node_info.valid_password?(password), "CASE:2-11-1")
      #　パスワード不一致
      assert(!node_info.valid_password?(nil), "CASE:2-11-2")
      assert(!node_info.valid_password?(error_pw), "CASE:2-11-3")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-11 Error")
    end
  end

  # テスト対象メソッド：common_key_expiration=
  test "CASE:2-12 common_key_expiration=" do
    # 正常ケース（数値設定）
    begin
      value = 100
      #　パスワード一致
      node_info = ConnectionNodeInfo.new(message_xml.root)
      node_info.common_key_expiration = value
      assert(node_info.common_key_expiration == value, "CASE:2-12-1")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-12-1 Error")
    end
    # 正常ケース（タイムスタンプ設定）
    begin
      value = Time.new
      #　パスワード一致
      node_info = ConnectionNodeInfo.new(message_xml.root)
      node_info.common_key_expiration = value
      assert(node_info.common_key_expiration == value.to_i, "CASE:2-12-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-12-2 Error")
    end
    # 異常ケース（数値以外設定）
    begin
      value = :Error
      #　パスワード一致
      node_info = ConnectionNodeInfo.new(message_xml.root)
      node_info.common_key_expiration = value
      flunk("CASE:2-12-3 Error")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      assert(true, "CASE:2-12-3")
    end
    # 異常ケース（過去の値）
    begin
      value = -2
      #　パスワード一致
      node_info = ConnectionNodeInfo.new(message_xml.root)
      node_info.common_key_expiration = value
      assert(node_info.common_key_expiration == -1, "CASE:2-12-4")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-12-4 Error")
    end
  end

  # テスト対象メソッド：init_key
  test "CASE:2-13 init_key" do
    # 正常ケース（ローカルノード以外）
    begin
      password = 'oredayooreoreore'
      error_pw = 'oredayone?'
      node_info = ConnectionNodeInfo.new(message_xml.root)
      # キー生成
      before_public_key = node_info.public_key
      before_common_key = node_info.common_key
      # キー初期化
      node_info.init_key
      # キー再生成
      after_public_key = node_info.public_key
      after_common_key = node_info.common_key
      #　キー判定
      assert(before_public_key.to_s != after_public_key.to_s, "CASE:2-13-1")
      assert(before_common_key.to_s != after_common_key.to_s, "CASE:2-13-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-13 Error")
    end
  end
  
  # メッセージ生成
  def message_xml
    xml_str = '<node>'
    xml_str += '<node_id>LOCAL</node_id>'
    xml_str += '<key_lifetime>3d</key_lifetime>'
    xml_str += '<address>'
    xml_str += '<key_sharing>http://localhost:3001/messaging/key_sharing</key_sharing>'
    xml_str += '<destination>http://localhost:3001/messaging/msg_receiver</destination>'
    xml_str += '</address>'
    xml_str += '<account>'
    xml_str += '<sending>'
    xml_str += '<id>AccessManagement</id>'
    xml_str += '<password>oredayooreoreore</password>'
    xml_str += '</sending>'
    xml_str += '<receiving>'
    xml_str += '<password_hash>j0HKUatWlPfSot60hHSVA22GjLC0xuS2U7i8Q4h5mv8=</password_hash>'
    xml_str += '</receiving>'
    xml_str += '</account>'
    xml_str += '</node>'
    return REXML::Document.new(xml_str)
  end
end