class ClientAppDeployer
  @queue = :deployer

  def self.perform(client_app_id)
    client_app = ClientApp.find(client_app_id)
    if client_app.deploy
      Resque.enqueue(ClientAppProcessRunner, client_app_id)
    end
  end
  
end
