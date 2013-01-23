module Todotxt
  class TodoFile
    #From Kernel::File
    #@arg filename, String, path to the file
    #@arg mode, String, IO-mode, defaults to a+
    #@arg generate, Boolean, Force generation of a todofile from template
    def initialize path
      @path = path
    end

    # Generate a file from template
    def generate!
      FileUtils.copy File.join(File.dirname(File.expand_path(__FILE__)), "..", "..", "conf", "todo.txt"), @path
    end

    def exists?
      File.exists? File.expand_path(@path)
    end

    def self.from_key(key)
      config = Todotxt::Config.new
      if config.files.has_key? key
        path = config.files[key]
        self.new path
      else
        raise "Key not found in config"
      end
    end


    def to_s
      @path
    end
  end
end
