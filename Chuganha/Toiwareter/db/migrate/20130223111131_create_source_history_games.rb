class CreateSourceHistoryGames < ActiveRecord::Migration
  def change
    create_table :source_history_games do |t|
      t.integer :source_id
      t.integer :quote_history_id
      t.string :title
      t.integer :game_console_id
      t.string :game_console_dtl_name
      t.string :sold_by
      t.date :release_date
      t.integer :lock_version

      t.timestamps
    end
  end
end
