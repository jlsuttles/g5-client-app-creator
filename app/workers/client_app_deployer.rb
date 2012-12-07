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
        # for seeding client info
        "G5_CLIENT_UID" => client_app.client_uid,
        # for autoscaling
        "HEROKU_APP_NAME" => client_app.name,
        # for deploying
        "HEROKU_API_KEY" => ENV["HEROKU_API_KEY"],
        "HEROKU_USERNAME" => ENV["HEROKU_USERNAME"],
        "ID_RSA" => ENV["ID_RSA"],
        # for deploying buddy
        "BUDDY_HEROKU_APP_NAME" => client_app.buddy_name,
        "BUDDY_HEROKU_REPO" => client_app.buddy_heroku_repo,
        "BUDDY_GITHUB_REPO"=> client_app.buddy_git_repo,
      )

      # Client Hubs
      if client_app.name.include? "g5-ch-"
        puts "Taking a nap..."
        sleep 30
        puts "Seeding database..."
        client_app.heroku_run("rake seed_client")
      end

      puts "Adding resdistogo:nano"
      client_app.heroku_addon_add("redistogo:nano")

      puts "Done deploying #{client_app.name}"
    end
  end
end
