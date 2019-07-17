# -*- coding: utf-8 -*-
###############################################################################
# マイグレーションファイル:ドメイン
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/27 Nakanohito
# 更新日:
###############################################################################
class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :domain_name
      t.integer :domain_class
      t.datetime :date_confirmed
      t.string :remarks
      t.boolean :delete_flg
      t.integer :lock_version

      t.timestamps
    end
  end
end
