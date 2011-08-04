# Static files updater

module Builder
  class Static < Builder::Base

    def run
      puts 'Static running...'
      if repo_exists?
        update_repo
      else
        create_repo
      end

      source_directory = File.join(@local_repo_path, @config[:builder_options][:source], '.')
      FileUtils.cp_r(source_directory, @config[:builder_options][:destination])
      puts 'Static finished'
    end

  end
end
