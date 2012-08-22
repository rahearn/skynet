require 'thor'
require 'thin'
require 'yaml'

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
    method_option :port, type: :numeric, default: 7575, aliases: '-p', desc: 'Port to listen on'
    method_option :host, type: :string, default: '0.0.0.0', aliases: '-h', desc: 'Interface to listen on'
    method_option :file, type: :string, default: './config.yml', aliases: '-f', desc: 'Configuration file'
    def server
      Skynet.logger = Logger.new 'skynet.log', 'weekly'

      unless File.exist? options[:file]
        Skynet.logger.fatal "Configuration file #{options[:file]} cannot be found"
        raise ArgumentError.new "Cannot find configuration file"
      end

      Skynet::App.configure do |app|
        app.set :config, YAML.load_file(options[:file])
      end

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

    desc "build [PROJECT_NAME]", "Builds all applications, or PROJECT_NAME only if given"
    def build(name="")
      raise NotImplementedError
    end

    desc "check", "Verifies correctness of config.yml"
    method_option :file, type: :string, default: './config.yml', aliases: '-f', desc: 'File to check'
    def check
      Skynet.logger.debug "RCA file: #{options[:file]}"
      raise NotImplementedError
    end

    desc "config [PROJECT_NAME]", "Generate config.yml, stubbed out for for PROJECT_NAME"
    def config(name="PROJECT_NAME")
      @project_name = name
      template('config.yml', 'config.yml')
    end

  end
end
