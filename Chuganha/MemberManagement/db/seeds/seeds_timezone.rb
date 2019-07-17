# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：タイムゾーン
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/20 Nakanohito
# 更新日:
###############################################################################
require "csv"

module Seeds
  module SeedsTimezone
    # 全データ削除
    def delete_all
      Timezone.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      file_path = Rails.root + 'db/data/timezone.csv'
      id_val = 1
      CSV.foreach(file_path) do |row|
        Timezone.create do |ent|
          ent.id = id_val;
          ent.timezone_id  = row[1];
          id_val += 1
        end
      end
    end
    module_function :create
  end
end