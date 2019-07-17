# -*- coding: utf-8 -*-
###############################################################################
# 処理通知ノードリスト
# 概要：メッセージ送信を使用して処理依頼を行う際の、通知先ノードのリスト情報を保持する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/06/12 Nakanohito
# 更新日:
###############################################################################
require 'drb/drb'
require 'singleton'
require 'yaml'
require 'rkvi/rkv_client'
require 'messaging/message_sender'

module BizCommon
  class BizNotifyList
    include Singleton
    include Messaging
    include DRbUndumped
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # アカウント情報ロードパス
      @load_path = Rails.root.join('config', 'business', 'process_notify_list.yml').to_s
      # 設定情報
      @root_path = nil
      # アカウント情報データ
      @proc_node_hash = nil
      # データをメモリに展開
      data_load
    end
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # データロード処理
    def data_load
      # ノード情報読み込み
      new_proc_node_hash = YAML.load_file(@load_path)
      new_proc_node_hash.each_key do |key|
        nodes = new_proc_node_hash[key]
        new_proc_node_hash[key] = [nodes] unless Array === nodes
      end
      @mutex.synchronize do
        @proc_node_hash = new_proc_node_hash
      end
    end
    
    # メンバーアクセス
    def proc_nodes(key)
      return @proc_node_hash[key.to_s]
    end
    
    # 処理通知依頼
    def notify_process?(proc_id)
      exec_flg = true
      rkv_client = Rkvi::RkvClient.instance
      rkv_client.refresh
      sender = MessageSender.instance
      @mutex.synchronize do
        proc_nodes(proc_id).each do |node_id|
          exec_flg = false unless sender.processing_request?(node_id, proc_id)
        end
      end
      return exec_flg
    end
  end
end