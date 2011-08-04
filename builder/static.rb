# Static files updater

module Builder
  class Static < Builder::Base

    def run
      puts 'Static running...'
      build_repository

      source_directory = File.join(@local_repo_path, @options[:source], '.')
      FileUtils.cp_r(source_directory, @options[:destination])
      puts 'Static finished'
    end

  end
end
