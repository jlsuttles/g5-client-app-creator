class ClientAppDeployer
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :deployer

  def self.perform(client_app_id)
    client_app = ClientApp.find(client_app_id)

    puts "Deploying #{client_app.name}..."
    if client_app.deploy

      puts "Migrating..."
      client_app.heroku_run("rake db:migrate")

      puts "Setting config variables..."
      client_app.heroku_config_set(
        "G5_CLIENT_UID" => client_app.client_uid,
        "HEROKU_API_KEY" => ENV["HEROKU_API_KEY"],
        "HEROKU_APP_NAME" => client_app.name,
        "HEROKU_USERNAME" => ENV["HEROKU_USERNAME"],
        "ID_RSA" => ENV["ID_RSA"],
      )

      # Client Hubs
      if client_app.name.include? "g5-ch-"
        puts "Taking a nap..."
        sleep 10
        puts "Seeding database..."
        client_app.heroku_run("rake seed_client")
      end

      client_app.heroku_addon_add("redistogo:nano")

      puts "Done deploying #{client_app.name}"
    end
  end
end
