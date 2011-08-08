require "thor"

module Todotxt
  class CLI < Thor
    include Thor::Actions

    desc "version", "Show todotxt version"
    def version
      require "todotxt/version"
      say "todotxt #{Todotxt::VERSION}"
    end

  end
end
