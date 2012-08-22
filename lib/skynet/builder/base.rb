require 'active_model'

module Skynet
  module Builder

    ALLOWED_BUILDERS = Dir.entries(File.dirname(__FILE__)).select { |f| f =~ /^\w+(?<!base)\.rb$/ }.map { |f| f.chomp '.rb' }

    class Base
      include ActiveModel::Validations

      attr_accessor :app, :url, :branch, :destination, :type
      attr_reader :source

      validates_presence_of :app, :url, :branch, :destination
      validates_inclusion_of :type,
        in: ALLOWED_BUILDERS,
        message: "must be one of #{ALLOWED_BUILDERS}"

      def initialize(app, config)
        self.app         = app
        @config          = config
        self.url         = config[:url]
        self.branch      = config[:branch] || 'master'
        self.destination = config[:destination]
        self.type        = config[:type]
        @source_base     = File.join Dir.pwd, app
        @source          = File.join @source_base, branch
      end

      def build
        unless valid?
          Skynet.logger.error "Configuration error for #{app}"
          Skynet.logger.error errors.full_messages.join '. '
          raise ArgumentError
        end
      end

      private

      def build_repository
        repo_exists? ? update_repo : create_repo
      end

      def create_repo
        Skynet.logger.debug `rm -rf #{source}; mkdir -p #@source_base`
        Skynet.logger.info `cd #@source_base; git clone #{url} #{branch}`
      end

      def update_repo
        Skynet.logger.info `cd #{source}; git pull`
      end

      def repo_exists?
        File.exist? File.join(source, '.git')
      end
    end
  end
end
