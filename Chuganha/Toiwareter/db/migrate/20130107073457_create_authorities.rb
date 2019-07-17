class CreateAuthorities < ActiveRecord::Migration
  def change
    create_table :authorities do |t|
      t.string :authority_cls
      t.string :authority
      t.string :authority_simple
      t.integer :lock_version

      t.timestamps
    end
  end
end
