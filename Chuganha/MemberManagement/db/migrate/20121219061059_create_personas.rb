class CreatePersonas < ActiveRecord::Migration
  def change
    create_table :personas do |t|
      t.integer :account_id
      t.integer :seq_no
      t.binary :enc_nickname
      t.binary :enc_country_name_cd
      t.binary :enc_lang_name_cd
      t.binary :enc_timezone_id
      t.binary :enc_postcode
      t.binary :enc_email
      t.binary :enc_mobile_phone_no
      t.integer :mobile_carrier_id
      t.binary :enc_mobile_email
      t.binary :enc_mobile_id_no
      t.binary :enc_mobile_host
      t.integer :lock_version,        :null=>false, :default=>0

      t.timestamps
    end
  end
end
