class CreateOpenIdRequests < ActiveRecord::Migration
  def change
    create_table :open_id_requests do |t|
      t.string :token
      t.text :parameters
      t.integer :lock_version

      t.timestamps
    end
  end
end
