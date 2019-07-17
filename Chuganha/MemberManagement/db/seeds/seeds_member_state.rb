# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：会員状態
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/20 Nakanohito
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
        ent.member_state_cls = 'PRG';
        ent.member_state = '仮登録';
        ent.member_state_simple = '仮';
      end
      MemberState.create do |ent|
        ent.id = 2;
        ent.member_state_cls = 'DRG';
        ent.member_state = '本登録';
        ent.member_state_simple = '本';
      end
      MemberState.create do |ent|
        ent.id = 3;
        ent.member_state_cls = 'PUD';
        ent.member_state = '仮更新';
        ent.member_state_simple = '更';
      end
      MemberState.create do |ent|
        ent.id = 4;
        ent.member_state_cls = 'QST';
        ent.member_state = '資格停止';
        ent.member_state_simple = '停';
      end
    end
    module_function :create
  end
end