# -*- coding: utf-8 -*-
###############################################################################
# セッション情報セッタークラス
# 機能：リクエスト解析結果にセッション情報を設定する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/07 Nakanohito
# 更新日:
###############################################################################
require 'filter/request_analysis/abstract_info_setter'

module Filter
  module RequestAnalysis
    # セッション情報セッター
    class SessionInfoSetter < AbstractInfoSetter
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(setting_info, next_setter)
        super(setting_info, next_setter)
      end
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # 設定処理
      def set_values(params)
        # セッションID編集
        analysis_info = params.request_analysis_result
        analysis_info.session_id = params.request.session_options[:id]
        # クライアントID
        analysis_info.client_id = params.session[:client_id]
      end
    end
  end
end