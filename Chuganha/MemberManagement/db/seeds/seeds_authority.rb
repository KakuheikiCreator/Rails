# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：権限
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/20 Nakanohito
# 更新日:
###############################################################################
module Seeds
  module SeedsAuthority
    # 全データ削除
    def delete_all
      Authority.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      Authority.create do |ent|
        ent.id = 1;
        ent.authority_cls = 'GEN';
        ent.authority = '一般会員';
        ent.authority_simple = '一般';
      end
      Authority.create do |ent|
        ent.id = 2;
        ent.authority_cls = 'ADM';
        ent.authority = '管理者';
        ent.authority_simple = '管理';
      end
    end
    module_function :create
  end
end