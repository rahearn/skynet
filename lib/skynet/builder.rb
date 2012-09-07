module Skynet
  module Builder

    autoload :Base,   'skynet/builder/base'
    autoload :Static, 'skynet/builder/static'
    autoload :Jekyll, 'skynet/builder/jekyll'

    def self.build(app, config, branch=nil)
      for_app(app, config).build branch
    end

    def self.for_app(app, config, type=nil)
      type ||= config[:type] || 'base'
      const_get("#{type[0].upcase}#{type.reverse.chop.reverse}").new app, config
    rescue NameError
      for_app(app, config, 'base')
    end

  end
end
