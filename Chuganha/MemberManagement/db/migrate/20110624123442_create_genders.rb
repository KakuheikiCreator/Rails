class CreateGenders < ActiveRecord::Migration
  def self.up
    create_table :genders, :force => true do |t|
      t.string :gender_cls, :null => false, :limit => 1
      t.string :gender, :null => false, :limit => 10
      t.integer :lock_version, :default => 0, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :genders
  end
end
