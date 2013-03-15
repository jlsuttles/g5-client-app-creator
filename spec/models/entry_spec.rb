require 'spec_helper'

describe Entry do
  before do
    Resque.stub(:enqueue)
    Entry.stub(:feed_url).and_return("spec/support/g5-configurator-entries.html")
    Entry.stub(:target_uid).and_return("http://g5-configurator.dev/apps/g5-client-app-creator")
  end

  describe ".feed" do
    it "returns a Microformats2::Collection" do
      Entry.feed.should be_kind_of Microformats2::Collection
    end
  end
  describe ".consume_feed" do
    it "returns an Array of created ActiveRecord Entries" do
      Entry.consume_feed.first.should be_a_kind_of(Entry)
    end
    it "returns nil if not targeted" do
      Entry.stub(:target_uid).and_return("http://g5-configurator.dev/apps/g5-client-app-creator-deployer")
      Entry.consume_feed.first.should be_nil
    end
    it "swallows 304 errors" do
      error = OpenURI::HTTPError.new("304 Not Modified", nil)
      Entry.stub(:find_or_create_from_hentry).and_raise(error)
      Entry.consume_feed.should be_nil
    end
  end
  describe ".async_consume_feed" do
    it "enqueues EntryConsumer" do
      Resque.stub(:enqueue)
      Resque.should_receive(:enqueue).with(EntryConsumer)
      Entry.async_consume_feed
    end
  end
  describe ".find_or_create_from_hentry" do
    before do
      @hentry = Entry.feed.entries.second
      @instruction = Entry.instruction(@hentry)
    end
    it "creates an Entry" do
      expect { Entry.find_or_create_from_hentry(@hentry) }.to(
        change(Entry, :count).by(1))
    end
    it "creates a ClientApp" do
      expect { Entry.find_or_create_from_hentry(@hentry) }.to(
        change(ClientApp, :count).by(1))
    end
  end
  describe ".instruction" do
    before do
      @instruction = Entry.instruction(Entry.feed.entries.second)
    end
    it "has a uid" do
      @instruction.uid.to_s.should == "http://g5-configurator.dev/instructions/4"
    end
    it "has a target uid" do
      @instruction.g5_target.format.uid.to_s.should == "http://g5-configurator.dev/apps/g5-client-app-creator"
    end
    describe "has an app" do
      before do
        @app = @instruction.g5_app.format
      end
      it "has a name" do
        @app.name.to_s.should == "g5-chd-metro-self-storage"
      end
      it "has an app uid" do
        @app.uid.to_s.should == "http://g5-configurator.dev/apps/g5-chd-metro-self-storage"
      end
      it "has a client uid" do
        @app.org.format.uid.to_s.should == "http://g5-hub.dev/clients/g5-c-1-metro-self-storage"
      end
      it "has a git repo" do
        @app.g5_git_repo.to_s.should == "git@github.com:g5search/g5-client-hub-deployer.git"
      end
    end
  end
end
