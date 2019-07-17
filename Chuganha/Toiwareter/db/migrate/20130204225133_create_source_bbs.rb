class CreateSourceBbs < ActiveRecord::Migration
  def change
    create_table :source_bbs do |t|
      t.integer :source_id
      t.integer :quote_id
      t.string :bbs_id
      t.string :bbs_detail_name
      t.integer :thread_title
      t.datetime :posted_date
      t.string :posted_by
      t.string :quoted_source_url
      t.integer :lock_version

      t.timestamps
    end
  end
end
