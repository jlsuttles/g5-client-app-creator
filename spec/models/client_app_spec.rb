require 'spec_helper'

describe ClientApp do
  let(:entry) { Entry.create(uid: "http://example.com/1") }
  let(:client_app) { ClientApp.create(name: "mock-app", entry_id: entry.id) }
  let(:buddy_app) { ClientApp.create(name: "ch-mock-app", entry_id: entry.id) }
  it "creates from name" do
    client_app.name.should eq "mock-app"
  end

  it "has a sibling app" do
    buddy_app
    client_app.siblings.should include buddy_app
  end
  
  it "does something" do
    app = ClientApp.new(name: "mockk-app", entry_id: 1)
    app.should_receive(:async_deploy).once
    app.save
  end
end
