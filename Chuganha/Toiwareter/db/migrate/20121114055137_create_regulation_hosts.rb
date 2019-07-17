class CreateRegulationHosts < ActiveRecord::Migration
  def change
    create_table :regulation_hosts do |t|
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
