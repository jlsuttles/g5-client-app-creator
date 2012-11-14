class ClientAppProcessRunner
  @queue = :process_runner

  def self.perform(client_app_id)
    client_app = ClientApp.find(client_app_id)
    client_app.run('rake db:migrate')
  end
end
