class CreateReasonCorrections < ActiveRecord::Migration
  def change
    create_table :reason_corrections do |t|
      t.string :update_reason
      t.integer :lock_version

      t.timestamps
    end
  end
end
