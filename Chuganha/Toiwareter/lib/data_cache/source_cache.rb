# -*- coding: utf-8 -*-
###############################################################################
# 出所キャッシュクラス
# 機能：出所データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/24 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 出所データモデルキャッシュクラス
  class SourceCache
    include Singleton
    # アクセサー
    attr_reader :source_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 出所データモデルリスト
      @source_list = nil
      # 出所データモデルハッシュ
      @source_hash = nil
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
      new_source_list = Source.order('id ASC')
      new_source_hash = Hash.new
      new_source_list.each do |ent|
        new_source_hash[ent.id] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @source_list = new_source_list
        @source_hash = new_source_hash
      end
    end
    
    # 存在チェック（区分）
    def exist?(source_id)
      return false unless Integer === source_id
      return @source_hash.key?(source_id)
    end
    
    # データモデル取得
    def [](source_id)
      return false unless Integer === source_id
      return @source_hash[source_id]
    end
  end
end