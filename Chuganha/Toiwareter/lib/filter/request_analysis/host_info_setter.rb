# -*- coding: utf-8 -*-
###############################################################################
# ホスト情報セッタークラス
# 機能：リクエスト解析結果にホスト情報を設定する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/04 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'
require 'filter/request_analysis/abstract_info_setter'

module Filter
  module RequestAnalysis
    # ホスト情報セッター
    class HostInfoSetter < AbstractInfoSetter
      include Common::NetUtilModule
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
        # ホスト情報取得
        host_info = extract_host(params.request)
        # リクエスト解析結果編集
        analysis_info = params.request_analysis_result
        analysis_info.remote_host = host_info[0]
        analysis_info.ip_address = host_info[1]
        # プロキシ判定
        return if host_info.size == 2
        analysis_info.proxy_host = host_info[2]
        analysis_info.proxy_ip_address = host_info[3]
      end
    end
  end
end