# -*- coding: utf-8 -*-
###############################################################################
# NULLセッタークラス
# 機能：リクエスト解析結果の設定不要な項目にNULLを設定する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/07 Nakanohito
# 更新日:
###############################################################################
require 'filter/request_analysis/abstract_info_setter'

module Filter
  module RequestAnalysis
    # NULLセッター
    class NullSetter < AbstractInfoSetter
      #########################################################################
      # メソッド定義
      #########################################################################
       # コンストラクタ
      def initialize(setting_info, next_setter)
        super(setting_info, next_setter)
        @nil_item_list = generate_nil_item_list
      end
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # NULL設定処理
      def set_values(params)
        @nil_item_list.each do |item|
          params.request_analysis_result[item] = nil
        end
      end
      # NULL設定項目リスト生成処理
      def generate_nil_item_list
        item_list = Array.new
        # 受信年のクリア
        item_list.push(:received_year) unless @setting_info.gs_received_year
        # 受信月のクリア
        item_list.push(:received_month) unless @setting_info.gs_received_month
        # 受信日のクリア
        item_list.push(:received_day) unless @setting_info.gs_received_day
        # 受信時のクリア
        item_list.push(:received_hour) unless @setting_info.gs_received_hour
        # 受信分のクリア
        item_list.push(:received_minute) unless @setting_info.gs_received_minute
        # 受信秒のクリア
        item_list.push(:received_second) unless @setting_info.gs_received_second
        # 機能IDのクリア
        item_list.push(:function_id) unless @setting_info.gs_function_id
        # 機能遷移番号のクリア
        item_list.push(:function_transition_no) unless @setting_info.gs_function_transition_no
        # セッションIDのクリア
        item_list.push(:session_id) unless @setting_info.gs_session_id
        # クライアントIDのクリア
        item_list.push(:client_id) unless @setting_info.gs_client_id
        # ブラウザIDのクリア
        item_list.push(:browser_id) unless @setting_info.gs_browser_id
        # ブラウザバージョンIDのクリア
        item_list.push(:browser_version_id) unless @setting_info.gs_browser_version_id
        # 言語のクリア
        item_list.push(:accept_language) unless @setting_info.gs_accept_language
        # リファラーのクリア
        item_list.push(:referrer) unless @setting_info.gs_referrer
        # ドメインIDのクリア
        item_list.push(:domain_id) unless @setting_info.gs_domain_id
        # リモートホスト（プロキシ）のクリア
        item_list.push(:proxy_host) unless @setting_info.gs_proxy_host
        # IPアドレス（プロキシ）のクリア
        item_list.push(:proxy_ip_address) unless @setting_info.gs_proxy_ip_address
        # リモートホスト（クライアント）のクリア
        item_list.push(:remote_host) unless @setting_info.gs_remote_host
        # IPアドレス（クライアント）のクリア
        item_list.push(:ip_address) unless @setting_info.gs_ip_address
        return item_list
      end
    end
  end
end