class CreateOpenIdNonces < ActiveRecord::Migration
  def change
    create_table :open_id_nonces do |t|
      t.binary :server_url
      t.binary :salt
      t.string :timestamp
      t.integer :lock_version

      t.timestamps
    end
  end
end
