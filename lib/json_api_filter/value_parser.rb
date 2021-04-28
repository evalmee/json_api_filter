module JsonApiFilter
  class ValueParser
    
    attr_reader :value
    
    # @param [String, Hash, HashWithIndifferentAccess] value
    def initialize(value)
      @value = value
    end
    
    # Transform string of coma separated values to Array
    #
    # @example
    #   "1,2,3" #=> [1,2,3]
    #
    # @param [String, Hash, HashWithIndifferentAccess] value
    # @return [Array]
    def self.parse(value)
      new(value).indifferent_parse
    end
    
    def indifferent_parse
      return parse if value.is_a? String
      parse_hash if value.is_a? HashWithIndifferentAccess
    end
    
    def parse
      return [value] unless value.include?(",")
      value.split(',')
    end
    
    def parse_hash
      value.map{|k,v| {k => self.class.parse(v)}}.reduce(&:merge)
    end
  
  end
end
