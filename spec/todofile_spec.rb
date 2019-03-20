require 'spec_helper'
require 'todotxt/config'
require 'todotxt/todofile'

describe Todotxt::TodoFile do
  before(:each) do
    @todo_path = '/tmp/todo.txt'
    allow_any_instance_of(Todotxt::Config).to receive(:files).and_return(todo: @todo_path)
  end
  after(:each) do
    File.delete @todo_path if File.exist? @todo_path
  end

  it 'should create a new file when initializing' do
    file = Todotxt::TodoFile.new(@todo_path)
    expect(file).to be_kind_of(Todotxt::TodoFile)
  end

  it 'should create a new file via the key in config' do
    file = Todotxt::TodoFile.from_key(:todo)
    expect(file).to be_kind_of(Todotxt::TodoFile)
  end

  it 'should throw an error for undefined keys' do
    expect do
      Todotxt::TodoFile.from_key(:does_not_exist)
    end.to raise_error 'Key not found in config'
  end

  describe '#==' do
    it 'should compare using paths' do
      expect(Todotxt::TodoFile.new(@todo_path)).to eq(Todotxt::TodoFile.new(@todo_path))
      expect(Todotxt::TodoFile.new(@todo_path)).not_to eq(Todotxt::TodoFile.new('/other/path'))
    end
  end
end
