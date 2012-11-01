class CreateClientHubs < ActiveRecord::Migration
  def change
    create_table :client_apps do |t|
      t.string :name, :app_type, :uid
      t.integer :entry_id, :sibling_app_id

      t.timestamps
    end
    add_index :client_apps, :entry_id
    add_index :client_apps, :sibling_app_id
  end
end