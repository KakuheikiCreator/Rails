# -*- coding: utf-8 -*-
###############################################################################
# メッセージ共通モジュール
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/04/05 Nakanohito
# 更新日:
###############################################################################

module Messaging
  # メッセージ共通モジュール
  module MessageModule
    # ステータス
    MSG_STATUS_OK = '0'
    MSG_STATUS_NG = '1'
    # メッセージタイプ
    MSG_TYPE_EXCHANGE_REQ = '0' # 公開鍵交換リクエスト
    MSG_TYPE_EXCHANGE_RES = '1' # 公開鍵交換レスポンス
    MSG_TYPE_CONFIRMATION_REQ = '2' # キー確認リクエスト
    MSG_TYPE_CONFIRMATION_RES = '3' # キー確認レスポンス
    MSG_TYPE_PROCESS_REQ = '4' # 処理リクエスト
    MSG_TYPE_PROCESS_RES = '5' # 処理リクエスト
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
  end
end
