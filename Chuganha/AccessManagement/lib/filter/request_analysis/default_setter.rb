# -*- coding: utf-8 -*-
###############################################################################
# デフォルトセッタークラス
# 機能：リクエスト解析結果に基本情報を設定する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/02 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/system_cache'
require 'filter/request_analysis/abstract_info_setter'
require 'biz_common/business_config'

module Filter
  module RequestAnalysis
    # デフォルトセッター
    class DefaultSetter < AbstractInfoSetter
      include DataCache
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(setting_info, next_setter)
        super(setting_info, next_setter)
        @business_config = BizCommon::BusinessConfig.instance
        @system_cache = SystemCache.instance
      end
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # 設定処理
      def set_values(params)
        analysis_info = params.request_analysis_result
        # システムIDの編集
        analysis_info.system_id = @setting_info.system_id
        # リクエスト解析スケジュールIDの編集
        analysis_info.request_analysis_schedule_id = @setting_info.id
        # 機能ID
        analysis_info.function_id = get_function_id(params.controller_path)
        # 機能遷移番号
        analysis_info.function_transition_no = params.request.params[:function_transition_no]
        # リクエスト回数の編集
        analysis_info.request_count = 1
      end
      # 機能ID検索
      def get_function_id(function_path)
        info = @system_cache.get_function(@business_config.system_name,
                                          @business_config.subsystem_name,
                                          function_path)
        return info.id unless info.nil?
        return nil
      end
    end
  end
end