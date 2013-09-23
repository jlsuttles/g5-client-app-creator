class ClientAppDeployer
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :deployer
  attr_reader :app, :defaults, :retries

  def self.perform(client_app_id)
    self.new(client_app_id).perform
  end

  def initialize(client_app_id)
    @app = ClientApp.find(client_app_id)
    @defaults = DEFAULTS["deploys"]["initial"][@app.app_type]
    @retries = 0
  end

  def perform
    raise ArgumentError, "Unknown app type: #{@app.app_type}" unless @defaults
    create
    configure
    add_addons
    run_tasks
    Rails.logger.info "Finished deploying #{@app.name}!"
  rescue GithubHerokuDeployer::CommandException,
         Heroku::API::Errors::ErrorWithResponse => e
    if should_retry?
      Rails.logger.info "Retrying  #{@app.name}..."
      increment_retries
      retry
    else
      raise e
    end
  end

  def create
    Rails.logger.info "Creating #{@app.name}..."
    @app.deploy
  end

  def configure
    Rails.logger.info "Configuring #{@app.name}..."
    config = {}
    @defaults["config"].each do |variable|
      if @app.respond_to?(variable.downcase)
        config[variable] = @app.send(variable.downcase)
      end
    end
    @app.heroku_config_set(config)
  end

  def add_addons
    Rails.logger.info "Adding addons to #{@app.name}..."
    @defaults["addons"].each do |addon|
      @app.heroku_addon_add(addon)
    end
  end

  def run_tasks
    Rails.logger.info "Running tasks on #{@app.name}..."
    @defaults["tasks"].each do |task|
      @app.heroku_run(task)
    end
  end

  def should_retry?
    @retries < 3
  end

  def increment_retries
    @retries += 1
  end

end
