class CreateCommentDeletes < ActiveRecord::Migration
  def change
    create_table :comment_deletes do |t|
      t.integer :quote_id
      t.integer :quote_history_id
      t.integer :seq_no
      t.text :comment
      t.integer :critic_id
      t.string :critic_member_id
      t.datetime :criticism_date
      t.integer :delete_reason_id
      t.string :delete_reason_detail
      t.integer :deleted_id
      t.string :delete_member_id
      t.integer :lock_version

      t.timestamps
    end
  end
end
