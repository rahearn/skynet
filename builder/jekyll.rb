# File updater using jekyll for processing

module Builder
  class Jekyll < Builder::Base

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
