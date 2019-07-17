class CreateSourceSns < ActiveRecord::Migration
  def change
    create_table :source_sns do |t|
      t.integer :source_id
      t.integer :quote_id
      t.integer :sns_id
      t.string :sns_detail_name
      t.datetime :posted_date
      t.string :posted_by
      t.integer :job_title_id
      t.string :job_title
      t.integer :lock_version

      t.timestamps
    end
  end
end
