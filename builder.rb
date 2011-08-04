require 'builder/base'
require 'builder/static'
require 'builder/jekyll'

module Builder
  def self.build(opts)
    Builder.const_get(opts[:builder]).new(opts[:config]).build
  end
end
