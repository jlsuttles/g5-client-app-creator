class ClientApp < ActiveRecord::Base
  attr_accessible :uid, :client_uid, :name, :app_type, :entry_id, :sibling_app, :git_repo

  belongs_to :entry

  validates :git_repo, presence: true
  validates :name, presence: true, uniqueness: { scope: :app_type }

  after_create :async_deploy

  def async_deploy
    Resque.enqueue(ClientAppDeployer, self.id)
  end

  def deploy
    GithubHerokuDeployer.deploy(deployer_options)
  end

  def heroku_restart
    GithubHerokuDeployer.heroku_restart(deployer_options)
  end

  def heroku_destroy
    GithubHerokuDeployer.heroku_destroy(deployer_options)
  end

  def heroku_run(command)
    GithubHerokuDeployer.heroku_run(command, deployer_options)
  end

  def heroku_config_set(values)
    GithubHerokuDeployer.heroku_config_set(values, deployer_options)
  end

  def heroku_addon_add(addon)
    GithubHerokuDeployer.heroku_addon_add(addon, deployer_options)
  end

  def heroku_post_ps_scale(process, quantity)
    GithubHerokuDeployer.heroku_post_ps_scale(process, quantity, deployer_options)
  end

  def deployer_options
    { github_repo: git_repo,
      heroku_app_name: name,
      heroku_repo: heroku_repo }
  end

  def heroku_repo
    "git@heroku.com:#{name}.git"
  end

  def heroku_url
    "http://#{name}.herokuapp.com"
  end

  def siblings
    entry.client_apps.drop_while { |k| k == self }
  end

  def app_type
    name.split("-")[1]
  end

  # used to set up heroku config

  def secret_token
    SecureRandom.hex(30)
  end

  def secret_key_base
    secret_token
  end

  def app_display_name
    "Client Hub Deployer"
  end

  def main_app_uid
    uid
  end

  def g5_client_uid
    client_uid
  end

  def heroku_app_name
    name
  end

  def new_relic_app_name
    name
  end

  def heroku_api_key
    ENV["HEROKU_API_KEY"]
  end

  def heroku_username
    ENV["HEROKU_USERNAME"]
  end

  def id_rsa
    ENV["ID_RSA"]
  end

  def g5_configurator_feed_url
    ENV["G5_CONFIGURATOR_FEED_URL"]
  end
end
