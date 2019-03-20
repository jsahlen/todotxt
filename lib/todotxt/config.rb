require 'parseconfig'
require 'fileutils'

module Todotxt
  class Config < ParseConfig
    def initialize(options = {})
      @options = options

      @config_file = options[:config_file] || Config.config_path

      if file_exists?
        super @config_file
        validate
      else
        @params = {}
        @groups = []
      end
    end

    def file_exists?
      File.exist? @config_file
    end

    def files
      files = {}
      (params['files'] || { 'todo' => params['todo_txt_path'] }).each do |k, p|
        files[k] = TodoFile.new(p)
      end

      files
    end

    def file
      if @options[:file].nil?
        files['todo'] || raise("Bad configuration file: 'todo' is a required file.")
      elsif files[@options[:file]]
        files[@options[:file]]
      elsif File.exist?(File.expand_path(@options[:file]))
        TodoFile.new(File.expand_path(@options[:file]))
      else
        raise("\"#{@options[:file]}\" is not defined in the config and not a valid filename.")
      end
    end

    def editor
      params['editor'] || ENV['EDITOR']
    end

    def generate!
      FileUtils.copy File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'conf', 'todotxt.cfg'), @config_file
      import_config
    end

    def path
      @config_file
    end

    def basename
      File.basename @config_file
    end

    def self.config_path
      File.join ENV['HOME'], '.todotxt.cfg'
    end

    def deprecated?
      params['files'].nil?
    end

    private

    def validate
      if params['files'] && params['todo_txt_path']
        raise 'Bad configuration file: use either files or todo_txt_path'
      end
    end
  end
end
