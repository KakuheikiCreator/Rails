class CreateNgWords < ActiveRecord::Migration
  def change
    create_table :ng_words do |t|
      t.string :ng_word
      t.string :replace_word
      t.string :replace_count
      t.integer :lock_version

      t.timestamps
    end
  end
end
