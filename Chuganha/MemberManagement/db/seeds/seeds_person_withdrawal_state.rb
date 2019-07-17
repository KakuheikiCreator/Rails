# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：退会者状態
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/20 Nakanohito
# 更新日:
###############################################################################
module Seeds
  module SeedsPersonWithdrawalState
    # 全データ削除
    def delete_all
      PersonWithdrawalState.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      PersonWithdrawalState.create do |ent|
        ent.id = 1;
        ent.person_withdrawal_state_cls = 'PRW'
        ent.person_withdrawal_state = '退会済み'
        ent.lock_version = 0;
      end
      PersonWithdrawalState.create do |ent|
        ent.id = 2;
        ent.person_withdrawal_state_cls = 'DPI'
        ent.person_withdrawal_state = '個人情報削除済み'
        ent.lock_version = 0;
      end
    end
    module_function :create
  end
end