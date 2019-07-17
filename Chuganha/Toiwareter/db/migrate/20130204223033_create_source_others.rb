class CreateSourceOthers < ActiveRecord::Migration
  def change
    create_table :source_others do |t|
      t.integer :source_id
      t.integer :quote_id
      t.string :media_name
      t.integer :lock_version

      t.timestamps
    end
  end
end
