require 'thor/group'
require 'active_support/inflector'

module Skynet
  module Generators
    class Install < Thor::Group
      argument :task,    :type => :string
      argument :repo,    :type => :string
      argument :appname, :type => :string, :required => false
      class_options :builder => 'jekyll'
      include Thor::Actions

      def self.source_root
        File.join File.dirname(__FILE__), 'install'
      end

      def copy_config
        case options[:builder]
        when /jekyll/i
          @builder = 'Jekyll'
          @source = 'jekyll'
        when /static/i
          @builder = 'Static'
          @source = 'public'
        else
          raise "Builder must be one of jekyll or static"
        end
        template('config.yml', 'config.yml')
      end

      def copy_rackup
        if appname.nil?
          template('config-no-app.ru', 'config.ru')
        else
          @appname = appname.camelize
          @appfile = appname.underscore
          template('config.ru', 'config.ru')
        end
      end

      def copy_procfile
        template('Procfile', 'Procfile')
      end
    end
  end
end
