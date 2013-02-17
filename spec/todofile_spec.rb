require "spec_helper"
require "todotxt/config"
require "todotxt/todofile"

describe Todotxt::TodoFile do
  before(:each) do
    @todo_path = "/tmp/todo.txt"
    Todotxt::Config.any_instance.stub(:files) do
      {todo:@todo_path}
    end
  end
  after(:each) do
    File.delete @todo_path if File.exists? @todo_path
  end

  it 'should create a new file when initializing' do
    file = Todotxt::TodoFile.new(@todo_path)
    file.class.should == Todotxt::TodoFile
  end

  it 'should create a new file via the key in config' do
    file = Todotxt::TodoFile.from_key(:todo)
    file.class.should == Todotxt::TodoFile
  end

  it 'should throw an error for undefined keys' do
    expect { 
      Todotxt::TodoFile.from_key(:does_not_exist)
    }.to raise_error "Key not found in config"
  end

  describe "#==" do
    it "should compare using paths" do
      (Todotxt::TodoFile.new(@todo_path)==Todotxt::TodoFile.new(@todo_path)).should be_true
      (Todotxt::TodoFile.new(@todo_path)==Todotxt::TodoFile.new("/other/path")).should_not be_true
    end
  end
end
