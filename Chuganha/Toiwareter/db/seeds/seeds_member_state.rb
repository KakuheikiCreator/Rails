# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：会員状態
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/09 Nakanohito
# 更新日:
###############################################################################
module Seeds
  module SeedsMemberState
    # 全データ削除
    def delete_all
      MemberState.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      MemberState.create do |ent|
        ent.id = 1;
        ent.member_state_cls = 'RGD';
        ent.member_state = '登録済み';
        ent.member_state_simple = '登';
      end
      MemberState.create do |ent|
        ent.id = 2;
        ent.member_state_cls = 'QST';
        ent.member_state = '資格停止';
        ent.member_state_simple = '停';
      end
      MemberState.create do |ent|
        ent.id = 3;
        ent.member_state_cls = 'LDT';
        ent.member_state = '論理削除';
        ent.member_state_simple = '削';
      end
    end
    module_function :create
  end
end