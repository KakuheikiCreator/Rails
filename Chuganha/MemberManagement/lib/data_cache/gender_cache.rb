# -*- coding: utf-8 -*-
###############################################################################
# 性別キャッシュクラス
# 機能：性別データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/21 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 性別データモデルキャッシュクラス
  class GenderCache
    include Singleton
    # アクセサー
    attr_reader :gender_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 性別データモデルリスト
      @gender_list = nil
      # 性別データモデルハッシュ
      @gender_hash = nil
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
      new_gender_list = Gender.order('gender_cls DESC')
      new_gender_hash = Hash.new
      new_gender_list.each do |ent|
        new_gender_hash[ent.gender_cls] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @gender_list = new_gender_list
        @gender_hash = new_gender_hash
      end
    end
    
    # 存在チェック
    def exist?(gender_cls)
      return @gender_hash.key?(gender_cls)
    end
    
    # データモデル取得
    def [](gender_cls)
      return @gender_hash[gender_cls]
    end
  end
end