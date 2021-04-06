module JsonApiFilter
  module FieldFilters
    class Base
      
      attr_reader :scope, :values
      
      def initialize(scope, values)
        @scope = scope
        @values = values
      end
    
    end
  end
end
