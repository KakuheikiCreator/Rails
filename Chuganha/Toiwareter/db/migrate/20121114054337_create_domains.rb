class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :domain_name
      t.integer :domain_class
      t.datetime :date_confirmed
      t.string :remarks
      t.boolean :delete_flg
      t.integer :lock_version

      t.timestamps
    end
  end
end
