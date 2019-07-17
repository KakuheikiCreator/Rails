class CreateNewspapers < ActiveRecord::Migration
  def change
    create_table :newspapers do |t|
      t.string :newspaper_name
      t.integer :lock_version

      t.timestamps
    end
  end
end
