require 'spec_helper'

describe ClientApp do
  let(:entry) { Entry.create(name: "mock-app") }
  subject { entry.client_apps.last }
  it "creates from name" do
    entry.client_hub.name.should eq "mock-app"
  end

  it "has a uid" do
    entry.client_hub.uid.should eq "http://g5-ch-mock-app.herokuapp.com"
  end

  it "has a deployer uid" do
    entry.client_hub_deployer.uid.should eq "http://g5-chd-mock-app.herokuapp.com"
  end

  it "has a sibling app" do
    entry.client_hub.sibling_app.should be_an_instance_of ClientApp
  end
  
  it "does something" do
    app = ClientApp.new(name: "mockk-app", entry_id: 1, app_type: "ClientHub")
    app.uid = "blah"
    app.should_receive(:deploy).once
    app.save
  end
end
