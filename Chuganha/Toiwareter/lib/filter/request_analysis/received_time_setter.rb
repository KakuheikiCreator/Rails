# -*- coding: utf-8 -*-
###############################################################################
# 受信日時セッタークラス
# 機能：リクエスト解析結果に受信日時を設定する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/07 Nakanohito
# 更新日:
###############################################################################
require 'filter/request_analysis/abstract_info_setter'

module Filter
  module RequestAnalysis
    # 受信日時セッター
    class ReceivedTimeSetter < AbstractInfoSetter
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(setting_info, next_setter)
        super(setting_info, next_setter)
      end
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # 設定処理
      def set_values(params)
        # 現在日時の取得
        received_time = params.received_time
        # 受信日時の編集
        analysis_info = params.request_analysis_result
        analysis_info.received_year   = received_time.year
        analysis_info.received_month  = received_time.month
        analysis_info.received_day    = received_time.day
        analysis_info.received_hour   = received_time.hour
        analysis_info.received_minute = received_time.min
        analysis_info.received_second = received_time.sec
      end
    end
  end
end