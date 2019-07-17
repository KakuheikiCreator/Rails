class CreateJobTitles < ActiveRecord::Migration
  def change
    create_table :job_titles do |t|
      t.string :job_title
      t.integer :lock_version

      t.timestamps
    end
  end
end
