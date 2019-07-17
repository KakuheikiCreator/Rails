# -*- coding: utf-8 -*-
###############################################################################
# NGワードキャッシュクラス
# 機能：NGワードデータモデルのキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/14 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'
require 'data_cache/data_updated_cache'

module DataCache
  # NGワードデータモデルキャッシュクラス
  class NgWordCache
    include Singleton
    # アクセサー
    attr_reader :ng_word_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 権限データモデルリスト
      @ng_word_list = nil
      # 権限データモデルハッシュ
      @replace_word_hash = nil
      # キャッシュデータロード日時
      @loaded_at = nil
      # キャッシュデータロードバージョン
      @loaded_version = nil
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
      new_ng_word_list = NgWord.order('ng_word ASC')
      new_replace_word_hash = Hash.new
      new_ng_word_list.each do |ent|
        new_replace_word_hash[ent.ng_word] = ent.replace_word
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @loaded_version = DataUpdatedCache.instance.current_version(:ng_word)
        @ng_word_list = new_ng_word_list
        @replace_word_hash = new_replace_word_hash
      end
    end
    
    # リフレッシュ
    def refresh?
      # クリティカルセクションの実行
      @mutex.synchronize do
        cache = DataUpdatedCache.instance
        return false unless cache.data_update?(:ng_word, @loaded_version)
      end
      data_load
    end
    
    # 存在チェック
    def exist?(ng_word)
      # クリティカルセクションの実行
      @mutex.synchronize do
        @ng_word_list.each do |target|
          return true unless target.index(ng_word).nil?
        end
        return false
      end
    end
    
    # 置換処理
    def replacement(original)
      return original unless String === original
      # クリティカルセクションの実行
      @mutex.synchronize do
        rep_sentence = original
        @ng_word_list.each do |ng_word_ent|
          rep_sentence = rep_sentence.gsub(ng_word_ent.ng_word, ng_word_ent.replace_word)
        end
        return rep_sentence
      end
    end
  end
end