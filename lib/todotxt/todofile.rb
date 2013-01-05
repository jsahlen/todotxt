module Todotxt
  class TodoFile < File
    #From Kernel::File
    #@arg filename, String, path to the file
    #@arg mode, String, IO-mode, defaults to a+
    #@arg offer_template, Boolean, Whether or not to offer creation of file from template.
    def initialize *args
      # Default to append-mode
      if args[2].nil?
        args[1] = "a+"
      end

      super *args
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
  end
end
