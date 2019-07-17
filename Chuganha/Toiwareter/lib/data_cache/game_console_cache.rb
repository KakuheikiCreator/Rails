# -*- coding: utf-8 -*-
###############################################################################
# ゲーム機キャッシュクラス
# 機能：ゲーム機データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/26 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # ゲーム機データモデルキャッシュクラス
  class GameConsoleCache
    include Singleton
    # アクセサー
    attr_reader :game_console_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 電子掲示板データモデルリスト
      @game_console_list = nil
      # 電子掲示板データモデルハッシュ
      @game_console_hash = nil
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
      new_game_console_list = GameConsole.order('id ASC')
      new_game_console_hash = Hash.new
      new_game_console_list.each do |ent|
        new_game_console_hash[ent.id] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @game_console_list = new_game_console_list
        @game_console_hash = new_game_console_hash
      end
    end
    
    # 存在チェック
    def exist?(game_console_id)
      return false unless Integer === game_console_id
      return @game_console_hash.key?(game_console_id)
    end
    
    # データモデル取得
    def [](game_console_id)
      return false unless Integer === game_console_id
      return @game_console_hash[game_console_id]
    end
  end
end