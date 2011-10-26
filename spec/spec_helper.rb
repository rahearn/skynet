require 'bundler/setup'
Bundler.require :default

require 'skynet/builder'

RSpec.configure do |config|
  config.mock_with :rspec
end
