# -*- coding: utf-8 -*-
###############################################################################
# 退会理由キャッシュクラス
# 機能：退会理由データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/30 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 退会理由キャッシュクラス
  class WithdrawalReasonCache
    include Singleton
    # アクセサー
    attr_reader :withdrawal_reason_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 退会理由データモデルリスト
      @withdrawal_reason_list = nil
      # 退会理由データモデルハッシュ
      @withdrawal_reason_hash = nil
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
      new_withdrawal_reason_list = WithdrawalReason.order('id ASC')
      new_withdrawal_reason_hash = Hash.new
      new_withdrawal_reason_list.each do |ent|
        new_withdrawal_reason_hash[ent.withdrawal_reason_cls] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @withdrawal_reason_list = new_withdrawal_reason_list
        @withdrawal_reason_hash = new_withdrawal_reason_hash
      end
    end
    
    # 存在チェック
    def exist?(withdrawal_reason_cls)
      return @withdrawal_reason_hash.key?(withdrawal_reason_cls)
    end
    
    # データモデル取得
    def [](withdrawal_reason_cls)
      return @withdrawal_reason_hash[withdrawal_reason_cls]
    end
  end
end