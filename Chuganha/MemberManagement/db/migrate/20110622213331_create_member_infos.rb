class CreateMemberInfos < ActiveRecord::Migration
  def self.up
    create_table :member_infos, :force => true do |t|
      t.string   :login_id, :null => false, :limit => 10
      t.string   :member_state_cls, :null => false, :limit => 2
      t.string   :authority_cls, :null => false, :limit => 3
      t.string   :login_password, :null => false
      t.string   :nickname, :null => false, :limit => 20
      t.string   :name, :null => false
      t.string   :reading_of_a_name, :null => false
      t.string   :gender_cls, :null => false
      t.string   :birth_date, :null => false
      t.string   :postcode, :null => false
      t.string   :mobile_phone_number, :null => false
      t.string   :mobile_carrier_cd, :null => false, :limit => 2
      t.integer  :mobile_domain_no, :null => false, :limit => 2
      t.string   :mobile_email, :null => false
      t.string   :mobile_id_no
      t.timestamp :join_date
      t.integer  :lock_version, :default => 0, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :member_infos
  end
end
