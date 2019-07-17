# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：性別
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/20 Nakanohito
# 更新日:
###############################################################################
module Seeds
  module SeedsGender
    # 全データ削除
    def delete_all
      Gender.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      Gender.create do |ent|
        ent.id = 1;
        ent.gender_cls = 'M';
        ent.gender = '男性';
        ent.gender_simple = '男';
      end
      Gender.create do |ent|
        ent.id = 2;
        ent.gender_cls = 'F';
        ent.gender = '女性';
        ent.gender_simple = '女';
      end
    end
    module_function :create
  end
end