# -*- coding: utf-8 -*-
###############################################################################
# マイグレーションファイル:規制リファラー情報
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
class CreateRegulationReferrers < ActiveRecord::Migration
  def change
    create_table :regulation_referrers, :force => true do |t|
      t.integer :system_id
      t.text :referrer
      t.string :remarks
      t.integer :lock_version

      t.timestamps
    end
  end
end
