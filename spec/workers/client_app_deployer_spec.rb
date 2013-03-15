require "spec_helper"

describe ClientAppDeployer do
  let(:client_app) { ClientApp.create(name: "g5-ch-mock-app", git_repo: "git@git") }
  before :each do
    Resque.stub(:enqueue)
    ClientApp.any_instance.stub(:deploy).and_return(true)
    ClientApp.any_instance.stub(:heroku_run)
    ClientApp.any_instance.stub(:heroku_config_set)
    ClientApp.any_instance.stub(:heroku_addon_add)
  end

  describe "#perform" do
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
    it "runs rake seed_client if deploying client hub" do
      ClientApp.any_instance.should_receive(:heroku_run).with("rake seed_client").once
      ClientAppDeployer.perform(client_app.id)
    end
    it "runs rake sibling:consume" do
      ClientApp.any_instance.should_receive(:heroku_run).with("rake sibling:consume").once
      ClientAppDeployer.perform(client_app.id)
    end
    it "runs rake sibling:consume" do
      client_app.update_attribute(:name, "g5-chd-mock-app")
      ClientApp.any_instance.should_receive(:heroku_run).with("rake sibling:consume").once
      ClientAppDeployer.perform(client_app.id)
    end
  end
end
