class AddRepoToClientApps < ActiveRecord::Migration
  def change
    add_column :client_apps, :git_repo, :string
  end
end
