class CreateMemberStates < ActiveRecord::Migration
  def self.up
    create_table :member_states, :force => true do |t|
      t.string :member_state_cls, :null => false, :limit => 2
      t.string :member_state, :null => false, :limit => 5
      t.string :member_state_simple, :null => false, :limit => 2
      t.integer :lock_version, :default => 0, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :member_states
  end
end
