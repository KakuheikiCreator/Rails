# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：電子掲示板
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/26 Nakanohito
# 更新日:
###############################################################################
require "csv"

module Seeds
  module SeedsBbs
    # 全データ削除
    def delete_all
      Bbs.delete_all
    end
    module_function :delete_all
    
    # データ生成
    def create
      file_path = Rails.root + 'db/data/bbs.txt'
      id_val = 1
      CSV.foreach(file_path) do |row|
        Bbs.create do |ent|
          ent.id = row[0].to_i;
          ent.bbs_name = row[1];
        end
      end
    end
    module_function :create
  end
end