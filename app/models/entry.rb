class Entry < ActiveRecord::Base
  attr_accessible :name
  APP_NAME = "g5-client-app-creator"
  after_create :create_client_app
  validates :name, uniqueness: true
  has_many :client_apps
  has_one :client_hub, class_name: "ClientApp", conditions: {app_type: "ClientHub"}
  has_one :client_hub_deployer, class_name: "ClientApp", conditions: {app_type: "ClientHubDeployer"}
  
  def self.consume_feed(file)
    feed = G5HentryConsumer.parse(file)
    self.parse_entries!(feed)
  end

  def self.targets_me?(url)
    url =~ /^https?:\/\/w{3}?.?#{APP_NAME}.herokuapp.com/i
  end

  def self.parse_entries!(feed)
    feed = feed.entries.delete_if {|entry| !self.targets_me?(entry.content.target.first.url.first) }
    feed.entries.map do |entry|
      self.find_or_create_by_name(entry.name)
    end
  end
  
  private
  
  def create_client_app
    client_apps.create_from_name(name, app_type: "ClientHub")
  end
  
end
