# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：肩書き
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/23 Nakanohito
# 更新日:
###############################################################################
require "csv"

module Seeds
  module SeedsJobTitle
    # 全データ削除
    def delete_all
      JobTitle.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      file_path = Rails.root + 'db/data/job_title.txt'
      id_val = 1
      CSV.foreach(file_path) do |row|
        JobTitle.create do |ent|
          ent.id = row[0].to_i
          ent.job_title = row[1]
        end
      end
    end
    module_function :create
  end
end