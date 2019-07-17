class CreateSourceNewsSites < ActiveRecord::Migration
  def change
    create_table :source_news_sites do |t|
      t.integer :source_id
      t.integer :quote_id
      t.string :site_name
      t.string :article_title
      t.datetime :posted_date
      t.string :reporter
      t.integer :job_title_id
      t.string :job_title
      t.string :quoted_source_url
      t.integer :lock_version

      t.timestamps
    end
  end
end
