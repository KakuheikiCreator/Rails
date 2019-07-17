# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：リクエスト解析スケジュール
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/06 Nakanohito
# 更新日:
###############################################################################
module Seeds
  module SeedsRequestAnalysisSchedule
    # 全データ削除
    def delete_all
      RequestAnalysisSchedule.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      systems = System.where(:system_name=>"仲観派").
                       where(:subsystem_name=>"Access Management")
      RequestAnalysisSchedule.create do |ent|
        ent.id = 0;
        ent.gets_start_date = '2012-02-06 04:00:00';
        ent.system_id = systems[0].id;
        ent.gs_received_year = true;
        ent.gs_received_month = true;
        ent.gs_received_day = true;
        ent.gs_received_hour = true;
        ent.gs_received_minute = true;
        ent.gs_received_second = true;
        ent.gs_function_id = true;
        ent.gs_function_transition_no = true;
        ent.gs_session_id = true;
        ent.gs_client_id = true;
        ent.gs_browser_id = true;
        ent.gs_browser_version_id = true;
        ent.gs_accept_language = true;
        ent.gs_referrer = true;
        ent.gs_domain_id = true;
        ent.gs_proxy_host = true;
        ent.gs_proxy_ip_address = true;
        ent.gs_remote_host = true;
        ent.gs_ip_address = true;
        ent.lock_version = 0;
      end
    end
    module_function :create
  end
end