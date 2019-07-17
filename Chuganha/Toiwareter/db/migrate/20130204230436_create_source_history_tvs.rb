class CreateSourceHistoryTvs < ActiveRecord::Migration
  def change
    create_table :source_history_tvs do |t|
      t.integer :source_id
      t.integer :quote_history_id
      t.string :program_name
      t.datetime :broadcast_date
      t.string :production
      t.string :tv_station
      t.integer :lock_version

      t.timestamps
    end
  end
end
