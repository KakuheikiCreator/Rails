# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：規制ホスト情報クラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'

class RegulationHostTest < ActiveSupport::TestCase
  include UnitTestUtil
  # 基本機能テスト
  # 登録・検索・更新・削除のテストを行う
  test "2-1:Basic functions Test" do
    # 登録
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.proxy_host = '^test\.infoweb\.ne\.jp'
      assert(info.save!, "CASE:2-1-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # 検索
    infos = RegulationHost.where(:proxy_host => '^test\.infoweb\.ne\.jp')
    assert(infos.length == 1, "CASE:2-1-2")
    # 更新
    begin
      info = infos[0]
      info.proxy_host = '^minagorosi\.com'
      assert(info.save!, "CASE:2-1-3")
      infos = RegulationHost.where(:proxy_host => '^test\.infoweb\.ne\.jp')
      assert(infos.length == 0, "CASE:2-1-3")
      infos = RegulationHost.where(:proxy_host => '^minagorosi\.com')
      assert(infos.length == 1, "CASE:2-1-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # 削除
    begin
      result = RegulationHost.where(:proxy_host => '^minagorosi\.com').destroy_all
      assert(result.length == 1, "CASE:2-1-4")
      result = RegulationHost.where(:proxy_host => '^minagorosi\.com')
      assert(result.length == 0, "CASE:2-1-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
  end
  
  # 検索（関連）テスト
  # テーブル間の関連のテストを行う
  test "2-2:Relationship Test" do
    # システム
    infos = RegulationHost.where(:proxy_host => '^proxy1\.ne\.jp$')
    info = infos[0].system
    assert(System === info , "CASE:2-2-1")
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-3:Validation Test:system_id" do
    # 必須チェック
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.proxy_host = '^infoweb\.ne\.jp'
      assert(info.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-1")
    end
    begin
      info = RegulationHost.new
      info.system_id = nil
      info.proxy_host = '^infoweb\.ne\.jp'
      assert(!info.valid?, "CASE:2-3-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-3-1")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-4:Validation Test:proxy_host" do
    # 必須チェック
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.proxy_host = '^infoweb\.ne\.jp'
      assert(info.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-1")
    end
    begin
      info = RegulationHost.new
      info.system_id = 1
      assert(!info.valid?, "CASE:2-4-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-1")
    end
    # 文字数チェック
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.proxy_host = "^test\.infoweb\.ne\.jp"
      assert(info.valid?, "CASE:2-4-2-1")
      info.proxy_host = "^" + generate_str(CHAR_SET_ALPHABETIC, 60) + "\." +
                        generate_str(CHAR_SET_ALPHABETIC, 62) + "\." +
                        generate_str(CHAR_SET_ALPHABETIC, 62) + "\." +
                        generate_str(CHAR_SET_ALPHABETIC, 60) + "\.jp"
      assert(info.valid?, "CASE:2-4-2-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-2")
    end
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.proxy_host = "^" + generate_str(CHAR_SET_ALPHABETIC, 61) + "\\." +
                        generate_str(CHAR_SET_ALPHABETIC, 62) + "\\." +
                        generate_str(CHAR_SET_ALPHABETIC, 62) + "\\." +
                        generate_str(CHAR_SET_ALPHABETIC, 60) + "\\.jp"
      assert(!info.valid?, "CASE:2-4-2-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-2")
    end
    # 正規表現チェック
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.proxy_host = "^["
      assert(!info.valid?, "CASE:2-4-3")
      info.proxy_host = "^[\.jp"
      assert(!info.valid?, "CASE:2-4-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-3")
    end
    # 項目関連チェック（プロキシもしくはリモートホストのいずれか必須入力）
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.proxy_host = 'test.infoweb.ne.jp'
      info.proxy_ip_address = nil
      info.remote_host = nil
      info.ip_address = nil
      assert(info.valid?, "CASE:2-4-4")
      info.proxy_host = nil
      info.proxy_ip_address = '192.168.100.100'
      info.remote_host = nil
      info.ip_address = nil
      assert(info.valid?, "CASE:2-4-4")
      info.proxy_host = nil
      info.proxy_ip_address = nil
      info.remote_host = 'test.infoweb.ne.jp'
      info.ip_address = nil
      assert(info.valid?, "CASE:2-4-4")
      info.proxy_host = nil
      info.proxy_ip_address = nil
      info.remote_host = nil
      info.ip_address = '192.168.100.100'
      assert(info.valid?, "CASE:2-4-4")
      info.proxy_host = 'test.infoweb.ne.jp'
      info.proxy_ip_address = '192.168.100.100'
      info.remote_host = 'test.infoweb.ne.jp'
      info.ip_address = '192.168.100.100'
      assert(info.valid?, "CASE:2-4-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-4")
    end
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.proxy_host = nil
      info.proxy_ip_address = nil
      info.remote_host = nil
      info.ip_address = nil
      assert(!info.valid?, "CASE:2-4-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-4-4")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-5:Validation Test:proxy_ip_address" do
    # 必須チェック
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.proxy_ip_address = '1.10.100.100'
      assert(info.valid?, "CASE:2-5-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-5-1")
    end
    # フォーマットチェック
    begin
      # 正常ケース
      info = RegulationHost.new
      info.system_id = 1
      info.proxy_ip_address = '0.0.0.0'
      assert(info.valid?, "CASE:2-5-2-1")
      info.proxy_ip_address = '1.10.100.100'
      assert(info.valid?, "CASE:2-5-2-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-5-2")
    end
    begin
      # 異常ケース
      info = RegulationHost.new
      info.system_id = 1
      info.proxy_ip_address = '0.0.0.0.0'
      assert(!info.valid?, "CASE:2-5-2")
      info.proxy_ip_address = '0.0.a.0'
      assert(!info.valid?, "CASE:2-5-2")
      info.proxy_ip_address = '0.0.0'
      assert(!info.valid?, "CASE:2-5-2")
      info.proxy_ip_address = '0.256.0.0'
      assert(!info.valid?, "CASE:2-5-2")
      info.proxy_ip_address = '0.0.0.256'
      assert(!info.valid?, "CASE:2-5-2")
      info.proxy_ip_address = '0.1000.0.0'
      assert(!info.valid?, "CASE:2-5-2")
      info.proxy_ip_address = '0.0.0.1000'
#      info.valid?
#      f = File::open("log.txt", "a") # 追加モード
#      f.error_log("Message   :", info.errors.full_messages, "\n")
#      f.close
      assert(!info.valid?, "CASE:2-5-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-5-2")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-6:Validation Test:remote_host" do
    # 必須チェック
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.remote_host = 'infoweb.ne.jp'
      assert(info.valid?, "CASE:2-6-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-6-1")
    end
    # 文字数チェック
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.remote_host = "test.infoweb.ne.jp"
      assert(info.valid?, "CASE:2-6-2-1")
      info.remote_host = "^" + generate_str(CHAR_SET_ALPHABETIC, 60) + "\\." +
                         generate_str(CHAR_SET_ALPHABETIC, 62) + "\\." +
                         generate_str(CHAR_SET_ALPHABETIC, 62) + "\\." +
                         generate_str(CHAR_SET_ALPHABETIC, 60) + "\\.jp"
      assert(info.valid?, "CASE:2-6-2-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-6-2")
    end
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.remote_host = "^" + generate_str(CHAR_SET_ALPHABETIC, 61) + "\\." +
                         generate_str(CHAR_SET_ALPHABETIC, 62) + "\\." +
                         generate_str(CHAR_SET_ALPHABETIC, 62) + "\\." +
                         generate_str(CHAR_SET_ALPHABETIC, 60) + "\\.jp"
                         
      assert(info.remote_host.length == 256, "CASE:2-6-2-3")
      assert(!info.valid?, "CASE:2-6-2-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-6-2")
    end
    # 正規表現チェック
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.remote_host = "^["
      assert(!info.valid?, "CASE:2-6-3")
      info.remote_host = "^[\.jp"
      assert(!info.valid?, "CASE:2-6-3")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-6-3")
    end
  end
  
  # バリデーションテスト
  # バリデーションチェックのテストを行う
  test "2-7:Validation Test:ip_address" do
    # 必須チェック
    begin
      info = RegulationHost.new
      info.system_id = 1
      info.ip_address = '1.10.100.100'
      assert(info.valid?, "CASE:2-7-1")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-1")
    end
    # フォーマットチェック
    begin
      # 正常ケース
      info = RegulationHost.new
      info.system_id = 1
      info.ip_address = '0.0.0.0'
      assert(info.valid?, "CASE:2-7-2-1")
      info.ip_address = '1.10.100.100'
      assert(info.valid?, "CASE:2-7-2-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-2")
    end
    begin
      # 異常ケース
      info = RegulationHost.new
      info.system_id = 1
      info.ip_address = '0.0.0.0.0'
      assert(!info.valid?, "CASE:2-7-2")
      info.ip_address = '0.0.a.0'
      assert(!info.valid?, "CASE:2-7-2")
      info.ip_address = '0.0.0'
      assert(!info.valid?, "CASE:2-7-2")
      info.ip_address = '0.256.0.0'
      assert(!info.valid?, "CASE:2-7-2")
      info.ip_address = '0.0.0.256'
      assert(!info.valid?, "CASE:2-7-2")
      info.ip_address = '0.1000.0.0'
      assert(!info.valid?, "CASE:2-7-2")
      info.ip_address = '0.0.0.1000'
#      info.valid?
#      f = File::open("log.txt", "a") # 追加モード
#      f.error_log("Message   :", info.errors.full_messages, "\n")
#      f.close
      assert(!info.valid?, "CASE:2-7-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-7-2")
    end
  end
  
  # 検索条件生成テスト
  # 検索条件のリスト生成テストを行う
  test "2-8:search_condition Test:" do
    # 正常：検索条件なし
    begin
      ent = RegulationHost.new
      cond_list = ent.search_condition
      assert(cond_list.size == 0, "CASE:2-8-01-1")
      # 検索チェック
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 11, "CASE:2-8-01-2")
      id_list = [1,2,3,4,5,6,7,8,9,10,11]
      idx = 0
      result_list.each do |res_ent|
        assert(res_ent.id == id_list[idx], "CASE:2-8-01-3")
        idx += 1
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-01")
    end
    # 正常：システムID
    begin
      ent = RegulationHost.new
      ent.system_id = 1
      cond_list = ent.search_condition
      assert(cond_list.size == 2, "CASE:2-8-02-1")
      assert(cond_list[0] == 'system_id = ?', "CASE:2-8-02-2")
      assert(cond_list[1] == 1, "CASE:2-8-02-3")
      # 検索チェック
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 10, "CASE:2-8-02-4")
      id_list = [1,2,3,4,5,6,7,8,10,11]
      idx = 0
      result_list.each do |res_ent|
        assert(res_ent.id == id_list[idx], "CASE:2-8-02-5")
        idx += 1
      end
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-02")
    end
    # 正常：リモートホスト（プロキシ）
    begin
      ent = RegulationHost.new
      ent.proxy_host = '^proxy2\.ne\.%_\\jp$'
      cond_list = ent.search_condition
      assert(cond_list.size == 2, "CASE:2-8-03-1")
      assert(cond_list[0] == 'proxy_host like ?', "CASE:2-8-03-2")
      assert(cond_list[1] == '%^proxy2\\\\.ne\\\\.\%\_\\\\jp$%', "CASE:2-8-03-3")
      # 検索チェック
      ent.proxy_host = '^proxy2\.ne\.jp$'
      result_list = RegulationHost.search_list(ent)
#      Rails.logger.debug('result_list.size:' + result_list.size.to_s)
      assert(result_list.size == 1, "CASE:2-8-03-4")
      assert(result_list[0].id == 2, "CASE:2-8-03-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-03")
    end
    # 正常：IPアドレス（プロキシ）
    begin
      ent = RegulationHost.new
      ent.proxy_ip_address = '%_\\192.168.254.3'
      cond_list = ent.search_condition
      assert(cond_list.size == 2, "CASE:2-8-04-1")
      assert(cond_list[0] == 'proxy_ip_address like ?', "CASE:2-8-04-2")
      assert(cond_list[1] == '%\%\_\\\\192.168.254.3%', "CASE:2-8-04-3")
      # 検索チェック
      ent.proxy_ip_address = '192.168.254.3'
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 1, "CASE:2-8-04-4")
      assert(result_list[0].id == 3, "CASE:2-8-04-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-04")
    end
    # 正常：リモートホスト（クライアント）
    begin
      ent = RegulationHost.new
      ent.remote_host = '^client4\.%_\\ne\.jp$'
      cond_list = ent.search_condition
      assert(cond_list.size == 2, "CASE:2-8-05-1")
      assert(cond_list[0] == 'remote_host like ?', "CASE:2-8-05-2")
      assert(cond_list[1] == '%^client4\\\\.\%\_\\\\ne\\\\.jp$%', "CASE:2-8-05-3")
      # 検索チェック
      ent.remote_host = '^client4\.ne\.jp$'
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 1, "CASE:2-8-05-4")
      assert(result_list[0].id == 4, "CASE:2-8-05-5")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-05")
    end
    # 正常：IPアドレス（クライアント）
    begin
      ent = RegulationHost.new
      ent.ip_address = '192.168.255.7_%\\'
      cond_list = ent.search_condition
      assert(cond_list.size == 2, "CASE:2-8-06-1")
      assert(cond_list[0] == 'ip_address like ?', "CASE:2-8-06-2")
      assert(cond_list[1] == '%192.168.255.7\_\%\\\\%', "CASE:2-8-06-3")
      # 検索チェック
      ent.ip_address = '192.168.255.7'
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 1, "CASE:2-8-06-4")
      assert(result_list[0].id == 7, "CASE:2-8-06-4")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-06")
    end
    # 正常：備考
    begin
      ent = RegulationHost.new
      ent.remarks = 'MyString'
      cond_list = ent.search_condition
      assert(cond_list.size == 2, "CASE:2-8-07-1")
      assert(cond_list[0] == 'remarks like ?', "CASE:2-8-07-2")
      assert(cond_list[1] == '%MyString%', "CASE:2-8-07-3")
      # 検索チェック
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 11, "CASE:2-8-07-4")
      id_list = [1,2,3,4,5,6,7,8,9,10,11]
      idx = 0
      result_list.each do |res_ent|
        assert(res_ent.id == id_list[idx], "CASE:2-8-07-5")
        idx += 1
      end
      # 検索チェック（その２）
      ent = RegulationHost.new
      ent.remarks = 'Error _%\ String'
      cond_list = ent.search_condition
      assert(cond_list.size == 2, "CASE:2-8-07-6")
      assert(cond_list[0] == 'remarks like ?', "CASE:2-8-07-7")
      assert(cond_list[1] == '%Error \_\%\\\\ String%', "CASE:2-8-07-8")
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 0, "CASE:2-8-07-9")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-07")
    end
    # 正常：システムID＋リモートホスト（プロキシ）
    begin
      ent = RegulationHost.new
      ent.system_id = 1
      ent.proxy_host = '^proxy4'
      cond_list = ent.search_condition
      assert(cond_list.size == 3, "CASE:2-8-08-1")
      assert(cond_list[0] == 'system_id = ? and proxy_host like ?', "CASE:2-8-08-2")
      assert(cond_list[1] == 1, "CASE:2-8-08-3")
      assert(cond_list[2] == '%^proxy4%', "CASE:2-8-08-4")
      # 検索チェック
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 1, "CASE:2-8-08-5")
      assert(result_list[0].id == 4, "CASE:2-8-08-6")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-08")
    end
    # 正常：システムID＋IPアドレス（プロキシ）
    begin
      ent = RegulationHost.new
      ent.system_id = 2
      ent.proxy_ip_address = '.168.254.9'
      cond_list = ent.search_condition
      assert(cond_list.size == 3, "CASE:2-8-09-1")
      assert(cond_list[0] == 'system_id = ? and proxy_ip_address like ?', "CASE:2-8-09-2")
      assert(cond_list[1] == 2, "CASE:2-8-09-3")
      assert(cond_list[2] == '%.168.254.9%', "CASE:2-8-09-4")
      # 検索チェック
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 1, "CASE:2-8-09-5")
      assert(result_list[0].id == 9, "CASE:2-8-09-6")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-09")
    end
    # 正常：システムID＋リモートホスト（クライアント）
    begin
      ent = RegulationHost.new
      ent.system_id = 1
      ent.remote_host = 'client6'
      cond_list = ent.search_condition
      assert(cond_list.size == 3, "CASE:2-8-10-1")
      assert(cond_list[0] == 'system_id = ? and remote_host like ?', "CASE:2-8-10-2")
      assert(cond_list[1] == 1, "CASE:2-8-10-3")
      assert(cond_list[2] == '%client6%', "CASE:2-8-10-4")
      # 検索チェック
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 1, "CASE:2-8-10-5")
      assert(result_list[0].id == 6, "CASE:2-8-10-6")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-10")
    end
    # 正常：システムID＋IPアドレス（クライアント）
    begin
      ent = RegulationHost.new
      ent.system_id = 1
      ent.ip_address = '68.255.5'
      cond_list = ent.search_condition
      assert(cond_list.size == 3, "CASE:2-8-11-1")
      assert(cond_list[0] == 'system_id = ? and ip_address like ?', "CASE:2-8-11-2")
      assert(cond_list[1] == 1, "CASE:2-8-11-3")
      assert(cond_list[2] == '%68.255.5%', "CASE:2-8-11-4")
      # 検索チェック
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 1, "CASE:2-8-11-5")
      assert(result_list[0].id == 5, "CASE:2-8-11-6")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-11")
    end
    # 正常：システムID＋備考
    begin
      ent = RegulationHost.new
      ent.system_id = 2
      ent.remarks = 'My'
      cond_list = ent.search_condition
      assert(cond_list.size == 3, "CASE:2-8-12-1")
      assert(cond_list[0] == 'system_id = ? and remarks like ?', "CASE:2-8-12-2")
      assert(cond_list[1] == 2, "CASE:2-8-12-3")
      assert(cond_list[2] == '%My%', "CASE:2-8-12-4")
      # 検索チェック
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 1, "CASE:2-8-12-5")
      assert(result_list[0].id == 9, "CASE:2-8-12-6")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-12")
    end
    # 正常：システムID＋リモートホスト（クライアント）＋備考
    begin
      ent = RegulationHost.new
      ent.system_id = 1
      ent.remote_host = '^[A]$'
      ent.remarks = 'String'
      cond_list = ent.search_condition
      assert(cond_list.size == 4, "CASE:2-8-13-1")
      assert(cond_list[0] == 'system_id = ? and remote_host like ? and remarks like ?', "CASE:2-8-13-2")
      assert(cond_list[1] == 1, "CASE:2-8-13-3")
      assert(cond_list[2] == '%^[A]$%', "CASE:2-8-13-4")
      assert(cond_list[3] == '%String%', "CASE:2-8-13-5")
      # 検索チェック
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 1, "CASE:2-8-13-6")
      assert(result_list[0].id == 8, "CASE:2-8-13-7")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-13")
    end
    # 正常：IPアドレス（プロキシ）＋備考
    begin
      ent = RegulationHost.new
      ent.proxy_ip_address = '255.168'
      ent.remarks = 'yStr'
      cond_list = ent.search_condition
      assert(cond_list.size == 3, "CASE:2-8-14-1")
      assert(cond_list[0] == 'proxy_ip_address like ? and remarks like ?', "CASE:2-8-14-2")
      assert(cond_list[1] == '%255.168%', "CASE:2-8-14-3")
      assert(cond_list[2] == '%yStr%', "CASE:2-8-14-4")
      # 検索チェック
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 1, "CASE:2-8-14-5")
      assert(result_list[0].id == 11, "CASE:2-8-14-6")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-14")
    end
    # 正常：全ての検索条件指定
    begin
      ent = RegulationHost.new
      ent.system_id = 1
      ent.proxy_host = '^proxy2\.ne\.jp$'
      ent.proxy_ip_address = '192.168.254.2'
      ent.remote_host = '^client2\.ne\.jp$'
      ent.ip_address = '192.168.255.2'
      ent.remarks = 'MyString'
      cond_list = ent.search_condition
      cond_str = ['system_id = ? and ',
                  'proxy_host like ? and ',
                  'proxy_ip_address like ? and ',
                  'remote_host like ? and ',
                  'ip_address like ? and ',
                  'remarks like ?'].join
      assert(cond_list.size == 7, "CASE:2-8-15-1")
      assert(cond_list[0] == cond_str, "CASE:2-8-15-2")
      assert(cond_list[1] == 1, "CASE:2-8-15-3")
      assert(cond_list[2] == '%^proxy2\\\\.ne\\\\.jp$%', "CASE:2-8-15-4")
      assert(cond_list[3] == '%192.168.254.2%', "CASE:2-8-15-5")
      assert(cond_list[4] == '%^client2\\\\.ne\\\\.jp$%', "CASE:2-8-15-6")
      assert(cond_list[5] == '%192.168.255.2%', "CASE:2-8-15-7")
      assert(cond_list[6] == '%MyString%', "CASE:2-8-15-8")
      # 検索チェック
      result_list = RegulationHost.search_list(ent)
      assert(result_list.size == 1, "CASE:2-8-15-9")
      assert(result_list[0].id == 2, "CASE:2-8-15-10")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-8-15")
    end
  end
  
  # 重複データ検索テスト
  # 重複データ検索テストを行う
  test "2-9:duplicate  Test:" do
    # 正常：値無し
    begin
      ent = RegulationHost.new
      cond_list = ent.generate_duplicate_condition
      assert(cond_list.size == 5, "CASE:2-9-1-1")
      assert(cond_list[:system_id].nil?, "CASE:2-9-1-2")
      assert(cond_list[:proxy_host].nil?, "CASE:2-9-1-3")
      assert(cond_list[:proxy_ip_address].nil?, "CASE:2-9-1-4")
      assert(cond_list[:remote_host].nil?, "CASE:2-9-1-5")
      assert(cond_list[:ip_address].nil?, "CASE:2-9-1-6")
      ent_list = RegulationHost.duplicate(ent)
      assert(ent_list.size == 0, "CASE:2-9-1-7")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-9-1")
    end
    # 正常：値有り
    begin
      ent = RegulationHost.new
      ent.system_id = 1
      ent.proxy_host = '^proxy6\.ne\.jp$'
      ent.proxy_ip_address = '192.168.254.6'
      ent.remote_host = '^client6\.ne\.jp$'
      ent.ip_address = nil
      ent.remarks = 'test remarks' # 検索条件に含まれない
      cond_list = ent.generate_duplicate_condition
      assert(cond_list.size == 5, "CASE:2-9-2-1")
      assert(cond_list[:system_id] == 1, "CASE:2-9-2-2")
      assert(cond_list[:proxy_host] == '^proxy6\.ne\.jp$', "CASE:2-9-2-3")
      assert(cond_list[:proxy_ip_address] == '192.168.254.6', "CASE:2-9-2-4")
      assert(cond_list[:remote_host] == '^client6\.ne\.jp$', "CASE:2-9-2-5")
      assert(cond_list[:ip_address].nil? , "CASE:2-9-2-6")
      ent_list = RegulationHost.duplicate(ent)
      assert(ent_list.size == 1, "CASE:2-9-2-7")
      assert(ent_list[0].id == 6, "CASE:2-9-2-8")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-9-2")
    end
  end
end
