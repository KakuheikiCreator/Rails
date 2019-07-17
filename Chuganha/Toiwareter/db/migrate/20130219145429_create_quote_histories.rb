class CreateQuoteHistories < ActiveRecord::Migration
  def change
    create_table :quote_histories do |t|
      t.integer :quote_id
      t.integer :seq_no
      t.text :quote
      t.text :description
      t.integer :source_id
      t.string :speaker
      t.integer :speaker_job_title_id
      t.string :speaker_job_title
      t.integer :last_comment_seq_no
      t.integer :registrant_id
      t.string :registered_member_id
      t.datetime :registered_date
      t.integer :update_id
      t.string :update_member_id
      t.datetime :update_date
      t.integer :delete_reason_id
      t.string :delete_reason_detail
      t.integer :deleted_id
      t.string :delete_member_id
      t.integer :lock_version

      t.timestamps
    end
  end
end
