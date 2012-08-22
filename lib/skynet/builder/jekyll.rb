# File updater using jekyll for processing

module Skynet
  module Builder
    class Jekyll < Base

      def build
        super

        Skynet.logger.info "Jekyll running for #{app}..."

        build_repository
        Skynet.logger.info `jekyll #{source} #{destination}`

        Skynet.logger.info 'Jekyll finished'
      end

    end
  end
end
