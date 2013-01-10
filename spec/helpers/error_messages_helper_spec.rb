require "spec_helper"

describe ErrorMessagesHelper do
  describe "#error_messages_for" do
    it "returns nil when no messages" do
      helper.error_messages_for(nil).should eq nil
    end
    it "returns messages when messages" do
      app = ClientApp.create
      helper.error_messages_for(app).should include "Invalid Fields"
    end
  end
  describe ErrorMessagesHelper::FormBuilderAdditions do
    describe "#error_messages" do
      it "calls ErrorMessagesHelper#error_messages_for" do
        class Foo 
          include ErrorMessagesHelper::FormBuilderAdditions
          def initialize(template)
            @template = template
          end
        end
        helper.should_receive(:error_messages_for).once
        Foo.new(helper).error_messages
      end
    end
  end
  it "is included in FormBuilder" do
    ActionView::Helpers::FormBuilder.included_modules.should 
      include ErrorMessagesHelper::FormBuilderAdditions
  end
end
