# -*- coding: utf-8 -*-
###############################################################################
# 会員状態キャッシュクラス
# 機能：会員状態データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/22 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 会員状態データモデルキャッシュクラス
  class MemberStateCache
    include Singleton
    # アクセサー
    attr_reader :member_state_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 会員状態データモデルリスト
      @member_state_list = nil
      # 会員状態データモデルハッシュ（キー：member_state_cls）
      @member_state_hash = nil
      # 会員状態データモデルハッシュ（キー：id）
      @member_state_id_hash = nil
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
      new_member_state_list = MemberState.order('id ASC')
      new_member_state_hash = Hash.new
      new_member_state_id_hash = Hash.new
      new_member_state_list.each do |ent|
        new_member_state_hash[ent.member_state_cls] = ent
        new_member_state_id_hash[ent.id] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @member_state_list = new_member_state_list
        @member_state_hash = new_member_state_hash
        @member_state_id_hash = new_member_state_id_hash
      end
    end
    
    # 存在チェック（区分）
    def exist?(member_state_cls)
      return @member_state_hash.key?(member_state_cls)
    end
    
    # 会員状態区分でアクセス
    def [](member_state_cls)
      return @member_state_hash[member_state_cls]
    end
    
    # 会員状態IDでアクセス
    def id_data(member_state_id)
      return @member_state_id_hash[member_state_id]
    end
  end
end