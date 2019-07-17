# -*- coding: utf-8 -*-
###############################################################################
# 通報理由キャッシュクラス
# 機能：通報理由データモデルのキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/14 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 通報理由データモデルキャッシュクラス
  class ReportReasonCache
    include Singleton
    # アクセサー
    attr_reader :report_reason_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 通報理由データモデルリスト
      @report_reason_list = nil
      # 通報理由データモデルハッシュ
      @report_reason_hash = nil
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
      new_report_reason_list = ReportReason.order('id ASC')
      new_report_reason_hash = Hash.new
      new_report_reason_list.each do |ent|
        new_report_reason_hash[ent.id] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @report_reason_list = new_report_reason_list
        @report_reason_hash = new_report_reason_hash
      end
    end
    
    # 存在チェック
    def exist?(report_reason_id)
      return false unless Integer === report_reason_id
      return @report_reason_hash.key?(report_reason_id)
    end
    
    # データモデル取得
    def [](report_reason_id)
      return false unless Integer === report_reason_id
      return @report_reason_hash[report_reason_id]
    end
  end
end