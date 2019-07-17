# -*- coding: utf-8 -*-
###############################################################################
# リクエスト解析スケジュールキャッシュクラス
# 機能：リクエスト解析スケジュールのキャッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/09/06 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'
require 'data_cache/system_cache'

module DataCache
  # リクエスト解析スケジュールキャッシュクラス
  class RequestAnalysisScheduleCache
    include Singleton
    # アクセサー
    attr_reader :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 自システム取得
      @system = SystemCache.instance.get_system
      # キャッシュデータ
      @setting_list = nil
      # 取得開始日時
      @start_time = nil
      # キャッシュデータ更新日時
      @loaded_at = nil
      # 有効期限（有効期限切れ）
      @expiration_time = nil
      # 現在インデックス
      @current_index = nil
      # データをメモリに展開
      data_load
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # データロード処理
    def data_load(time=Time.now)
      # クリティカルセクションの実行
      @mutex.synchronize do
        # キャッシュロード日時
        @loaded_at = Time.now
        # キャッシュロード
        @setting_list = @system.request_analysis_schedule(true).order('gets_start_date ASC')
        # 取得開始日時
        @start_time = nil
        # 現在ステータス設定
        set_current_state(time)
      end
    end
    
    # リクエスト解析スケジュール
    def get_setting(time=Time.now)
      # クリティカルセクションの実行
      @mutex.synchronize do
        unless expiration_date?(time) then
          # 現在ステータス設定
          set_current_state(time)
        end
        return nil if @current_index.nil?
        return @setting_list[@current_index]
      end
    end
    
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # 現在状態設定
    def set_current_state(time)
      if @setting_list.empty? then
        @current_index = nil    # 現在インデックス
        @start_time = nil       # 取得開始日時
        @expiration_time = nil  # 有効期限（有効期限切れ）
        return
      end
      idx = 0
      unless @start_time.nil? then
        idx = @current_index if time >= @start_time
      end
      @expiration_time = nil
      @setting_list[idx..-1].each do |setting|
        if setting.gets_start_date > time then
          @expiration_time = setting.gets_start_date
          break
        end
        idx += 1
      end
      if idx > 0 then
        @current_index = idx - 1
        @start_time = @setting_list[@current_index].gets_start_date
      else
        @current_index = nil
        @start_time = nil
      end
    end
    
    # 有効期間内判定
    def expiration_date?(time)
      if @start_time.nil? then
        return false if @expiration_time.nil?
        return time < @expiration_time
      elsif @expiration_time.nil? then
        return time >= @start_time
      else
        return (time >= @start_time && time < @expiration_time)
      end
    end
  end
end