class ClientApp < ActiveRecord::Base
  attr_accessible :uid, :client_uid, :name, :app_type, :entry_id, :sibling_app, :git_repo

  belongs_to :entry
  
  # validates :entry_id, presence: true
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
    GithubHerokuDeployer.heroku_addon_add(addon)
  end

  def deployer_options
    { github_repo: git_repo,
      heroku_app_name: name,
      heroku_repo: heroku_repo }
  end
  
  def heroku_repo
    "git@heroku.com:#{name}.git"
  end
  
  def siblings
    entry.client_apps.drop_while { |k| k == self }
  end
end
