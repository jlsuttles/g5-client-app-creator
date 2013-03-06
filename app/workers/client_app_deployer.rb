class ClientAppDeployer
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :deployer

  def self.perform(client_app_id)
    client_app = ClientApp.find(client_app_id)

    Rails.logger.info "Deploying #{client_app.name}..."
    if client_app.deploy

      Rails.logger.info "Migrating..."
      client_app.heroku_run("rake db:migrate")

      sleep 15 unless Rails.env.test?
      Rails.logger.info "Adding resdistogo:nano"
      client_app.heroku_addon_add("redistogo:nano")
      sleep 15 unless Rails.env.test?

      setup_client_hub(client_app) if client_app.name.include? "g5-ch"
      setup_client_service(client_app) if client_app.name.include? "g5-cls-"

      Rails.logger.info "Done deploying #{client_app.name}"
    end
  end

  def self.setup_client_service(client_app)
    Rails.logger.info "Scaling worker to 1..."
    client_app.heroku_post_ps_scale("worker", 1)
  end

  def self.setup_client_hub(client_app)
    Rails.logger.info "Setting config variables..."
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

    if client_app.name.include? "g5-ch-"
      Rails.logger.info "Seeding database..."
      client_app.heroku_run("rake seed_client")
      client_app.heroku_run("rake sibling:consume")
    elsif client_app.name.include? "g5-chd-"
      Rails.logger.info "Seeding database..."
      client_app.heroku_run("rake sibling:consume")
    end
  end
end
