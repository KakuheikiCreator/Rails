class CreateCommentReports < ActiveRecord::Migration
  def change
    create_table :comment_reports do |t|
      t.integer :quote_id
      t.integer :quote_history_id
      t.integer :comment_id
      t.integer :comment_delete_id
      t.text :seq_no
      t.integer :report_reason_id
      t.text :report_reason_detail
      t.integer :whistleblower_id
      t.string :report_member_id
      t.datetime :report_date
      t.integer :lock_version

      t.timestamps
    end
  end
end
