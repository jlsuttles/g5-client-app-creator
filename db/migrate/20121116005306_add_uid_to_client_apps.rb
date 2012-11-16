class AddUidToClientApps < ActiveRecord::Migration
  def change
    add_column :client_apps, :uid, :string
  end
end
