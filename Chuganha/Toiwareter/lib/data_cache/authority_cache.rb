# -*- coding: utf-8 -*-
###############################################################################
# 権限キャッシュクラス
# 機能：権限データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/09 Nakanohito
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
      # 権限データモデルハッシュ（キー：id）
      @authority_id_hash = nil
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
      new_authority_id_hash = Hash.new
      new_authority_list.each do |ent|
        new_authority_hash[ent.authority_cls] = ent
        new_authority_id_hash[ent.id] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @authority_list = new_authority_list
        @authority_hash = new_authority_hash
        @authority_id_hash = new_authority_id_hash
      end
    end
    
    # 存在チェック（区分）
    def exist?(authority_cls)
      return @authority_hash.key?(authority_cls)
    end
    
    # 存在チェック（ID）
    def id_exist?(authority_id)
      return false unless Integer === authority_id
      return @authority_id_hash.key?(authority_id)
    end
    
    # データモデル取得
    def [](authority_cls)
      return @authority_hash[authority_cls]
    end
    
    # データモデル取得
    def id_data(authority_id)
      return false unless Integer === authority_id
      return @authority_id_hash[authority_id]
    end
  end
end