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
        # for targeting
        "UID" => client_app.uid,
        # for sibling deployer
        "MAIN_APP_UID" => client_app.uid,
        # for seeding client info
        "G5_CLIENT_UID" => client_app.client_uid,
        # for autoscaling
        "HEROKU_APP_NAME" => client_app.name,
        # for deploying
        "HEROKU_API_KEY" => ENV["HEROKU_API_KEY"],
        "HEROKU_USERNAME" => ENV["HEROKU_USERNAME"],
        "ID_RSA" => ENV["ID_RSA"],
      )

      sleep 15
      puts "Adding resdistogo:nano"
      client_app.heroku_addon_add("redistogo:nano")
      sleep 15

      if client_app.name.include? "g5-ch-"
        puts "Seeding database..."
        client_app.heroku_run("rake seed_client")
        client_app.heroku_run("rake sibling:consume")
      elsif client_app.name.include? "g5-chd-"
        puts "Seeding database..."
        client_app.heroku_run("rake sibling:consume")
      end

      puts "Done deploying #{client_app.name}"
    end
  end
end
