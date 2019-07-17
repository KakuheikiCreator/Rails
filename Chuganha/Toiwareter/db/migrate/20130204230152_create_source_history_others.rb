class CreateSourceHistoryOthers < ActiveRecord::Migration
  def change
    create_table :source_history_others do |t|
      t.integer :source_id
      t.integer :quote_history_id
      t.string :media_name
      t.integer :lock_version

      t.timestamps
    end
  end
end
