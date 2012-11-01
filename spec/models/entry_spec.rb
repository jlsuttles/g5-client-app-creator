require 'spec_helper'

describe Entry do

  describe "feed entry conversion" do

    it { Entry.targets_me?('http://g5-chd-mock-app').should be_false }
    it { Entry.targets_me?('').should be_false }
    it { Entry.targets_me?(nil).should be_false }
    it { Entry.targets_me?("http://g5-client-app-creator.herokuapp.com").should be_true }
    it { Entry.targets_me?("https://g5-client-app-creator.herokuapp.com").should be_true }
    it { Entry.targets_me?("https://www.g5-client-app-creator.herokuapp.com").should be_true }
    it { Entry.targets_me?("https://www.g5-client-app-creator.herokuapp.com/").should be_true }
  end
  describe "consuming feed" do
    let(:feed) { Entry.consume_feed('spec/support/example_feed.html') }
    subject { feed }

    it "has elements" do
      feed.should have(1).thing
    end

    describe "parsed entry" do
      subject { feed.first }

      its(:name) { should eq "i-want-deployed" }

      it "is a entry" do
        subject.should be_an_instance_of Entry
      end

      describe "apps" do

        it "should have a client hub" do
          subject.client_apps.should be_present
        end

        it "has 2 client apps" do
          subject.client_apps.should have(2).things(ClientApp)
        end
        
        it "has a hub" do
          subject.client_hub.app_type.should eq "ClientHub"
        end
        
        it "has a deployer" do
          subject.client_hub_deployer.app_type.should eq "ClientHubDeployer"
        end
        
      end
    end
  end

end
