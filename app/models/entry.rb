class Entry < ActiveRecord::Base
  FEED_URL = "http://g5-configurator.herokuapp.com/instructions"
  TARGET_URL = "http://g5-configurator.herokuapp.com/apps/1"

  attr_accessible :name, :uid

  has_many :client_apps

  validates :uid, uniqueness: true

  class << self
    def feed(path_or_url=FEED_URL)
      G5HentryConsumer.parse(path_or_url)
    end

    def async_consume_feed
      Resque.enqueue(EntryConsumer)
    end

    def consume_feed(path_or_url=FEED_URL)
      feed(path_or_url).entries.map do |hentry|
        consume_entry(hentry)
      end.compact
    end

    def targets_me?(hentry)
      if hentry.nil? || hentry.is_a?(String)
        hentry == TARGET_URL
      else
        targets = hentry.content.first.targets
        targets && targets.include?(TARGET_URL)
      end
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
    hentry.content.first.apps.each do |app|
      client_apps.build(
        uid: app.uid, 
        client_uid: app.client_uid.first,
        name: app.name.first, 
        git_repo: app.git_repo.first
      )
    end
  end
end
