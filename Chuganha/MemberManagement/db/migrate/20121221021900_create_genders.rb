class CreateGenders < ActiveRecord::Migration
  def change
    create_table :genders do |t|
      t.string :gender_cls
      t.string :gender
      t.string :gender_simple

      t.timestamps
    end
  end
end
