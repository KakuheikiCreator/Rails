class CreateAuthorities < ActiveRecord::Migration
  def self.up
    create_table :authorities, :force => true do |t|
      t.string :authority_cls, :null => false, :limit => 3
      t.string :authority, :null => false, :limit => 10
      t.string :authority_simple, :null => false, :limit => 6
      t.integer :lock_version, :default => 0, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :authorities
  end
end
