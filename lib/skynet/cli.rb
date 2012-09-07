require 'thor'
require 'thin'
require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'

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
    method_option :log, type: :string, default: 'skynet.log', aliases: '-l', desc: 'Log file'
    def server
      Skynet.logger = Logger.new options[:log], 'weekly'

      unless File.exist? options[:file]
        Skynet.logger.fatal "Configuration file #{options[:file]} cannot be found"
        raise ArgumentError.new "Cannot find configuration file"
      end

      Skynet::App.configure do |app|
        app.set :config, load_configuration(options[:file])
      end

      server = Thin::Server.new(options[:host], options[:port]) do
        run Skynet::App
      end

      begin
        server.start!
      rescue => ex
        Skynet.logger.fatal ex.message
        Skynet.logger.fatal ex.backtrace.join("\n")
        raise ex
      end
    end

    desc "build [PROJECT_NAME] [BRANCH_NAME]", "Builds all applications, or PROJECT_NAME only if given"
    method_option :file, type: :string, default: './config.yml', aliases: '-f', desc: 'Configuration file'
    def build(project=nil, branch=nil)
      all_apps = load_configuration options[:file]

      if project.nil?
        all_apps.each do |app, config|
          begin
            Builder.build app, config
          rescue ArgumentError
            next
          end
        end
      else
        config = all_apps[project]
        if config.nil?
          Skynet.logger.error "Could not find configuration for #{project}"
        else
          Builder.build project, config, branch
        end
      end
    end

    desc "check", "Verifies correctness of config.yml"
    method_option :file, type: :string, default: './config.yml', aliases: '-f', desc: 'File to check'
    def check
      all_apps = load_configuration options[:file]
      all_apps.each do |app, config|
        builder = Builder.for_app app, config
        if builder.valid?
          puts "#{app} configuration is valid"
        else
          puts "#{app} configuration errors: #{builder.errors.full_messages.join '. '}"
        end
      end
    end

    desc "config [PROJECT_NAME]", "Generate config.yml, stubbed out for PROJECT_NAME"
    def config(name="PROJECT_NAME")
      @project_name = name
      template('config.yml', 'config.yml')
    end

    private

    def load_configuration(file)
      YAML.load_file(file).with_indifferent_access
    end
  end
end
