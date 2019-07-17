# -*- coding: utf-8 -*-
###############################################################################
# リクエスト解析フィルタモジュール
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/12/29 Nakanohito
# 更新日:
# 実行の前提：なし
###############################################################################
require 'filter/request_analysis/request_parser'

module Filter
  module RequestAnalysis
    module RequestAnalysisModule
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # アクション実行前のフィルタ処理
      def request_analysis
        logger.debug('RequestAnalysisFilter Execute!!!')
        RequestParser.instance.parse(self)
      end
    end
  end
end