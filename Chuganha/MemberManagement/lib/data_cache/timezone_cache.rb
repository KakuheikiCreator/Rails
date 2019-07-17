# -*- coding: utf-8 -*-
###############################################################################
# タイムゾーンキャッシュクラス
# 機能：タイムゾーンデータモデルのキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/21 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # タイムゾーンデータモデルキャッシュクラス
  class TimezoneCache
    include Singleton
    # アクセサー
    attr_reader :timezone_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # タイムゾーンデータモデルリスト
      @timezone_list = nil
      # タイムゾーンデータモデルリスト
      @timezone_hash = nil
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
      new_timezone_list = Timezone.order('timezone_id ASC')
      new_timezone_hash = Hash.new
      new_timezone_list.each do |ent|
        new_timezone_hash[ent.timezone_id] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @timezone_list = new_timezone_list
        @timezone_hash = new_timezone_hash
      end
    end
    
    # 存在チェック
    def exist?(timezone_id)
      return @timezone_hash.key?(timezone_id)
    end
    
    # データモデル取得
    def [](timezone_id)
      return @timezone_hash[timezone_id]
    end
  end
end