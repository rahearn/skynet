require 'thor/group'

module Skynet
  module Generators
    class Install < Thor::Group
      include Thor::Actions

      def self.source_root
        File.join File.dirname(__FILE__), 'install'
      end

      def copy_config
        template('config.yml', 'config.yml')
      end

      def copy_rackup
        template('config.ru', 'config.ru')
      end

      def copy_procfile
        template('Procfile', 'Procfile')
      end
    end
  end
end
