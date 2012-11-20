require 'spec_helper'

describe ClientApp do
  let(:entry) { Entry.create(uid: "http://example.com/1") }
  let(:client_app) { ClientApp.create(name: "mock-app", entry_id: entry.id, git_repo: "git@git") }
  let(:buddy_app) { ClientApp.create(name: "ch-mock-app", entry_id: entry.id, git_repo: "git@git") }

  it "creates from name" do
    client_app.name.should eq "mock-app"
  end

  it "has a sibling app" do
    buddy_app
    client_app.siblings.should include buddy_app
  end
  
  it "does something" do
    app = ClientApp.new(name: "mockk-app", entry_id: 1, git_repo: "git@git")
    app.should_receive(:async_deploy).once
    app.save
  end
  
  it "should receive heroku_run once" do
    GithubHerokuDeployer.should_receive(:heroku_run).once
    client_app.heroku_run("rake db:migrate")
  end

  it "should receive heroku_config_set once" do
    GithubHerokuDeployer.should_receive(:heroku_config_set).once
    client_app.heroku_config_set("FOO" => "bar")
  end
end
