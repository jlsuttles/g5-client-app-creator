require "spec_helper"

describe ClientAppDeployer do
  before :each do
    Resque.stub(:enqueue)
  end

  describe "#perform" do
    let(:client_app) { ClientApp.create(name: "g5-cms-mock-app", git_repo: "git@git") }

    before :each do
      ClientApp.any_instance.stub(:deploy).and_return(true)
      ClientApp.any_instance.stub(:heroku_run)
      ClientApp.any_instance.stub(:heroku_config_set)
      ClientApp.any_instance.stub(:heroku_addon_add)
    end

    it "deploys" do
      ClientApp.any_instance.should_receive(:deploy).once
      ClientAppDeployer.perform(client_app.id)
    end
    it "runs rake db:migrate" do
      ClientApp.any_instance.should_receive(:heroku_run).with("rake db:migrate").once
      ClientAppDeployer.perform(client_app.id)
    end
    it "sets config variables" do
      ClientApp.any_instance.should_receive(:heroku_config_set).once
      ClientAppDeployer.perform(client_app.id)
    end
    it "adds redistogo:nano addon" do
      ClientApp.any_instance.should_receive(:heroku_addon_add).with("redistogo:nano").once
      ClientAppDeployer.perform(client_app.id)
    end
    it "runs rake deploy:tasks if deploying client-hub" do
      ClientApp.any_instance.should_receive(:heroku_run).with("rake deploy:tasks").once
      ClientAppDeployer.perform(client_app.id)
    end
    it "runs rake deploy:tasks if deploying client-hub-deployer" do
      client_app.update_attribute(:name, "g5-chd-mock-app")
      ClientApp.any_instance.should_receive(:heroku_run).with("rake deploy:tasks").once
      ClientAppDeployer.perform(client_app.id)
    end
  end

  describe "when an exception is raised" do
    before do
     client_app = ClientApp.create(name: "g5-cms-mock-app", git_repo: "git@git")
     @client_app_deployer = ClientAppDeployer.new(client_app.id)
    end

    it "retries 0 times when Exception" do
      ClientApp.any_instance.stub(:deploy).and_raise(Exception)
      expect { @client_app_deployer.perform }.to raise_error(Exception)
      expect(@client_app_deployer.retries).to eq 0
    end

    it "retries 3 times when GithubHerokuDeployer::CommandException" do
      ClientApp.any_instance.stub(:deploy).and_raise(GithubHerokuDeployer::CommandException)
      expect { @client_app_deployer.perform }.to raise_error(GithubHerokuDeployer::CommandException)
      expect(@client_app_deployer.retries).to eq 3
    end

    it "retries 3 times when Heroku::API::Errors::ErrorWithResponse" do
      ClientApp.any_instance.stub(:deploy).and_raise(Heroku::API::Errors::ErrorWithResponse.new(nil, nil))
      expect { @client_app_deployer.perform }.to raise_error(Heroku::API::Errors::ErrorWithResponse)
      expect(@client_app_deployer.retries).to eq 3
    end
  end

  describe "when app type does not exist in deploy defaults" do
    before do
     client_app = ClientApp.create(name: "g5-foo-mock-app", git_repo: "git@git")
     @client_app_deployer = ClientAppDeployer.new(client_app.id)
    end

    it "raises an Exception" do
      expect { @client_app_deployer.perform }.to raise_error(ArgumentError, "Unknown app type: foo")
    end
  end
end
