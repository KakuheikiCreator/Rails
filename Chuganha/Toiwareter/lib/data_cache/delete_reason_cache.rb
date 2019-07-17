# -*- coding: utf-8 -*-
###############################################################################
# 削除理由キャッシュクラス
# 機能：削除理由データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/17 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 削除理由データモデルキャッシュクラス
  class DeleteReasonCache
    include Singleton
    # アクセサー
    attr_reader :delete_reason_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 削除理由データモデルリスト
      @delete_reason_list = nil
      # 削除理由データモデルハッシュ
      @delete_reason_hash = nil
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
      new_delete_reason_list = DeleteReason.order('id ASC')
      new_delete_reason_hash = Hash.new
      new_delete_reason_list.each do |ent|
        new_delete_reason_hash[ent.id] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @delete_reason_list = new_delete_reason_list
        @delete_reason_hash = new_delete_reason_hash
      end
    end
    
    # 存在チェック
    def exist?(delete_reason_id)
      return false unless Integer === delete_reason_id
      return @delete_reason_hash.key?(delete_reason_id)
    end
    
    # データモデル取得
    def [](delete_reason_id)
      return false unless Integer === delete_reason_id
      return @delete_reason_hash[delete_reason_id]
    end
  end
end