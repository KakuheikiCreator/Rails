# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：出所
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/24 Nakanohito
# 更新日:
###############################################################################
require "csv"

module Seeds
  module SeedsSource
    # 全データ削除
    def delete_all
      Source.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      file_path = Rails.root + 'db/data/source.txt'
      id_val = 1
      CSV.foreach(file_path) do |row|
        Source.create do |ent|
          ent.id = row[0].to_i;
          ent.source = row[1];
        end
      end
    end
    module_function :create
  end
end