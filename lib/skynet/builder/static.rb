# Static files updater

module Skynet
  module Builder
    class Static < Base

      def build
        super

        Skynet.logger.info "Static running for #{app}..."

        build_repository
        FileUtils.cp_r source, destination

        Skynet.logger.debug 'Static build finished'
      end

    end
  end
end
