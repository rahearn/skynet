module Builder
  class Base

    def initialize(config)
      @config = config
    end

    def run
      raise "Must be implemented in subclass"
    end
  end
end
