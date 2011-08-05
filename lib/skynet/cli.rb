require 'thor'
require 'skynet/generators/install'

module Skynet
  class CLI < Thor

    desc "install", "Installs generic Profile, config.ru and config.yml"
    def install
      Skynet::Generators::Install.start
    end

  end
end
