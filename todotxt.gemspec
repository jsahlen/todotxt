# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "todotxt/version"

Gem::Specification.new do |s|
  s.name        = "todotxt"
  s.version     = Todotxt::VERSION
  s.authors     = ["Johan Sahlén"]
  s.email       = ["johan@monospace.se"]
  s.homepage    = "http://github.com/jsahlen/todotxt"
  s.summary     = %q{todo.txt with a Ruby flair}
  s.description = %q{Interact with your todo.txt using a Ruby-base command-line tool}

  s.rubyforge_project = "todotxt"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "thor", "~> 0.15.4"
  s.add_dependency "rainbow", "~> 1.1.4"
  s.add_dependency "parseconfig", "~> 1.0.2"
  s.add_dependency "chronic", "~> 0.9.1"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.11.0"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "aruba", "~> 0.5.1"
  s.add_development_dependency "debugger"
end
