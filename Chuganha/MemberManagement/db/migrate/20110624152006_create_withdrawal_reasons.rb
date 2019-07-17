class CreateWithdrawalReasons < ActiveRecord::Migration
  def self.up
    create_table :withdrawal_reasons, :force => true do |t|
      t.string :withdrawal_reason_cls, :null => false, :limit => 1
      t.string :withdrawal_reason, :null => false, :limit => 20
      t.integer :lock_version, :default => 0, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :withdrawal_reasons
  end
end
