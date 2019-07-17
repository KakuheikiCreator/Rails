# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：規制クッキー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/03/23 Nakanohito
# 更新日:
###############################################################################
module Seeds
  module SeedsRegulationCookie
    # 全データ削除
    def delete_all
      RegulationCookie.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      RegulationCookie.create do |ent|
        ent.id = 1;
        ent.system_id = 1;
        ent.cookie = "Test Cookie 01";
        ent.remarks = "備考１";
        ent.lock_version = 0;
      end
      RegulationCookie.create do |ent|
        ent.id = 2;
        ent.system_id = 1;
        ent.cookie = "Test Cookie 02";
        ent.remarks = "備考２";
        ent.lock_version = 0;
      end
      RegulationCookie.create do |ent|
        ent.id = 3;
        ent.system_id = 1;
        ent.cookie = "Test Cookie 03";
        ent.remarks = "備考３";
        ent.lock_version = 0;
      end
      RegulationCookie.create do |ent|
        ent.id = 4;
        ent.system_id = 1;
        ent.cookie = "Test Cookie 04";
        ent.remarks = "備考４";
        ent.lock_version = 0;
      end
    end
    module_function :create
  end
end