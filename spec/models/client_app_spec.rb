require 'spec_helper'

describe ClientApp do
  let(:entry) { Entry.create(uid: "http://example.com/1") }
  let(:client_app) { ClientApp.create(name: "mock-app", entry_id: entry.id, git_repo: "git@git") }
  let(:buddy_app) { ClientApp.create(name: "ch-mock-app", entry_id: entry.id, git_repo: "git@git") }
  before do
    Resque.stub(:enqueue)
  end

  describe "#deploy" do
    it "deploys with options" do
      GithubHerokuDeployer.stub(:deploy)
      GithubHerokuDeployer.should_receive(:deploy).with(client_app.deployer_options).once
      client_app.deploy
    end
  end
  describe "#heroku_restart" do
    it "heroku_restarts with options" do
      GithubHerokuDeployer.stub(:heroku_restart)
      GithubHerokuDeployer.should_receive(:heroku_restart).with(client_app.deployer_options).once
      client_app.heroku_restart
    end
  end
  describe "#heroku_destroy" do
    it "heroku_destroys with options" do
      GithubHerokuDeployer.stub(:heroku_destroy)
      GithubHerokuDeployer.should_receive(:heroku_destroy).with(client_app.deployer_options).once
      client_app.heroku_destroy
    end
  end
  describe "#heroku_addon_add" do
    it "heroku_addon_adds with options" do
      GithubHerokuDeployer.stub(:heroku_addon_add)
      GithubHerokuDeployer.should_receive(:heroku_addon_add).with(:foo, client_app.deployer_options).once
      client_app.heroku_addon_add(:foo)
    end
  end
  describe "#heroku_url" do
    it "heroku_urls with options" do
      client_app.heroku_url.should eq "http://mock-app.herokuapp.com"
    end
  end

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
