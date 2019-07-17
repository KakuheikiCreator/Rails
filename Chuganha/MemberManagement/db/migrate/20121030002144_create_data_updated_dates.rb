class CreateDataUpdatedDates < ActiveRecord::Migration
  def change
    create_table :data_updated_dates do |t|
      t.string :data_key
      t.datetime :data_update_time
      t.integer :lock_version

      t.timestamps
    end
  end
end
