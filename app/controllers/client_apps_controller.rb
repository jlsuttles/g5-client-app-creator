class ClientAppsController < ApplicationController
  def index
    @client_apps = ClientApp.order("updated_at DESC").all
  end
end
