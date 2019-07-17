# -*- coding: utf-8 -*-
###############################################################################
# クラス：アプリケーションヘルパークラス
# 機能：規制ホスト一覧
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/08/06 Nakanohito
# 更新日:
###############################################################################
require 'biz_helpers/business_helper'

module BizHelpers
  module ScheduleList
    class ListHelper < BizHelpers::BusinessHelper
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @now_time = Time.now
      end
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # 全チェックボタン
      def full_check_button(entity, opts={})
        if entity.gets_start_date < @now_time then
          return " "
        end
        opts[:type] = "button"
        opts[:value] = vt('item_names.select')
        opts[:onclick] = "full_check(this)"
        return tag("input", opts)
      end
      
      # サブミットボタン生成
      def submit_button(value, action, opts={})
        opts[:type] = "button"
        opts[:value] = value
        opts[:onclick] = "submit_action(this, '" + action + "')"
        return tag("input", opts)
      end
      
      # サブミットボタン生成（削除）
      def delete_button(ent, opts={})
        opts[:type] = "button"
        opts[:value] = vt('item_names.delete')
        opts[:onclick] = "delete_action('" + ent.id.to_s + "')"
        return tag("input", opts)
      end
      
      # サブミットボタン生成（更新）
      def update_button(ent, opts={})
        return '' if ent.gets_start_date <= @now_time
        opts[:type] = "button"
        opts[:value] = vt('item_names.update')
        opts[:onclick] = "update_action(this, " + ent.id.to_s + ")"
        return tag("input", opts)
      end
      
      # ソート項目選択コンボボックスオプション
      def item_select_options(selected=nil)
        label_hash = {
          System.human_attribute_name("system_name")=>'system_id',
          RequestAnalysisSchedule.human_attribute_name('gets_start_date')=>'gets_start_date',
          RequestAnalysisSchedule.human_attribute_name('gs_received_year')=>'gs_received_year',
          RequestAnalysisSchedule.human_attribute_name('gs_received_month')=>'gs_received_month',
          RequestAnalysisSchedule.human_attribute_name('gs_received_day')=>'gs_received_day',
          RequestAnalysisSchedule.human_attribute_name('gs_received_hour')=>'gs_received_hour',
          RequestAnalysisSchedule.human_attribute_name('gs_received_minute')=>'gs_received_minute',
          RequestAnalysisSchedule.human_attribute_name('gs_received_second')=>'gs_received_second',
          RequestAnalysisSchedule.human_attribute_name('gs_function_id')=>'gs_function_id',
          RequestAnalysisSchedule.human_attribute_name('gs_function_transition_no')=>'gs_function_transition_no',
          RequestAnalysisSchedule.human_attribute_name('gs_login_id')=>'gs_login_id',
          RequestAnalysisSchedule.human_attribute_name('gs_client_id')=>'gs_client_id',
          RequestAnalysisSchedule.human_attribute_name('gs_browser_id')=>'gs_browser_id',
          RequestAnalysisSchedule.human_attribute_name('gs_browser_version_id')=>'gs_browser_version_id',
          RequestAnalysisSchedule.human_attribute_name('gs_accept_language')=>'gs_accept_language',
          RequestAnalysisSchedule.human_attribute_name('gs_referrer')=>'gs_referrer',
          RequestAnalysisSchedule.human_attribute_name('gs_domain_id')=>'gs_domain_id',
          RequestAnalysisSchedule.human_attribute_name('gs_proxy_host')=>'gs_proxy_host',
          RequestAnalysisSchedule.human_attribute_name('gs_proxy_ip_address')=>'gs_proxy_ip_address',
          RequestAnalysisSchedule.human_attribute_name('gs_remote_host')=>'gs_remote_host',
          RequestAnalysisSchedule.human_attribute_name('gs_ip_address')=>'gs_ip_address'
        }
        return options_for_select(label_hash, selected)
      end
      
      # リクエスト解析スケジュールのチェックボックス生成
      def entity_check_box(entity, attr)
        attr_name = attr.to_s
        name = 'analysis_schedule[' + attr_name + ']'
        value = entity.attributes[attr_name]
        opts = Hash.new
        if entity.gets_start_date < @now_time then
          opts[:disabled] = true
          opts[:readonly] = true
        end
        return check_box_tag(name, true, value, opts)
      end
      
      # リクエスト解析スケジュールのHidden項目
      def entity_hidden(attr)
        name = 'analysis_schedule[' + attr.to_s + ']'
        return hidden_field_tag(name, false)
      end
    end
  end
end
