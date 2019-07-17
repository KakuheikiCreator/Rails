# -*- coding: utf-8 -*-
###############################################################################
# リクエスト解析パラメータ
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/07 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/request_analysis_schedule_cache'

module Filter
  module RequestAnalysis
    # リクエスト解析パラメータ
    class AnalysisParameters
      include DataCache
      # アクセスメソッド定義
      attr_reader :received_time, :setting_info, :controller_path,
                  :request, :session
      attr_accessor :request_analysis_result
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(controller)
        @received_time = Time.now
        @setting_info = RequestAnalysisScheduleCache.instance.get_setting(@received_time)
        @controller_path = controller.controller_path
        @request = controller.request
        @session = controller.session
        @request_analysis_result = RequestAnalysisResult.new
        @request_analysis_result.request_analysis_schedule_id = @setting_info.id unless @setting_info.nil?
      end
    end
  end
end