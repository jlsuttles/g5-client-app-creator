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

      its(:client_name) { should eq "i-want-deployed" }
      its(:uid)         { should eq "http://i-want-deployed.herokuapp.com"}
      it "is a entry" do
        subject.should be_an_instance_of Entry
      end
      it "should call push client apps" do
        entry = Entry.new(uid: "http://example.com", client_name: "blah")
        entry.should_receive(:push_client_apps).once
        entry.save
      end
    end
  end
  
end
