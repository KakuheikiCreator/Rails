# -*- coding: utf-8 -*-
###############################################################################
# 国キャッシュクラス
# 機能：国データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/21 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 国データモデルキャッシュクラス
  class CountryCache
    include Singleton
    # アクセサー
    attr_reader :country_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 国データモデルリスト
      @country_list = nil
      # 国データモデルハッシュ
      @country_hash = nil
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
      new_country_list = Country.order('country_name_cd ASC')
      new_country_hash = Hash.new
      new_country_list.each do |ent|
        new_country_hash[ent.country_name_cd] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @country_list = new_country_list
        @country_hash = new_country_hash
      end
    end
    
    # 存在チェック
    def exist?(country_name_cd)
      return @country_hash.key?(country_name_cd)
    end
    
    # データモデル取得
    def [](country_name_cd)
      return @country_hash[country_name_cd]
    end
  end
end