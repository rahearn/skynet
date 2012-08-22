# Static files updater

module Skynet
  module Builder
    class Static < Base

      def build
        super

        Skynet.logger.info "Static running for #{app}..."

        build_repository
        FileUtils.cp_r source, destination
        FileUtils.remove_entry_secure File.join(destination, '.git')

        Skynet.logger.info 'Static build finished'
      end

    end
  end
end
