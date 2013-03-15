require 'spec_helper'

describe WebhooksController do
  describe "#g5_configurator" do

    before do
      Resque.stub(:enqueue)
      Entry.stub(:async_consume_feed).and_return(true)
    end

    it "queues Entry feed consumption" do
      Entry.should_receive(:async_consume_feed).once
      post :g5_configurator
    end

    it "queues Sibling::Instruction feed consumption" do
      Sibling::Instruction.should_receive(:async_consume_feed).once
      post :g5_configurator
    end
    # it "retuns OK" do
    #   post :consume_feed
    #   response.should == "something"
    # end
  end
end
