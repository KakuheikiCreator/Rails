# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：携帯キャリア
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/20 Nakanohito
# 更新日:
###############################################################################
require "csv"

module Seeds
  module SeedsMobileCarrier
    # 全データ削除
    def delete_all
      MobileCarrier.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      file_path = Rails.root + 'db/data/mobile_carrier.CSV'
      id_val = 1
      CSV.foreach(file_path) do |row|
        MobileCarrier.create do |ent|
          ent.id = id_val;
          ent.mobile_carrier_cd  = row[0];
          ent.mobile_domain_no   = row[1].to_i;
          ent.mobile_carrier     = row[2];
          ent.domain             = row[3];
          id_val += 1
        end
      end
    end
    module_function :create
  end
end