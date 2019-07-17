# -*- coding: utf-8 -*-
###############################################################################
# 規制リファラー情報キャッシュクラス
# 機能：規制リファラー情報のキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'
require 'common/validation_chk_module'
require 'data_cache/system_cache'

module DataCache
  # 規制リファラー情報キャッシュクラス
  class RegulationReferrerCache
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
      # 規制リファラー情報リスト
      @referrer_list = nil
      @regexp_referrer_list = nil
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
      new_referrer_list = new_system.regulation_referrer(true)
      new_regexp_referrer_list = []
      new_referrer_list.each do |ent|
        begin
          new_regexp_referrer_list.push(Regexp.new(ent.referrer))
        rescue RegexpError => ex
          raise 'RegulationReferrerCache Data Load Error Referrer:' + ent.referrer.to_s
        end
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @system = new_system
        @referrer_list = new_referrer_list
        @regexp_referrer_list = new_regexp_referrer_list
      end
    end
    
    # 規制対象チェック
    def regulation?(referrer)
      return false if referrer.nil?
      # クリティカルセクションの実行
      @mutex.synchronize do
        @regexp_referrer_list.each do |reg_referrer| return true unless (reg_referrer =~ referrer).nil? end
        return false
      end
    end
  end
end