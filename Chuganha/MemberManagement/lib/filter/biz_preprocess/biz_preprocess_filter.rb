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
require 'data_cache/account_cache'

module Filter
  module BizPreprocess
    class BizPreprocessFilter
      include DataCache
      ###########################################################################
      # コンストラクタ
      ###########################################################################
      def initialize
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # フィルタ処理
      def filter(controller)
        controller.logger.debug('BizPreprocessFilter Execute!!!')
        # アクセス管理キャッシュロード
        access_cache_load
        #　会員管理関係キャッシュロード
        member_cache_load
      end
      
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      #　アクセス管理関係キャッシュロード
      def access_cache_load
        # データ更新日時ハッシュ
        cache = DataUpdatedDateCache.instance
        # リロード判定（解析情報取得設定キャッシュ）
        cache_1 = RequestAnalysisScheduleCache.instance
        cache_1.data_load if cache.data_update?(:request_analysis_schedule, cache_1.loaded_at)
        # リロード判定（規制クッキー情報）
        cache_2 = RegulationCookieCache.instance
        cache_2.data_load if cache.data_update?(:regulation_cookie, cache_2.loaded_at)
        # リロード判定（規制ホスト情報）
        cache_3 = RegulationHostCache.instance
        cache_3.data_load if cache.data_update?(:regulation_host, cache_3.loaded_at)
        # リロード判定（規制リファラー情報）
        cache_4 = RegulationReferrerCache.instance
        cache_4.data_load if cache.data_update?(:regulation_referrer, cache_4.loaded_at)
      end
      
      #　会員管理関係キャッシュロード
      def member_cache_load
        # リロード（アカウントキャッシュ）
        AccountCache.instance.data_update?
      end
      
    end
  end
end