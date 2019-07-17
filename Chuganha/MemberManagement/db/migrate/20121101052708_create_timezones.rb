class CreateTimezones < ActiveRecord::Migration
  def change
    create_table :timezones do |t|
      t.string   :timezone_id,         :null=>false
      t.string   :timezone_name,       :null=>true
      t.integer  :lock_version,        :null=>false, :default=>0

      t.timestamps
    end
  end
end
