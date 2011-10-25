require 'skynet/builder/base'
require 'skynet/builder/static'
require 'skynet/builder/jekyll'

module Skynet
  module Builder
    def self.build(opts)
      Builder.const_get(opts[:builder]).new(opts[:config]).build
    end
  end
end
