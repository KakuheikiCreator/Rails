class CreateMobileCarriers < ActiveRecord::Migration
  def change
    create_table :mobile_carriers do |t|
      t.string  :mobile_carrier_cd,    :null=>false
      t.integer :mobile_domain_no,     :null=>false
      t.string  :mobile_carrier,       :null=>false
      t.string  :domain,               :null=>false
      t.integer :lock_version,         :null=>false, :default=>0

      t.timestamps
    end
  end
end
