class CreatePeopleLeavingStates < ActiveRecord::Migration
  def self.up
    create_table :people_leaving_states, :force => true do |t|
      t.string :people_leaving_state_cls, :null => false, :limit => 1
      t.string :people_leaving_state, :null => false, :limit => 20
      t.integer :lock_version, :default => 0, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :people_leaving_states
  end
end
