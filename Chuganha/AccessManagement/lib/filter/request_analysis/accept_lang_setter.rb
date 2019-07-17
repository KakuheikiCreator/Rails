# -*- coding: utf-8 -*-
###############################################################################
# 言語セッタークラス
# 機能：リクエスト解析結果に言語を設定する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/02 Nakanohito
# 更新日:
###############################################################################
require 'filter/request_analysis/abstract_info_setter'
require 'common/net_util_module'

module Filter
  module RequestAnalysis
    # 言語セッター
    class AcceptLangSetter < AbstractInfoSetter
      include Common::NetUtilModule
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
        # 言語の編集
        accept_language = params.request.headers['Accept-Language']
        params.request_analysis_result.accept_language = ex_lang_code(accept_language)
      end
    end
  end
end