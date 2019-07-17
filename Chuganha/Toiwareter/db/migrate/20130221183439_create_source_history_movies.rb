class CreateSourceHistoryMovies < ActiveRecord::Migration
  def change
    create_table :source_history_movies do |t|
      t.integer :source_id
      t.integer :quote_history_id
      t.string :title
      t.string :production
      t.string :sold_by
      t.date :release_date
      t.integer :lock_version

      t.timestamps
    end
  end
end
