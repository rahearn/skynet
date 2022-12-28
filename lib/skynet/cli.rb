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
    method_option :log, type: :string, aliases: '-l', desc: 'Log file'
    def server
      Skynet.logger = Logger.new(options[:log], 'weekly') unless options[:log].nil?

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

    desc "install", "Generate config.yml"
    method_option :wizard, type: :boolean, default: false, aliases: '-w', desc: 'Run configuration wizard'
    def install
      copy_file 'config.yml'
      run_wizard if options[:wizard]
    end

    desc 'config', 'Run a wizard to append a new project to existing config.yml'
    method_option :file, type: :string, default: './config.yml', aliases: '-f', desc: 'Configuration file'
    def config
      copy_file 'config.yml', options[:file] unless File.exist? options[:file]
      run_wizard options[:file]
    end

    desc 'hook PROJECT_NAME', 'Generates an example post_receive hook for PROJECT_NAME'
    method_option :file, type: :string, default: './config.yml', aliases: '-f', desc: 'Configuration file'
    method_option :output, type: :string, default: './post-receive', aliases: '-o', desc: 'Output file'
    method_option :server, type: :string, default: 'http://localhost:7575', aliases: '-s', desc: 'Location of running skynet server'
    def hook(project)
      if File.exist? options[:output]
        Skynet.logger.fatal %{Output file "#{options[:output]}" already exists}
        exit 1
      end
      config = load_configuration(options[:file])[project]
      server = "#{options[:server].chomp '/'}/#{project}"
      HookGenerator.new(config, server, options[:output]).generate
    end

    private

    def run_wizard(file = './config.yml')
      append_file file, Wizard.new.run
    end

    def load_configuration(file)
      unless File.exist? file
        Skynet.logger.fatal %{Configuration file "#{file}" does not exist}
        exit 1
      end
      YAML.load_file(file).with_indifferent_access
    end
  end
end
