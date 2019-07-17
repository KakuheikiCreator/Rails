class CreateSourceHistoryMusics < ActiveRecord::Migration
  def change
    create_table :source_history_musics do |t|
      t.integer :source_id
      t.integer :quote_history_id
      t.string :music_name
      t.string :lyricist
      t.string :composer
      t.string :jasrac_code
      t.string :iswc
      t.integer :lock_version

      t.timestamps
    end
  end
end
