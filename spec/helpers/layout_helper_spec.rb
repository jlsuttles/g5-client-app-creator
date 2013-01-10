require "spec_helper"

describe LayoutHelper do
  describe "#title" do
    it "sets content_for(:title)" do
      helper.title("foo")
      view.content_for(:title).should eq "foo"
    end
    it "sets @show_title to true by default" do
      helper.title("foo")
      helper.show_title?.should eq true
    end
    it "sets @show_title to false" do
      helper.title("foo", false)
      helper.show_title?.should eq false
    end
  end
  describe "#header_right" do
    it "sets content_for(:header_right)" do
      helper.header_right("foo")
      view.content_for(:header_right).should eq "foo"
    end
    it "sets @show_header_right to true by default" do
      helper.header_right("foo")
      helper.show_header_right?.should eq true
    end
    it "sets @show_header_right to false" do
      helper.header_right("foo", false)
      helper.show_header_right?.should eq false
    end
  end
  describe "#flash_div" do
    it "returns nil if flash at given level is not present" do
      flash[:notice] = nil
      helper.flash_div(:notice).should eq nil
    end
    it "returns message if flash at given level is present" do
      flash[:notice] = "Notice"
      helper.flash_div(:notice).should include "Notice"
    end
    it "sets bootstrap class special for notice level" do
      flash[:notice] = "Notice"
      helper.flash_div(:notice).should include "alert-info"
    end
  end
end
