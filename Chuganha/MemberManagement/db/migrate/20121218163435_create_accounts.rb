class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :user_id
      t.binary :hsh_password
      t.integer :member_state_id
      t.binary :enc_authority_cls
      t.timestamp :join_date
      t.binary :hsh_temp_password
      t.integer :last_auth_seq_no
      t.integer :consecutive_failure_cnt
      t.binary :enc_last_name
      t.binary :enc_first_name
      t.binary :enc_yomigana_last
      t.binary :enc_yomigana_first
      t.binary :enc_gender_cls
      t.binary :enc_birth_date
      t.string :salt
      t.boolean :delete_flg,          :null=>false, :default=>false
      t.integer :lock_version,        :null=>false, :default=>0

      t.timestamps
    end
  end
end
