# -*- coding: utf-8 -*-
###############################################################################
# マイグレーションファイル:システム
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/27 Nakanohito
# 更新日:
###############################################################################
class CreateSystems < ActiveRecord::Migration
  def change
    create_table :systems do |t|
      t.string :system_name
      t.string :subsystem_name
      t.integer :lock_version

      t.timestamps
    end
  end
end
