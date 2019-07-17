# -*- coding: utf-8 -*-
###############################################################################
# ドメインセッタークラス
# 機能：リクエスト解析結果にドメインを設定する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/07 Nakanohito
# 更新日:
# 実行の前提：リクエスト解析結果にリモートホストが編集されている事
###############################################################################
require 'data_cache/domain_cache'
require 'filter/request_analysis/abstract_info_setter'

module Filter
  module RequestAnalysis
    # ホスト情報セッター
    class DomainSetter < AbstractInfoSetter
      include DataCache
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(setting_info, next_setter)
        super(setting_info, next_setter)
        @info_cache = DomainCache.instance
      end
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # 設定処理
      def set_values(params)
        # リモートホストのドメインのIDを設定
        analysis_info = params.request_analysis_result
        analysis_info.domain_id = @info_cache.get_domain_id(analysis_info.remote_host)
      end
    end
  end
end