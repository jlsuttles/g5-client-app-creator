class EntryConsumer
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :consumer

  def self.perform
    puts "Start consuming feed"
    Entry.consume_feed
    puts "Done consuming feed"
  end
end
