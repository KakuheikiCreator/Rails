class CreatePersonWithdrawalStates < ActiveRecord::Migration
  def change
    create_table :person_withdrawal_states do |t|
      t.string   :person_withdrawal_state_cls,   :null=>false
      t.string   :person_withdrawal_state,       :null=>false
      t.integer  :lock_version,                  :null=>false, :default=>0

      t.timestamps
    end
  end
end
