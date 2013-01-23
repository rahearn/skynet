require 'skynet/builder/base'

module Skynet
  class Wizard < Thor::Shell::Basic

    def run
      [
        "#{ask('Project name:').downcase}:",
        "  url: #{repository_url}",
        "  type: #{build_type}",
        private_key,
        branches,
        "\n"
      ].compact.join "\n"
    end

    private

    def repository_url
      if ask('Is the repository on github? (y/n)').downcase == 'y'
        @github = true
        owner = ask 'Repository owner:'
        project = ask 'Github project name:'
        "https://github.com/#{owner}/#{project}"
      else
        @github = false
        ask 'Repository URL:'
      end
    end

    def build_type
      say 'Choose a build type:'
      Builder::ALLOWED_BUILDERS.each_index do |index|
        say "#{index + 1}: #{Builder::ALLOWED_BUILDERS[index]}"
      end
      builder = ask 'Choice:'
      Builder::ALLOWED_BUILDERS[builder.to_i - 1]
    end

    def private_key
      needs_key = ask('Is this a private repository? (y/n)').downcase
      if needs_key == 'y'
        ["  key: #{ask 'Full path to ssh key:'}"].tap do |pk|
          pk << "  repository: #{ask 'SSH repository address:'}" unless @github
        end.join "\n"
      else
        nil
      end
    end

    def branches
      branches = ['  branches:']
      while (branch = ask('Branch to deploy (blank to finish):')).present?
        dest = ask 'Full path to build destination:'
        branches << "    #{branch}: #{dest}"
      end
      branches.join "\n"
    end

  end
end
