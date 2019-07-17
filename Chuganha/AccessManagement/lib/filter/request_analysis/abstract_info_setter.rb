# -*- coding: utf-8 -*-
###############################################################################
# 抽象セッタークラス
# 機能：各セッタークラスの基底クラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/02 Nakanohito
# 更新日:
###############################################################################
require 'common/validation_chk_module'

module Filter
  module RequestAnalysis
    # 抽象セッタークラス
    class AbstractInfoSetter
      include Common::ValidationChkModule
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(setting_info, next_setter)
        # リクエスト解析スケジュール
        @setting_info = setting_info
        # 次のセッターインスタンス
        @next_setter = next_setter
      end
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # 値の設定処理（テンプレートメソッド）
      def execute(params)
        set_values(params)
        @next_setter.execute(params)
        return params
      end
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # 値の設定処理（サブクラスでオーバーライド）
      def set_values(params)
      end
    end
  end
end