module JsonApiFilter
  class ValueParser
    
    attr_reader :value
    
    # @param [String] value
    def initialize(value)
      @value = value
    end
    
    # Transform string of coma separated values to Array
    #
    # @example
    #   "1,2,3" #=> [1,2,3]
    #
    # @param [String] value
    # @return [Array]
    def self.parse(value)
      new(value).parse
    end
    
    private
    
    # @private
    def parse
      return [value] unless value.include?(",")
      value.split(',')
    end
  
  end
end
