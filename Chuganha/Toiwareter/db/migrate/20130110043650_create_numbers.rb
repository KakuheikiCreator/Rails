class CreateNumbers < ActiveRecord::Migration
  def change
    create_table :numbers do |t|
      t.string :number_cls
      t.string :number_item
      t.integer :number
      t.integer :lock_version

      t.timestamps
    end
  end
end
