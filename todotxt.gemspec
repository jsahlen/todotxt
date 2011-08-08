# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "todotxt/version"

Gem::Specification.new do |s|
  s.name        = "todotxt"
  s.version     = Todotxt::VERSION
  s.authors     = ["Johan Sahlén"]
  s.email       = ["johan@monospace.se"]
  s.homepage    = ""
  s.summary     = %q{todo.txt with a Ruby flair}
  s.description = %q{Interact with your todo.txt using a Ruby-base command-line tool}

  s.rubyforge_project = "todotxt"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "thor", ">= 0.14.6"
  s.add_dependency "rainbow", ">= 1.1.1"
  s.add_dependency "parseconfig", ">= 0.5.2"
end
