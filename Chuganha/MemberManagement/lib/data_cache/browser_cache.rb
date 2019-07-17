# -*- coding: utf-8 -*-
###############################################################################
# ブラウザキャッシュクラス
# 機能：ブラウザおよびブラウザバージョンのキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/04 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # ブラウザキャッシュクラス
  class BrowserCache
    include Singleton
    # アクセサー
    attr_reader :loaded_at, :browser_data
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # Logger
      @logger = Rails.logger
      # キャッシュデータロード日時
      @loaded_at = nil
      # ブラウザデータ
      @browser_data = nil
      # ブラウザ名をキーとしてブラウザを格納するハッシュ
      @browser_hash = nil
      # ブラウザ名をキーとしてブラウザバージョン配列を格納するハッシュ
      @browser_version_hash = nil
      # データをメモリに展開
      data_load
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # データロード処理
    def data_load
      # キャッシュロード日時
      loaded_at = Time.now
      # ブラウザ名をキーとしてブラウザを格納するハッシュ
      browser_hash = Hash.new
      # ブラウザ名をキーとしてブラウザバージョン配列を格納するハッシュ
      browser_version_hash = Hash.new
      # ブラウザのロード
      browsers = Browser.all
      # ハッシュへの格納処理
      browsers.each do |browser|
        name = browser.browser_name
        browser_hash[name] = browser
        # バージョン情報ハッシュの作成
        version_hash = Hash.new
        version_list = browser.browser_version(true)
        version_list.each do |version_info|
          version_hash[version_info.browser_version] = version_info
        end
        browser_version_hash[name] = version_hash
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        # キャッシュロード日時
        @loaded_at = loaded_at
        # ブラウザデータ
        @browser_data = browsers
        # ブラウザ名をキーとしてブラウザを格納するハッシュ
        @browser_hash = browser_hash
        # ブラウザ名をキーとしてブラウザバージョン配列を格納するハッシュ
        @browser_version_hash = browser_version_hash
      end
    end
    
    # ブラウザの取得
    def get_info(name)
      return nil if name.nil?
      # クリティカルセクションの実行
      @mutex.synchronize do
        return @browser_hash[name]
      end
    end
    
    # ブラウザバージョンの取得
    def get_version_info(name, version)
      return nil if name.nil?
      # クリティカルセクションの実行
      @mutex.synchronize do
        browser_version_hash = @browser_version_hash[name]
        return nil if browser_version_hash.nil?
        # バージョン情報の検索
        return browser_version_hash[version]
      end
    end
    
    # ブラウザバージョンの取得
    def add_info(name, version)
      return nil if name.nil?
      # クリティカルセクションの実行
      @mutex.synchronize do
        browser = nil
        browser_version = nil
        # トランザクションの開始
        ActiveRecord::Base.transaction do
          # ブラウザの登録
          browser = add_browser(name)
          # ブラウザバージョンの登録
          browser_version = add_browser_version(browser, version)
        end
        return [browser, browser_version]
      end
    end
    
    ###########################################################################
    # protectesdメソッド定義
    ###########################################################################
    protected
    
    # ブラウザの登録
    def add_browser(name)
      # ブラウザの検索
      browser = @browser_hash[name]
      return browser unless browser.nil?
      # ブラウザの検索
      browsers = Browser.where(:browser_name => name)
      browser = browsers[0]
      unless browser.nil? then
        @browser_hash[name] = browser
        return browser
      end
      # ブラウザの登録
      begin
        browser = Browser.new(:browser_name => name)
        browser.save!
        @browser_hash[name] = browser
        return browser
      rescue ActiveRecord::ActiveRecordError => ex
        @logger.error('Browser Persistence Error')
        @logger.error('Exception:' + ex.class.name)
        @logger.error('Message  :' + ex.message)
        @logger.error('Backtrace:' + ex.backtrace.join("\n"))
        return nil
      end
    end
    
    # ブラウザバージョンの登録
    def add_browser_version(parents, version)
      # ハッシュの検索
      version_hash = @browser_version_hash[parents.browser_name]
      if version_hash.nil? then
        version_hash = Hash.new
        @browser_version_hash[parents.browser_name] = version_hash
      else
        version_info = version_hash[version]
        return version_info unless version_info.nil?
      end
      # ブラウザバージョンの検索
      version_infos = BrowserVersion.where(:browser_id => parents.id,
                                           :browser_version => version)
      version_info = version_infos[0]
      unless version_info.nil? then
        version_hash[version] = version_info
        return version_info
      end
      # ブラウザバージョンの登録
      begin
        version_info = BrowserVersion.new(:browser_id => parents.id,
                                          :browser_version => version)
        version_info.save!
        version_hash[version] = version_info
        return version_info
      rescue ActiveRecord::ActiveRecordError => ex
        @logger.error('BrowserVersion Persistence Error')
        @logger.error('Exception:' + ex.class.name)
        @logger.error('Message  :' + ex.message)
        @logger.error('Backtrace:' + ex.backtrace.join("\n"))
        return nil
      end
    end
  end
end