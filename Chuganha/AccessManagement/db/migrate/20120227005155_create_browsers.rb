# -*- coding: utf-8 -*-
###############################################################################
# マイグレーションファイル:ブラウザ
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/27 Nakanohito
# 更新日:
###############################################################################
class CreateBrowsers < ActiveRecord::Migration
  def change
    create_table :browsers do |t|
      t.string :browser_name
      t.integer :lock_version

      t.timestamps
    end
  end
end
