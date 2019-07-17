class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :source
      t.integer :lock_version

      t.timestamps
    end
  end
end
