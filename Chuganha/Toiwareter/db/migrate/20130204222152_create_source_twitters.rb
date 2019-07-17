class CreateSourceTwitters < ActiveRecord::Migration
  def change
    create_table :source_twitters do |t|
      t.integer :source_id
      t.integer :quote_id
      t.datetime :posted_date
      t.string :posted_by
      t.integer :job_title_id
      t.string :job_title
      t.string :quoted_source_url
      t.integer :lock_version

      t.timestamps
    end
  end
end
