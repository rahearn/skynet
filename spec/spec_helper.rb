require 'bundler/setup'
# require 'active_model'
# require 'shoulda-matchers'

require 'skynet'

Skynet.logger = Logger.new File.join(File.dirname(__FILE__), 'test.log')

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
end

# Shoulda::Matchers.configure do |config|
#   config.integrate do |with|
#     with.test_framework :rspec
#
#     # Keep as many of these lines as are necessary:
#     # with.library :active_record
#     with.library :active_model
#   end
# end
