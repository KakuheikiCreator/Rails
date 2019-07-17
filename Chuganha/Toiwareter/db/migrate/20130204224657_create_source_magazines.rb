class CreateSourceMagazines < ActiveRecord::Migration
  def change
    create_table :source_magazines do |t|
      t.integer :source_id
      t.integer :quote_id
      t.string :magazine_cd
      t.string :magazine_name
      t.string :article_title
      t.string :publisher
      t.date :release_date
      t.string :reporter
      t.integer :job_title_id
      t.string :job_title
      t.integer :lock_version

      t.timestamps
    end
  end
end
