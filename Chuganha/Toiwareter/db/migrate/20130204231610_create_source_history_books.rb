class CreateSourceHistoryBooks < ActiveRecord::Migration
  def change
    create_table :source_history_books do |t|
      t.integer :source_id
      t.integer :quote_history_id
      t.string :isbn
      t.string :book_title
      t.string :publisher
      t.date :release_date
      t.string :author
      t.integer :job_title_id
      t.string :job_title
      t.integer :lock_version
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
