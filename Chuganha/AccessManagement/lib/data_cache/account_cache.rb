# -*- coding: utf-8 -*-
###############################################################################
# アカウント情報キャッシュクラス
# 機能：設定ファイルから読み込んだアカウント情報のキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/01 Nakanohito
# 更新日:
###############################################################################
require 'base64'
require 'openssl'
require 'singleton'
require 'yaml'

module DataCache
  # アカウント情報キャッシュクラス
  class AccountCache
    include Singleton
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # アカウント情報ロードパス
      @load_path = Rails.root.join('config', 'business', 'accounts.yml').to_s
      # アカウント情報データ
      @account_infos = nil
      # データをメモリに展開
      data_load
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    
    # データロード処理
    def data_load
      # Account Info File Load
      load_data = YAML.load_file(@load_path)
      # クリティカルセクションの実行
      @mutex.synchronize do
        @account_infos = load_data
      end
    end
    
    # アカウント照会
    def valid_account?(id, password)
      return false if id.nil? || password.nil?
      account = nil
      @mutex.synchronize do
        account = @account_infos[id]
      end
      return false if account.nil?
      return account['password'] == Base64::strict_encode64(OpenSSL::Digest::SHA256.digest(password))
    end
  end
end