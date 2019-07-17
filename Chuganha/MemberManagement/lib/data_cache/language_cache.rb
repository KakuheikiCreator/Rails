# -*- coding: utf-8 -*-
###############################################################################
# 言語キャッシュクラス
# 機能：言語データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/21 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 言語データモデルキャッシュクラス
  class LanguageCache
    include Singleton
    # アクセサー
    attr_reader :language_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 言語データモデルリスト
      @language_list = nil
      # 言語データハッシュモデルリスト
      @lang_cd_hash = nil
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
      new_language_list = Language.order('lang_name_cd ASC')
      new_lang_cd_hash  = Hash.new
      new_language_list.each do |ent|
        new_lang_cd_hash[ent.lang_name_cd] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @language_list = new_language_list
        @lang_cd_hash  = new_lang_cd_hash
      end
    end
    
    # 存在チェック
    def exist?(lang_name_cd)
      return @lang_cd_hash.key?(lang_name_cd)
    end
    
    # ロケール情報でエンティティ取得
    def locale_ent
      return @lang_cd_hash[I18n.locale.to_s[0..2]]
    end
    
    # 言語名コードでエンティティ取得
    def [](lang_name_cd)
      return @lang_cd_hash[lang_name_cd.to_s]
    end
  end
end