require "spec_helper"
require "todotxt/config"

describe Todotxt::Config do
  before(:each) do
    ENV["HOME"] = File.join "/", "tmp"
    @config_file = File.join ENV["HOME"], ".todotxt.cfg"
  end

  context "valid config" do
    before(:each) do
      @cfg = Todotxt::Config.new({:config_file => "spec/fixtures/config_new.cfg"})
    end

    it 'should have a "files"' do
      @cfg.files.keys.should include "todo"
    end

    it 'should not be deprecated' do
      @cfg.should_not be_deprecated
    end

    describe "#files" do
      it "should return a list of TodoFile objects as configured in config" do
        @cfg.files.should be_kind_of(Hash)
        @cfg.files.should eq({ "todo" => Todotxt::TodoFile.new("/tmp/todo.txt") })
      end
    end
    describe "#file" do
      it "should return the 'todo' file from the 'files' hash" do
        @cfg.file.should eq @cfg.files["todo"]
      end
    end
  end

  context "invalid config" do
    it 'not allow both "files" and "todo_txt_path"' do
      expect do
        Todotxt::Config.new({ :config_file => "spec/fixtures/config_both.cfg" })
      end.to raise_error "Bad configuration file: use either files or todo_txt_path"
    end

    it 'should complain when there is no "todo" in files and no file is requested' do
      expect do
        Todotxt::Config.new({:config_file => "spec/fixtures/config_no_todo.cfg"}).file
      end.to raise_error "Bad configuration file: 'todo' is a required file."
    end
  end

  context "old style config" do
    before(:each) do
      @cfg = Todotxt::Config.new({:config_file => "spec/fixtures/config_old.cfg"})
    end

    it 'should place "todo_txt_path" under files' do
      @cfg.files.keys.should include "todo"
    end

    it 'should be deprecated' do
      @cfg.should be_deprecated
    end
  end

  context "#generate!" do
    it 'should create a template' do
      File.delete @config_file if File.exists? @config_file
      todo = Todotxt::Config.new
      todo.generate!
      File.exists?(@config_file).should be_true
    end
  end
end
