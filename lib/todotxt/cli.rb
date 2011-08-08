require "thor"

module Todotxt
  class CLI < Thor
    include Thor::Actions

    desc "version", "Show todotxt version"
    def version
      say "todotxt #{VERSION}"
    end

  end
end
