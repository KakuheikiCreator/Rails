# -*- coding: utf-8 -*-
###############################################################################
# 肩書きキャッシュクラス
# 機能：新聞データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/27 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 新聞データモデルキャッシュクラス
  class NewspaperCache
    include Singleton
    # アクセサー
    attr_reader :newspaper_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 肩書きデータモデルリスト
      @newspaper_list = nil
      # 肩書きデータモデルハッシュ
      @newspaper_hash = nil
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
      new_newspaper_list = Newspaper.order('id ASC')
      new_newspaper_hash = Hash.new
      new_newspaper_list.each do |ent|
        new_newspaper_hash[ent.id] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @newspaper_list = new_newspaper_list
        @newspaper_hash = new_newspaper_hash
      end
    end
    
    # 存在チェック
    def exist?(newspaper_id)
      return false unless Integer === newspaper_id
      return @newspaper_hash.key?(newspaper_id)
    end
    
    # データモデル取得
    def [](newspaper_id)
      return false unless Integer === newspaper_id
      return @newspaper_hash[newspaper_id]
    end
  end
end