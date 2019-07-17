class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :quote_id
      t.integer :seq_no
      t.text :comment
      t.integer :critic_id
      t.string :critic_member_id
      t.datetime :criticism_date
      t.integer :lock_version

      t.timestamps
    end
  end
end
