class CreateBrowserVersions < ActiveRecord::Migration
  def change
    create_table :browser_versions do |t|
      t.integer :browser_id
      t.string :browser_version
      t.integer :lock_version

      t.timestamps
    end
  end
end
