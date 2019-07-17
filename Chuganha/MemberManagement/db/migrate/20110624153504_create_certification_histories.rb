class CreateCertificationHistories < ActiveRecord::Migration
  def self.up
    create_table :certification_histories, :force => true do |t|
      t.string :login_id, :null => false, :limit => 10
      t.integer :history_no, :null => false
      t.timestamp :certification_date, :null => false
      t.string :ip_address, :null => false, :limit => 15
      t.text :referer
      t.text :cookie
      t.string :user_agent
      t.integer :lock_version, :default => 0, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :certification_histories
  end
end
