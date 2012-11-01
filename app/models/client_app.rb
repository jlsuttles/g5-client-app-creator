class ClientApp < ActiveRecord::Base
  attr_accessible :name, :app_type, :entry_id, :sibling_app
  validates :entry_id, :name, :app_type, :uid, presence: true
  validates :name, :uid, uniqueness: {scope: :app_type}
  belongs_to :sibling_app, class_name: "ClientApp", foreign_key: :sibling_app_id
  
  after_create :create_sibling, unless: :sibling_app
  after_create :deploy
  
  def self.create_from_name(name, attrs={})
    self.create(attrs) do |app|
      app.name = name
      app.uid  = "http://#{app.prefix}-#{name}.herokuapp.com"
      app.save
    end
  end
  
  def deploy
    # DEPLOY LOGIC HERE
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
      app.uid  = "http://#{app.prefix}-#{name}.herokuapp.com"
    end
    if sibling  
      self.update_attributes(sibling_app: sibling)
    end
  end
end
