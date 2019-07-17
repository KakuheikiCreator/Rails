class CreatePersonWithdrawals < ActiveRecord::Migration
  def change
    create_table :person_withdrawals do |t|
      t.string :user_id
      t.integer :withdrawal_reason_id
      t.binary :enc_withdrawal_reason_dtl
      t.integer :person_withdrawal_state_id
      t.timestamp :join_date
      t.timestamp :withdrawal_date
      t.integer :member_state_id
      t.binary :enc_authority_cls
      t.binary :hsh_password
      t.binary :hsh_temp_password
      t.binary :enc_nickname
      t.binary :enc_last_name
      t.binary :enc_first_name
      t.binary :enc_yomigana_last
      t.binary :enc_yomigana_first
      t.binary :enc_gender_cls
      t.binary :enc_birth_date
      t.binary :enc_country_name_cd
      t.binary :enc_lang_name_cd
      t.binary :enc_timezone_id
      t.binary :enc_postcode
      t.binary :enc_email
      t.binary :enc_mobile_phone_no
      t.binary :hsh_mobile_phone_no
      t.integer :mobile_carrier_id
      t.binary :enc_mobile_email
      t.binary :hsh_mobile_email
      t.binary :enc_mobile_id_no
      t.binary :hsh_mobile_id_no
      t.binary :enc_mobile_host
      t.binary :hsh_mobile_host
      t.timestamp :last_authentication_date
      t.boolean :last_authentication_result
      t.string :last_authentication_ip_address
      t.string :last_authentication_referer
      t.string :last_authentication_user_agent
      t.string :salt
      t.boolean :delete_flg
      t.integer :lock_version

      t.timestamps
    end
  end
end
