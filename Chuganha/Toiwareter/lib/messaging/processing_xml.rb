# -*- coding: utf-8 -*-
###############################################################################
# 処理メッセージXMLクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/04/06 Nakanohito
# 更新日:
###############################################################################
require 'messaging/message_xml'

module Messaging
  # 処理メッセージXMLクラス
  class ProcessingXML < MessageXML
    # メッセージエレメントパス
    PATH_PROCESS_ID = '/message/body/process_id'
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期化メソッド
    def initialize(*args)
      # 基底クラスのコンストラクタ実行
      super(*args)
      return if args.size == 1
      if @message_type != MSG_TYPE_PROCESS_REQ &&
         @message_type != MSG_TYPE_PROCESS_RES then
        raise 'Message type Error'
      end
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # 処理ID取得
    def process_id
      return get_elm_text(PATH_PROCESS_ID)
    end
    
    # 処理ID設定
    def process_id=(process_id)
      set_elm_text(PATH_PROCESS_ID, process_id)
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # 送信XMLテンプレート（本文）生成
    def xml_body(body_elm)
      body_elm.add_element("process_id")
    end
  end
end
