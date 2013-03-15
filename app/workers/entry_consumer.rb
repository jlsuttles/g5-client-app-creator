class EntryConsumer
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :consumer

  def self.perform
    Rails.logger.info "Start consuming feed"
    Entry.consume_feed
    Rails.logger.info "Done consuming feed"
  end
end
