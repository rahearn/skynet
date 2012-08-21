require 'thor'

module Skynet
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.join File.dirname(__FILE__), 'templates'
    end

    desc "config PROJECT_NAME", "Installs config.yml started for PROJECT_NAME"
    def config(name)
      @project_name = name
      template('config.yml', 'config.yml')
    end

  end
end
