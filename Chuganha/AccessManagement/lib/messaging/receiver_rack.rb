# -*- coding: utf-8 -*-
###############################################################################
# 受信ラック基底クラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/08 Nakanohito
# 更新日:
###############################################################################
require 'rubygems'
require 'rack'
require 'messaging/connection_node_info_cache'
require 'messaging/message_module'
require 'messaging/rack_net_util_module'

module Messaging
  # 受信ラック基底クラス
  class ReceiverRack
    include MessageModule
    include RackNetUtilModule
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize(logger)
      @logger = logger
      # 接続ノード情報ハッシュ
      @node_info_cache = Messaging::ConnectionNodeInfoCache.instance
      # ローカルノード情報
      @local_node_info = @node_info_cache.local_info
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # 警告メッセージ表示
    def warn_log(request, message)
      @logger.warn(message + host_message(request))
    end
    
    # 例外メッセージ表示
    def exception_log(ex)
      @logger.debug("Exception:" + ex.class.name)
      @logger.debug("Message  :" + ex.message)
      @logger.debug("Backtrace:" + ex.backtrace.join("\n"))
    end
    
    # ホスト情報メッセージ生成
    def host_message(request)
      host_info = extract_host(request)
      msg = ' Host:' + host_info[0].to_s + '(' + host_info[1].to_s + ')'
      return msg if host_info.size == 2
      return msg + ' Proxy Host:' + host_info[2].to_s + '(' + host_info[3].to_s + ')'
    end
  end
end
