# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：言語
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/20 Nakanohito
# 更新日:
###############################################################################
require "csv"

module Seeds
  module SeedsLanguage
    # 全データ削除
    def delete_all
      Language.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      file_path = Rails.root + 'db/data/language.csv'
      id_val = 1
      CSV.foreach(file_path) do |row|
        Language.create do |ent|
          ent.id = id_val;
          ent.lang_name_cd      = row[0];
          ent.lang_name         = row[1];
          ent.name_notation_cls = row[2];
          id_val += 1
        end
      end
    end
    module_function :create
  end
end