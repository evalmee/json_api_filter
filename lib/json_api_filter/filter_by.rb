module JsonApiFilter
  class FilterBy

    attr_reader :attr, :value

    def initialize(attr, value)
      @attr = attr
      @value = value
    end

    def to_hash
      return {} unless parsed_value.present?

      { key.to_sym => parsed_value }
    end

    private

    def key
      attr.to_sym
    end

    def parsed_value
      value.split(',')
    end
  end
end


