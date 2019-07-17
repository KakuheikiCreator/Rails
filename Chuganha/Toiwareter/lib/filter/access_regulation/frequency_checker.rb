# -*- coding: utf-8 -*-
###############################################################################
# 頻度チェッカー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
require 'singleton'

module Filter
  module AccessRegulation
    # 頻度チェッカークラス
    class FrequencyChecker
      include Singleton
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize
        # 排他制御オブジェクト生成
        @mutex = Mutex.new
        # 業務設定
        @biz_config = BizCommon::BusinessConfig.instance
        @max_request_frequency = @biz_config.max_request_frequency
        @max_request_frequency ||= 10
        # 頻度履歴キュー（1秒間の頻度数）
        @received_time_queue = Array.new
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # 頻度超過チェック
      def excess_frequency?
        @mutex.synchronize do
          now_time = Time.now
          # 過去1秒以内の履歴のみにする
          @received_time_queue.size.times do
            break if @received_time_queue.first > (now_time - 1.0)
            @received_time_queue.shift
          end
          # 過去1秒以内のチェック回数を判定
          return true if @received_time_queue.size >= @biz_config.max_request_frequency
          @received_time_queue.push(now_time)
          return false
        end
      end
    end
  end
end