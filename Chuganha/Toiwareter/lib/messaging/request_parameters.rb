# -*- coding: utf-8 -*-
###############################################################################
# リクエストパラメータクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/04/10 Nakanohito
# 更新日:
###############################################################################
require 'rubygems'
require 'messaging/connection_node_info_cache'
require 'messaging/message_xml'

module Messaging
  # リクエストパラメータクラス
  class RequestParameters
    # アクセサー定義
    attr_reader :request, :status, :err_message, :log_message, :message_xml
    # 定数定義
    DECRYPTION_DEFAULT = 0  # デフォルトの復号化（Base64のみ）
    DECRYPTION_PRIVATE = 1  # 秘密鍵による復号化
    DECRYPTION_COMMON  = 2  # 共通鍵による復号化
    #########################################################################
    # メソッド定義
    #########################################################################
    # コンストラクタ
    def initialize(env)
      # リクエスト生成
      @request = Rack::Request.new(env)
      # エラー情報
      @status = 200           # ステータス
      @err_message = nil      # エラーメッセージ
      @log_message = nil      # ロガーメッセージ
      # 受信メッセージ情報
      @message_xml = nil      # メッセージXML
      # ノード情報
      @node_info_cache = Messaging::ConnectionNodeInfoCache.instance
      @local_node_info = @node_info_cache.local_info
    end
    
    #########################################################################
    # protected定義
    #########################################################################
    protected
    # メッセージデコード
    def decode_message(decryption_type=DECRYPTION_DEFAULT)
      message_str64 = @request.params['message']
      return nil if !(String === message_str64) || message_str64.empty?
      # デコード
      message_str = message_str64.unpack('m')[0]
      case decryption_type
      when DECRYPTION_DEFAULT then
        # 通常の復号化
        return message_str
      when DECRYPTION_PRIVATE then
        # 秘密鍵による復号化
        return @local_node_info.private_decrypt(message_str)
      when DECRYPTION_COMMON then
        # 共通鍵による復号化
        from_node_info = @node_info_cache[@request.params['node_id']]
        return nil if from_node_info.nil?
        return from_node_info.common_decrypt(message_str)
      end
    rescue StandardError => ex
      return nil
    end
  end
end
