class CreateDataUpdateds < ActiveRecord::Migration
  def change
    create_table :data_updateds do |t|
      t.string :data_key
      t.integer :data_update_version
      t.integer :lock_version

      t.timestamps
    end
  end
end
