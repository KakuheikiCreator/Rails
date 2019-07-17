# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：国
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/20 Nakanohito
# 更新日:
###############################################################################
require "csv"

module Seeds
  module SeedsCountry
    # 全データ削除
    def delete_all
      Country.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      file_path = Rails.root + 'db/data/country.csv'
      id_val = 1
      CSV.foreach(file_path) do |row|
        Country.create do |ent|
          ent.id = id_val
          ent.country_name_cd = row[2]
          ent.country_name    = row[5]
          id_val += 1
        end
      end
    end
    module_function :create
  end
end