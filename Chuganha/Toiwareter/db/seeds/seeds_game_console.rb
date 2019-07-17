# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：ゲーム機
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/26 Nakanohito
# 更新日:
###############################################################################
require "csv"

module Seeds
  module SeedsGameConsole
    # 全データ削除
    def delete_all
      GameConsole.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      file_path = Rails.root + 'db/data/game_console.txt'
      id_val = 1
      CSV.foreach(file_path) do |row|
        GameConsole.create do |ent|
          ent.id = row[0].to_i;
          ent.game_console_name = row[1];
        end
      end
    end
    module_function :create
  end
end