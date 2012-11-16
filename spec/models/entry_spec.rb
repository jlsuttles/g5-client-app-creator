require 'spec_helper'

describe Entry do
  describe "#targets_me?" do
    it { Entry.targets_me?(hentry_with_target Entry::TARGET_URL).should be_true }
    it { Entry.targets_me?('').should be_false }
    it { Entry.targets_me?(nil).should be_false }
    it { Entry.targets_me?(hentry_with_target 'http://g5-chd-mock-app').should be_false }
    it { Entry.targets_me?(hentry_with_target "https://g5-client-app-creator.herokuapp.com").should be_false }
    it { Entry.targets_me?(hentry_with_target "https://www.g5-client-app-creator.herokuapp.com").should be_false }
    it { Entry.targets_me?(hentry_with_target "https://www.g5-client-app-creator.herokuapp.com/").should be_false }

    def hentry_with_target(target)
      feed = G5HentryConsumer.parse("spec/support/example_feed.html")
      hentry = feed.entries.first
      hentry.content.first.targets = [target]
      hentry
    end
  end

  describe "consuming feed" do
    let(:feed) { Entry.consume_feed('spec/support/example_feed.html') }
    subject { feed }

    it "has elements" do
      subject.should have(1).thing
    end

    describe "parsed entry" do
      subject { feed.last }

      its(:uid) { should eq "http://g5-configurator.dev/instructions/35" }

      it "is a entry" do
        subject.should be_an_instance_of Entry
      end
      
      describe "apps" do

        it "should have a client hub" do
          subject.client_apps.should be_present
        end

        it "has 2 client apps" do
          subject.client_apps.should have(1).things(ClientApp)
        end
        
        it "should have a git repo" do
          subject.client_apps.first.git_repo.should eq "git@git"
        end

      end
    end
  end

end
