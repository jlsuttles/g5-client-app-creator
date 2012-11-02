class ClientApp < ActiveRecord::Base
  attr_accessible :name, :app_type, :entry_id, :sibling_app
  validates :entry_id, :name, :app_type, presence: true
  validates :name, uniqueness: {scope: :app_type}
  belongs_to :sibling_app, class_name: "ClientApp", foreign_key: :sibling_app_id
  
  after_create :create_sibling, unless: :sibling_app
  after_create :deploy
  def async_deploy
    Resque.enqueue(ClientAppDeployer, self.id)
  end

  def deploy
    GithubHerokuDeployer.deploy(
      github_repo: github_repo,
      heroku_app_name: heroku_app_name,
      heroku_repo: heroku_repo,
      repo_dir: "/tmp"
    )
  end
  
  def github_repo
    "git@github.com:g5search/g5-client-hub"
  end
  
  def heroku_app_name
    "#{prefix}-#{name}"
  end
  
  def heroku_repo
    "git@heroku.com:#{heroku_app_name}.git"
  end
  
  def prefix
    case self.app_type
    when "ClientHub" then "g5-ch"
    when "ClientHubDeployer" then "g5-chd"
    end
  end
  
  def create_sibling
    sibling = create_sibling_app(entry_id: self.entry_id, app_type: "ClientHubDeployer") do |app|
      app.name = self.name
    end
    if sibling  
      self.update_attributes(sibling_app: sibling)
    end
  end
end
