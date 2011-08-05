require 'thor'
require 'skynet/generators/install'

module Skynet
  class CLI < Thor

    desc "install REPOSITORY_URL [AppName]", "Installs generic Profile, config.ru and config.yml"
    method_options :builder => 'jekyll'
    def install(repo, appname=nil)
      Skynet::Generators::Install.start
    end

  end
end
