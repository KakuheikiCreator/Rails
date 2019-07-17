class CreateOpenIdAssociations < ActiveRecord::Migration
  def change
    create_table :open_id_associations do |t|
      t.binary :server_url
      t.binary :secret
      t.string :handle
      t.string :assoc_type
      t.integer :issued
      t.integer :lifetime
      t.integer :lock_version

      t.timestamps
    end
  end
end
