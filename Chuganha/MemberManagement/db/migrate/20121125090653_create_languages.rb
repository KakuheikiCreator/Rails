class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string  :lang_name_cd,        :null=>false
      t.string  :lang_name,           :null=>false
      t.string  :name_notation_cls,   :null=>false
      t.integer :lock_version,        :null=>false, :default=>0

      t.timestamps
    end
  end
end
