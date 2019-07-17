class CreateSns < ActiveRecord::Migration
  def change
    create_table :sns do |t|
      t.string :sns_name
      t.integer :lock_version

      t.timestamps
    end
  end
end
