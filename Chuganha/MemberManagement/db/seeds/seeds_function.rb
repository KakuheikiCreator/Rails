# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：機能
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/30 Nakanohito
# 更新日:
###############################################################################
module Seeds
  module SeedsFunction
    # 全データ削除
    def delete_all
      Function.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      systems = System.where(:system_name=>"仲観派").
                       where(:subsystem_name=>"Access Management")
      Function.create do |ent|
        ent.id = 1;
        ent.system_id = systems[0].id;
        ent.function_path = "login/login";
        ent.function_name = "ログイン";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 2;
        ent.system_id = systems[0].id;
        ent.function_path = "menu/menu";
        ent.function_name = "メニュー";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 3;
        ent.system_id = systems[0].id;
        ent.function_path = "schedule_list/schedule_list";
        ent.function_name = "アクセス集計";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 4;
        ent.system_id = systems[0].id;
        ent.function_path = "access_total/access_total";
        ent.function_name = "スケジュールリスト";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 5;
        ent.system_id = systems[0].id;
        ent.function_path = "regulation_host_list/regulation_host_list";
        ent.function_name = "規制ホスト一覧";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 6;
        ent.system_id = systems[0].id;
        ent.function_path = "regulation_cookie_list/regulation_cookie_list";
        ent.function_name = "規制クッキー一覧";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 7;
        ent.system_id = systems[0].id;
        ent.function_path = "regulation_referrer_list/regulation_referrer_list";
        ent.function_name = "規制リファラー一覧";
        ent.lock_version = 0;
      end
    end
    module_function :create
  end
end