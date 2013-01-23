require 'skynet/version'
require 'logger'

module Skynet

  autoload :Builder, 'skynet/builder'
  autoload :App,     'skynet/app'
  autoload :CLI,     'skynet/cli'
  autoload :Wizard,  'skynet/wizard'

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end

end
