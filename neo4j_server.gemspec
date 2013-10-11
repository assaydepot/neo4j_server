# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'neo4j_server/version'

Gem::Specification.new do |s|
  s.name        = "neo4j_server"
  s.version     = Neo4jServer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Xavier Lange']
  s.email       = ["xlange@assaydepot.com"]
  s.homepage    = 'https://www.github.com/assaydepot/neo4j_server'
  s.summary     = 'Packaged Neo4j Server'
  s.description = <<-TEXT
    Neo4j::Server is a packaged distribution of the Neo4j java server.

    This Gem is inspired by the sunspot_solr package.
  TEXT

  s.rubyforge_project = "neo4j_server"

  s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rdoc_options << '--webcvs=https://www.github.com/assaydepot/neo4j_server/tree/master/%s' <<
                  '--title' << 'Neo4j::Server - Vendored Neo4j for Ruby' <<
                  '--main' << 'README.rdoc'
end
