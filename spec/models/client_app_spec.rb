require 'spec_helper'

describe ClientApp do
  let(:entry) { Entry.create(name: "mock-app") }
  subject { entry.client_apps.last }
  it "creates from name" do
    entry.client_hub.name.should eq "mock-app"
  end

  it "has a sibling app" do
    entry.client_hub.sibling_app.should be_an_instance_of ClientApp
  end
  
  it "does something" do
    app = ClientApp.new(name: "mockk-app", entry_id: 1, app_type: "ClientHub")
    app.uid = "blah"
    app.should_receive(:async_deploy).once
    app.save
  end
end
