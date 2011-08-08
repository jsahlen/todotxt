# Setup our load paths
libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

module Todotxt
  autoload :CLI,  "todotxt/cli"
end

require "todotxt/version"
