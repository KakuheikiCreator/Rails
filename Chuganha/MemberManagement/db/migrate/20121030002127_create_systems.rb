class CreateSystems < ActiveRecord::Migration
  def change
    create_table :systems do |t|
      t.string :system_name
      t.string :subsystem_name
      t.integer :lock_version

      t.timestamps
    end
  end
end
