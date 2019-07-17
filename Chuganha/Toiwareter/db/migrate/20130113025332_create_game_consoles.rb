class CreateGameConsoles < ActiveRecord::Migration
  def change
    create_table :game_consoles do |t|
      t.string :game_console_name
      t.integer :lock_version

      t.timestamps
    end
  end
end
