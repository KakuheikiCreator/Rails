class CreateSourceHistoryOtherSites < ActiveRecord::Migration
  def change
    create_table :source_history_other_sites do |t|
      t.integer :source_id
      t.integer :quote_history_id
      t.string :site_name
      t.string :page_name
      t.string :posts_by
      t.integer :job_title_id
      t.string :job_title
      t.datetime :posted_date
      t.string :quoted_source_url
      t.integer :lock_version

      t.timestamps
    end
  end
end
