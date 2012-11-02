class Entry < ActiveRecord::Base
  attr_accessible :name, :uid
  APP_NAME = "g5-client-app-creator"
  validates :name, uniqueness: true
  has_many :client_apps

  def self.consume_feed(file=nil)
    file ||= "http://g5-configurator.herokuapp.com/configurations"
    feed = G5HentryConsumer.parse(file)
    self.parse_entries!(feed)
  end

  def self.targets_me?(url)
    url =~ /^https?:\/\/w{3}?.?#{APP_NAME}.herokuapp.com/i
  end

  def self.parse_entries!(feed)
    feed = feed.entries.delete_if {|entry| !self.targets_me?(entry.content.target.first.url.first) }
    feed.entries.map do |entry|
      e = self.find_or_create_by_uid(entry.bookmark)
      puts e.inspect
      entry.content.apps.each do |app|
        e.client_apps.create(name: app.name)
      end
      e
    end.flatten
  end

end
