# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'team_hub/version'

Gem::Specification.new do |s|
  s.name          = "team_hub"
  s.version       = TeamHub::VERSION
  s.authors       = ["Mike Bland"]
  s.email         = ["michael.bland@gsa.gov"]
  s.summary       = 'Components for creating a team Hub using Jekyll'
  s.description   = (
    "Contains resuable components extracted from the 18F Hub " +
    "implementation for creating a team hub using Jekyll. See the 18F " +
    "Public Hub for a running example:\n" +
    "  https://18f.gsa.gov/hub/\n" +
    "The 18F Hub repository is:\n" +
    "  https://github.com/18F/hub"
  )
  s.homepage      = 'https://github.com/18F/team_hub'
  s.license       = 'CC0'

  s.files         = `git ls-files -z README.md lib`.split("\x0")

  s.add_runtime_dependency 'hash-joiner'
  s.add_runtime_dependency 'weekly_snippets'
  s.add_runtime_dependency 'jekyll'
  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'codeclimate-test-reporter'
end
