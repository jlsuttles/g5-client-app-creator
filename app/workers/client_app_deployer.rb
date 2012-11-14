class ClientAppDeployer
  @queue = :deployer

  def self.perform(client_app_id)
    client_app = ClientApp.find(client_app_id)
    if client_app.deploy
      ClientAppProcessRunner()
      Resque.enqueue(ClientAppProcessRunner, client_app_id, "rake db:migrate")
    end
  end
  
end
