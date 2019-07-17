# -*- coding: utf-8 -*-
###############################################################################
# メッセージ処理クラス
# 概要：リクエスト解析スケジュール情報キャッシュのリフレッシュを行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/11 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/request_analysis_schedule_cache'

module BizMessageProcess
  class BizRefreshSchedule
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # メッセージ処理
    def execute?(message_xml)
      # リクエスト解析スケジュール情報のリフレッシュ
      RequestAnalysisScheduleCache.instance.data_load
      return true
    end
  end
end