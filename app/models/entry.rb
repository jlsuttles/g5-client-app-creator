class Entry < ActiveRecord::Base
  attr_accessible :client_name, :uid
  APP_NAME = "g5-client-app-creator"
  after_create :push_client_apps
  def push_client_apps
    # PUT LOGIC TO PUSH APPS HERE WITH GEM
  end
  
  def self.consume_feed(file)
    feed = read_feed(file)
    self.parse_entries!(feed)
  end

  def self.targets_me?(url)
    url =~ /^https?:\/\/w{3}?.?#{APP_NAME}.herokuapp.com/i
  end

  def self.read_feed(file)
    G5HentryConsumer.parse(file)
  end

  def self.parse_entries!(feed)
    feed = feed.entries.delete_if {|entry| !self.targets_me?(entry.content.target.first.url.first) }
    feed.entries.map do |entry|
      self.find_or_create_by_uid("http://#{entry.name}.herokuapp.com", client_name: entry.name)
    end
  end
  
end
