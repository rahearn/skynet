# Static files updater

module Skynet
  module Builder
    class Static < Base

      def build
        super

        Skynet.logger.info "Static running for #{app}..."
        build_repository

        Skynet.logger.debug "Copying #{source} to #{destination}"
        FileUtils.cp_r source, destination

        Skynet.logger.debug "Removing #{destination}/.git"
        FileUtils.remove_entry_secure File.join(destination, '.git')

        Skynet.logger.info 'Static build finished'
      end

    end
  end
end
