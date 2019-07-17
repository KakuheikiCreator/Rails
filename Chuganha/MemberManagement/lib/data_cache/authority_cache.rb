# -*- coding: utf-8 -*-
###############################################################################
# 権限キャッシュクラス
# 機能：権限データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/14 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 権限データモデルキャッシュクラス
  class AuthorityCache
    include Singleton
    # アクセサー
    attr_reader :authority_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 権限データモデルリスト
      @authority_list = nil
      # 権限データモデルハッシュ
      @authority_hash = nil
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
      new_authority_list = Authority.order('authority_cls ASC')
      new_authority_hash = Hash.new
      new_authority_list.each do |ent|
        new_authority_hash[ent.authority_cls] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @authority_list = new_authority_list
        @authority_hash = new_authority_hash
      end
    end
    
    # 存在チェック
    def exist?(authority_cls)
      return @authority_hash.key?(authority_cls)
    end
    
    # データモデル取得
    def [](authority_cls)
      return @authority_hash[authority_cls]
    end
  end
end