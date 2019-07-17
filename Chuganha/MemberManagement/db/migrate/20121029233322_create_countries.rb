class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string   :country_name_cd,     :null=>false
      t.string   :country_name,        :null=>false
      t.integer  :lock_version,        :null=>false, :default=>0

      t.timestamps
    end
  end
end
