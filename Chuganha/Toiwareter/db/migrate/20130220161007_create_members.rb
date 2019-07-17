class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.binary :enc_open_id
      t.string :member_id
      t.integer :member_state_id
      t.integer :authority_id
      t.binary :enc_nickname
      t.binary :enc_email
      t.datetime :join_date
      t.datetime :ineligibility_date
      t.datetime :last_login_date
      t.integer :login_cnt
      t.integer :quote_cnt
      t.integer :quote_failure_cnt
      t.integer :quote_correct_cnt
      t.integer :quote_correct_failure_cnt
      t.integer :quote_delete_cnt
      t.integer :comment_cnt
      t.integer :comment_failure_cnt
      t.integer :comment_report_cnt
      t.integer :were_reported_cnt
      t.integer :support_report_cnt
      t.integer :lock_version

      t.timestamps
    end
  end
end
