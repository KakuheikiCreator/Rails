# -*- coding: utf-8 -*-
###############################################################################
# 規制クッキー情報キャッシュクラス
# 機能：規制クッキー情報のキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'
require 'common/validation_chk_module'
require 'data_cache/system_cache'

module DataCache
  # 規制クッキー情報キャッシュクラス
  class RegulationCookieCache
    include Singleton
    include Common::ValidationChkModule
    # アクセサー
    attr_reader :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 自システム取得
      @system = nil
      # 規制クッキー情報リスト
      @regulation_cookie_list = nil
      @regexp_cookie_list = nil
      # キャッシュデータロード日時
      @loaded_at = nil
      # データをメモリに展開
      data_load
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # データロード処理
    def data_load
      loaded_at = Time.now
      new_system = SystemCache.instance.get_system
      new_regulation_cookie_list = new_system.regulation_cookie(true)
      new_regexp_cookie_list = []
      new_regulation_cookie_list.each do |ent|
        begin
          new_regexp_cookie_list.push(Regexp.new(ent.cookie))
        rescue RegexpError => ex
          raise 'RegulationCookieCache Data Load Error Cookie:' + ent.cookie.to_s
        end
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @system = new_system
        @regulation_cookie_list = new_regulation_cookie_list
        @regexp_cookie_list = new_regexp_cookie_list
      end
    end
    
    # 規制対象チェック
    def regulation?(cookie)
      return false if cookie.nil?
      # クリティカルセクションの実行
      @mutex.synchronize do
        @regexp_cookie_list.each do |reg_cookie| return true unless (reg_cookie =~ cookie).nil? end
        return false
      end
    end
  end
end