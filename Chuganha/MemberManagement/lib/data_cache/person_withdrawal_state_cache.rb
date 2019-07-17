# -*- coding: utf-8 -*-
###############################################################################
# 退会者状態キャッシュクラス
# 機能：退会者状態データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/31 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 退会者状態データモデルキャッシュクラス
  class PersonWithdrawalStateCache
    include Singleton
    # アクセサー
    attr_reader :person_withdrawal_state_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 退会者状態データモデルリスト
      @person_withdrawal_state_list = nil
      # 退会者状態データモデルハッシュ
      @person_withdrawal_state_hash = nil
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
      new_state_list = PersonWithdrawalState.all
      new_state_hash = Hash.new
      new_state_list.each do |ent|
        new_state_hash[ent.person_withdrawal_state_cls] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @person_withdrawal_state_list = new_state_list
        @person_withdrawal_state_hash = new_state_hash
      end
    end
    
    # 存在チェック
    def exist?(person_withdrawal_state_cls)
      return @person_withdrawal_state_hash.key?(person_withdrawal_state_cls)
    end
    
    # データモデル取得
    def [](person_withdrawal_state_cls)
      return @person_withdrawal_state_hash[person_withdrawal_state_cls]
    end
  end
end