class CreateBbs < ActiveRecord::Migration
  def change
    create_table :bbs do |t|
      t.string :bbs_name
      t.integer :lock_version

      t.timestamps
    end
  end
end
