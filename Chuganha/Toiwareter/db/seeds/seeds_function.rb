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
      # アクセス管理
      systems = System.where(:system_name=>"仲観派").
                       where(:subsystem_name=>"Access Management")
      Function.create do |ent|
        ent.id = 1;
        ent.system_id = systems[0].id;
        ent.function_path = "common/session/clear";
        ent.function_name = "セッション履歴クリア";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 2;
        ent.system_id = systems[0].id;
        ent.function_path = "common/session/sweep";
        ent.function_name = "タイムアウトセッションクリア";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 3;
        ent.system_id = systems[0].id;
        ent.function_path = "login/login";
        ent.function_name = "ログイン";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 4;
        ent.system_id = systems[0].id;
        ent.function_path = "menu/menu";
        ent.function_name = "メニュー";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 5;
        ent.system_id = systems[0].id;
        ent.function_path = "schedule_list/schedule_list";
        ent.function_name = "アクセス集計";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 6;
        ent.system_id = systems[0].id;
        ent.function_path = "access_total/access_total";
        ent.function_name = "スケジュールリスト";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 7;
        ent.system_id = systems[0].id;
        ent.function_path = "regulation_host_list/regulation_host_list";
        ent.function_name = "規制ホスト一覧";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 8;
        ent.system_id = systems[0].id;
        ent.function_path = "regulation_cookie_list/regulation_cookie_list";
        ent.function_name = "規制クッキー一覧";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 9;
        ent.system_id = systems[0].id;
        ent.function_path = "regulation_referrer_list/regulation_referrer_list";
        ent.function_name = "規制リファラー一覧";
        ent.lock_version = 0;
      end
      # Toiwareter
      systems = System.where(:system_name=>"仲観派").
                       where(:subsystem_name=>"Toiwareter")
      Function.create do |ent|
        ent.id = 10;
        ent.system_id = systems[0].id;
        ent.function_path = "common/session/clear";
        ent.function_name = "セッション履歴クリア";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 11;
        ent.system_id = systems[0].id;
        ent.function_path = "common/session/logout";
        ent.function_name = "ログアウト";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 12;
        ent.system_id = systems[0].id;
        ent.function_path = "common/session/sweep";
        ent.function_name = "タイムアウトセッションクリア";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 13;
        ent.system_id = systems[0].id;
        ent.function_path = "open_id/rp";
        ent.function_name = "ログイン機能";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 14;
        ent.system_id = systems[0].id;
        ent.function_path = "admission/admission";
        ent.function_name = "入会機能";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 15;
        ent.system_id = systems[0].id;
        ent.function_path = "member/view";
        ent.function_name = "会員参照";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 16;
        ent.system_id = systems[0].id;
        ent.function_path = "member/home";
        ent.function_name = "会員ホーム";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 17;
        ent.system_id = systems[0].id;
        ent.function_path = "member/list";
        ent.function_name = "会員リスト";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 18;
        ent.system_id = systems[0].id;
        ent.function_path = "member/update";
        ent.function_name = "会員情報更新";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 19;
        ent.system_id = systems[0].id;
        ent.function_path = "search/fulltext";
        ent.function_name = "全文検索";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 20;
        ent.system_id = systems[0].id;
        ent.function_path = "search/detail";
        ent.function_name = "詳細検索";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 21;
        ent.system_id = systems[0].id;
        ent.function_path = "quote/post";
        ent.function_name = "引用投稿";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 22;
        ent.system_id = systems[0].id;
        ent.function_path = "quote/update";
        ent.function_name = "引用更新";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 23;
        ent.system_id = systems[0].id;
        ent.function_path = "quote/delete";
        ent.function_name = "引用削除";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 24;
        ent.system_id = systems[0].id;
        ent.function_path = "quote/view";
        ent.function_name = "引用参照";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 25;
        ent.system_id = systems[0].id;
        ent.function_path = "comment/post";
        ent.function_name = "コメント投稿";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 26;
        ent.system_id = systems[0].id;
        ent.function_path = "comment/report";
        ent.function_name = "コメント通報";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 27;
        ent.system_id = systems[0].id;
        ent.function_path = "comment/delete";
        ent.function_name = "コメント削除";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 28;
        ent.system_id = systems[0].id;
        ent.function_path = "report/list";
        ent.function_name = "コメント通報リスト";
        ent.lock_version = 0;
      end
      Function.create do |ent|
        ent.id = 29;
        ent.system_id = systems[0].id;
        ent.function_path = "ng_list/ng_list";
        ent.function_name = "NGワードリスト";
        ent.lock_version = 0;
      end

    end
    module_function :create
  end
end