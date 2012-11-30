require "todotxt/config"

describe Todotxt::Config do
  before(:each) do
    ENV["HOME"] = File.join "/", "tmp"
    @config_file = File.join ENV["HOME"], ".todotxt.cfg"
  end
  it 'should create a template on initialize' do
    File.delete @config_file if File.exists? @config_file
    Todotxt::Config.new
    File.exists?(@config_file).should be_true
  end

  it 'should have a "files"' do
    cfg = Todotxt::Config.new "spec/fixtures/config_new.cfg"
    cfg.files.keys.should include "todo"
  end

  it 'should place "todo_txt_path" under files' do
    cfg = Todotxt::Config.new "spec/fixtures/config_old.cfg"
    cfg.files.keys.should include "todo"
  end

  it 'not allow both "files" and "todo_txt_path"' do
    expect do
      Todotxt::Config.new "spec/fixtures/config_both.cfg"
    end.to raise_error "Bad configuration file: use either files or todo_txt_path"
  end
end
