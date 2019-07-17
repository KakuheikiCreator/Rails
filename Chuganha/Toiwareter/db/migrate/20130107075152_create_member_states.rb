class CreateMemberStates < ActiveRecord::Migration
  def change
    create_table :member_states do |t|
      t.string :member_state_cls
      t.string :member_state
      t.string :member_state_simple
      t.integer :lock_version

      t.timestamps
    end
  end
end
