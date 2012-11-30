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
      copy_new unless File.exists? @config_path

      super @config_path

      validate
    end

    def files
      params["files"] || {"todo" => params["todo_txt_path"] }
    end

    private
    def validate
      if params["files"] && params["todo_txt_path"]
        raise "Bad configuration file: use either files or todo_txt_path"
      end
    end

    def copy_new
      FileUtils.copy "conf/todotxt.cfg", @config_path
    end
  end
end
