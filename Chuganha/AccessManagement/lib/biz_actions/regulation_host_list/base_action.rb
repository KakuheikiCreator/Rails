# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションの基底クラス
# 概要：受信したリクエスト情報をラッピングし、検証と規制ホスト情報の検索を行う
# コントローラー：RegulationHost::RegulationHostController
# アクション：list,create,delete,notify
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/07/27 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/generic_code_cache'

module BizActions
  module RegulationHostList
    class BaseAction < BizActions::BusinessAction
      include DataCache
      # アクセサー定義
      attr_reader :reg_host, :reg_host_list, :sort_item, :sort_order, :disp_counts
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        reg_params = params[:regulation_host]
        reg_params = Hash.new unless Hash === reg_params
        begin
          @reg_host = RegulationHost.new(reg_params)
        rescue StandardError=>ex
          @reg_host = RegulationHost.new()
        end
        @system_id = reg_params[:system_id]
        @proxy_host = reg_params[:proxy_host]
        @proxy_ip_address = reg_params[:proxy_ip_address]
        @remote_host = reg_params[:remote_host]
        @ip_address = reg_params[:ip_address]
        @remarks = reg_params[:remarks]
        @sort_item   = params[:sort_item]
        @sort_item   ||= 'system_id'
        @sort_order  = params[:sort_order]
        @sort_order  ||= 'ASC'
        @disp_counts = params[:disp_counts]
        @disp_counts ||= '500'
        # 規制ホストリスト
        @reg_host_list = nil
        # 汎用コードキャッシュ
        @generic_code_cache = GenericCodeCache.instance
      end
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目属性チェック
      def items_attr_chk?
        check_result = true
        # システムID
        unless blank?(@system_id) then
          unless numeric?(@system_id.to_s) then
            @error_msg_hash[:system_id] = validation_msg(:system_name, :invalid)
            check_result = false
          end
        end
        # プロキシホスト
        unless blank?(@proxy_host) then
          if overflow?(@proxy_host, 255) then
            @error_msg_hash[:proxy_host] = validation_msg(:proxy_host, :invalid)
            check_result = false
          end
        end
        # プロキシIP
        unless blank?(@proxy_ip_address) then
          if overflow?(@proxy_ip_address, 15) then
            @error_msg_hash[:proxy_ip_address] = validation_msg(:proxy_ip_address, :invalid)
            check_result = false
          end
        end
        # クライアントホスト
        unless blank?(@remote_host) then
          if overflow?(@remote_host, 255) then
            @error_msg_hash[:remote_host] = validation_msg(:remote_host, :invalid)
            check_result = false
          end
        end
        # クライアントIP
        unless blank?(@ip_address) then
          if overflow?(@ip_address, 15) then
            @error_msg_hash[:ip_address] = validation_msg(:ip_address, :invalid)
            check_result = false
          end
        end
        # 備考
        unless blank?(@remarks) then
          if overflow?(@remarks, 255) then
            @error_msg_hash[:remarks] = validation_msg(:remarks, :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # その他条件チェック
      def cond_attr_chk?
        check_result = true
        # ソート条件チェック
        if blank?(@sort_item) then
          @error_msg_hash[:sort_cond] = validation_msg(:ordering, :blank)
          check_result = false
        else
          column_names = RegulationHost.column_names
          sort_order_info = @generic_code_cache.code_info(:SORT_ORDER_CLS)
          unless column_names.include?(@sort_item) &&
                 sort_order_info.values.include?(@sort_order) then
            @error_msg_hash[:sort_cond] = validation_msg(:ordering, :invalid)
            check_result = false
          end
        end
        # 表示件数チェック
        if blank?(@disp_counts) then
          @error_msg_hash[:disp_counts] = validation_msg(:number_to_display, :blank)
          check_result = false
        else
          count_info = @generic_code_cache.code_info(:COUNT_L)
          unless count_info.values.include?(@disp_counts) then
            @error_msg_hash[:disp_counts] = validation_msg(:number_to_display, :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # システム項目存在チェック
      def system_exist_chk?
        check_result = true
        if !@reg_host.system_id.nil? && @reg_host.system.nil? then
          @error_msg_hash[:system_id] = validation_msg(:system_name, :invalid)
          check_result = false
        end
        return check_result
      end
      
      # デフォルト検索
      def default_search
        return RegulationHost.order('system_id ASC').limit(500)
      end
    end
  end
end