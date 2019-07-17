# -*- coding: utf-8 -*-
###############################################################################
# 接続ノード情報キャッシュ
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/03 Nakanohito
# 更新日:
###############################################################################
require 'drb/drb'
require 'singleton'
require 'rexml/document'
require 'messaging/connection_node_info'

module Messaging
  # 接続ノード情報キャッシュ
  class ConnectionNodeInfoCache
    include Singleton
    include DRbUndumped
    # アクセサー定義
    attr_reader :local_info
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # ノード情報ハッシュ
      @node_info_hash = nil
      # ノード情報（ローカル）
      @local_info = nil
      # ノード情報をメモリに展開
      data_load
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # データロード処理
    def data_load(node_info_path=nil)
      node_info_path ||= Rails.root.join('config', 'messaging_nodes.xml').to_s
      # ノード情報読み込み
      new_node_info_hash = Hash.new
      new_local_info = nil
      xmldoc = REXML::Document.new(File.open(node_info_path))
      xmldoc.root.elements.each do |node_info|
        msg_node = ConnectionNodeInfo.new(node_info)
        new_node_info_hash[msg_node.node_id] = msg_node
        new_local_info = msg_node if msg_node.local_node?
      end
      # クリティカルセクションの実行
      @mutex.synchronize do
        @node_info_hash = new_node_info_hash
        @local_info = new_local_info
      end
    end
    
    # ノード情報取得
    def [](node_id)
      return @node_info_hash[node_id.to_s]
    end
  end
end
