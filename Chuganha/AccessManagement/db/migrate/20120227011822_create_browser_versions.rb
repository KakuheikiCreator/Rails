# -*- coding: utf-8 -*-
###############################################################################
# マイグレーションファイル:ブラウザバージョン
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/27 Nakanohito
# 更新日:
###############################################################################
class CreateBrowserVersions < ActiveRecord::Migration
  def change
    create_table :browser_versions do |t|
      t.integer :browser_id
      t.string :browser_version
      t.integer :lock_version

      t.timestamps
    end
  end
end
