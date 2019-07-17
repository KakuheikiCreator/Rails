class CreateSourceBooks < ActiveRecord::Migration
  def change
    create_table :source_books do |t|
      t.integer :source_id
      t.integer :quote_id
      t.string :isbn
      t.string :book_title
      t.string :publisher
      t.date :release_date
      t.string :author
      t.integer :job_title_id
      t.string :job_title
      t.integer :lock_version

      t.timestamps
    end
  end
end
