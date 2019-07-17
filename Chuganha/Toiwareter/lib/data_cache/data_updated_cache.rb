# -*- coding: utf-8 -*-
###############################################################################
# データ更新キャッシュクラス
# 機能：データ更新のキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/11/30 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'common/validation_chk_module'

module DataCache
  # データ更新キャッシュクラス
  class DataUpdatedCache
    include Singleton
    include Common::ValidationChkModule
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # データバージョンハッシュ
      @data_version_hash = Hash.new
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # 現在バージョン
    def current_version(data_key)
      # クリティカルセクションの実行
      @mutex.synchronize do
        ActiveRecord::Base.transaction do
          return latest_version(data_key)
        end
      end
    end
    
    # 次バージョン
    def next_version(data_key)
      # クリティカルセクションの実行
      @mutex.synchronize do
        ActiveRecord::Base.transaction do
          target_ent = DataUpdated.where(:data_key=>data_key.to_s)[0]
          unless target_ent.nil? then
            # バージョンアップ処理
            target_ent.data_update_version += 1
            target_ent.save!
            @data_version_hash[data_key] = target_ent.data_update_version
            return target_ent.data_update_version
          end
          # 対象データなしの場合には新規登録
          target_ent = DataUpdated.new
          target_ent.data_key = data_key.to_s
          target_ent.data_update_version = 1
          target_ent.save!
          @data_version_hash[data_key] = target_ent.data_update_version
          return target_ent.data_update_version
        end
      end
    end
    
    # データ更新チェック
    def data_update?(data_key, chk_version)
      return true unless Integer === chk_version
      # クリティカルセクションの実行
      @mutex.synchronize do
        cache_version = @data_version_hash[data_key]
        unless cache_version.nil? then
          return true if chk_version < cache_version
        end
        ActiveRecord::Base.transaction do
          return latest_version(data_key) > chk_version
        end
      end
    end
    
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # 現在バージョン
    def latest_version(data_key)
      target_ent = DataUpdated.where(:data_key=>data_key.to_s)[0]
      unless target_ent.nil? then
        @data_version_hash[data_key] = target_ent.data_update_version
        return target_ent.data_update_version
      end
      # 対象データなしの場合には新規登録
      target_ent = DataUpdated.new
      target_ent.data_key = data_key.to_s
      target_ent.data_update_version = 1
      target_ent.save!
      @data_version_hash[data_key] = target_ent.data_update_version
      return target_ent.data_update_version
    end
    
  end
end