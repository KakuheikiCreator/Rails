# -*- coding: utf-8 -*-
###############################################################################
# 電子掲示板キャッシュクラス
# 機能：電子掲示板データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/25 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 電子掲示板データモデルキャッシュクラス
  class BbsCache
    include Singleton
    # アクセサー
    attr_reader :bbs_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 電子掲示板データモデルリスト
      @bbs_list = nil
      # 電子掲示板データモデルハッシュ
      @bbs_hash = nil
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
      new_bbs_list = Bbs.order('id ASC')
      new_bbs_hash = Hash.new
      new_bbs_list.each do |ent|
        new_bbs_hash[ent.id] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @bbs_list = new_bbs_list
        @bbs_hash = new_bbs_hash
      end
    end
    
    # 存在チェック
    def exist?(bbs_id)
      return false unless Integer === bbs_id
      return @bbs_hash.key?(bbs_id)
    end
    
    # データモデル取得
    def [](bbs_id)
      return false unless Integer === bbs_id
      return @bbs_hash[bbs_id]
    end
  end
end