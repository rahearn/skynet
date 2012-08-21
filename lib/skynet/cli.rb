require 'thor'
require 'thin'

module Skynet
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.join File.dirname(__FILE__), 'templates'
    end

    desc "version", "display the current version"
    def version
      puts "Skynet #{Skynet::VERSION}"
    end

    desc "server", "starts the skynet server"
    method_option :port, type: :numeric, default: 7575, required: true, aliases: '-p'
    method_option :host, type: :string, default: '0.0.0.0', required: true, aliases: '-h'
    def server
      server = Thin::Server.new(options[:host], options[:port]) do
        run Skynet::App
      end

      begin
        server.start!
      rescue => ex
        Skynet.logger.error ex.message
        Skynet.logger.error ex.backtrace.join("\n")
        rase ex
      end
    end

    desc "build [PROJECT_NAME]", "Builds all applicatoins, or PROJECT_NAME only if given"
    def build(name="")
      raise NotImplementedError
    end

    desc "config PROJECT_NAME", "Installs config.yml started for PROJECT_NAME"
    def config(name)
      @project_name = name
      template('config.yml', 'config.yml')
    end

  end
end
