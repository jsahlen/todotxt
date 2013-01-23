require "spec_helper"
require "todotxt/regex"
require "todotxt/clihelpers"

describe Todotxt::CLIHelpers do
  include Todotxt::CLIHelpers
  describe "#format_todo" do
    before(:each) do
      @string = String.new("Make it happen")
      String.any_instance.stub(:color).and_return(@string)
      String.any_instance.stub(:bright).and_return(@string)

      @todo = mock "Todo"
      @todo.stub(:line).and_return(nil)
      @todo.stub(:done).and_return(false)
    end

    describe "without priority" do
      it "should be white" do
        pending "refactor #format_todo to make it testable"
        @string.should_receive(:color).with(:white)
        @todo.stub(:text).and_return(@string)
        @todo.stub(:to_s).and_return(@string)

        format_todo(@todo)
      end
    end

    describe "with priority" do
      it "should render priority A in red"
      it "should render priority B in yellow"
      it "should render priority C in green"
    end

    it "should render projects in green"
    it "should render contexts in blue"
    it "should render 'done' items in black"

    it "should render the line-number in black"
  end
end
