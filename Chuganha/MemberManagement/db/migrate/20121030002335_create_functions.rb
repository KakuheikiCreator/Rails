class CreateFunctions < ActiveRecord::Migration
  def change
    create_table :functions do |t|
      t.integer :system_id
      t.string :function_path
      t.string :function_name
      t.integer :lock_version

      t.timestamps
    end
  end
end
