class AddClientUidToClientApps < ActiveRecord::Migration
  def change
    add_column :client_apps, :client_uid, :string
  end
end
