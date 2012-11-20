class ClientAppDeployer
  @queue = :deployer

  def self.perform(client_app_id)
    client_app = ClientApp.find(client_app_id)
    if client_app.deploy
      client_app.heroku_run("rake db:migrate")
      client_app.heroku_config_set("G5_CLIENT_UID" => client_app.uid)
      client_app.heroku_run("rake seed_client") if client.app.name.include? "g5-ch-"
    end
  end
end
