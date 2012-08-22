# Static files updater

module Skynet
  module Builder
    class Static < Base

      def build
        Skynet.logger.info "Static running for #{app}..."
        super

        Skynet.logger.debug "Removing #{destination}/*"
        FileUtils.rm_rf Dir.glob(File.join destination, '*'), secure: true

        Skynet.logger.debug "Copying #{source} to #{destination}"
        FileUtils.cp_r source, destination

        Skynet.logger.debug "Removing #{destination}/.git"
        FileUtils.remove_entry_secure File.join(destination, '.git')

        Skynet.logger.info 'Static build finished'
      end

    end
  end
end
