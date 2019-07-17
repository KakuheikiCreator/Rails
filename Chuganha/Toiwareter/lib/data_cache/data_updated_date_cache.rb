# -*- coding: utf-8 -*-
###############################################################################
# データ更新日時キャッシュクラス
# 機能：データ更新日時のキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/10/09 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'common/validation_chk_module'

module DataCache
  # データ更新日時キャッシュクラス
  class DataUpdatedDateCache
    include Singleton
    include Common::ValidationChkModule
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # データ更新チェック
    def data_update?(data_key, updated_at, upd_flg=false)
      # クリティカルセクションの実行
      @mutex.synchronize do
        ActiveRecord::Base.transaction do
          target_ent = DataUpdatedDate.where(:data_key=>data_key.to_s)[0]
          if target_ent.nil? then
            target_ent = DataUpdatedDate.new
            target_ent.data_key = data_key.to_s
            target_ent.data_update_time = updated_at
            target_ent.save!
            return false
          end
          if target_ent.data_update_time.nil? then
            target_ent.data_update_time = updated_at
            target_ent.save!
            return false
          end
          return true if target_ent.data_update_time > updated_at
          if upd_flg then
            target_ent.data_update_time = updated_at
            target_ent.save!
          end
          return false
        end
      end
    end
  end
end