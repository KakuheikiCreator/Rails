class CreatePostcodes < ActiveRecord::Migration
  def self.up
    create_table :postcodes, :force => true do |t|
      t.string :postcode, :null => false, :limit => 7
      t.string :state
      t.string :city
      t.string :town_area
      t.integer :lock_version, :default => 0, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :postcodes
  end
end
