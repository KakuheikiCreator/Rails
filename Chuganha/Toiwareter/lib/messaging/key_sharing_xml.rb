# -*- coding: utf-8 -*-
###############################################################################
# キー共有メッセージXMLクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/04/05 Nakanohito
# 更新日:
###############################################################################
require 'messaging/message_xml'

module Messaging
  # キー共有メッセージXMLクラス
  class KeySharingXML < MessageXML
    # メッセージエレメントパス
    PATH_PUBLIC_KEY = '/message/body/public_key'
    PATH_COMMON_KEY = '/message/body/common_key'
    PATH_EXPIRATION = '/message/body/expiration'
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期化メソッド
    def initialize(*args)
      # 基底クラスのコンストラクタ実行
      super(*args)
      return if args.size == 1
      # パラメータの編集
      case @message_type
      when MSG_TYPE_EXCHANGE_REQ then
        # 公開鍵の交換依頼
        @msg_xml.delete_element(PATH_SENDER_PW)
        set_elm_text(PATH_PUBLIC_KEY, @from_node_info.public_key.export)
      when MSG_TYPE_EXCHANGE_RES then
        # 公開鍵の交換依頼返信
        @msg_xml.delete_element(PATH_ACCOUNT)
        set_elm_text(PATH_PUBLIC_KEY, @from_node_info.public_key.export)
      when MSG_TYPE_CONFIRMATION_REQ then
        # 共通鍵の送信
        set_elm_text(PATH_COMMON_KEY, @to_node_info.common_key)
      when MSG_TYPE_CONFIRMATION_RES then
        # 有効期限の返信
        set_elm_text(PATH_EXPIRATION, @to_node_info.common_key_expiration)
      else
        raise 'Message type Error'
      end
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # 公開鍵取得
    def public_key
      return get_elm_text(PATH_PUBLIC_KEY)
    end
    
    # 共通鍵取得
    def common_key
      return get_elm_text(PATH_COMMON_KEY)
    end
    
    # 有効期限取得
    def expiration
      return get_elm_text(PATH_EXPIRATION)
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # 送信XMLテンプレート（本文）生成
    def xml_body(body_elm)
      if @message_type == MSG_TYPE_EXCHANGE_REQ ||
         @message_type == MSG_TYPE_EXCHANGE_RES then
        body_elm.add_element("public_key")
      elsif @message_type == MSG_TYPE_CONFIRMATION_REQ then
        body_elm.add_element("common_key")
      else
        body_elm.add_element("expiration")
      end
    end
  end
end
