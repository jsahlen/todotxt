# Setup our load paths
libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

module Todotxt
  autoload :Todo,       "todotxt/todo"
  autoload :TodoList,   "todotxt/todolist"
  autoload :CLI,        "todotxt/cli"
  autoload :CLIHelpers, "todotxt/clihelpers"
end

require "todotxt/regex"
require "todotxt/version"
