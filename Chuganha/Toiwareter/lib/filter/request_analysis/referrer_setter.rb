# -*- coding: utf-8 -*-
###############################################################################
# リファラーセッタークラス
# 機能：リクエスト解析結果にリファラーを設定する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/07 Nakanohito
# 更新日:
###############################################################################
require 'filter/request_analysis/abstract_info_setter'

module Filter
  module RequestAnalysis
    # リファラーセッター
      class ReferrerSetter < AbstractInfoSetter
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
        # リファラーの編集
        referer = params.request.referer
        return if referer.nil?
        params.request_analysis_result.referrer = referer.unpack('a255a*')[0] 
      end
    end
  end
end