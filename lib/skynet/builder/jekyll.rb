# File updater using jekyll for processing

module Skynet::Builder
  class Jekyll < Base

    def build
      puts 'Jekyll running...'
      build_repository

      destination = File.join FileUtils.pwd, @options[:destination]
      source = File.join @local_repo_path, @options[:source]
      `jekyll #{source} #{destination}`

      puts 'Jekyll finished'
    end

  end
end
