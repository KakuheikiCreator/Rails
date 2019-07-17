class CreateMemberStates < ActiveRecord::Migration
  def change
    create_table :member_states do |t|
      t.string   :member_state_cls,    :null=>false
      t.string   :member_state,        :null=>false
      t.string   :member_state_simple, :null=>false
      t.integer  :lock_version,        :null=>false, :default=>0

      t.timestamps
    end
  end
end
