class CreateBrowsers < ActiveRecord::Migration
  def change
    create_table :browsers do |t|
      t.string :browser_name
      t.integer :lock_version

      t.timestamps
    end
  end
end
