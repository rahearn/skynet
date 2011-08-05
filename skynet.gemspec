# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "skynet/version"

Gem::Specification.new do |s|
  s.name        = "skynet-middleware"
  s.version     = Skynet::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan Ahearn"]
  s.email       = ["ryan@coshx.com"]
  s.homepage    = ""
  s.summary     = %q{Sinatra middleware to listen for GitHub post-receive callbacks and perform an action}
  s.description = %q{Sinatra middleware to listen for GitHub post-receive callbacks and perform an action}

  s.required_rubygems_version = ">= 1.3.6"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'sinatra',       '~> 1.2'
  s.add_runtime_dependency 'thin',          '~> 1.2'
  s.add_runtime_dependency 'json',          '~> 1.5'
  s.add_runtime_dependency 'jekyll',        '~> 0.11'
  s.add_runtime_dependency 'thor',          '~> 0.14'
  s.add_runtime_dependency 'activesupport', '~> 3.0'
  s.add_runtime_dependency 'i18n'

  s.add_development_dependency 'heroku',     '~> 2.4'
  s.add_development_dependency 'showoff-io', '~> 0.3'
  s.add_development_dependency 'foreman',    '~> 0.19'
end
