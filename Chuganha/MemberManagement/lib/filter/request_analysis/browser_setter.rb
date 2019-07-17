# -*- coding: utf-8 -*-
###############################################################################
# ブラウザセッタークラス
# 機能：リクエスト解析結果にブラウザを設定する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/03 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'
require 'data_cache/browser_cache'
require 'filter/request_analysis/abstract_info_setter'

module Filter
  module RequestAnalysis
    # ブラウザセッター
    class BrowserSetter < AbstractInfoSetter
      include Common::NetUtilModule
      include DataCache
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(setting_info, next_setter)
        super(setting_info, next_setter)
        @info_cache = BrowserCache.instance
      end
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # 設定処理
      def set_values(params)
        user_agent = params.request.headers['HTTP_USER_AGENT']
        # Return
        return if user_agent.nil?
        # ブラウザ判定
        check_result = check_browser(user_agent)
        # ブラウザ照会
        info = @info_cache.add_info(check_result[0], check_result[1])
        # 照会結果編集
        analysis_info = params.request_analysis_result
        analysis_info.browser_id = info[0].id
        analysis_info.browser_version_id = info[1].id
      end
    end
  end
end