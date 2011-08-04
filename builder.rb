require 'builder/base'
require 'builder/static'
require 'builder/jekyll'

module Builder
  def self.run(opts)
    Builder.const_get(opts[:builder]).new(opts[:config]).run
  end
end
