# -*- coding: utf-8 -*-
###############################################################################
# 業務前処理フィルタ
# 実行の前提：業務前処理が必要とされる業務処理を実行する際のみ実行する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/07/14 Nakanohito
# 更新日:
###############################################################################
# キャッシュデータ
require 'data_cache/data_updated_date_cache'
require 'data_cache/regulation_cookie_cache'
require 'data_cache/regulation_host_cache'
require 'data_cache/regulation_referrer_cache'
require 'data_cache/request_analysis_schedule_cache'

module Filter
  module BizPreprocess
    class BizPreprocessFilter
      include DataCache
      ###########################################################################
      # コンストラクタ
      ###########################################################################
      def initialize
        # データ更新日時ハッシュ
        @cache = DataUpdatedDateCache.instance
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # フィルタ処理
      def filter(controller)
        controller.logger.debug('BizPreprocessFilter Execute!!!')
        # リロード判定（解析情報取得設定キャッシュ）
        cache_1 = RequestAnalysisScheduleCache.instance
        cache_1.data_load if @cache.data_update?(:request_analysis_schedule, cache_1.loaded_at)
        # リロード判定（規制クッキー情報）
        cache_2 = RegulationCookieCache.instance
        cache_2.data_load if @cache.data_update?(:regulation_cookie, cache_2.loaded_at)
        # リロード判定（規制ホスト情報）
        cache_3 = RegulationHostCache.instance
        cache_3.data_load if @cache.data_update?(:regulation_host, cache_3.loaded_at)
        # リロード判定（規制リファラー情報）
        cache_4 = RegulationReferrerCache.instance
        cache_4.data_load if @cache.data_update?(:regulation_referrer, cache_4.loaded_at)
      end
    end
  end
end