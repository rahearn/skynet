require 'active_model'
require 'active_support/core_ext/object/blank'

module Skynet
  module Builder

    ALLOWED_BUILDERS = Dir.entries(File.dirname(__FILE__)).select { |f| f =~ /^\w+(?<!base)\.rb$/ }.map { |f| f.chomp '.rb' }

    class Base
      include ActiveModel::Validations

      attr_accessor :app, :url, :branch, :destination, :branches, :type
      attr_reader :source

      validates_presence_of :app, :url, :branch, :destination, :branches
      validates_inclusion_of :type,
        in: ALLOWED_BUILDERS,
        message: "must be one of #{ALLOWED_BUILDERS}"
      validate :branches_have_destinations

      def initialize(app, config)
        self.app = app
        @config  = config
        @source  = File.join Dir.pwd, app, '.'

        if config[:branches].blank?
          self.branches = { config[:branch] => config[:destination] }
        else
          self.branches = config[:branches]
        end
        self.branch      = branches.first[0]
        self.destination = branches.first[1]
        self.url         = config[:url]
        self.type        = config[:type]
      end

      def build(branch=nil)
        unless branch.blank?
          return if branches[branch].blank?
          self.branches = { branch => branches[branch] }
        end

        branches.each_pair do |branch, destination|
          self.branch      = branch.to_s
          self.destination = destination

          if valid?
            Skynet.logger.info "#{type} running for #{app} (branch: #{branch})"
          else
            Skynet.logger.error "Configuration error for #{app} (branch: #{branch})"
            Skynet.logger.error errors.full_messages.join '. '
            raise ArgumentError
          end

          build_repository
          execute
        end
      end

      private

      def build_repository
        repo_exists? ? update_repo : create_repo
      end

      def create_repo
        Skynet.logger.debug "Creating repository for #{app}"
        Skynet.logger.debug `rm -rf #{source}`
        Skynet.logger.info `git clone #{url} #{app}; cd #{source}; git checkout #{branch}`
      end

      def update_repo
        Skynet.logger.debug "Updating repository for #{app}"
        Skynet.logger.info `cd #{source}; git checkout #{branch}; git pull origin #{branch}`
      end

      def repo_exists?
        File.exist? File.join(source, '.git')
      end

      def branches_have_destinations
        return if branches.blank?
        branches.each_pair do |b, d|
          errors.add(:branches, "#{b} must have a destination") unless d.present?
        end
      end
    end
  end
end
