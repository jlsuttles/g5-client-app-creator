class Entry < ActiveRecord::Base
  has_many :client_apps
  accepts_nested_attributes_for :client_apps
  validates :uid, uniqueness: true

  class << self
    def feed_url
      ENV["G5_CONFIGURATOR_FEED_URL"]
    end

    def target_uid
      ENV["G5_CLIENT_APP_CREATOR_UID"]
    end

    def feed
      Microformats2.parse(feed_url)
    end

    def consume_feed
      feed.entries.map do |hentry|
        find_or_create_from_hentry(hentry) if targets_me?(hentry)
      end.compact
    rescue OpenURI::HTTPError, "304 Not Modified"
    end

    def async_consume_feed
      Resque.enqueue(EntryConsumer)
    end

    def targets_me?(hentry)
      targets = instruction(hentry).g5_targets.map { |t| t.format.uid.to_s }
      targets && targets.include?(target_uid)
    end

    def instruction(hentry)
      Microformats2.parse(hentry.content.to_s).card
    end

    def find_or_create_from_hentry(hentry)
      find_or_create_by(uid: hentry.uid.to_s) do |entry|
        app = instruction(hentry).g5_app.format
        if client_app = ClientApp.find_by_uid(app.uid.to_s)
          entry.client_id = client_app.id
        elsif app.respond_to?(:org)
          entry.client_apps_attributes = [
            { uid: app.uid.to_s,
              client_uid: app.org.format.uid.to_s,
              name: app.g5_heroku_app_name.to_s,
              git_repo: app.g5_git_repo.to_s }
          ]
        end
      end
    end
  end # class << self
end
