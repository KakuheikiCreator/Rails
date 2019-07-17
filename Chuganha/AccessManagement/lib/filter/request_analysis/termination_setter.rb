# -*- coding: utf-8 -*-
###############################################################################
# 終端セッタークラス
# 機能：リクエスト解析結果を返却する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/07 Nakanohito
# 更新日:
###############################################################################
require 'filter/request_analysis/abstract_info_setter'

module Filter
  module RequestAnalysis
    # 終端セッター
    class TerminationSetter < AbstractInfoSetter
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
      # 値の設定処理（テンプレートメソッド）
      def execute(params)
        return params
      end
    end
  end
end