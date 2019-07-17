# -*- coding: utf-8 -*-
###############################################################################
# 携帯キャリアキャッシュクラス
# 機能：携帯キャリアデータモデルのキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/21 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 携帯キャリアデータモデルキャッシュクラス
  class MobileCarrierCache
    include Singleton
    # アクセサー
    attr_reader :mobile_carrier_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 携帯キャリアデータモデルリスト
      @mobile_carrier_list = nil
      # 携帯キャリアデータモデルハッシュ
      @mobile_carrier_Hash = nil
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
      new_mobile_carrier_list = MobileCarrier.order('mobile_carrier_cd ASC, mobile_domain_no ASC')
      new_mobile_carrier_Hash = Hash.new
      new_mobile_carrier_list.each do |ent|
        new_mobile_carrier_Hash[ent.id] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @mobile_carrier_list = new_mobile_carrier_list
        @mobile_carrier_Hash = new_mobile_carrier_Hash
      end
    end
    
    # 存在チェック
    def exist?(mobile_carrier_id)
      return @mobile_carrier_Hash.key?(mobile_carrier_id.to_i)
    end
    
    # 携帯キャリアコード存在チェック
    def exist_cd?(mobile_carrier_cd)
      @mobile_carrier_list.each do |ent|
        return true if ent.mobile_carrier_cd == mobile_carrier_cd
      end
      return false
    end
    
    # 携帯キャリアコードに対応するIDのリストを取得
    def id_list(mobile_carrier_cd)
      list = Array.new
      @mobile_carrier_list.each do |ent|
        list.push(ent.id) if ent.mobile_carrier_cd == mobile_carrier_cd
      end
      return list
    end
    
    # 携帯キャリアコードでエンティティ取得
    def [](mobile_carrier_id)
      return @mobile_carrier_Hash[mobile_carrier_id.to_i]
    end
  end
end