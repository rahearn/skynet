module Skynet
  module Builder

    autoload :Base,   'skynet/builder/base'
    autoload :Static, 'skynet/builder/static'
    autoload :Jekyll, 'skynet/builder/jekyll'

    def self.build(opts)
      Builder.const_get(opts[:builder]).new(opts[:app], opts[:config]).build
    end

  end
end
