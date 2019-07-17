# -*- coding: utf-8 -*-
###############################################################################
# 肩書きキャッシュクラス
# 機能：肩書きデータモデルのキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/23 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module DataCache
  # 肩書きデータモデルキャッシュクラス
  class JobTitleCache
    include Singleton
    # アクセサー
    attr_reader :job_title_list, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 肩書きデータモデルリスト
      @job_title_list = nil
      # 肩書きデータモデルハッシュ
      @job_title_hash = nil
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
      new_job_title_list = JobTitle.order('id ASC')
      new_job_title_hash = Hash.new
      new_job_title_list.each do |ent|
        new_job_title_hash[ent.id] = ent
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @job_title_list = new_job_title_list
        @job_title_hash = new_job_title_hash
      end
    end
    
    # 存在チェック
    def exist?(job_title_id)
      return false unless Integer === job_title_id
      return @job_title_hash.key?(job_title_id)
    end
    
    # データモデル取得
    def [](job_title_id)
      return false unless Integer === job_title_id
      return @job_title_hash[job_title_id]
    end
  end
end