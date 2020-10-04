# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "skynet/version"

Gem::Specification.new do |s|
  s.name        = "skynet-deploy"
  s.version     = Skynet::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan Ahearn"]
  s.email       = ["ryan.ahearn@hey.com"]
  s.homepage    = "https://github.com/rahearn/skynet"
  s.summary     = %q{Sinatra app that listens for GitHub post-receive callbacks and deploys your code}
  s.description = %q{Sinatra app that listens for GitHub post-receive callbacks and deploys your code}

  s.required_ruby_version = ">= 2.7.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'sinatra',       '~> 2.1'
  s.add_runtime_dependency 'thin',          '~> 1.7'
  s.add_runtime_dependency 'json',          '~> 2.3'
  s.add_runtime_dependency 'jekyll',        '~> 4.1'
  s.add_runtime_dependency 'thor',          '~> 1.0'
  s.add_runtime_dependency 'activesupport', '~> 6.0'
  s.add_runtime_dependency 'activemodel',   '~> 6.0'
  s.add_runtime_dependency 'multi_json',    '~> 1.15'

  s.add_development_dependency 'rake',             '~> 13.0'
  s.add_development_dependency 'rspec',            '~> 3.9'
  s.add_development_dependency 'shoulda-matchers', '~> 4.4'
end
