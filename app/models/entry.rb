class Entry < ActiveRecord::Base
  FEED_URL = "http://g5-configurator.herokuapp.com/configurations"
  TARGET_URL = "http://g5-client-app-creator.herokuapp.com"

  attr_accessible :name, :uid

  has_many :client_apps

  validates :uid, uniqueness: true

  class << self
    def feed(path_or_url=FEED_URL)
      G5HentryConsumer.parse(path_or_url)
    end

    def consume_feed(path_or_url=FEED_URL)
      feed(path_or_url).entries.map do |hentry|
        consume_entry(hentry)
      end.compact
    end

    def targets_me?(hentry)
      url = hentry.content.target.first.url if hentry.is_a?(HentryConsumer::HEntry)
      url = url.first if url.is_a?(Array)
      !!(url && url =~ /^#{TARGET_URL}$/i)
    end

    def consume_entry(hentry)
      if targets_me?(hentry)
        entry = find_or_initialize_from_hentry(hentry)
        entry.build_client_apps_from_hentry(hentry)
        entry.save
        entry
      end
    end

    def find_or_initialize_from_hentry(hentry)
      find_or_initialize_by_uid(hentry.bookmark)
    end
  end # class << self

  def build_client_apps_from_hentry(hentry)
    hentry.content.configuration.each do |app|
      client_apps.build(name: app.name)
    end
  end
end
