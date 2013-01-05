require "parseconfig"
require "fileutils"

module Todotxt
  class Config < ParseConfig
    def initialize config_path = ""
      if config_path.empty?
        @config_path = File.join ENV["HOME"], ".todotxt.cfg"
      else
        @config_path = config_path
      end

      if file_exists?
        super @config_path
        validate
      end
    end

    def file_exists?
      File.exists? @config_path
    end

    def files
      params["files"] || {"todo" => params["todo_txt_path"] }
    end

    def generate!
      FileUtils.copy "conf/todotxt.cfg", @config_path
    end

    private
    def validate
      if params["files"] && params["todo_txt_path"]
        raise "Bad configuration file: use either files or todo_txt_path"
      end
    end
  end
end
