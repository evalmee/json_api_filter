module JsonApiFilter
  class ValueParser
    
    attr_reader :value
    
    # @param [String] value
    def initialize(value)
      @value = value
    end
    
    def self.parse(value)
      new(value).parse
    end
    
    def parse
      return value unless value.include?(",")
      value.split(',')
    end
  
  end
end