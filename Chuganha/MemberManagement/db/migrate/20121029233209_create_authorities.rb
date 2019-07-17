class CreateAuthorities < ActiveRecord::Migration
  def change
    create_table :authorities do |t|
      t.string   :authority_cls,     :null=>false
      t.string   :authority,         :null=>false
      t.string   :authority_simple,  :null=>false
      t.integer  :lock_version,      :null=>false, :default=>0

      t.timestamps
    end
  end
end
