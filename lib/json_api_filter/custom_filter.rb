module JsonApiFilter
  class CustomFilter
    OPERATORS = %i[eq ne gt ge lt le].freeze

    attr_reader :handlers

    def initialize(&definition)
      @handlers = {}
      instance_eval(&definition)
      @handlers.freeze
      freeze
    end

    OPERATORS.each do |operator|
      define_method(operator) do |&handler|
        handlers[operator.to_s] = handler
      end
    end

    def handler_for(operator)
      handlers[operator.to_s]
    end
  end
end
