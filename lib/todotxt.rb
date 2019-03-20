# Setup our load paths
libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)


# Todotxt is a Ruby librairy / CLI interface to work with a [todo.txt](http://www.todotxt.com) format.
module Todotxt
  autoload :Todo,       'todotxt/todo'
  autoload :TodoList,   'todotxt/todolist'
  autoload :TodoFile,   'todotxt/todofile'
  autoload :CLI,        'todotxt/cli'
  autoload :CLIHelpers, 'todotxt/clihelpers'
  autoload :Config,     'todotxt/config'
end

require 'todotxt/regex'
require 'todotxt/version'
