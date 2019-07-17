# -*- coding: utf-8 -*-
###############################################################################
# RKVの初期化クラス
# 概要：RKVサーバーの業務的な初期化処理を実行する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/07/09 Nakanohito
# 更新日:
###############################################################################
require 'drb/drb'
# キャッシュデータ
require 'data_cache/generic_code_cache'
# メッセージ関係
require 'biz_common/biz_notify_list'
require 'messaging/connection_node_info_cache'
require 'messaging/message_sender'

module BizCommon
  class BizRkvInitializer
    include DataCache
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize(kv_hash={})
      @kv_hash = kv_hash
    end
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # RKVサーバー初期化処理
    def init_server(rkv_server)
      # キャッシュデータ
      data_cache_hash = RemoteHash.new
      data_cache_hash[:generic_code] = GenericCodeCache.instance
      rkv_server[:data_cache] = data_cache_hash
      # データ更新日時ハッシュ
      rkv_server[:updated_at] = RemoteHash.new
      # メッセージセンダー初期化
      Messaging::MessageSender.instance.logger = Rails.logger
      # 処理通知リスト
      rkv_server[:biz_notify_list] = BizNotifyList.instance
      # プロパティ追加
      update(rkv_server)
    end
    ###########################################################################
    # protectesdメソッド定義
    ###########################################################################
    protected
    # マージ処理
    def update(rkv_server)
      @kv_hash.each_pair do |key, value|
        rkv_server[key] = value
      end
    end
    ###########################################################################
    # 内部クラス定義
    ###########################################################################
    # リモートアクセスされるハッシュクラス
    class RemoteHash < Hash
      include DRbUndumped
    end
  end
end