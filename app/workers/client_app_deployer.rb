class ClientAppDeployer
  @queue = :deployer

  def self.perform(client_app_id)
    client_app = ClientApp.find(client_app_id)
    client_app.deploy
  end
end
