# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：退会理由
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/20 Nakanohito
# 更新日:
###############################################################################
module Seeds
  module SeedsWithdrawalReason
    # 全データ削除
    def delete_all
      WithdrawalReason.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      WithdrawalReason.create do |ent|
        ent.id = 1;
        ent.withdrawal_reason_cls = 'PSC'
        ent.withdrawal_reason = '本人の都合'
        ent.lock_version = 0;
      end
      WithdrawalReason.create do |ent|
        ent.id = 2;
        ent.withdrawal_reason_cls = 'OTC'
        ent.withdrawal_reason = '本人以外の都合'
        ent.lock_version = 0;
      end
      WithdrawalReason.create do |ent|
        ent.id = 3;
        ent.withdrawal_reason_cls = 'AGV'
        ent.withdrawal_reason = '会員規約違反の為'
        ent.lock_version = 0;
      end
      WithdrawalReason.create do |ent|
        ent.id = 4;
        ent.withdrawal_reason_cls = 'LWV'
        ent.withdrawal_reason = '法令違反の為'
        ent.lock_version = 0;
      end
      WithdrawalReason.create do |ent|
        ent.id = 5;
        ent.withdrawal_reason_cls = 'OTH'
        ent.withdrawal_reason = 'その他'
        ent.lock_version = 0;
      end
    end
    module_function :create
  end
end