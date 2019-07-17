class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.text :quote
      t.text :description
      t.integer :source_id
      t.string :speaker
      t.integer :speaker_job_title_id
      t.string :speaker_job_title
      t.integer :last_history_seq_no
      t.integer :last_comment_seq_no
      t.integer :registrant_id
      t.string :registered_member_id
      t.datetime :registered_date
      t.integer :update_id
      t.string :update_member_id
      t.datetime :update_date
      t.integer :lock_version

      t.timestamps
    end
  end
end
