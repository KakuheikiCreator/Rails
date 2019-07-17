# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションの基底クラス
# 概要：受信したリクエスト情報をラッピングし、バリデーションチェックとデフォルト検索を行う
# コントローラー：AccessTotal::AccessTotalController
# アクション：totalization
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/09/24 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/access_total/base_action'
require 'biz_actions/access_total/sql_ranking'
require 'biz_actions/access_total/sql_totalization'

module BizActions
  module AccessTotal
    class TotalizationAction < BizActions::AccessTotal::BaseAction
      include BizActions::AccessTotal
      # アクセサー定義
      attr_reader :result_list
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # キーリスト
        @line_key_list = Array.new
        [:item_1, :item_2, :item_3, :item_4, :item_5].each do |item|
          item_name = @params[item]
          break if blank?(item_name)
          @line_key_list.push(item_name)
        end
        # 集計結果リスト
        @result_list = []
      end

      #########################################################################
      # public定義
      #########################################################################
      public
      # リスト検索
      def totalization
        ActiveRecord::Base.transaction do
          return unless valid?
          @date_list = received_date_list
          sql_params = @params.dup
          sql_params[:received_date_from] = @received_date_from
          total_sql = SQLTotalization.new(sql_params)
          @result_list = RequestAnalysisResult.find_by_sql(total_sql.sql_params)
          @item_values = to_item_values(@result_list)
          @graph_data  = to_graph_data(@result_list)
        end
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 線分類チェック
        check_result = line_cond_chk?
        # 横軸チェック
        check_result = false unless horizontal_axis_chk?
        # 抽出条件チェック
        check_result = false unless extraction_cond_chk?
        return check_result
      end
      
      # 項目関連チェック
      def related_items_chk?
        # 線分類項目関係チェック
        check_result = line_class_rel_chk?
        # 抽出条件関係チェック
        check_result = false unless extraction_cond_rel_chk?
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        # システム存在チェック
        check_result = system_exist_chk?
        # 機能存在チェック
        check_result = false unless function_exist_chk?
        # ブラウザ存在チェック
        check_result = false unless browser_exist_chk?
        # ブラウザバージョン存在チェック
        check_result = false unless browser_version_exist_chk?
        # ドメイン存在チェック
        check_result = false unless domain_exist_chk?
        return check_result
      end
      
      # 受信日時リスト生成
      def received_date_list
        # 差分算出
        difference = nil
        case @time_unit
        when 'year' then
          difference = @time_unit_num.to_i.years
        when 'month' then
          difference = @time_unit_num.to_i.months
        when 'day' then
          difference = @time_unit_num.to_i.days
        when 'hour' then
          difference = @time_unit_num.to_i.hours
        when 'minute' then
          difference = @time_unit_num.to_i.minutes
        else
          difference = @time_unit_num.to_i.seconds
        end        
        date_list = Array.new
        next_datetime = @received_date_from
        @aggregation_period.to_i.times do
          date_list.push(datetime_to_str(next_datetime))
          next_datetime = next_datetime + difference
        end
        return date_list
      end
      
      # 日付文字列生成
      def datetime_to_str(datetime)
        str_list = [datetime.year]
        return to_date_str(str_list) if @time_unit == 'year'
        str_list.push(datetime.month)
        return to_date_str(str_list) if @time_unit == 'month'
        str_list.push(datetime.day)
        return to_date_str(str_list) if @time_unit == 'day'
        str_list.push(datetime.hour)
        return to_date_str(str_list) if @time_unit == 'hour'
        str_list.push(datetime.minute)
        return to_date_str(str_list) if @time_unit == 'minute'
        str_list.push(datetime.second)
        return to_date_str(str_list)
      end
      
      # 日時文字列変換
      def to_date_str(val_list)
        value_list = val_list.dup
        str_list = [lpad(value_list.shift, 4)]
        ['/', '/', ' ', ':', ':'].each do |sep|
          value = value_list.shift
          break if blank?(value)
          str_list.push(sep)
          str_list.push(lpad(value, 2))
        end
        return str_list.join
      end
      
      # 文字列埋め処理
      def lpad(val, length)
        return ''.rjust(length, 'X') if blank?(val)
        return val.to_s.rjust(length, '0')
      end
      
      # 項目名リスト生成
      def to_item_values(result_list)
        legend_list = 'ABCDEFGH'.split('')
        item_values_list = Array.new
        bef_ent = nil
        result_list.each do |ent|
          next unless line_key_break?(bef_ent, ent)
          values = [legend_list.shift]
          @line_key_list.each do |item_name|
            case item_name
            when 'system_id' then
              system_ent = ent.system
              system_name = ''
              system_name = system_ent.system_name + '　' + system_ent.subsystem_name unless system_ent.nil?
              values.push(system_name)
            when 'function_id' then
              function_name = ''
              function_name = ent.function.function_name unless ent.function.nil?
              values.push(function_name)
            when 'browser_id' then
              browser_name = ''
              browser_name = ent.browser.browser_name unless ent.browser.nil?
              values.push(browser_name)
            when 'browser_version_id' then
              browser_version = ''
              browser_version = ent.browser_version.browser_version unless ent.browser_version.nil?
              values.push(browser_version)
            else
              values.push(ent.attributes[item_name])
            end
          end
          item_values_list.push(values)
          bef_ent = ent
        end
        return item_values_list
      end
      
      # グラフデータ生成
      def to_graph_data(result_list)
        graph_data = Array.new
        return graph_data if result_list.empty?
        bef_ent = result_list[0]
        line_ent_list = Array.new
        result_list.each do |ent|
          if line_key_break?(bef_ent, ent) then
            graph_data.push(to_line_data(line_ent_list))
            line_ent_list = Array.new
            bef_ent = ent
          end
          line_ent_list.push(ent)
        end
        graph_data.push(to_line_data(line_ent_list))
        return graph_data
      end
      
      # キーブレーク判定
      def line_key_break?(bef_ent, now_ent)
        return true if bef_ent.nil?
        @line_key_list.each do |key_item|
          return true if bef_ent.attributes[key_item] != now_ent.attributes[key_item]
        end
        return false
      end
      
      # 線データリスト
      def to_line_data(ent_list)
        line_data = Array.new
        ent = ent_list.shift
        @date_list.each do |ref_date|
          sum_count = 0
          unless ent.nil? then
            while ent_to_date_str(ent) <= ref_date do
              sum_count += ent.request_count
              ent = ent_list.shift
              break if ent.nil?
            end
          end
          line_data.push(sum_count)
        end
        return line_data
      end
      
      # 日付文字列返還
      def ent_to_date_str(ent)
        str_list = [ent.received_year]
        return to_date_str(str_list) if @time_unit == 'year'
        str_list.push(ent.received_month)
        return to_date_str(str_list) if @time_unit == 'month'
        str_list.push(ent.received_day)
        return to_date_str(str_list) if @time_unit == 'day'
        str_list.push(ent.received_hour)
        return to_date_str(str_list) if @time_unit == 'hour'
        str_list.push(ent.received_minute)
        return to_date_str(str_list) if @time_unit == 'minute'
        str_list.push(ent.received_second)
        return to_date_str(str_list)
      end
    end
  end
end