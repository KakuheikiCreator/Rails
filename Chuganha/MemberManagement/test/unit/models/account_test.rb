# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：機能
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/17 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'common/code_conv/code_converter'
require 'data_cache/account_cache'

class AccountTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Common::CodeConv
  include DataCache
  
  # 前処理
  def setup
    ActiveRecord::Base.transaction do
      100000.times do |idx|
        account = generate_ent(idx)
        account.save!
      end
    end
  end
  
  # メモリ占有量チェック
  test "3-1:Memory Size Test" do
    # 10万件展開
    begin
#      account_hsh = Hash.new
#      100000.times do |idx|
#        account = generate_ent(idx)
#        account.save!
#        account_hsh[idx] = account
#        account_hsh[idx] = AccountData.new(account)
#        account_hsh[idx] = generate_data
#      end
      AccountCache.instance
      GC.start
      sleep(10)
#      print_log("Account Hash   Size:" + account_hsh.size.to_s)
#      memory_size = memsize(Account.class)
#      memory_size = memsize(Account.class)
#      print_log("Account Memory Size:" + memory_size.to_s)
#      memory_size = memsize(AccountCache.class)
#      print_log("Cache   Memory Size:" + memory_size.to_s)
#      memory_size = memsize(AccountCache::AccountData.class)
#      print_log("Data    Memory Size:" + memory_size.to_s)
#      memory_size = memsize(AccountData.class)
#      print_log("Account Memory Size:" + memory_size.to_s)
#      hash_size = memsize(Hash.class)
#      print_log("Hash    Memory Size:" + memory_size.to_s)
      memory_size = memsize(false)
      print_log("All of  Memory Size:" + memory_size.to_s)
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Trace    :" + ex.backtrace.join("\n"))
      flunk("CASE:3-1-1")
    end
  end
  
  # アカウントエンティティ生成
  def generate_ent(idx)
    converter = CodeConverter.instance
    salt = converter.hash_salt
    ent = Account.new
    ent.user_id = 'abcdefghijklmnopqrstuvwxyz' + idx.to_s
    ent.hsh_password = converter.hash('abcdefghijklmnopqrstuvwxyz012345', salt)
    ent.member_state_id = 100
    ent.enc_authority_cls = converter.encryption('ADM')
    ent.enc_email = converter.encryption('abcdefg.hijklmnop.qrstuvwxyz@nifty.com')
    ent.join_date = Time.now
    ent.hsh_password_reset_cd = converter.hash('abcdefghijklmnopqrstuvwxyz012345', salt)
    ent.last_seq_no = 1000
    ent.consecutive_failure_cnt = 100
    ent.salt = salt
    return ent
  end
  
  # アカウントデータ生成
  def generate_data
    converter = CodeConverter.instance
    salt = converter.hash_salt
    data = AccountData.new
    data.id = 1000
    data.user_id = 'abcdefghijklmnopqrstuvwxyz012345'
    data.hsh_password = converter.hash('abcdefghijklmnopqrstuvwxyz012345', salt)
    data.member_state_id = 100
    data.consecutive_failure_cnt = 100
    return data
  end

    # アカウントデータクラス定義
    class AccountData
      # アクセサー定義
#      attr_reader :id, :user_id, :member_state_id, :consecutive_failure_cnt
      attr_accessor :id, :user_id, :hsh_password, :member_state_id, :consecutive_failure_cnt
      # コンストラクタ
      def initialize(ent)
        # アカウント情報
        @id = ent.id
        @user_id = ent.user_id
        @hsh_password = ent.hsh_password
        @member_state_id = ent.member_state_id
        @consecutive_failure_cnt = ent.consecutive_failure_cnt
#        @id = nil
#        @user_id = nil
#        @hsh_password = nil
#        @member_state_id = nil
#        @consecutive_failure_cnt = nil
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # アカウントモデル取得
      def account
        return Account.find(@id)
      end
      
      # 連続認証回数カウントアップ
      def failer_count_up(lock_threshold=5)
        @consecutive_failure_cnt += 1
      end
      
      # 連続認証回数カウントアップ
      def reset_failer_count
        @consecutive_failure_cnt = 0
      end
    end
end
