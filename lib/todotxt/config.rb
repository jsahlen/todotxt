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
    end

    def files
      params["files"] || {"todo" => params["todo_txt_path"] }
    end

    private
    def copy_new
      FileUtils.copy "conf/todotxt.cfg", @config_path
    end
  end
end
