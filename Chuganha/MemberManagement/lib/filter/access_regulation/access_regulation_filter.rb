# -*- coding: utf-8 -*-
###############################################################################
# リクエスト規制フィルタ
# 実行の前提：なし
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/22 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'
require 'data_cache/regulation_cookie_cache'
require 'data_cache/regulation_host_cache'
require 'data_cache/regulation_referrer_cache'
require 'filter/access_regulation/frequency_checker'

module Filter
  module AccessRegulation
    class AccessRegulationFilter
      include Common::NetUtilModule
      include DataCache
      #########################################################################
      # コンストラクタ
      #########################################################################
      # コンストラクタ
      def initialize
        # Logger
        @logger = Rails.logger
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # アクション実行前のフィルタ処理
      def filter(controller)
        controller.logger.debug('AccessRegulationFilter Execute!!!')
        return if controller.flash[:redirect_flg] == true
        # エラーステータス返却（403）
        controller.head(:forbidden) if regulation?(controller)
      end
      
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # 規制対象判定
      def regulation?(controller)
        host_info = extract_host(controller.request)
        # ホスト規制チェック
        return true if regulation_host?(controller, host_info)
        # リファラー規制チェック
        return true if regulation_referrer?(controller, host_info)
        # クッキー規制チェック
        return true if regulation_cookie?(controller, host_info)
        # 頻度チェック
        return regulation_frequency?(controller, host_info)
      end
    
      # 規制対象クッキーチェック
      def regulation_cookie?(controller, host_info)
        # 規制クッキー判定
        cookie = controller.request.env['HTTP_COOKIE']
        return false unless RegulationCookieCache.instance.regulation?(cookie)
        # 規制クッキー処理
        @logger.warn('Regulated!!! Cookie ' + generate_host_info(host_info) + ':' + cookie.to_s)
        return true
      rescue StandardError => ex
        return false
      end
      
      # 規制対象ホストチェック
      def regulation_host?(controller, host_info)
        # 規制ホスト判定
        return false unless RegulationHostCache.instance.regulation?(
                                                   host_info[0], host_info[1],
                                                   host_info[2], host_info[3])
        @logger.warn('Regulated!!! Client ' + generate_host_info(host_info))
        return true
      rescue StandardError => ex
        return false
      end
      
      # 規制対象リファラーチェック
      def regulation_referrer?(controller, host_info)
        # 規制リファラー判定
        referer = controller.request.referer
        return false unless RegulationReferrerCache.instance.regulation?(referer)
        # 規制リファラー処理
        @logger.warn('Regulated!!! Referrer ' + generate_host_info(host_info) +
                                          ':' + controller.request.referer.to_s)
        return true
      rescue StandardError => ex
        return false
      end
      
      # 規制リクエスト頻度チェック
      def regulation_frequency?(controller, host_info)
        return false unless FrequencyChecker.instance.excess_frequency?
        @logger.warn('Regulated!!! Frequency ' + generate_host_info(host_info))
        return true
      rescue StandardError => ex
        return false
      end
      
      # ホスト情報メッセージ生成
      def generate_host_info(host_info)
        msg = 'Host:' + host_info[0].to_s + '(' + host_info[1].to_s + ')'
        return msg if host_info.size == 2
        return msg + ' Proxy Host:' + host_info[2].to_s + '(' + host_info[3].to_s + ')'
      end
    end
  end
end