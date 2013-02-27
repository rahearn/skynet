require 'active_model'
require 'active_support/core_ext/object/blank'
require 'uri'

module Skynet
  module Builder

    ALLOWED_BUILDERS = Dir.entries(File.dirname(__FILE__)).select { |f| f =~ /^\w+(?<!base)\.rb$/ }.map { |f| f.chomp '.rb' }

    class Base
      include ActiveModel::Validations

      attr_accessor :app, :url, :branch, :destination, :branches, :type, :repository
      attr_reader :source, :key

      validates_presence_of :app, :url, :branch, :destination, :branches
      validates_inclusion_of :type,
        in: ALLOWED_BUILDERS,
        message: "must be one of #{ALLOWED_BUILDERS}"
      validate :branches_have_destinations
      validate :key_is_readable, if: :key?

      def initialize(app, config)
        self.app = app
        @config  = config
        @source  = File.join Dir.pwd, app, '.'
        @key     = config[:key]

        if config[:branches].blank?
          Skynet.logger.warn "Passing a single branch and destination is deprecated and will be removed in 2.0"
          Skynet.logger.warn "Please change to:\nbranches:\n  #{config[:branch]}: #{config[:destination]}"
          self.branches = { config[:branch] => config[:destination] }
        else
          self.branches = config[:branches]
        end
        self.branch      = branches.first[0]
        self.destination = branches.first[1]
        self.url         = config[:url]
        self.type        = config[:type]
        self.repository  = config[:repository]
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

      def remote_repository
        repository || translate_url
      end

      def translate_url
        uri = URI.parse url
        if uri.host == 'github.com'
          "git@github.com:#{uri.path.gsub %r[(^/)|(/$)|(\.git$)], ''}.git"
        else
          url
        end
      rescue URI::InvalidURIError
        url
      end

      def create_repo
        Skynet.logger.debug "Creating repository for #{app}"
        Skynet.logger.debug `rm -rf #{source}`
        if key?
          Skynet.logger.info `ssh-agent bash -c 'ssh-add #{key}; git clone #{remote_repository} #{app}'; cd #{source}; git checkout #{branch}`
        else
          Skynet.logger.info `git clone #{remote_repository} #{app}; cd #{source}; git checkout #{branch}`
        end
      end

      def update_repo
        Skynet.logger.debug "Updating repository for #{app}"
        if key?
          Skynet.logger.info `cd #{source}; git checkout #{branch}; ssh-agent bash -c 'ssh-add #{key}; git pull origin #{branch}'`
        else
          Skynet.logger.info `cd #{source}; git checkout #{branch}; git pull origin #{branch}`
        end
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

      def key?
        key.present?
      end

      def key_is_readable
        errors.add(:key, 'must be present and readable') unless File.readable?(key)
      end
    end
  end
end
