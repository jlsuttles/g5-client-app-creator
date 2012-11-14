class ClientAppProcessRunner
  @queue = :process_runner

  def self.perform(client_app_id, command)
    client_app = ClientApp.find(client_app_id)
    client_app.deploy
  end
end
