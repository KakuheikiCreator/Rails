# -*- coding: utf-8 -*-
###############################################################################
# マイグレーションファイル:機能
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/27 Nakanohito
# 更新日:
###############################################################################
class CreateFunctions < ActiveRecord::Migration
  def change
    create_table :functions do |t|
      t.integer :system_id
      t.string :function_path
      t.string :function_name
      t.integer :lock_version

      t.timestamps
    end
  end
end
