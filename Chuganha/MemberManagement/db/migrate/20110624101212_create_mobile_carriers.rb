class CreateMobileCarriers < ActiveRecord::Migration
  def self.up
    create_table :mobile_carriers, :force => true do |t|
      t.string :mobile_carrier_cd, :null => false, :limit => 2
      t.integer :mobile_domain_no, :null => false
      t.string :mobile_carrier, :null => false
      t.string :domain, :null => false
      t.integer :lock_version, :default => 0, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :mobile_carriers
  end
end
