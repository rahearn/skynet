# File updater using jekyll for processing

module Skynet
  module Builder
    class Jekyll < Base

      def execute
        Skynet.logger.debug "PWD: #{Dir.pwd} Source: #{source} Destination: #{destination}"
        Skynet.logger.info `jekyll #{source} #{destination}`

        Skynet.logger.info 'Jekyll finished'
      end

    end
  end
end
