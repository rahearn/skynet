module Skynet
  module Builder
    class Base

      def initialize(app, config)
        @app         = app
        @config      = config
        @repo        = config['url']
        @branch      = config['branch']
        @destination = config['destination']
        @source_base = File.join Dir.pwd, @app
        @source      = File.join @source_base, @branch
      end

      def build
        raise NotImplementedError.new "Must be implemented in subclass"
      end

      private

      def build_repository
        repo_exists? ? update_repo : create_repo
      end

      def create_repo
        `rm -rf #{@source}`
        `mkdir -p #{@source_base}; cd #{@source_base}; git clone #{@repo} #{@branch}`
      end

      def update_repo
        `cd #{@source}; git pull`
      end

      def repo_exists?
        File.exist? File.join(@source, '.git')
      end
    end
  end
end
