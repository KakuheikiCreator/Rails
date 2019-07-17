class CreateAuthenticationHistories < ActiveRecord::Migration
  def change
    create_table :authentication_histories do |t|
      t.integer   :account_id,             :null=>false
      t.integer   :seq_no,                 :null=>false
      t.string    :server_url,             :null=>false
      t.timestamp :authentication_date,    :null=>false
      t.boolean   :authentication_result,  :null=>false
      t.string    :ip_address,             :null=>false
      t.string    :referer
      t.string    :user_agent
      t.integer   :lock_version,           :null=>false, :default=>0

      t.timestamps
    end
  end
end
