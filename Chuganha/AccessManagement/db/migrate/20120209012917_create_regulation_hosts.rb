# -*- coding: utf-8 -*-
###############################################################################
# マイグレーションファイル:規制ホスト情報
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/09 Nakanohito
# 更新日:
###############################################################################
class CreateRegulationHosts < ActiveRecord::Migration
  def change
    create_table :regulation_hosts, :force => true do |t|
      t.integer :system_id
      t.string :proxy_host
      t.string :proxy_ip_address
      t.string :remote_host
      t.string :ip_address
      t.string :remarks
      t.integer :lock_version

      t.timestamps
    end
  end
end
