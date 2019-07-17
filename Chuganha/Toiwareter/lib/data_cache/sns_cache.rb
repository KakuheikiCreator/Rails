# -*- coding: utf-8 -*-
###############################################################################
# SNSキャッシュクラス
# 機能：SNSデータモデルのキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/27 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # SNSデータモデルキャッシュクラス
  class SnsCache
    include Singleton
    # アクセサー
    attr_reader :sns_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 肩書きデータモデルリスト
      @sns_list = nil
      # 肩書きデータモデルハッシュ
      @sns_hash = nil
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
      new_sns_list = Sns.order('id ASC')
      new_sns_hash = Hash.new
      new_sns_list.each do |ent|
        new_sns_hash[ent.id] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @sns_list = new_sns_list
        @sns_hash = new_sns_hash
      end
    end
    
    # 存在チェック
    def exist?(sns_id)
      return false unless Integer === sns_id
      return @sns_hash.key?(sns_id)
    end
    
    # データモデル取得
    def [](sns_id)
      return false unless Integer === sns_id
      return @sns_hash[sns_id]
    end
  end
end