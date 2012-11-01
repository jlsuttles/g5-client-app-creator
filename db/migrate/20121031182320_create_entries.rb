class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :client_name
      t.string :uid

      t.timestamps
    end
  end
end
