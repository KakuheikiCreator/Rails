class CreateSourceNewspapers < ActiveRecord::Migration
  def change
    create_table :source_newspapers do |t|
      t.integer :source_id
      t.integer :quote_id
      t.integer :newspaper_id
      t.string :newspaper_detail
      t.date :posted_date
      t.string :newspaper_cls
      t.string :headline
      t.string :reporter
      t.integer :job_title_id
      t.string :job_title
      t.integer :lock_version

      t.timestamps
    end
  end
end
