# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションの基底クラス
# 概要：受信したリクエスト情報をラッピングし、バリデーションチェックとデフォルト検索を行う
# コントローラー：AccessTotal::AccessTotalController
# アクション：totalization
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/09/22 Nakanohito
# 更新日:
###############################################################################
require 'common/model/db_util_module'
require 'common/net_util_module'
require 'biz_actions/business_action'
require 'data_cache/generic_code_cache'

module BizActions
  module AccessTotal
    class BaseAction < BizActions::BusinessAction
      include Common::NetUtilModule
      include Common::Model::DbUtilModule
      include DataCache
      # アクセサー定義
      attr_reader :item_1, :item_2, :item_3, :item_4, :item_5, :disp_order, :disp_number,
                  :received_date_from, :time_unit_num, :time_unit, :aggregation_period,
                  :system_id, :function_id, :function_trans_no, :function_trans_no_comp,
                  :session_id, :client_id, :browser_id, :browser_version_id, :browser_version_id_comp,
                  :accept_language, :referrer, :referrer_match, :domain_name, :domain_name_match,
                  :proxy_host, :proxy_host_match, :proxy_ip_address,
                  :remote_host, :remote_host_match, :ip_address,
                  :date_list, :item_values, :graph_data
      
      #########################################################################
      # 定数定義
      #########################################################################
      # IPアドレス条件
      REG_FMT_IP_COND =
      /^(1\d{2}|2[0-4]\d|25[0-5]|[1-9]?\d)(\.(1\d{2}|2[0-4]\d|25[0-5]|[1-9]?\d)){0,3}$/
      # デフォルト値
      DEFAULT_DISP_NUMBER      = '8'     # 表示件数
      DEFAULT_DISP_ORDER       = 'DESC'  # 表示順序
      DEFAULT_TIME_UNIT_NUM    = '1'     # 単位時間数

      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 汎用コードキャッシュ
        @generic_code_cache = DataCache::GenericCodeCache.instance
        # 集計日時リスト
        @date_list = []
        # 線分類
        @item_1     = @params[:item_1]
        @item_2     = @params[:item_2]
        @item_3     = @params[:item_3]
        @item_4     = @params[:item_4]
        @item_5     = @params[:item_5]
        @disp_number = @params[:disp_number]
        @disp_number ||= DEFAULT_DISP_NUMBER
        @disp_order  = @params[:disp_order]
        @disp_order  ||= DEFAULT_DISP_ORDER
        # 横軸
        @received_date_from = date_time_param(:received_date_from)
        if @received_date_from.nil? then
          now = DateTime.now
          @received_date_from = DateTime.new(now.year, now.month, now.day, now.hour, now.minute, 0, now.offset)
        end
        @time_unit_num = @params[:time_unit_num]
        @time_unit_num ||= DEFAULT_TIME_UNIT_NUM
        @time_unit = @params[:time_unit]
        @aggregation_period = @params[:aggregation_period]
        # 抽出条件
        @system_id       = @params[:system_id]
        @function_id     = @params[:function_id]
        @function_trans_no = @params[:function_trans_no]
        @function_trans_no_comp = @params[:function_trans_no_comp]
        @session_id        = @params[:session_id]
        @client_id       = @params[:client_id]
        @browser_id      = @params[:browser_id]
        @browser_version_id = @params[:browser_version_id]
        @browser_version_id_comp  = @params[:browser_version_id_comp]
        @accept_language = @params[:accept_language]
        @referrer        = @params[:referrer]
        @referrer_match  = @params[:referrer_match]
        @domain_name     = @params[:domain_name]
        @domain_name_match  = @params[:domain_name_match]
        @proxy_host      = @params[:proxy_host]
        @proxy_host_match   = @params[:proxy_host_match]
        @proxy_ip_address   = @params[:proxy_ip_address]
        @remote_host     = @params[:remote_host]
        @remote_host_match  = @params[:remote_host_match]
        @ip_address      = @params[:ip_address]
        # 表示データ（項目値リスト）
        @item_values = []
        # 表示データ（受信日時リスト）
        @date_list = []
        # 表示データ（グラフデータ）
        @graph_data = []
      end
      #########################################################################
      # protected定義
      #########################################################################
      protected      
      # 線分類項目チェック
      def line_cond_chk?
        # チェック結果
        check_result = true
        line_fields = @generic_code_cache.code_values(:LINE_FIELDS)
        # 各項目の条件チェック
        if !line_fields.include?(@item_1) then
          @error_msg_hash[:item_1] = validation_msg(:item_1, :invalid)
          check_result = false
        end
        if !blank?(@item_2) && !line_fields.include?(@item_2) then
          @error_msg_hash[:item_2] = validation_msg(:item_2, :invalid)
          check_result = false
        end
        if !blank?(@item_3) && !line_fields.include?(@item_3) then
          @error_msg_hash[:item_3] = validation_msg(:item_3, :invalid)
          check_result = false
        end
        if !blank?(@item_4) && !line_fields.include?(@item_4) then
          @error_msg_hash[:item_4] = validation_msg(:item_4, :invalid)
          check_result = false
        end
        if !blank?(@item_5) && !line_fields.include?(@item_5) then
          @error_msg_hash[:item_5] = validation_msg(:item_5, :invalid)
          check_result = false
        end
        # 表示順序
        order_values = @generic_code_cache.code_values(:SORT_ORDER_CLS)
        unless order_values.include?(@disp_order) then
          @error_msg_hash[:disp_cond] = validation_msg(:display_target, :invalid)
          check_result = false
        end
        # 表示件数
        num_cls_values = @generic_code_cache.code_values(:DISP_NUMBER_S)
        unless num_cls_values.include?(@disp_number) then
          @error_msg_hash[:disp_cond] = validation_msg(:display_target, :invalid)
          check_result = false
        end
        return check_result
      end
      
      # 横軸チェック
      def horizontal_axis_chk?
        # チェック結果
        check_result = true
        # 受信日時
        unless DateTime === @received_date_from then
          @error_msg_hash[:received_date_from] = validation_msg(:received_datetime, :invalid)
          check_result = false
        end
        # 集計単位数
        if blank?(@time_unit_num) || !numeric?(@time_unit_num) || @time_unit_num.to_i <= 0 then
          @error_msg_hash[:time_unit_cond] = validation_msg(:counting_unit, :invalid)
          check_result = false
        end
        # 集計単位
        unit_cls_values = @generic_code_cache.code_values(:TIME_UNIT)
        unless unit_cls_values.include?(@time_unit) then
          @error_msg_hash[:time_unit_cond] = validation_msg(:counting_unit, :invalid)
          check_result = false
        end
        # 集計期間
        period_values = @generic_code_cache.code_values(:AGGREGATION_PERIOD)
        unless period_values.include?(@aggregation_period) then
          @error_msg_hash[:aggregation_period] = validation_msg(:aggregation_period, :invalid)
          check_result = false
        end
        return check_result
      end
      
      # 抽出条件項目チェック
      def extraction_cond_chk?
        check_result = true
        # 比較条件値リスト
        comp_cls_name = @generic_code_cache.code_name(:COMP_COND_CLS)
        comp_cls_values = @generic_code_cache.code_values(:COMP_COND_CLS)
        # マッチング条件値リスト
        match_cls_name = @generic_code_cache.code_name(:MATCH_COND_CLS)
        match_cls_values = @generic_code_cache.code_values(:MATCH_COND_CLS)
        # システムID
        if !numeric_val?(@system_id) then
          attr_name = System.human_attribute_name("system_name")
          @error_msg_hash[:system_id] = validation_msg(attr_name, :invalid)
          check_result = false
        end
        # 機能
        if !numeric_val?(@function_id) then
          attr_name = Function.human_attribute_name("function_name")
          @error_msg_hash[:function_id] = validation_msg(attr_name, :invalid)
          check_result = false
        end
        # 機能遷移番号
        if !numeric_val?(@function_trans_no) then
          attr_name = RequestAnalysisResult.human_attribute_name("function_transition_no")
          @error_msg_hash[:function_trans_no_cond] = validation_msg(attr_name, :invalid)
          check_result = false
        # 機能遷移番号比較条件
        elsif !comp_cls_values.include?(@function_trans_no_comp) then
          @error_msg_hash[:function_trans_no_cond] = validation_msg(comp_cls_name, :invalid)
          check_result = false
        end
        # セッションID
        if !blank?(@session_id) && !length_is?(@session_id, 32) then
          attr_name = RequestAnalysisResult.human_attribute_name("session_id")
          @error_msg_hash[:session_id] = validation_msg(attr_name, :invalid)
          check_result = false
        end
        # クライアントID
        if !blank?(@client_id) && overflow?(@client_id, 255) then
          attr_name = RequestAnalysisResult.human_attribute_name("client_id")
          @error_msg_hash[:client_id] = validation_msg(attr_name, :invalid)
          check_result = false
        end
        # ブラウザID
        if !numeric_val?(@browser_id) then
          attr_name = Browser.human_attribute_name("browser_name")
          @error_msg_hash[:browser_id] = validation_msg(attr_name, :invalid)
          check_result = false
        end
        # ブラウザバージョンID
        if !numeric_val?(@browser_version_id) then
          attr_name = BrowserVersion.human_attribute_name("browser_version")
          @error_msg_hash[:browser_version_cond] = validation_msg(attr_name, :invalid)
          check_result = false
        # ブラウザバージョン比較条件
        elsif !comp_cls_values.include?(@browser_version_id_comp) then
          @error_msg_hash[:browser_version_cond] = validation_msg(comp_cls_name, :invalid)
          check_result = false
        end
        # 言語
        if !hankaku_val?(@accept_language) then
          attr_name = RequestAnalysisResult.human_attribute_name("accept_language")
          @error_msg_hash[:accept_language] = validation_msg(attr_name, :invalid)
          check_result = false
        end
        # ドメイン名
        if !hankaku_val?(@domain_name) then
          attr_name = Domain.human_attribute_name("domain_name")
          @error_msg_hash[:domain_name_cond] = validation_msg(attr_name, :invalid)
          check_result = false
        # ドメイン名一致条件
        elsif !match_cls_values.include?(@domain_name_match) then
          @error_msg_hash[:domain_name_cond] = validation_msg(match_cls_name, :invalid)
          check_result = false
        end
        # リファラー
        if !hankaku_val?(@referrer) then
          attr_name = RequestAnalysisResult.human_attribute_name("referrer")
          @error_msg_hash[:referrer_cond] = validation_msg(attr_name, :invalid)
          check_result = false
        # リファラー一致条件
        elsif !match_cls_values.include?(@referrer_match) then
          @error_msg_hash[:referrer_cond] = validation_msg(match_cls_name, :invalid)
          check_result = false
        end
        # プロキシホスト
        if !hankaku_val?(@proxy_host) then
          attr_name = RequestAnalysisResult.human_attribute_name("proxy_host")
          @error_msg_hash[:proxy_host_cond] = validation_msg(attr_name, :invalid)
          check_result = false
        # プロキシホスト一致条件
        elsif !match_cls_values.include?(@proxy_host_match) then
          @error_msg_hash[:proxy_host_cond] = validation_msg(match_cls_name, :invalid)
          check_result = false
        end
        # プロキシIP
        if !ip_cond_val?(@proxy_ip_address) then
          attr_name = RequestAnalysisResult.human_attribute_name("proxy_ip_address")
          @error_msg_hash[:proxy_ip_address] = validation_msg(attr_name, :invalid)
          check_result = false
        end
        # クライアントホスト
        if !hankaku_val?(@remote_host) then
          attr_name = RequestAnalysisResult.human_attribute_name("remote_host")
          @error_msg_hash[:remote_host_cond] = validation_msg(attr_name, :invalid)
          check_result = false
        # クライアントホスト一致条件
        elsif !match_cls_values.include?(@remote_host_match) then
          @error_msg_hash[:remote_host_cond] = validation_msg(match_cls_name, :invalid)
          check_result = false
        end
        # クライアントIP
        if !ip_cond_val?(@ip_address) then
          attr_name = RequestAnalysisResult.human_attribute_name("ip_address")
          @error_msg_hash[:ip_address] = validation_msg(attr_name, :invalid)
          check_result = false
        end
        return check_result
      end
      
      # 数値チェック
      def numeric_val?(val)
        return true if blank?(val)
        return numeric?(val) 
      end
      
      # 半角文字数チェック
      def hankaku_val?(val)
        return true if blank?(val)
        return hankaku?(val) && !overflow?(val, 255)
      end
      
      # IP条件チェック
      def ip_cond_val?(val)
        return true if blank?(val)
        return !(REG_FMT_IP_COND =~ val).nil?
      end
      
      # 線分類項目関連チェック
      def line_class_rel_chk?
        check_result = true
        # 項目値リスト等
        item_val_list = [@item_1, @item_2, @item_3, @item_4, @item_5]
        item_key_list = [:item_1, :item_2, :item_3, :item_4, :item_5]
        val_blk_flg = false
        bef_blk_flg = false
        overlap_list = Array.new
        # 分類項目のチェック
        item_val_list.each_with_index do |item_val, idx|
          val_blk_flg = blank?(item_val)
          unless val_blk_flg then
            item_key = item_key_list[idx]
            # 項目重複チェック
            if overlap_list.include?(item_val) then
              @error_msg_hash[item_key] = validation_msg(item_key, :invalid)
              check_result = false
            # 間欠チェック
            elsif bef_blk_flg then
              target_msg = view_text('item_names.' + item_key_list[idx-1].to_s)
              @error_msg_hash[item_key] = validation_msg(item_key, :consistency, :target=>target_msg)
              check_result = false
            end
          end
          bef_blk_flg = val_blk_flg
          overlap_list.push(item_val)
        end
        return check_result
      end
      
      # 抽出条件項目の関連チェック
      def extraction_cond_rel_chk?
        check_result = true
        # システムIDと機能ID
        if blank?(@system_id) && !blank?(@function_id) then
          attr_name = System.human_attribute_name("system_name")
          @error_msg_hash[:system_id] = validation_msg(attr_name, :blank)
          check_result = false
        end
        # ブラウザIDとブラウザバージョンID
        if blank?(@browser_id) && !blank?(@browser_version_id) then
          attr_name = Browser.human_attribute_name("browser_name")
          @error_msg_hash[:browser_id] = validation_msg(attr_name, :blank)
          check_result = false
        end
        return check_result
      end
      
      # システム存在チェック
      def system_exist_chk?
        return true if blank?(@system_id)
        unless System.exists?(@system_id.to_i) then
          attr_name = System.human_attribute_name("system_name")
          @error_msg_hash[:system_id] = validation_msg(attr_name, :not_found)
          return false
        end
        return true
      end
      
      # 機能存在チェック
      def function_exist_chk?
        return true if blank?(@function_id)
        if Function.where(:id=>@function_id.to_i, :system_id=>@system_id.to_i).empty? then
          attr_name = Function.human_attribute_name("function_name")
          @error_msg_hash[:function_id] = validation_msg(attr_name, :not_found)
          return false
        end
        return true
      end
      
      # ブラウザ存在チェック
      def browser_exist_chk?
        return true if blank?(@browser_id)
        unless Browser.exists?(@browser_id.to_i) then
          attr_name = Browser.human_attribute_name("browser_name")
          @error_msg_hash[:browser_id] = validation_msg(attr_name, :not_found)
          return false
        end
        return true
      end
      
      # ブラウザバージョン存在チェック
      def browser_version_exist_chk?
        return true if blank?(@browser_version_id)
        if BrowserVersion.where(:id=>@browser_version_id.to_i, :browser_id=>@browser_id.to_i).empty? then
          attr_name = BrowserVersion.human_attribute_name("browser_version")
          @error_msg_hash[:browser_version_id] = validation_msg(attr_name, :not_found)
          return false
        end
        return true
      end
      
      # ドメイン存在チェック
      def domain_exist_chk?
        return true if blank?(@domain_name)
        statement = match_statement('domain_name', @domain_name_match)
        param = match_param(@domain_name, @domain_name_match)
        if Domain.where(statement, param).empty? then
          attr_name = Domain.human_attribute_name("domain_name")
          @error_msg_hash[:domain_name_cond] = validation_msg(attr_name, :not_found)
          return false
        end
        return true
      end
    end
  end
end