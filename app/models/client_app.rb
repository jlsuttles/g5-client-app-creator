class ClientApp < ActiveRecord::Base
  attr_accessible :name, :app_type, :entry_id, :sibling_app, :git_repo

  belongs_to :entry
  
  validates :git_repo, presence: true
  validates :entry_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :app_type }

  after_create :async_deploy

  def async_deploy
    Resque.enqueue(ClientAppDeployer, self.id)
  end

  def deploy
    GithubHerokuDeployer.deploy(
      github_repo: git_repo,
      heroku_app_name: name,
      heroku_repo: heroku_repo
    )
  end
  
  def run(command)
    GithubHerokuDeployer.heroku_run(command, 
      github_repo: git_repo,
      heroku_app_name: name,
      heroku_repo: heroku_repo,
      repo_dir: "/tmp"
    )
  end
  
  def async_run(command)
    Resque.enqueue(ClientAppProcessRunner, self.id, command)
  end
  
  def heroku_repo
    "git@heroku.com:#{name}.git"
  end
  
  def siblings
    entry.client_apps.drop_while { |k| k == self }
  end
end
