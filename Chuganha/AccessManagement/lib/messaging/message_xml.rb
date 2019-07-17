# -*- coding: utf-8 -*-
###############################################################################
# メッセージXMLクラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/05 Nakanohito
# 更新日:
###############################################################################
require 'messaging/message_module'
require 'messaging/connection_node_info_cache'

module Messaging
  # メッセージXMLクラス
  class MessageXML
    include MessageModule
    # メッセージエレメントパス
    PATH_TYPE = '/message/header/type'
    PATH_STATUS = '/message/header/status'
    PATH_ACCOUNT = '/message/header/account'
    PATH_SENDER_ID = '/message/header/account/sender_id'
    PATH_SENDER_PW = '/message/header/account/sender_pw'
    # アクセサー定義
    attr_reader :from_node_info, :to_node_info
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期化メソッド
    def initialize(*args)
      # メッセージタイプ
      @message_type = nil
      # ノード情報
      @from_node_info = nil
      @to_node_info = nil
      # XML生成
      @msg_xml = nil
      node_info_cache = Messaging::ConnectionNodeInfoCache.instance
      if args.size == 1 then
        @msg_xml = REXML::Document.new(args[0])
        @message_type = get_elm_text(PATH_TYPE)
        @from_node_info = node_info_cache[get_elm_text(PATH_SENDER_ID)]
        @to_node_info = node_info_cache.local_info
      else
        raise 'Destination node information error' unless ConnectionNodeInfo === args[1]
        @message_type = args[0]
        @from_node_info = node_info_cache.local_info
        @to_node_info = args[1]
        @msg_xml = xml_template
        # ヘッダー部初期化
        set_elm_text(PATH_TYPE, @message_type)
        set_elm_text(PATH_STATUS, MSG_STATUS_OK)
        set_elm_text(PATH_SENDER_ID, @to_node_info.send_id)
        set_elm_text(PATH_SENDER_PW, @to_node_info.send_pw)
      end
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # メッセージタイプ取得
    def msg_type
      return get_elm_text(PATH_TYPE)
    end
    
    # ステータス取得
    def status
      return get_elm_text(PATH_STATUS)
    end
    
    # ステータス設定
    def status=(status)
      set_elm_text(PATH_STATUS, status)
    end
    
    # 送信ノードID取得
    def sender_id
      return get_elm_text(PATH_SENDER_ID)
    end
    
    # 送信ノードID設定
    def sender_id=(value)
      return set_elm_text(PATH_SENDER_ID, value)
    end
    
    # 送信ノードPW取得
    def sender_pw
      return get_elm_text(PATH_SENDER_PW)
    end
    
    # 送信ノードPW設定
    def sender_pw=(value)
      return set_elm_text(PATH_SENDER_PW, value)
    end
    
    # 文字列化
    def to_s
      return @msg_xml.to_s
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # エレメント値取得
    def get_elm_text(path)
      elm = @msg_xml.elements[path]
      return nil if elm.nil?
      return elm.text
    end
    
    # エレメント値設定
    def set_elm_text(path, value)
      elm = @msg_xml.elements[path]
      return nil if elm.nil?
      elm.text = value
    end
        
    # 送信XMLテンプレート生成
    def xml_template
      template = REXML::Document.new
      template.add(REXML::XMLDecl.new(version="1.0", encoding="utf-8"))
      root = template.add_element("message")
      # ヘッダー編集
      header_elm = root.add_element("header")
      header_elm.add_element("type")
      header_elm.add_element("status")
      account_eml = header_elm.add_element("account")
      account_eml.add_element("sender_id")
      account_eml.add_element("sender_pw")
      # 本文編集
      xml_body(root.add_element("body"))
      return template
    end
    
    # 送信XMLテンプレート（本文）生成
    def xml_body(body_elm)
      return
    end
  end
end
