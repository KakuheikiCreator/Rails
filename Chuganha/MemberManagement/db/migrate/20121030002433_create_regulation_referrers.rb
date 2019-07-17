class CreateRegulationReferrers < ActiveRecord::Migration
  def change
    create_table :regulation_referrers do |t|
      t.integer :system_id
      t.text :referrer
      t.string :remarks
      t.integer :lock_version

      t.timestamps
    end
  end
end
