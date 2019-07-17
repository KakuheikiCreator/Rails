class CreateWithdrawalReasons < ActiveRecord::Migration
  def change
    create_table :withdrawal_reasons do |t|
      t.string   :withdrawal_reason_cls,   :null=>false
      t.string   :withdrawal_reason,       :null=>false
      t.integer  :lock_version,            :null=>false, :default=>0

      t.timestamps
    end
  end
end
