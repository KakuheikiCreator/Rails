class CreateDeleteReasons < ActiveRecord::Migration
  def change
    create_table :delete_reasons do |t|
      t.string :delete_reason
      t.integer :lock_version

      t.timestamps
    end
  end
end
