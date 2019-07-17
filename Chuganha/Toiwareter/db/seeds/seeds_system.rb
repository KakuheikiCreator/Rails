# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：システム
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/02/27 Nakanohito
# 更新日:
###############################################################################
module Seeds
  module SeedsSystem
    # 全データ削除
    def delete_all
      System.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      System.create do |ent|
        ent.id = 1
        ent.system_name = "仲観派"
        ent.subsystem_name = "Access Management"
        ent.lock_version = 0
      end
      System.create do |ent|
        ent.id = 2
        ent.system_name = "仲観派"
        ent.subsystem_name = "Member Management"
        ent.lock_version = 0
      end
      System.create do |ent|
        ent.id = 3
        ent.system_name = "仲観派"
        ent.subsystem_name = "Toiwareter"
        ent.lock_version = 0
      end
    end
    module_function :create
  end
end