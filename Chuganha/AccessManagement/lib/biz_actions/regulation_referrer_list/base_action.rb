# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションの基底クラス
# 概要：受信したリクエスト情報をラッピングし、検証と規制リファラー情報の検索を行う
# コントローラー：RegulationReferrer::RegulationReferrerController
# アクション：list,create,delete,notify
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/07/31 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/generic_code_cache'

module BizActions
  module RegulationReferrerList
    class BaseAction < BizActions::BusinessAction
      include DataCache
      # アクセサー定義
      attr_reader :reg_referrer, :reg_referrer_list, :sort_item, :sort_order, :disp_counts
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        reg_params = params[:regulation_referrer]
        reg_params = Hash.new unless Hash === reg_params
        begin
          @reg_referrer = RegulationReferrer.new(reg_params)
        rescue StandardError=>ex
          @reg_referrer = RegulationReferrer.new()
        end
        @system_id = reg_params[:system_id]
        @referrer = reg_params[:referrer]
        @remarks = reg_params[:remarks]
        @sort_item   = params[:sort_item]
        @sort_item   ||= 'system_id'
        @sort_order  = params[:sort_order]
        @sort_order  ||= 'ASC'
        @disp_counts = params[:disp_counts]
        @disp_counts ||= '500'
        # リスト
        @reg_referrer_list = nil
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
        # リファラー
        unless blank?(@referrer) then
          if overflow?(@referrer, 1024) then
            @error_msg_hash[:referrer] = validation_msg(:referrer, :invalid)
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
          column_names = RegulationReferrer.column_names
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
        if !@reg_referrer.system_id.nil? && @reg_referrer.system.nil? then
          @error_msg_hash[:system_id] = validation_msg(:system_name, :invalid)
          check_result = false
        end
        return check_result
      end
      
      # デフォルト検索
      def default_search
        return RegulationReferrer.order('system_id ASC').limit(500)
      end
    end
  end
end