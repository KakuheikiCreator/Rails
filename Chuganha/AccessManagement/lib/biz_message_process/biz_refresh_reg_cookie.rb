# -*- coding: utf-8 -*-
###############################################################################
# メッセージ処理クラス
# 概要：規制クッキー情報キャッシュのリフレッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/11 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/regulation_cookie_cache'

module BizMessageProcess
  class BizRefreshRegCookie
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # メッセージ処理
    def execute?(message_xml)
      # 規制クッキー情報リフレッシュ
      RegulationCookieCache.instance.data_load
      return true
    end
  end
end