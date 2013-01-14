require "spec_helper"

describe EntryConsumer do
  describe ".perform" do
    it "consumes entry feed" do
      Entry.should_receive(:consume_feed).once
      EntryConsumer.perform
    end
  end
end
