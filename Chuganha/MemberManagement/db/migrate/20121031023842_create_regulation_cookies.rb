class CreateRegulationCookies < ActiveRecord::Migration
  def change
    create_table :regulation_cookies do |t|
      t.integer :system_id
      t.text :cookie
      t.string :remarks
      t.integer :lock_version

      t.timestamps
    end
  end
end
