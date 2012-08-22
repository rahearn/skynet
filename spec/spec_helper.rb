require 'bundler/setup'

require 'skynet'

Skynet.logger = Logger.new File.join(File.dirname(__FILE__), 'test.log')

RSpec.configure do |config|
  config.mock_with :rspec
end
