class Entry < ActiveRecord::Base
  FEED_URL = "http://g5-configurator.herokuapp.com/configurations"
  TARGET_APP_NAME = "g5-client-app-creator"

  attr_accessible :name, :uid

  has_many :client_apps

  validates :uid, uniqueness: true

  class << self
    def feed
      G5HentryConsumer.parse(FEED_URL)
    end

    def consume_feed
      feed.entries.each do |hentry|
        consume_entry
      end
    end

    def targets_me?(hentry)
      url = hentry.content.target.first.url.first
      url =~ /^https?:\/\/w{3}?.?#{TARGET_APP_NAME}.herokuapp.com/i
    end

    def consume_entry(hentry)
      if targets_me?(hentry)
        entry = find_or_initialize_from_hentry(hentry)
        entry.build_client_apps_from_hentry(hentry)
        entry.save
      end
    end

    def find_or_create_from_entry(hentry)
      find_or_create_by_uid(hentry.bookmark)
    end
  end # class << self

  def build_client_apps_from_hentry(hentry)
    hentry.content.configuration.each do |app|
      client_apps.build(name: app.name)
    end
  end
end
