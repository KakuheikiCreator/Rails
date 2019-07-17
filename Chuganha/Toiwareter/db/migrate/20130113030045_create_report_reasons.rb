class CreateReportReasons < ActiveRecord::Migration
  def change
    create_table :report_reasons do |t|
      t.string :report_reason
      t.integer :lock_version

      t.timestamps
    end
  end
end
