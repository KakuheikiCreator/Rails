# -*- coding: utf-8 -*-
###############################################################################
# モックキー共有メッセージXMLクラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/06/02 Nakanohito
# 更新日:
###############################################################################
require 'messaging/key_sharing_xml'

module Mock
  # モックキー共有メッセージXMLクラス
  class MockKeySharingXML < Messaging::KeySharingXML
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期化メソッド
    def initialize(message_type, from_node_info, to_node_info)
      # 基底クラスのコンストラクタ実行
      super(message_type, to_node_info)
      # 送信元ノード情報
      @from_node_info = from_node_info
      # 送信元情報設定
      @msg_xml = update_msg(@msg_xml, from_node_info)
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # メッセージ更新処理
    def update_msg(msg_xml, from_node_info)
      new_msg_xml = REXML::Document.new(msg_xml.to_s)
      msg_type = new_msg_xml.elements[PATH_TYPE].text
#      Rails.logger.debug('MockKeySharingXML msg_type:' + msg_type.to_s)
#      Rails.logger.debug('MockKeySharingXML MSG_TYPE_EXCHANGE_REQ:' + MSG_TYPE_EXCHANGE_REQ.to_s)
#      Rails.logger.debug('MockKeySharingXML MSG_TYPE_EXCHANGE_RES:' + MSG_TYPE_EXCHANGE_RES.to_s)
      if msg_type == MSG_TYPE_EXCHANGE_RES then
        new_msg_xml.elements[PATH_PUBLIC_KEY].text = from_node_info.public_key.export
      elsif msg_type == MSG_TYPE_CONFIRMATION_RES then
        new_msg_xml.elements[PATH_EXPIRATION].text = from_node_info.common_key_expiration
      end
      return new_msg_xml
    end
  end
end
