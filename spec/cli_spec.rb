require "todotxt/clihelpers"
require "todotxt/cli"

describe Todotxt::CLI do
  it 'should have a move command' do
    Todotxt::CLI.tasks.should have_key "move"
  end

  context "move" do
    before(:each) do
      @task = Todotxt::CLI.tasks["move"]
      @cli  = Todotxt::CLI.new
    end
  end
end
