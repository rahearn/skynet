# File updater using jekyll for processing

module Skynet
  module Builder
    class Jekyll < Base

      def build
        Skynet.logger.info "Jekyll running for #{@app}..."

        build_repository
        `jekyll #{@source} #{@destination}`

        Skynet.logger.debug 'Jekyll finished'
      end

    end
  end
end
